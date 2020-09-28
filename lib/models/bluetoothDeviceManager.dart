import 'package:flutter/cupertino.dart';
import './OSSDevice.dart';

class BluetoothDeviceManager extends ChangeNotifier {
  OSSDevice ossDevices;
  BluetoothDeviceManager();


  void setDevice(OSSDevice device){
    ossDevices = device;
    notifyListeners();
  }

  void remove(){
    ossDevices = null;
  }


}