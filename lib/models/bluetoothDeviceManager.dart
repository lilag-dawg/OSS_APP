import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:oss_app/databases/cranksetsModel.dart';
import 'package:oss_app/databases/preferencesModel.dart';
import 'package:oss_app/databases/sprocketsModel.dart';
import './OSSDevice.dart';

class BluetoothDeviceManager extends ChangeNotifier {
  OSSDevice ossDevice;
  BluetoothDeviceManager();

  static String connectionHandlingService = "1802";
  static String cablibrationService = "1803";

  static String nombreCapteursCharact = "16A1";
  static String listCapteursCharact = "16A2";
  static String paringRequestCharact = "16A3";
  static String sensorDataType = "16A4";
  static String calibrationCharact = "16B1";

  static String convertRawToStringListCapteursCharact(List<int> value) {
    String name = "";
    for (int i = 1; i < value.length; i++) {
      if (value[i] == 0) break;

      name = name + String.fromCharCode(value[i]);
    }
    return name;
  }

  static int convertRawToIntCapteursCharact(List<int> value){
    int numberOfSensor = 0;
    for(int i = 0; i < value.length; i++){ //length should always be 1
      numberOfSensor = value[i];

    }
    return numberOfSensor;
  }

  static List<int> sendPairingRequestCharact(String deviceName, String status){
     List<int> stringToListInt = [];

     if(status == "Paired"){
       stringToListInt.add(0); //request to forget
     }
     else{
       stringToListInt.add(1); // request to pair
     }
     for(int c in deviceName.codeUnits){
       stringToListInt.add(c);
     }
     return stringToListInt;
  }

  static List<int> sendCalibrationCharact(CranksetsModel crankset, SprocketsModel sprocket, PreferencesModel preferences){
    int mask32bits = 0xFFFFFFFF;
    int mask9bits = 0x1FF;
    int mask8bits = 0xFF;
    int mask6bits = 0x3F;
    int mask3bitsMSB = 0x38;
    int mask3bitsLSB = 0x7;

    List<int> dataToSend = [];

    //crankset
    dataToSend.add((crankset.bigGear != null ? (crankset.bigGear & mask8bits) : 0 ));
    dataToSend.add((crankset.gear2 != null ? (crankset.gear2 & mask8bits) : 0 ));
    dataToSend.add((crankset.gear3 != null ? (crankset.gear3 & mask8bits) : 0 ));

    //sprocket
    dataToSend.add((sprocket.smallGear != null ? (sprocket.smallGear & mask8bits) : 0 ));
    dataToSend.add((sprocket.gear2 != null ? (sprocket.gear2 & mask8bits) : 0 ));
    dataToSend.add((sprocket.gear3 != null ? (sprocket.gear3 & mask8bits) : 0 ));
    dataToSend.add((sprocket.gear4 != null ? (sprocket.gear4 & mask8bits) : 0 ));
    dataToSend.add((sprocket.gear5 != null ? (sprocket.gear5 & mask8bits) : 0 ));
    dataToSend.add((sprocket.gear6 != null ? (sprocket.gear6 & mask8bits) : 0 ));
    dataToSend.add((sprocket.gear7 != null ? (sprocket.gear7 & mask8bits) : 0 ));
    dataToSend.add((sprocket.gear8 != null ? (sprocket.gear8 & mask8bits) : 0 ));
    dataToSend.add((sprocket.gear9 != null ? (sprocket.gear9 & mask8bits) : 0 ));
    dataToSend.add((sprocket.gear10 != null ? (sprocket.gear10 & mask8bits) : 0 ));
    dataToSend.add((sprocket.gear11 != null ? (sprocket.gear11 & mask8bits) : 0 ));
    dataToSend.add((sprocket.gear12 != null ? (sprocket.gear12 & mask8bits) : 0 ));
    dataToSend.add((sprocket.gear13 != null ? (sprocket.gear13 & mask8bits) : 0 ));

    //ftp
    dataToSend.add((preferences.ftp != null ? ((preferences.ftp & mask9bits) >> 8) : 0 ));  // 1 MSB
    dataToSend.add((preferences.ftp != null ? (preferences.ftp & mask8bits) : 0 ));         // 7 LSB

    //shitfting response
    dataToSend.add((preferences.shiftingResponsiveness != null ? (((preferences.shiftingResponsiveness * 10).toInt() & mask32bits) >> 24) : 0 )); // 8 MSB
    dataToSend.add((preferences.shiftingResponsiveness != null ? (((preferences.shiftingResponsiveness * 10).toInt() & mask32bits) >> 16) : 0 ));
    dataToSend.add((preferences.shiftingResponsiveness != null ? (((preferences.shiftingResponsiveness * 10).toInt() & mask32bits) >> 8) : 0 ));
    dataToSend.add((preferences.shiftingResponsiveness != null ? ((preferences.shiftingResponsiveness * 10).toInt() & mask32bits) : 0 ));         // 8 LSB

    //desired Rpm
    dataToSend.add((preferences.desiredRpm != null ? (preferences.desiredRpm & mask8bits) : 0 ));

    //desired Bpm
    dataToSend.add((preferences.desiredBpm != null ? (preferences.desiredBpm & mask8bits) : 0 ));
    
    return dataToSend;

  }



  void setDevice(OSSDevice device){
    ossDevice = device;
    notifyListeners();
  }

  void remove() {
    ossDevice = null;
  }
}
