import 'package:flutter_blue/flutter_blue.dart';
import './characteristic.dart';

class StreamPackage {
  final BluetoothDevice device;
  final DeviceCharacteristic c;
  final String streamContent;

  StreamPackage(this.device, this.c, this.streamContent);

  Stream<int> getStream() async* {
    if(!c.isCharacteristicStreaming){
      c.getBluetoothCharacteristic.setNotifyValue(true);
      characteristicStreamingStatus(true);
    }
    switch(streamContent){
      case "RPM":
        yield* convertRawToRpm(c.getBluetoothCharacteristic.value);
        break;
      case "Speed":
        yield* convertRawToSpeed(c.getBluetoothCharacteristic.value);
    }

  }

  Stream<BluetoothDeviceState> getConnexion() async*{
    yield* device.state;
  }

  Stream<int> convertRawToRpm(Stream<List<int>> source) async* {
    Map<String,List<int>> currentAndLast = {'current': [], 'last': []};
    await for (List<int> chunk in source){
      if(chunk.isNotEmpty){
        currentAndLast['last'] = currentAndLast['current'];
        currentAndLast['current'] = chunk;
        if(currentAndLast['last'].length != 0 && currentAndLast['current'].length != 0){
          yield rpmConversion(currentAndLast);
        }
      }

    }
  }
  Stream<int> convertRawToSpeed(Stream<List<int>> source) async* {
    await for (List<int> chunk in source){
      if(chunk.isNotEmpty){
        yield chunk[9];
      }

    }
  }

  int rpmConversion(Map<String,List<int>> currentAndLast){


    currentAndLast.values.forEach((data){
      switch(data[0]){
        case 3:
          data[1] = data[7];
          data[2] = data[8];
          data[3] = data[9];
          data[4] = data[10];
          break;
        case 2:
          data[1] = data[1];
          data[2] = data[2];
          data[3] = data[3];
          data[4] = data[4];
          break;
        default:
          data[1] = 0;
          data[2] = 0;
          data[3] = 0;
          data[4] = 0;   
          break;   
      }
    });
    print(currentAndLast["current"]);
    print(currentAndLast["last"]);
    double rpm;
    int currentCrankRev = (currentAndLast["current"][2] << 8) + currentAndLast["current"][1];
    int lastCrankRev = (currentAndLast["last"][2] << 8) + currentAndLast["last"][1];
    double currentCrankEventTime = ((currentAndLast["current"][4] << 8) + currentAndLast["current"][3]) * (1 / 1024);
    double lastCrankEventTime = ((currentAndLast["last"][4] << 8) + currentAndLast["last"][3]) * (1 / 1024);

    if(currentCrankEventTime != lastCrankEventTime){
      rpm = 60 * (currentCrankRev - lastCrankRev)/(currentCrankEventTime - lastCrankEventTime);
    }
    else{
      rpm = 0;
    }



    return rpm.round();
  }

  void characteristicStreamingStatus(bool status){
    c.setIsCharacteristicStreaming = status;
  }
}
