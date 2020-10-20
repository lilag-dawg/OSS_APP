import 'package:flutter/material.dart';
import '../constants.dart' as Constants;
import '../models/bluetoothDeviceManager.dart';
import 'package:provider/provider.dart';

import '../models/bluetoothDeviceCharacteristic.dart';

class ManageDevicesScreen extends StatefulWidget {
  @override
  _ManageDevicesScreenState createState() => _ManageDevicesScreenState();
}

class _ManageDevicesScreenState extends State<ManageDevicesScreen> {
  List<String> connectedDevices = [];
  List<String> availableDevices = [];

  int numberOfsensor = 0;

  String paired = "Paired";
  String notPaired = "notPaired";

  List<Widget> _buildConnectedDevicesTiles(List<String> result) {
    return result.map((d) => _customCardTile(d, paired)).toList();
  }

  List<Widget> _buildAvailableDevicesTiles(List<String> result) {
    return result.map((d) => _customCardTile(d, notPaired)).toList();
  }

  Future<void> _getList(Stream<List<int>> stream) async {
    int count = 0;
    String currentName = "";
    await for (var value in stream) {
      if (value.isNotEmpty) {
        if (count == numberOfsensor) break;
        currentName =
            BluetoothDeviceManager.convertRawToStringListCapteursCharact(value);
        if (!availableDevices.contains(currentName))
          availableDevices.add(currentName);
        count = count + 1;
      }
    }
  }

  Future<void> _getSensorStringListFromCharact(
      BluetoothDeviceManager ossManager) async {

    BluetoothDeviceCharacteristic listCapteursCharact = ossManager.ossDevice
        .getService(BluetoothDeviceManager.connectionHandlingService)
        .getCharacteristic(BluetoothDeviceManager.listCapteursCharact);

    BluetoothDeviceCharacteristic nombreCapteursCharact = ossManager.ossDevice
        .getService(BluetoothDeviceManager.connectionHandlingService)
        .getCharacteristic(BluetoothDeviceManager.nombreCapteursCharact);

    if (listCapteursCharact != null) {
      await nombreCapteursCharact.characteristic.read().then((value) => numberOfsensor = BluetoothDeviceManager.convertRawToIntCapteursCharact(value));
      await listCapteursCharact.characteristic.setNotifyValue(true);
      await _getList(listCapteursCharact.characteristic.value)
          .then((value) async {
        await listCapteursCharact.characteristic.setNotifyValue(false);
      });
    }
  }

  void _handlePressTrailing(String deviceName, String status) {
    setState(() {
      if (status == paired) {
        connectedDevices.remove(deviceName);
        availableDevices.add(deviceName);
      } else {
        availableDevices.remove(deviceName);
        connectedDevices.add(deviceName);
      }
    });
  }

  Widget _customCardTile(String deviceName, String status) {
    return Card(
        color: Colors.black12,
        child: ListTile(
          leading: (status == paired)
              ? Icon(Icons.bluetooth_connected)
              : Icon(Icons.bluetooth_disabled),
          title: Text(deviceName),
          subtitle: (status == paired) ? Text('Active') : SizedBox.shrink(),
          trailing: RaisedButton(
              child: (status == paired) ? Text("Forget") : Text("Pair"),
              onPressed: () {
                _handlePressTrailing(deviceName, status);
              }),
        ));
  }

  Widget _buildMainBody() {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black45,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: [
              Align(
                alignment: FractionalOffset(0.1, 0),
                child: Text(
                  "Connected Devices",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              Column(children: _buildConnectedDevicesTiles(connectedDevices))
            ]),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black45,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: [
              Align(
                alignment: FractionalOffset(0.1, 0),
                child: Text(
                  "Available Devices",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              Column(children: _buildAvailableDevicesTiles(availableDevices))
            ]),
          ),
        ],
      ),
    );
  }


  Widget _buildBody(BluetoothDeviceManager ossManager) {
    return FutureBuilder<void>(
      future: _getSensorStringListFromCharact(ossManager),
      builder: (c, snapshot) {
        print(snapshot.connectionState);
        if(snapshot.connectionState == ConnectionState.done){
            return _buildMainBody();
        }
        else{
          return Center(child: CircularProgressIndicator());
        }

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ossManager = Provider.of<BluetoothDeviceManager>(context);

    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        title: Text(ossManager.ossDevice.device.name),
        backgroundColor: Color(Constants.blueButtonColor),
      ),
      body: SingleChildScrollView(child: _buildBody(ossManager)),
    );
  }
}
