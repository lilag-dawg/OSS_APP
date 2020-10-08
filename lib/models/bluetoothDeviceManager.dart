import 'package:flutter/cupertino.dart';
import './OSSDevice.dart';

class BluetoothDeviceManager extends ChangeNotifier {
  OSSDevice ossDevice;
  BluetoothDeviceManager();


  void setDevice(OSSDevice device){
    ossDevice = device;
    notifyListeners();
  }

  void remove(){
    ossDevice = null;
  }


}