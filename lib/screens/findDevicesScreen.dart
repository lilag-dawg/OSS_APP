import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

import '../constants.dart' as Constants;
import '../widgets/customCheckbox.dart';
import '../models/deviceInfo.dart';
import '../models/connectedDevices.dart';

class FindDevicesScreen extends StatefulWidget {
  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  List<BluetoothDevice> connectToDevices = [];
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> alreadyConnectedDevices = [];

  List<DeviceInfo> devicesInfos = [];

  bool isDoneScanning;

  Future<void> scanForDevices() async {
    flutterBlue.scan(timeout: Duration(seconds: 4)).listen((scanResult) {
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
      if (alreadyConnectedDevices.length != 0) {
        for (BluetoothDevice d in alreadyConnectedDevices) {
          devicesInfos.add(DeviceInfo(
              device: d, connexionStatus: true, checkboxStatus: true));
        }
        connectToDevices = [...alreadyConnectedDevices];
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
      connectToDevices.removeWhere((d) => d == device);
    } else {
      await selectedDevice.device.connect();
    }
    setState(() {
      selectedDevice.setConnexionStatus = newStatus;
    });
  }

  void myPressHandler(BuildContext context,ConnectedDevices cd) {
    cd.copy(connectToDevices);
    Navigator.of(context).pop();

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
    final cd = Provider.of<ConnectedDevices>(context);
    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        title: Text("Select Devices to connect"),
        backgroundColor: Color(Constants.blueButtonColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => myPressHandler(context,cd)
          ),
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
                      onPressed: () {
                        myPressHandler(context,cd);
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
