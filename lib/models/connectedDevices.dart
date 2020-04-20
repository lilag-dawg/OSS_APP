
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import './customBluetoothDevice.dart';

class ConnectedDevices extends ChangeNotifier{
  final List<CustomBluetoothDevice> _devices;

  ConnectedDevices(this._devices);

  void add(CustomBluetoothDevice d){
    _devices.add(d);
    notifyListeners();
  }


  void remove(BluetoothDevice d){
    _devices.removeWhere((element) => element.getDevice == d);
    notifyListeners();
  }

  int deviceCount(){
    return _devices.length;
  }


}