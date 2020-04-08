import 'package:flutter_blue/flutter_blue.dart';

class DeviceCharacteristic{
  final BluetoothDevice device;
  final BluetoothCharacteristic characteristic;

  DeviceCharacteristic({this.device,this.characteristic});

  BluetoothDevice get getDevice {
    return device;
  }

  BluetoothCharacteristic get getCharacteristic{
    return characteristic;
  }
}