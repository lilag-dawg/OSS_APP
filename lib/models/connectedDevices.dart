import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ConnectedDevices extends ChangeNotifier{
  final List<BluetoothDevice> _devices;

  ConnectedDevices(this._devices);

  getConnectedDevices() => _devices;

  void add(BluetoothDevice d){
    _devices.add(d);
    notifyListeners();
  }

  void remove(BluetoothDevice d){
    _devices.remove(d);
    notifyListeners();
  }

  int deviceCount(){
    return _devices.length;
  }

  bool contains(BluetoothDevice d){
    if(_devices.contains(d))
      return true;
    return false;
  }

}