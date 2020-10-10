import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import './OSSDevice.dart';

class BluetoothDeviceManager extends ChangeNotifier {
  OSSDevice ossDevice;
  BluetoothDeviceManager();

  static String connectionHandlingService = "1802";
  
  static String nombreCapteursCharact = "16A1";
  static String listCapteursCharact = "16A2";

  static String convertRawToStringListCapteursCharact(List<int> value){
    String name = "";
    for(int i = 1; i < value.length; i++){
      if(value[i] == 0)
        break;

      name = name + String.fromCharCode(value[i]);
    }
    return name;
  }



  void setDevice(OSSDevice device){
    ossDevice = device;
    notifyListeners();
  }

  void remove(){
    ossDevice = null;
  }

}