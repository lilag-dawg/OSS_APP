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

  List<Device> receivedDevices = [];

  String paired = "Paired";
  String notPaired = "notPaired";

  List<Widget> _buildPairedDevicesTiles(
      List<Device> result, BluetoothDeviceManager ossManager) {
    return result.map((d) => _customListTile(d.name, d.status, ossManager)).toList();
  }

  List<Widget> _buildAvailableDevicesTiles(
      List<Device> result, BluetoothDeviceManager ossManager) {
    return result
        .map((d) => _customListTile(d.name, d.status, ossManager))
        .toList();
  }


  Future<void> _getSensorNamesList(Stream<List<int>> stream, int numberOfsensor) async {
    String currentName = "";
    String currentStatus = "";
    int count  = 0;
    await for (var value in stream) {
      if (value.isNotEmpty) {
        currentName = BluetoothDeviceManager.convertRawToStringListCapteursCharact(value);
        if (value[0] & 0x01 == 1) {
          currentStatus = paired;
        } else {
          currentStatus = notPaired;
        }
        if(receivedDevices.where((element) => element.name == currentName && element.status == currentStatus).isNotEmpty){
          count = count + 1;
        }
        else{
          if(receivedDevices.where((element) => element.name == currentName).isEmpty){
            receivedDevices.add(Device(currentName, currentStatus));
          }
          else{
            int index = receivedDevices.indexOf(receivedDevices.firstWhere((element) => element.name == currentName));
            receivedDevices[index] = Device(currentName, currentStatus);
          }
        }
        if (count == numberOfsensor) break;
      }
    }
  }

  Future<SupportedDataType> _getSensorDataTypes(Stream<List<int>> stream, String deviceName) async {
    String currentName = "";
    SupportedDataType supportedDataType = SupportedDataType(false,false,false,false,false);
    await for (var value in stream){
      currentName = BluetoothDeviceManager.convertRawToStringListCapteursCharact(value);
      if(currentName == deviceName){
        if(value[0] & 0x1 == 1){
          supportedDataType.gear = true;
        }
        else{
          supportedDataType.gear = false;
        }

        if(value[0] & 0x2 == 2){
          supportedDataType.battery = true;
        }
        else{
          supportedDataType.battery = false;
        }

        if(value[0] & 0x4 == 4){
          supportedDataType.power = true;
        }
        else{
          supportedDataType.power = false;
        }

        if(value[0] & 0x8 == 8){
          supportedDataType.speed = true;
        }
        else{
          supportedDataType.speed = false;
        }

        if(value[0] & 0x10 == 16){
          supportedDataType.cadence = true;
        }
        else{
          supportedDataType.cadence = false;
        }
        break;
      }
    }
    return supportedDataType;

  }

  Future<int> _getNumberOfSensorCharact(
      BluetoothDeviceManager ossManager) async {
    BluetoothDeviceCharacteristic nombreCapteursCharact = ossManager.ossDevice
        .getService(BluetoothDeviceManager.connectionHandlingService)
        .getCharacteristic(BluetoothDeviceManager.nombreCapteursCharact);

    int number = 0;

    await nombreCapteursCharact.characteristic.read().then((value) =>
        number = BluetoothDeviceManager.convertRawToIntCapteursCharact(value));

    return number;
  }

  Future<void> _getSensorStringListFromCharact(
      BluetoothDeviceManager ossManager) async {
    BluetoothDeviceCharacteristic listCapteursCharact = ossManager.ossDevice
        .getService(BluetoothDeviceManager.connectionHandlingService)
        .getCharacteristic(BluetoothDeviceManager.listCapteursCharact);

    int numberOfsensor = 0;

    if (listCapteursCharact != null) {
      await _getNumberOfSensorCharact(ossManager)
          .then((value) => numberOfsensor = value);
      await listCapteursCharact.characteristic.setNotifyValue(true);
      await _getSensorNamesList(listCapteursCharact.characteristic.value, numberOfsensor)
          .then((value) async {
        await listCapteursCharact.characteristic.setNotifyValue(false);
      });
    }
  }

  Future<Device> _getSensorDataTypeFromCharact(BluetoothDeviceManager ossManager, String deviceName) async{
    BluetoothDeviceCharacteristic sensorSupportedData = ossManager.ossDevice.getService(BluetoothDeviceManager.connectionHandlingService).getCharacteristic(BluetoothDeviceManager.sensorDataType);
    await sensorSupportedData.characteristic.setNotifyValue(true);
    await _getSensorDataTypes(sensorSupportedData.characteristic.value, deviceName).then((value) async{
      await sensorSupportedData.characteristic.setNotifyValue(false);
      //maybe need to add a setstate
      receivedDevices.firstWhere((element) => element.name == deviceName).setSupportedDataType(value);
    });

    return receivedDevices.firstWhere((element) => element.name == deviceName);

  }

  Future<void> _writeToMCU(String deviceName, String status,
      BluetoothDeviceManager ossManager) async {
    BluetoothDeviceCharacteristic paringRequestCharact = ossManager.ossDevice
        .getService(BluetoothDeviceManager.connectionHandlingService)
        .getCharacteristic(BluetoothDeviceManager.paringRequestCharact);

    await paringRequestCharact.characteristic
        .write(BluetoothDeviceManager.sendPairingRequestCharact(
            deviceName, status));
  }

  Future<void> _handlePressTrailing(String deviceName, String status,
      BluetoothDeviceManager ossManager) async {
    await _writeToMCU(deviceName, status, ossManager).then((value) {
      setState(() {
        receivedDevices.clear();
      });
    });
  }

  Widget _customListTile(
      String deviceName, String status, BluetoothDeviceManager ossManager) {
    return ListTile(
      leading: (status == paired)
          ? Icon(Icons.bluetooth_connected)
          : Icon(Icons.bluetooth_disabled),
      title: Text(deviceName),
      subtitle: (status == paired) ? Text("Active - Tap for informations") : SizedBox.shrink(),
      trailing: _customTrailing(deviceName, status, ossManager),
      onTap: () async{
        if(status == paired){
           await _getSensorDataTypeFromCharact(ossManager,deviceName).then((value) async {
             await _showPopUp(value);
           });
        }
      },
    );
  }

  Widget _customTrailing(
      String deviceName, String status, BluetoothDeviceManager ossManager) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(width:1, color: Colors.black45))
      ),
      padding: EdgeInsets.only(left:5),
      child: RaisedButton(
          child: (status == paired) ? Text("Forget") : Text("Pair"),
          onPressed: () async {
            await _handlePressTrailing(deviceName, status, ossManager);
          }),
    );
  }

  Future<void> _showPopUp(Device device) async{
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(device.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("List of supported features"),
                CheckboxListTile(
                  title: Text("Power"),
                  value: device.supportedDataType.power,
                  onChanged: null),
                CheckboxListTile(
                  title: Text("cadence"),
                  value: device.supportedDataType.cadence,
                  onChanged: null),
                CheckboxListTile(
                  title: Text("speed"),
                  value: device.supportedDataType.speed,
                  onChanged: null),
                CheckboxListTile(
                  title: Text("battery"),
                  value: device.supportedDataType.battery,
                  onChanged: null),
                CheckboxListTile(
                  title: Text("gear"),
                  value: device.supportedDataType.gear,
                  onChanged: null),                  
              ],
            ),
          ),
        actions: <Widget>[
          RaisedButton(
            child: Text('OK!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ], 
        );
      }
    );
  }

  Widget _customBox(BluetoothDeviceManager ossManager, String title,
      List<Widget> widgetList) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black45,
          width: 1,
        ),
      ),
      child: Column(children: [
        Align(
          alignment: FractionalOffset(0.1, 0),
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 5),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 1.5,
          color: Colors.black54,
        ),
        Column(
          children: widgetList,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        )
      ]),
    );
  }

  Widget _buildMainBody(BluetoothDeviceManager ossManager) {
    List<Device> notPairedDevices = receivedDevices.where((element) => element.status == notPaired).toList();
    List<Device> pairedDevices = receivedDevices.where((element) => element.status == paired).toList();
    return Container(
      child: Column(
        children: [
          _customBox(ossManager, "Available Devices",
              _buildAvailableDevicesTiles(notPairedDevices, ossManager)),
          _customBox(ossManager, "Paired Devices",
              _buildPairedDevicesTiles(pairedDevices, ossManager)),
        ],
      ),
    );
  }

  Widget _buildBody(BluetoothDeviceManager ossManager) {
    return FutureBuilder<void>(
      future: _getSensorStringListFromCharact(ossManager),
      builder: (c, snapshot) {
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildMainBody(ossManager);
        } else {
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

class Device {
  String name;
  String status;
  SupportedDataType supportedDataType;

  Device(String name, String status){
    this.name = name;
    this.status = status;
  }

  get deviceDataType{
    return supportedDataType;
  }

  void setSupportedDataType(SupportedDataType supportedDataType){
    this.supportedDataType = supportedDataType;
  }
}

class SupportedDataType{
  bool cadence;
  bool speed;
  bool battery;
  bool power;
  bool gear;

  SupportedDataType(bool cadence, bool speed, bool battery, bool power, bool gear){
    this.cadence = cadence;
    this.speed = speed;
    this.battery = battery;
    this.power = power;
    this.gear = gear;
  }
}