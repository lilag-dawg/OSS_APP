
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

import './streamPackage.dart';
import './device.dart';

class ConnectedDevices extends ChangeNotifier{
  final List<Device> _devices;

  ConnectedDevices(this._devices);

  void add(Device d){
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

  Device findFeatureInDeviceList(String tag){
    Device matchingDevice;
    _devices.forEach((d) => d.services.values.forEach((s){
      if(s.features[tag] == true){
        matchingDevice = d;
      }
    }));
    return matchingDevice;
  }

  StreamPackage getRpm(){
    Device selectedDevice = findFeatureInDeviceList("CrankRev");
    return selectedDevice.getStreamPackage("0x2A5B", "RPM");
  }

  StreamPackage getSpeed(){
    Device selectedDevice = findFeatureInDeviceList("WheelRev");
    return selectedDevice.getStreamPackage("0x2A5B","Speed");
  }

}