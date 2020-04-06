import 'package:flutter_blue/flutter_blue.dart';

class DeviceInfo {
  final BluetoothDevice device;
  bool connexionStatus;
  bool checkboxStatus;

  DeviceInfo({this.device, this.checkboxStatus, this.connexionStatus});

  BluetoothDevice get getDevice {
    return device;
  }

  set setConnexionStatus(bool status){
    connexionStatus = status;
  }

  set setCheckboxStatus(bool status){
    checkboxStatus = status;
  }


}
