import 'package:flutter_blue/flutter_blue.dart';

class DeviceInfo {
  final BluetoothDevice device;
  bool connexionStatus;

  DeviceInfo({this.device, this.connexionStatus});

  BluetoothDevice get getDevice {
    return device;
  }

  set setConnexionStatus(bool status){
    connexionStatus = status;
  }

}
