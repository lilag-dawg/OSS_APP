import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ConnectedDevices extends ChangeNotifier{
  List<BluetoothDevice> _devices;

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

  void copy(List<BluetoothDevice> d){
    _devices = [...d];
    notifyListeners();
  }

  int deviceCount(){
    return _devices.length;
  }

}