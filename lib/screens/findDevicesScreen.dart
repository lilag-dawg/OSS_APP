import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

import '../constants.dart' as Constants;
import '../widgets/customCheckbox.dart';
import '../models/deviceResult.dart';
import '../models/connectedDevices.dart';
import '../utile/deviceDataHandling.dart';

import '../models/customBluetoothDevice.dart';


class FindDevicesScreen extends StatefulWidget {
  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> with TickerProviderStateMixin  {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> alreadyConnectedDevices = [];
  List<DeviceResult> devicesInfos = [];

  AnimationController _controller;
  bool isDoneScanning;

  Future<void> scanForDevices() async {
    flutterBlue.scan(timeout: Duration(seconds: 4)).listen((scanResult) {
      bool isDeviceAlreadyAdded =
          devicesInfos.any((d) => d.getDevice == scanResult.device);
      if (!isDeviceAlreadyAdded) {
        devicesInfos.add(DeviceResult(
          device: scanResult.device,
          connexionStatus: false,
        ));
      }
    }, onDone: () async {
      flutterBlue.stopScan();
      alreadyConnectedDevices = await getConnectedDevice();
      if (alreadyConnectedDevices.length != 0) {
        for (BluetoothDevice d in alreadyConnectedDevices) {
          bool isDeviceAlreadyAdded =
              devicesInfos.any((device) => device.getDevice == d);
          if (!isDeviceAlreadyAdded) {
            devicesInfos.add(DeviceResult(
              device: d,
              connexionStatus: true,
            ));
          }
        }
      }
      setState(() {
        isDoneScanning = true;
      });
    });
  }

  Future<List<BluetoothDevice>> getConnectedDevice() async {
    List<BluetoothDevice> devices = await flutterBlue.connectedDevices;
    return devices;
  }


  Future<List<int>> getCharacteristic(BluetoothCharacteristic c) async {
    List<int> value;
    if('0x${c.uuid.toString().toUpperCase().substring(4, 8)}' == "0x2A5C"){
      value = await c.read();
    }
    return value;
  }

  Future<void> _handleOnpressChanged(
      BluetoothDevice device, bool newStatus, ConnectedDevices cd) async {
    final selectedDevice =
        devicesInfos.firstWhere((item) => item.getDevice == device);
    if (selectedDevice.connexionStatus) {
      await selectedDevice.device.disconnect();
      cd.remove(device);
    } else {
      await selectedDevice.device.connect();
      //await getDeviceFeatures(device,cd);
      await CustomBluetoothDevice.create(device).then((customD){
        cd.add(customD);
      });
      
    }
    setState(() {
      selectedDevice.setConnexionStatus = newStatus;
    });
  }


  List<Widget> _buildCustomTiles(List<DeviceResult> result, ConnectedDevices cd) {
    return result
        .map(
          (d) => CustomTile(
            currentDevice: d,
            onPressed: (BluetoothDevice d, bool status) async {
              await _handleOnpressChanged(d, status, cd);
            },
          ),
        )
        .toList();
  }

  Widget _buildBody(ConnectedDevices cd) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Column(children: _buildCustomTiles(devicesInfos, cd)),
          Center(
            child: RaisedButton(
              child: Text("Show Data"),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () => Navigator.of(context).pop(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFloatingButton(){
    return StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () {
                scanForDevices();
                setState(() {
                  isDoneScanning = false;
                });
              },
            );
          }
        },
      );
  }


  Widget _buildAnimations(){
    return RotationTransition(
      turns: Tween(
        begin: 0.0,
        end: 2.0
      ).animate(_controller),
      child: Center(
        child: Container(
          child: Image.asset("assets/oss_logo.png"),
          height: 120.0,
          width: 120.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync:this,
    );
    _controller.repeat();
    isDoneScanning = false;
    scanForDevices();
    // TODO: implement initState
    super.initState();
  }
  @override
void dispose() {
  _controller.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    final cd = Provider.of<ConnectedDevices>(context);
    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        title: Text("Manage your Devices"),
        backgroundColor: Color(Constants.blueButtonColor),
      ),
      body: !isDoneScanning
          ? _buildAnimations()
          : _buildBody(cd),
      floatingActionButton: _buildFloatingButton()
    );
  }
}
