import 'package:flutter_blue/flutter_blue.dart';

class DeviceResult {
  final BluetoothDevice device;
  bool connexionStatus;

  DeviceResult({this.device, this.connexionStatus});

  BluetoothDevice get getDevice {
    return device;
  }

  set setConnexionStatus(bool status){
    connexionStatus = status;
  }
}
