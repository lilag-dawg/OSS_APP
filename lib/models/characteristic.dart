import 'package:flutter_blue/flutter_blue.dart';

class DeviceCharacteristic{
  final BluetoothCharacteristic c;
  bool isCharacteristicStreaming;

  DeviceCharacteristic(this.c){
    isCharacteristicStreaming = false;
  }

  get getBluetoothCharacteristic{
    return c;
  }

  set setIsCharacteristicStreaming(bool status){
    isCharacteristicStreaming = status;
  }

} 