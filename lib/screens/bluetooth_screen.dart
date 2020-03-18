import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothStuff extends StatefulWidget {
  @override
  _BluetoothStuffState createState() => _BluetoothStuffState();
}

class _BluetoothStuffState extends State<BluetoothStuff> {

  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice device;
  BluetoothState state;
  BluetoothDeviceState deviceState;
  BluetoothCharacteristic c;
  Stream<List<int>> listStream; 
  var scanSubscription;
  

  bool _isLoading ;

  void connectToDevice() async {
    await device.connect();
    print("connected to device");
    discoverServices();
    setState(() {
      _isLoading = false;
    });

  }

  void disconnectDevice() async{
    await device.disconnect();
  }

  void scanForDevices() async {
    flutterBlue.connectedDevices.asStream().listen((paired) {
      print('paired device: $paired');
    });
    scanSubscription = flutterBlue.scan().listen((scanResult) async {
    if (scanResult.device.name == "Ride SenseV01 BACU2Q55") {
      print("found device");
      print(state);
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
      }

    });
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
        setState(() {
          _isLoading = false;
        }); 
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
            Text("On est connecté")

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

  Widget myStreamListener(){
    StreamBuilder<List<int>>(
      stream: listStream,
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot){
        if (snapshot.connectionState == ConnectionState.active){
          print("currentValue");
          return Center(
            child: Text("Data Received")
            );
        }
        else{
          return SizedBox();
        }
          
      },
      );
  }
}
