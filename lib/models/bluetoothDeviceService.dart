import 'package:flutter_blue/flutter_blue.dart';
import './bluetoothDeviceCharacteristic.dart';



class BluetoothDeviceService {
  final String serviceName;
  final BluetoothService service;
  List<BluetoothDeviceCharacteristic> characteristics = [];


  BluetoothDeviceService._create(this.serviceName, this.service);

  static Future<BluetoothDeviceService> create(
      String serviceName, BluetoothService service) async {
    BluetoothDeviceService ossService =
        BluetoothDeviceService._create(serviceName, service);

    await ossService._getOSSCharacteristics(service);

    return ossService;
  }

  Future<void> _getOSSCharacteristics(BluetoothService s) async {
    await Future.forEach(s.characteristics, (BluetoothCharacteristic c) async {
      await BluetoothDeviceCharacteristic.create(c.uuid.toString().toUpperCase().substring(4, 8), c).then((value) => characteristics.add(value));
    });
  }


  get name {
    return serviceName;
  }

  BluetoothDeviceCharacteristic getCharacteristic(String name) {
    BluetoothDeviceCharacteristic selected;
    characteristics.forEach((c) {
      if (c.name == name) {
        selected = c;
      }
    });
    return selected;
  }
}
