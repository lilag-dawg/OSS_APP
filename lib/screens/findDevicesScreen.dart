import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:oss_app/models/OSSDevice.dart';

import '../widgets/customTile.dart';
import '../models/deviceConnexionStatus.dart';
import '../models/bluetoothDeviceManager.dart';
import '../models/OSSDevice.dart';

import '../constants.dart' as Constants;

class FindDevicesScreen extends StatefulWidget {
  final BluetoothDeviceManager ossManager;
  FindDevicesScreen({Key key, @required this.ossManager}) : super(key: key);

  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen>{

  List<BluetoothDevice> alreadyConnectedDevices = [];
  List<DeviceConnexionStatus> devicesConnexionStatus = [];
  StreamSubscription<List<ScanResult>> scanSubscription;
  bool isDoneScanning;


  Future<void> performScan() async {
    scanSubscription = FlutterBlue.instance.scanResults.listen((scanResults) {
      for (ScanResult r in scanResults) {
        bool isDeviceAlreadyAdded =
            devicesConnexionStatus.any((d) => d.getDevice == r.device);
        if (!isDeviceAlreadyAdded) {
          devicesConnexionStatus.add(DeviceConnexionStatus(
            device: r.device,
            connexionStatus: DeviceConnexionStatus.disconnected,
          ));
        }
      }
    });

    await getConnectedDevice().then((alreadyConnectedDevices) async {
      for (BluetoothDevice d in alreadyConnectedDevices) {
        bool isDeviceAlreadyAdded =
            devicesConnexionStatus.any((device) => device.getDevice == d);
        if (!isDeviceAlreadyAdded) {
          devicesConnexionStatus.add(DeviceConnexionStatus(
            device: d,
            connexionStatus: DeviceConnexionStatus.connected,
          ));
          await addOSSDevice(d);
        } else {
          int errorFromScanResult = devicesConnexionStatus
              .indexWhere((device) => device.getDevice == d);
          devicesConnexionStatus[errorFromScanResult].setConnexionStatus = DeviceConnexionStatus.connected;
        }
      }
    });
  }

  Future<List<BluetoothDevice>> getConnectedDevice() async {
    List<BluetoothDevice> devices = await FlutterBlue.instance.connectedDevices;
    return devices;
  }

  Future<void> addOSSDevice(BluetoothDevice device) async {
    await OSSDevice.create(device).then((createdOSSDevice) {
      widget.ossManager.setDevice(createdOSSDevice);
    });
  }

  Future<void> _handleOnpressChanged(
      DeviceConnexionStatus c, String currentStatus) async {
    final selectedDevice =
        devicesConnexionStatus.firstWhere((item) => item == c);    
    if (currentStatus == DeviceConnexionStatus.connected) {
      await c.device.disconnect().then((_) => currentStatus = DeviceConnexionStatus.disconnected);
      widget.ossManager.remove();
    } else {
      await c.device.connect().then((value) async => await addOSSDevice(c.device).then((value) async {
        currentStatus = DeviceConnexionStatus.connected;
        for(DeviceConnexionStatus dc in devicesConnexionStatus){
          if(dc.connexionStatus == DeviceConnexionStatus.connected && dc != c){
            await dc.device.disconnect().then((_) => dc.connexionStatus = DeviceConnexionStatus.disconnected);
          }
        }
      })).timeout(Duration(seconds: 5), onTimeout: (){
        currentStatus = DeviceConnexionStatus.disconnected;
        return null; //on pourrait rajouter un snackbar pour montrer à l'utilisateur que le connexion avec l'appareil n'a pas pu être établie
      });
    }
    setState(() {
      selectedDevice.setConnexionStatus = currentStatus;
    });
  }

  List<Widget> _buildCustomTiles(List<DeviceConnexionStatus> result) {
    return result
        .map(
          (d) => CustomTile(
            currentDevice: d,
            onTapTile: (String currentStatus) async {
              setState(() {
                d.setConnexionStatus = DeviceConnexionStatus.inTransistion;
              });
              await _handleOnpressChanged(d, currentStatus);
            },
          ),
        )
        .toList();
  }

  Widget _buildScanningButton() {
    return StreamBuilder(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return RaisedButton(
              child: Text("Remettre à plus tard"),
              color: Colors.red,
              onPressed: () => FlutterBlue.instance.stopScan(),
            );
          } else {
            return RaisedButton(
                child: Text("Rechercher de OSS"),
                onPressed: () {
                  setState(() {
                    isDoneScanning = false;
                  });
                  startAScan();
                });
          }
        });
  }

  Widget _buildAnimations() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Center(
        child:Column(
        children: <Widget>[
          Text("Recherche de OSS.."),
        ],
      ),
    )
    );
  }


  
  Widget _buildBody(){
    return Scaffold(
        backgroundColor: Color(Constants.backGroundBlue),
        appBar: AppBar(
          title: Text("Bluetooth Manager"),
          backgroundColor: Color(Constants.blueButtonColor),
        ),
        body: SingleChildScrollView(
      child: Column(children: <Widget>[
        (isDoneScanning)
            ? Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      children: _buildCustomTiles(devicesConnexionStatus),
                    ),
                  ),
                ],
              )
            : _buildAnimations(),
        (Constants.isWorkingOnEmulator)
            ? RaisedButton(
                child: Text("Remettre à plus tard"),
                color: Colors.red,
                onPressed: () {})
            : _buildScanningButton(),
      ]),
    )
    );
  }

  void startAScan() {
    isDoneScanning = false;
    if (!Constants.isWorkingOnEmulator) {
      FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)).then((_) {
        setState(() {
          isDoneScanning = true;
        });
      });
      performScan();
    }
  }

  @override
  void initState() {
    startAScan();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    if (!Constants.isWorkingOnEmulator) {
      FlutterBlue.instance.stopScan();
      scanSubscription.cancel();
    }
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}