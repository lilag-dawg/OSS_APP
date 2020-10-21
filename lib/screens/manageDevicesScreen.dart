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


  String paired = "Paired";
  String notPaired = "notPaired";

  List<Widget> _buildConnectedDevicesTiles(List<String> result, BluetoothDeviceManager ossManager) {
    return result.map((d) => _customCardTile(d, paired, ossManager)).toList();
  }

  List<Widget> _buildAvailableDevicesTiles(List<String> result, BluetoothDeviceManager ossManager) {
    return result.map((d) => _customCardTile(d, notPaired, ossManager)).toList();
  }

  Future<void> _getList(Stream<List<int>> stream, int numberOfsensor) async {
    int count = 0;
    String currentName = "";
    await for (var value in stream) {
      if (value.isNotEmpty) {
        if (count == numberOfsensor) break;
        currentName =
            BluetoothDeviceManager.convertRawToStringListCapteursCharact(value);
        if(value[0] & 0x01 == 1){
          if (!connectedDevices.contains(currentName)){
            connectedDevices.add(currentName);
            count = count + 1;
          }
        }
        else{
          if (!availableDevices.contains(currentName)){
            availableDevices.add(currentName);
            count = count + 1;
          }
        }
      }
    }
  }

  Future<int> _getNumberOfSensorCharact(BluetoothDeviceManager ossManager) async{

      BluetoothDeviceCharacteristic nombreCapteursCharact = ossManager.ossDevice
        .getService(BluetoothDeviceManager.connectionHandlingService)
        .getCharacteristic(BluetoothDeviceManager.nombreCapteursCharact);

      int number = 0;

      await nombreCapteursCharact.characteristic.read().then((value) => number = BluetoothDeviceManager.convertRawToIntCapteursCharact(value));

      return number;
  }

  Future<void> _getSensorStringListFromCharact(
      BluetoothDeviceManager ossManager) async {

    BluetoothDeviceCharacteristic listCapteursCharact = ossManager.ossDevice
        .getService(BluetoothDeviceManager.connectionHandlingService)
        .getCharacteristic(BluetoothDeviceManager.listCapteursCharact);

    int numberOfsensor = 0;

    if (listCapteursCharact != null) {
      await _getNumberOfSensorCharact(ossManager).then((value) => numberOfsensor = value);
      await listCapteursCharact.characteristic.setNotifyValue(true);
      await _getList(listCapteursCharact.characteristic.value, numberOfsensor)
          .then((value) async {
        await listCapteursCharact.characteristic.setNotifyValue(false);
      });
    }
  }

  Future<void> _writeToMCU(String deviceName, String status, BluetoothDeviceManager ossManager) async{
      BluetoothDeviceCharacteristic paringRequestCharact = ossManager.ossDevice
        .getService(BluetoothDeviceManager.connectionHandlingService)
        .getCharacteristic(BluetoothDeviceManager.paringRequestCharact);

      await paringRequestCharact.characteristic.write(BluetoothDeviceManager.sendPairingRequestCharact(deviceName, status)).then((value) => print(value));
  }

  Future<void> _handlePressTrailing(String deviceName, String status, BluetoothDeviceManager ossManager) async{
    await _writeToMCU(deviceName, status, ossManager).then((value){
      setState(() {
        connectedDevices.clear();
        availableDevices.clear();
      });
    });
  }

  Widget _customCardTile(String deviceName, String status, BluetoothDeviceManager ossManager) {
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
              onPressed: () async {
                await _handlePressTrailing(deviceName, status, ossManager);
              }),
        ));
  }

  Widget _buildMainBody(BluetoothDeviceManager ossManager) {
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
              Column(children: _buildConnectedDevicesTiles(connectedDevices, ossManager))
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
              Column(children: _buildAvailableDevicesTiles(availableDevices, ossManager))
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
            return _buildMainBody(ossManager);
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
