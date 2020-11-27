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

    dataToSend.add( (crankset.bigGear != null ? ((crankset.bigGear & mask6bits) << 27) : 0 ) + (crankset.gear2 != null ? ((crankset.gear2 & mask6bits) << 21) : 0 ) + 
                    (crankset.gear3 != null ? ((crankset.gear3 & mask6bits) << 15) : 0 ) + (sprocket.smallGear != null ? ((sprocket.smallGear & mask6bits) << 9) : 0 ) + 
                    (sprocket.gear2 != null ? ((sprocket.gear2 & mask6bits) << 3) : 0 ) + (sprocket.gear3 != null ? (sprocket.gear3 & mask3bitsMSB) : 0 ) 
                    );


    dataToSend.add( (sprocket.gear3 != null ? ((sprocket.gear3 & mask3bitsLSB) << 60) : 0 ) + (sprocket.gear4 != null ? ((sprocket.gear4 & mask6bits) << 54) : 0 ) + 
                    (sprocket.gear5 != null ? ((sprocket.gear5 & mask6bits) << 48) : 0 )  + (sprocket.gear6 != null ? ((sprocket.gear6 & mask6bits) << 42) : 0 )  + 
                    (sprocket.gear7 != null? ((sprocket.gear7 & mask6bits) << 36) : 0 )  + (sprocket.gear8 != null ? ((sprocket.gear8 & mask6bits) << 30) : 0 )  + 
                    (sprocket.gear9 != null? ((sprocket.gear9 & mask6bits) << 24) : 0 )  + (sprocket.gear10 != null ? ((sprocket.gear10 & mask6bits) << 18) : 0 )  + 
                    (sprocket.gear11 != null ? ((sprocket.gear11 & mask6bits) << 12) : 0 )  + (sprocket.gear12 != null ? ((sprocket.gear12 & mask6bits) << 6) : 0 )  + 
                    (sprocket.gear13 != null ? (sprocket.gear13 & mask6bits) : 0 )
                    );
    
    dataToSend.add( (preferences.ftp != null ? ((preferences.ftp & mask9bits) << 54) : 0 ) + (preferences.shiftingResponsiveness != null ? (((preferences.shiftingResponsiveness * 10).toInt() & mask32bits) << 22) : 0 ) +
                    (preferences.desiredRpm != null ? ((preferences.desiredRpm & mask8bits) << 14) : 0 ) + (preferences.desiredBpm != null ? ((preferences.desiredBpm & mask8bits) << 6) : 0 )
                    );
    
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
