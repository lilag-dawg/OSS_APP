import 'package:flutter_blue/flutter_blue.dart';

class CustomBluetoothDevice {
  final BluetoothDevice device;
  Map<String, Service> services = {};

  CustomBluetoothDevice._create(this.device);

  get getDevice{
    return device;
  }

  static Future<CustomBluetoothDevice> create(BluetoothDevice d) async {
    CustomBluetoothDevice myDevice = CustomBluetoothDevice._create(d);
    await myDevice.getDeviceFeatures(d);
    return myDevice;
  }


  Future<void> getDeviceFeatures(BluetoothDevice d) async {
    List<BluetoothService> dServices = await d.discoverServices();
    await Future.forEach(dServices, (BluetoothService s) async {
      if ('0x${s.uuid.toString().toUpperCase().substring(4, 8)}' == "0x1816") {
        Future.forEach(s.characteristics, (c) async {
          _getCharacteristic(c).then((result) {
            if (result != null) {  
              services["CSCS"] = Service("CSCS",result);
            }
          });
        });
      }
    });
  }

  Future<List<int>> _getCharacteristic(BluetoothCharacteristic c) async {
    List<int> value;
    if ('0x${c.uuid.toString().toUpperCase().substring(4, 8)}' == "0x2A5C") {
      value = await c.read();
    }
    return value;
  }
}

class Service {
  final String serviceName;
  final List<int> resultValue;
  List<Feature> features = [];

  Service(this.serviceName, this.resultValue) {
    switch (serviceName) {
      case "CSCS":
        cscFeature(resultValue);
        break;
      case "CPS":
    }
  }

  void cscFeature(List<int> value) {
    int flags = value[0];

    bool isWheelRevSupported = (flags & 0x01 > 0);
    bool isCrankRevSupported = (flags & 0x02 > 0);

    features.add(Feature("CrankRev", isCrankRevSupported));
    features.add(Feature("CrankRev", isWheelRevSupported));
  }
}

class Feature {
  final String featureName;
  final bool isSupported;

  Feature(this.featureName, this.isSupported);
}
