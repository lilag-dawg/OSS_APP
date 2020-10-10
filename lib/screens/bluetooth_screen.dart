

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothStuff extends StatefulWidget {
  @override
  _BluetoothStuffState createState() => _BluetoothStuffState();
}

class _BluetoothStuffState extends State<BluetoothStuff> {

  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice device;

  Stream<List<int>> listStream; 
  var scanSubscription;
  List<int> lastdata = [];
  List<int> currentdata = [];
  double lastRpm = 0;
  double currentRpm = 0;

  
  

  bool _isLoading = true;

  void connectToDevice() async {
    await device.connect();
    print("connected to device");
    discoverServices();
  }

  void disconnectDevice() async{
    await device.disconnect();
  }

  void scanForDevices() async {
    scanSubscription = flutterBlue.scan().listen((scanResult) async {
    if (scanResult.device.name == "Ride SenseV01 BACU2Q55") {
      print("found device");
      //Assigning bluetooth device
      device = scanResult.device; 
      //After that we stop the scanning for device
      stopScanning();
      connectToDevice(); 
      }
    });

  }

  void stopScanning(){
    flutterBlue.stopScan();
    scanSubscription.cancel();
  }

  void discoverServices() async{
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service){
      if ('0x${service.uuid.toString().toUpperCase().substring(4, 8)}' == "0x1816"){
        print("service trouve");
        service.characteristics.forEach((characteristic){
          if('0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}' == "0x2A5B"){
            print("0x2A5B trouve");
            listStream = characteristic.value;
            characteristic.setNotifyValue(!characteristic.isNotifying);
            setState(() {
             _isLoading = false;
            });
          }
        });
      }
      /*if('0x${service.uuid.toString().toUpperCase().substring(4, 8)}' == "0x180F"){
        service.characteristics.forEach((characteristic){
        if('0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}' == "0x2A19"){
          print("0x2A19 trouve");
          c =characteristic;
          batteryLevel();
          }
        });
      }*/

    });
  }

  void setLastAndCurrentData(List<int> data){
    if(lastdata.length  == 0){
      lastdata = data;
      currentdata = data;
    }
    else{
      lastdata = currentdata;
      currentdata = data;
    }
  }

  double interpretReceivedData(List<int> data) {

    double rpm = 0;

    setLastAndCurrentData(data);
    if(lastdata != null && currentdata != null){
      int flags = currentdata[0];

      bool wheelRevFlag = (flags & 0x01 > 0);
      bool crankRevFlag = (flags & 0x02 > 0);

      //todo

      if(wheelRevFlag){
        int wheelRev = 0;
        int lasWheelRev = 0;

      }
      if(crankRevFlag){
        //convert little to big endian
        int crankRev = (currentdata[8] << 8) + (currentdata[7]);
        int lastCrankRev = (lastdata[8] << 8) + (lastdata[7]);
        double crankEventTime = ((currentdata[10] << 8) + (currentdata[9]))*(1/1024);
        double lastCrankEventTime = ((lastdata[10] << 8) + (lastdata[9]))*(1/1024);

        if(crankEventTime != lastCrankEventTime && crankRev != lastCrankRev){
          currentRpm = 60*(crankRev - lastCrankRev)/((crankEventTime - lastCrankEventTime));

        }
        else{
          currentRpm = 0;
        }       
    
        if(lastRpm == 0){
          lastRpm = currentRpm;
        }
        if(lastRpm == currentRpm || currentRpm < 0){
          rpm = lastRpm;
        }
        else{
          rpm = currentRpm;
          currentRpm = lastRpm;
        }

      }

    }

    return rpm;
    

  }



  

  @override
  void initState(){
    super.initState();

    //checks bluetooth current state
    flutterBlue.state.listen((state) {
      if (state == BluetoothState.off) {
        print("allume ton bluetooth");
        if (device != null){
          disconnectDevice();
        }
        if(scanSubscription != null){
          stopScanning();
        }
        setState(() {
          _isLoading = true;
        });

      } else if (state == BluetoothState.on) {
        print("le bluetooth est on");
        scanForDevices(); 
      }
    });
}


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
      ),
      body: Container(
        child: _isLoading
        ? _showCircularProgress()
        : Column(
          children: <Widget>[
            Text("On est connecté"),
            StreamBuilder<List<int>>(
              stream: listStream,
              initialData: [],
              builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot){
                final value = snapshot.data;
                
                if (value != null && value.length>0 &&      snapshot.connectionState == ConnectionState.active){
                  print(value);
                  var rpm = interpretReceivedData(value);
                  return Center(
                    //child : Text('aaa')
                    //child: rpm != null ? Text(rpm.toStringAsFixed(0)) : Text('oups')
                    child: Text(rpm.toStringAsFixed(0))
                    );
                }
                else{
                  return Text("Data missing");
                }
              }
            )
          ],
          ),
        ),

      
    );
  }
    Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

}

