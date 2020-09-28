import 'package:flutter_blue/flutter_blue.dart';


class BluetoothDeviceCharacteristic {
  final String characteristicName;
  final BluetoothCharacteristic characteristic;

  BluetoothDeviceCharacteristic._create(this.characteristicName, this.characteristic);

  static Future<BluetoothDeviceCharacteristic> create(String characteristicName, BluetoothCharacteristic characteristic) async{
    BluetoothDeviceCharacteristic myCharacteristic =  BluetoothDeviceCharacteristic._create(characteristicName, characteristic);
    return myCharacteristic;
  }



  get name {
    return characteristicName;
  }

  get getCharacteristic{
    return characteristic;
  }
}
