import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oss_app/models/bluetoothDeviceService.dart';
import '../constants.dart' as Constants;
import '../models/bluetoothDeviceManager.dart';
import 'package:provider/provider.dart';

import '../models/bluetoothDeviceCharacteristic.dart';

class ManageDevicesScreen extends StatefulWidget {
  @override
  _ManageDevicesScreenState createState() => _ManageDevicesScreenState();
}

class _ManageDevicesScreenState extends State<ManageDevicesScreen> {

  static String paired = "Paired";
  static String notPaired = "notPaired";
  static String connecting = "connecting";

  List<Device> receivedDevices = [];

  bool  _isDeviceOssCompatible(ossManager){
      BluetoothDeviceService customService = ossManager.ossDevice
      .getService(BluetoothDeviceManager.connectionHandlingService);

    if (customService != null){
      return true;
    }
    else return false;
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

  Future<void> _getListOfSensorCharact(
      BluetoothDeviceManager ossManager) async {
    BluetoothDeviceCharacteristic listCapteursCharact = ossManager.ossDevice
        .getService(BluetoothDeviceManager.connectionHandlingService)
        .getCharacteristic(BluetoothDeviceManager.listCapteursCharact);

    int numberOfsensor = 0;
    await _getNumberOfSensorCharact(ossManager).then((value) => numberOfsensor = value);
    await listCapteursCharact.characteristic.setNotifyValue(true);
    await _getSensorNamesList(listCapteursCharact.characteristic.value, numberOfsensor)
            .then((value) async {
              receivedDevices = value;
          await listCapteursCharact.characteristic.setNotifyValue(false);
    });
  }

    Future<List<Device>> _getSensorNamesList(Stream<List<int>> stream, int numberOfsensor) async {
    String currentName = "";
    String currentStatus = "";

    List<Device> listDevices = [];

    int count  = 0;
    await for (var value in stream) {
      if (value.isNotEmpty) {
        currentName = BluetoothDeviceManager.convertRawToStringListCapteursCharact(value);
        switch(value[0] & 0x3){
          case 0: //disconnect
            currentStatus = notPaired;
            break;
          case 1: //connect
            currentStatus = paired;
            break;
          case 2: //todo disconnecting
            break;
          case 3: //connecting
            currentStatus = connecting;
            break;
          default:
            break;
        }

        if(listDevices.where((element) => element.name == currentName && element.status == currentStatus).isNotEmpty){
          count = count + 1;
        }
        else{
          if(listDevices.where((element) => element.name == currentName).isEmpty){
            listDevices.add(Device(currentName, currentStatus));
          }
          else{
            int index = listDevices.indexOf(listDevices.firstWhere((element) => element.name == currentName));
            listDevices[index] = Device(currentName, currentStatus);
          }
        }
        if (count == numberOfsensor) break;
      }
    }
    return listDevices;
  }

  Widget _deviceIsNotOss(){
    return Text("device is not OSS");
  }

  Widget _deviceIsOss(BluetoothDeviceManager ossManager){
    List<Device> notPairedDevices = receivedDevices.where((element) => element.status == notPaired || element.status == connecting).toList();
    List<Device> pairedDevices = receivedDevices.where((element) => element.status == paired).toList();
    return Container(
      child: Column(
        children: [
          _customBox(ossManager, "Available Devices",
              _buildDevicesTiles(notPairedDevices, ossManager)),
          _customBox(ossManager, "Paired Devices",
              _buildDevicesTiles(pairedDevices, ossManager)),
        ],
      ),
    );
  }

  Widget _buildBody(BluetoothDeviceManager ossManager) {
    return FutureBuilder<void>(
      future: _getListOfSensorCharact(ossManager),
      builder: (c, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
            return _deviceIsOss(ossManager);         
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
      body: _isDeviceOssCompatible(ossManager) ? SingleChildScrollView(child: _buildBody(ossManager)) : _deviceIsNotOss(),
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

  List<Widget> _buildDevicesTiles(
    List<Device> result, BluetoothDeviceManager ossManager) {
    return result.map((d) => _CustomTile(device:d, ossManager: ossManager,onTapTile: (String currentStatus) {
              setState(() {
                receivedDevices.clear();
              });
            },)).toList();
  }
}

class _CustomTile extends StatefulWidget {
  final BluetoothDeviceManager ossManager;
  final Device device;
  final Function(String) onTapTile;
  
  const _CustomTile ({ Key key, this.ossManager, this.onTapTile, this.device}): super(key: key);

  @override
  __CustomTileState createState() => __CustomTileState();
}

class __CustomTileState extends State<_CustomTile> {

  static String paired = "Paired";
  static String notPaired = "notPaired";
  static String connecting = "connecting";

  String currentStatus = "";

  Future<void> _writeToMCU(String status,
        BluetoothDeviceManager ossManager) async {
      BluetoothDeviceCharacteristic paringRequestCharact = ossManager.ossDevice
          .getService(BluetoothDeviceManager.connectionHandlingService)
          .getCharacteristic(BluetoothDeviceManager.paringRequestCharact);

      await paringRequestCharact.characteristic
          .write(BluetoothDeviceManager.sendPairingRequestCharact(
              widget.device.name, status));
  }

  Future<void> _handlePressTrailing(String status,
        BluetoothDeviceManager ossManager) async {
      await _writeToMCU(status, ossManager).then((value) {
        if(status == paired){
          currentStatus = notPaired;
          widget.onTapTile(currentStatus);
        }
        else{
          setState(() {
            currentStatus = connecting;  
          });
        }
      });
  }

  Future<String> _waitForSensorConnection(Stream<List<int>> stream) async{
    String currentName = "";
    String currentStatus = notPaired;
    await for (var value in stream){
       currentName = BluetoothDeviceManager.convertRawToStringListCapteursCharact(value);
       if(widget.device.name == currentName){
        switch(value[0] & 0x3){
          case 0: //disconnect
            currentStatus = notPaired;
            break;
          case 1: //connect
            currentStatus = paired;
            break;
          case 2: //todo disconnecting
            break;
          case 3: //connecting
            break;
          default:
            break;
        }
        if(currentStatus == paired)
         break;  
       }
    }
    return currentStatus;
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

  Future<void> _getSensorDataTypeFromCharact(BluetoothDeviceManager ossManager) async{
    BluetoothDeviceCharacteristic sensorSupportedData = ossManager.ossDevice.getService(BluetoothDeviceManager.connectionHandlingService).getCharacteristic(BluetoothDeviceManager.sensorDataType);
    await sensorSupportedData.characteristic.setNotifyValue(true);
    await _getSensorDataTypes(sensorSupportedData.characteristic.value, widget.device.name).then((value) async{
      await sensorSupportedData.characteristic.setNotifyValue(false);
      //maybe need to add a setstate
      widget.device.setSupportedDataType(value);
    });
  }

  Future<void> _waitForSensorStringListFromCharact(BluetoothDeviceManager ossManager) async{
        BluetoothDeviceCharacteristic listCapteursCharact = ossManager.ossDevice
        .getService(BluetoothDeviceManager.connectionHandlingService)
        .getCharacteristic(BluetoothDeviceManager.listCapteursCharact);


      if (listCapteursCharact != null) {
        await listCapteursCharact.characteristic.setNotifyValue(true);
        await _waitForSensorConnection(listCapteursCharact.characteristic.value).timeout(Duration(seconds: 10), onTimeout: () async{
          await _writeToMCU(paired, ossManager); //cancel device pairing
          return notPaired;
        }).then((value) async {
          setState(() {
            currentStatus = value;
          });
          await listCapteursCharact.characteristic.setNotifyValue(false).then((value) => widget.onTapTile(currentStatus));
        });
    }
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

  Widget _customTrailing(
      String deviceName, String status, BluetoothDeviceManager ossManager) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(width:1, color: Colors.black45))
      ),
      padding: EdgeInsets.only(left:5),
      child: _footer(deviceName, status, ossManager)
    );
  }


  Widget _footer(String deviceName, String status, BluetoothDeviceManager ossManager){
    return (status == connecting)
    ? FutureBuilder<void>(
        future: _waitForSensorStringListFromCharact(ossManager),
        builder: (c, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return RaisedButton(
                    child: (status == paired) ? Text("Forget") : Text("Pair"),
                    onPressed: () async {
                      await _handlePressTrailing(status, ossManager);
                });
            } else {
              return CircularProgressIndicator();
            }
          },
      )
    : RaisedButton(
            child: (status == paired) ? Text("Forget") : Text("Pair"),
            onPressed: () async {
              await _handlePressTrailing(status, ossManager);
        });
  }

  @override
  Widget build(BuildContext context) {

    String status = widget.device.status;

    if(currentStatus.isNotEmpty){
      status = currentStatus;
    }
    return ListTile(
      leading: (status == paired)
          ? Icon(Icons.bluetooth_connected)
          : Icon(Icons.bluetooth_disabled),
      title: Text(widget.device.name),
      subtitle: (status == paired) ? Text("Active - Tap for informations") : SizedBox.shrink(),
      trailing: _customTrailing(widget.device.name, status, widget.ossManager),
      onTap: () async{
        if(status == paired){
           await _getSensorDataTypeFromCharact(widget.ossManager).then((value) async {
             await _showPopUp(widget.device);
           });
        }
      },
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