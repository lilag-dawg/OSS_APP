import 'package:flutter_blue/flutter_blue.dart';

class DeviceConnexionStatus {
  final BluetoothDevice device;
  String connexionStatus;
  String connected = "connected";
  String inTransistion = "standby";
  String disconnected = "disconnected";


  DeviceConnexionStatus({this.device, this.connexionStatus});

  BluetoothDevice get getDevice {
    return device;
  }

  set setConnexionStatus(String status){
    connexionStatus = status;
  }
}
