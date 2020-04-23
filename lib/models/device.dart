import 'package:flutter_blue/flutter_blue.dart';
import './streamPackage.dart';
import './characteristic.dart';

class Device {
  final BluetoothDevice device;
  Map<String, Service> services = {};
  List<BluetoothService> dServices;
  List<DeviceCharacteristic> deviceCharacteristics = [];

  Device._create(this.device);

  get getDevice {
    return device;
  }

  int getActiveCount(String serviceName){
    return services[serviceName].activeFeatureCount;
  }

  static Future<Device> create(BluetoothDevice d) async {
    Device myDevice = Device._create(d);
    await myDevice._getDeviceFeatures(d);
    return myDevice;
  }

  Future<void> _getDeviceFeatures(BluetoothDevice d) async {
    
    dServices = await d.discoverServices();
    await Future.forEach(dServices, (BluetoothService s) async {
      if ('0x${s.uuid.toString().toUpperCase().substring(4, 8)}' == "0x1816") {
        await _checkMatchingCharacteristic(s.characteristics).then((result){
          services["0x1816"] = Service("0x1816", result);
        });
      }
      if ('0x${s.uuid.toString().toUpperCase().substring(4, 8)}' == "0x1818") {
        await _checkMatchingCharacteristic(s.characteristics).then((result){
          services["0x1818"] = Service("0x1818", result);
        });
      }
      if ('0x${s.uuid.toString().toUpperCase().substring(4, 8)}' == "0x180F") {
        await _checkMatchingCharacteristic(s.characteristics).then((result){
          services["0x180F"] = Service("0x180F", result);
        });
      }
    });
  }

  Future<List<int>> _checkMatchingCharacteristic(List<BluetoothCharacteristic> characteristics)async{
    List<int> result = [0];
    await Future.forEach(characteristics, (BluetoothCharacteristic c) async{
      if('0x${c.uuid.toString().toUpperCase().substring(4, 8)}' == "0x2A5C"){
          result = await _getCharacteristicValue(c);
      }
      if('0x${c.uuid.toString().toUpperCase().substring(4, 8)}' == "0x2A65"){
          result = await _getCharacteristicValue(c);
      }
      if('0x${c.uuid.toString().toUpperCase().substring(4, 8)}' == "0x2A19"){
          result = await _getCharacteristicValue(c);
      }

      deviceCharacteristics.add(DeviceCharacteristic(c));
    });
    return result;
  }


  Future<List<int>> _getCharacteristicValue(BluetoothCharacteristic c) async {
    List<int> value = await c.read();
    return value;
  }

  StreamPackage getStreamPackage(String characteristic, String streamContent){
    DeviceCharacteristic selectedCharacteristic = deviceCharacteristics.firstWhere((c) => '0x${c.getBluetoothCharacteristic.uuid.toString().toUpperCase().substring(4, 8)}' == characteristic);
    return StreamPackage(device,selectedCharacteristic, streamContent);
  }


  
}

class Service {
  final String serviceName;
  final List<int> resultValue;
  Map<String,bool> features = {};
  int activeFeatureCount = 0;

  Service(this.serviceName, this.resultValue) {
    switch (serviceName) {
      case "0x1816":
        activeFeatureCount = cscFeatures(resultValue);
        break;
      case "0x1818":
        activeFeatureCount = cpsFeatures(resultValue);
        break;
      case "0x180F":
        activeFeatureCount = batteryFeatures();   
    }
  }

  int cscFeatures(List<int> value) {
    int flags = value[0];

    bool isWheelRevSupported = (flags & 0x01 > 0);
    bool isCrankRevSupported = (flags & 0x02 > 0);

    features["CrankRev"] = isCrankRevSupported;
    features["WheelRev"] = isWheelRevSupported;


    return features.values.where((value) => value == true).length;
  }

  int cpsFeatures(List<int> value) {
    int flags = value[0];

    bool isWheelRevSupported = (flags & 0x04 > 0);
    bool isCrankRevSupported = (flags & 0x08 > 0);
    bool isPowerSupported = true;

    features["CrankRev"] = isCrankRevSupported;
    features["WheelRev"] = isWheelRevSupported;
    features["Power"] = isPowerSupported;

    return features.values.where((value) => value == true).length;

  }

int batteryFeatures(){
    features["Battery Level"] = true;
    return features.values.where((value) => value == true).length;
 }
}
