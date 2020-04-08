import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import './screens/statistics_screen.dart';
import './widgets/customCheckbox.dart';
import './models/deviceInfo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDeviesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state.toString().substring(15)}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDeviesScreen extends StatefulWidget {
  @override
  _FindDeviesScreenState createState() => _FindDeviesScreenState();
}

class _FindDeviesScreenState extends State<FindDeviesScreen> {
  Map<ScanResult, bool> devicesStatus = {};
  List<BluetoothDevice> connectToDevices = [];
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> alreadyConnectedDevices;

  List<DeviceInfo> devicesInfos = [];

  bool isDoneScanning;

  Future<void> scanForDevices() async {
    flutterBlue.scan(timeout: Duration(seconds: 4)).listen((scanResult) {
      devicesStatus.putIfAbsent(scanResult, () => false);
      bool isDeviceAlreadyAdded =
          devicesInfos.any((d) => d.getDevice == scanResult.device);
      if (!isDeviceAlreadyAdded) {
        devicesInfos.add(DeviceInfo(
            device: scanResult.device,
            connexionStatus: false,
            checkboxStatus: false));
      }
    }, onDone: () async {
      flutterBlue.stopScan();
      alreadyConnectedDevices = await getConnectedDevice();
      //compareMapToList(devicesStatus, alreadyConnectedDevices);
      setState(() {
        isDoneScanning = true;
      });
    });
  }

  Future<List<BluetoothDevice>> getConnectedDevice() async {
    List<BluetoothDevice> devices = await flutterBlue.connectedDevices;
    return devices;
  }

  void _handleTapboxChanged(BluetoothDevice device, bool isCheckboxChecked) {
    final selectedDevice =
        devicesInfos.firstWhere((item) => item.getDevice == device);
    if (isCheckboxChecked) {
      connectToDevices.add(selectedDevice.device);
    } else {
      connectToDevices.removeWhere((d) => d == device);
    }
    setState(() {
      selectedDevice.setCheckboxStatus = isCheckboxChecked;
    });
  }

  Future<void> _handleOnpressChanged(
      BluetoothDevice device, bool newStatus) async {
    final selectedDevice =
        devicesInfos.firstWhere((item) => item.getDevice == device);
    if (selectedDevice.connexionStatus) {
      await selectedDevice.device.disconnect();
    } else {
      await selectedDevice.device.connect();
    }
    setState(() {
      selectedDevice.setConnexionStatus = newStatus;
    });
  }

  List<Widget> _buildCustomTiles(List<DeviceInfo> result) {
    return result
        .map(
          (d) => CustomTile(
            currentDevice: d,
            checkStatus: d.checkboxStatus,
            onChanged: (BluetoothDevice d, bool val) {
              _handleTapboxChanged(d, val);
            },
            onPressed: (BluetoothDevice d, bool status) async {
              await _handleOnpressChanged(d, status);
            },
          ),
        )
        .toList();
  }

  Widget _circularProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.cyan,
        strokeWidth: 5,
      ),
    );
  }

  @override
  void initState() {
    isDoneScanning = false;
    scanForDevices();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Devices to connect"),
      ),
      body: !isDoneScanning
          ? _circularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Column(children: _buildCustomTiles(devicesInfos)),
                  Center(
                    child: RaisedButton(
                      child: Text("Show Data"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StatisticsScreen(
                                    devices: connectToDevices)));

                        isDoneScanning = false;
                        scanForDevices();
                      },
                    ),
                  )
                ],
              ),
            ),
      floatingActionButton: StreamBuilder<bool>(
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
      ),
    );
  }
}
