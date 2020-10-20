import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import './OSSDevice.dart';

class BluetoothDeviceManager extends ChangeNotifier {
  OSSDevice ossDevice;
  BluetoothDeviceManager();

  static String connectionHandlingService = "1802";
  
  static String nombreCapteursCharact = "16A1";
  static String listCapteursCharact = "16A2";
  static String paringRequestCharact = "16A3";

  static String convertRawToStringListCapteursCharact(List<int> value){
    String name = "";
    for(int i = 1; i < value.length; i++){
      if(value[i] == 0)
        break;

      name = name + String.fromCharCode(value[i]);
    }
    return name;
  }

  static int convertRawToIntCapteursCharact(List<int> value){
    print(value);
    int numberOfSensor = 0;
    for(int i = 0; i < value.length; i++){ //length should always be 1
      numberOfSensor = value[i];

    }
    return numberOfSensor;
  }



  void setDevice(OSSDevice device){
    ossDevice = device;
    notifyListeners();
  }

  void remove(){
    ossDevice = null;
  }

}