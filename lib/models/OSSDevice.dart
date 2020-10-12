import 'package:flutter_blue/flutter_blue.dart';
import './bluetoothDeviceService.dart';

class OSSDevice {
  final BluetoothDevice device;
  List<BluetoothDeviceService> services = [];


  OSSDevice._create(this.device);

  static Future<OSSDevice> create(BluetoothDevice d) async{
    OSSDevice ossDevice = OSSDevice._create(d);
    await ossDevice._getOSSServices(d);
    return ossDevice;
  }

  Future<void> _getOSSServices(BluetoothDevice d) async{
    List<BluetoothService> dServices = await d.discoverServices();
    await Future.forEach(dServices, (BluetoothService s) async{
      await BluetoothDeviceService.create(s.uuid.toString().toUpperCase().substring(4, 8),s).then((onValue){
        services.add(onValue);
      });
    });
  }

  BluetoothDeviceService getService(String name){
    BluetoothDeviceService selected;
    services.forEach((s){
      if(s.name == name){
        selected = s;
      }
    });
    return selected;
  }

  get getDevice{
    return device;
  }
  
 }