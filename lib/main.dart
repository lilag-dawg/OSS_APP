import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import './screens/statistics_screen.dart';

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

  bool isDoneScanning;
  bool isBackButtonPress;

  Future<void> scanForDevices() async {
    flutterBlue.scan(timeout: Duration(seconds: 4)).listen((scanResult) {
      devicesStatus.putIfAbsent(scanResult, () => false);
    }, onDone: () async {
      flutterBlue.stopScan();
      alreadyConnectedDevices = await getConnectedDevice();
      //compareMapToList(devicesStatus, alreadyConnectedDevices);
      setState(() {
        isDoneScanning = true;
      });
    });
  }

  /*Future<void> connectOrDisconnectAsync(
      List<BluetoothDevice> deviceToConnect) async {
    for (ScanResult s in devicesStatus.keys) {
      if (devicesStatus[s] == true) {
        connectToDevices.add(s.device);
        await s.device.connect();
        print("connected to");
        print(s.device.name);
      }
    }
  }*/

  /*List<BluetoothDevice> compareMapToList(Map<ScanResult, bool> scannedDevices,
      List<BluetoothDevice> alreadyConnectedToDevices) {
    List<BluetoothDevice> listOfScannedDevice = [];
    List<BluetoothDevice> result = [];

    scannedDevices.forEach((k, v) {
      listOfScannedDevice.add(k.device);
      result.add(k.device);
    });
    for (BluetoothDevice scanned in listOfScannedDevice) {
      for (BluetoothDevice connected in alreadyConnectedToDevices) {
        if (scanned.name == connected.name || scanned.id == connected.id) {
          result.remove(scanned);
        }
      }
    }
    return result;
  }*/

  Future<void> connectOrDisconnectToSelectedDevices() async {
    List<BluetoothDevice> listOfScannedDevice = [];
    List<BluetoothDevice> unConnectedAvailableDevices = [];
    devicesStatus.forEach((k, v) {
      listOfScannedDevice.add(k.device);
      unConnectedAvailableDevices.add(k.device);
    });

    for (BluetoothDevice scanned in listOfScannedDevice) {
      for (BluetoothDevice connected in alreadyConnectedDevices) {
        if (scanned.name == connected.name || scanned.id == connected.id) {
          unConnectedAvailableDevices.remove(scanned);
        }
      }
    }

    for (ScanResult s in devicesStatus.keys) {
      for (BluetoothDevice d in alreadyConnectedDevices) {
        if (devicesStatus[s] == false) {
          if (s.device.name == d.name || s.device.id == d.id) {
            connectToDevices.remove(s.device);
            await d.disconnect();
            print("disconnedted from ${d.name}");
          }
        }
      }
    }
    for (ScanResult s in devicesStatus.keys) {
      for (BluetoothDevice d in unConnectedAvailableDevices) {
        if (devicesStatus[s] == true) {
          if (s.device.name == d.name || s.device.id == d.id) {
            connectToDevices.add(s.device);
            await d.connect();
            print("connected to ${d.name}");
          }
        }
      }
    }
  }

  Future<List<BluetoothDevice>> getConnectedDevice() async {
    List<BluetoothDevice> devices = await flutterBlue.connectedDevices;
    return devices;
  }

  @override
  void initState() {
    isDoneScanning = true;
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
      body: Column(
        children: <Widget>[
          Column(
              children: devicesStatus.entries
                  .map(
                    (result) => CheckboxListTile(
                        title: Text(result.key.device.name),
                        subtitle: Text(result.key.device.id.toString()),
                        value: result.value,
                        onChanged: (bool value) {
                          setState(() {
                            devicesStatus[result.key] = value;
                          });
                        }),
                  )
                  .toList()),
          Center(
            child: RaisedButton(
              child: Text("Show Data"),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () async {
                await connectOrDisconnectToSelectedDevices();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            StatisticsScreen(devices: connectToDevices)));
                isDoneScanning = false;
                scanForDevices();
              },
            ),
          )
        ],
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
                isDoneScanning = false;
              },
            );
          }
        },
      ),
    );
  }
}

//----------------------------------OLD STUFF----------------------------------------------------------------------------------//

/*class FindDevicesScreen extends StatelessWidget {
  List<ScanResult> _filterResult(data) {
    return data;
    List<ScanResult> filteredResult = [];
    if (data.length != 0) {
      for (int i = 0; i < data.length; i++) {
        //print(data[i].device.name);
        if (data[i].device.name == "Ride SenseV01 BACU2Q55") {
          filteredResult.add(data[i]);
          print(data[i].device.state);
        }
      }
    }
    return filteredResult;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: _filterResult(snapshot.data)
                      .map((r) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 8,
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(r.device.name),
                                subtitle: Text(r.device.id.toString()),
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  r.device.connect();
                                  return DiscoverServices(device: r.device);
                                })),
                              ),
                            ],
                          )))
                      .toList(),
                ),
              ),
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 8,
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  color: Colors.yellow.shade600,
                                  padding: const EdgeInsets.all(8),
                                  child: Text(d.name),
                                ),
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return DiscoverServices(device: d);
                                })),
                              ),
                              StreamBuilder<BluetoothDeviceState>(
                                stream: d.state,
                                initialData: BluetoothDeviceState.disconnected,
                                builder: (c, snapshot) {
                                  return Text(snapshot.data.toString());
                                },
                              ),
                            ],
                          )))
                      .toList(),
                ),
              ),
            ],
          ),
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
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

class DiscoverServices extends StatelessWidget {
  const DiscoverServices({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  List<BluetoothService> _filterService(data) {
    //return data;
    List<BluetoothService> filteredResult = [];
    if (data.length != 0) {
      for (int i = 0; i < data.length; i++) {
        //print(data[i].device.name);
        if (data[i].uuid.toString().toUpperCase().substring(4, 8) == "1816") {
          // Cycling Speed and Cadence
          filteredResult.add(data[i]);
        }
        if (data[i].uuid.toString().toUpperCase().substring(4, 8) == "180F") {
          // Battery Service
          filteredResult.add(data[i]);
        }
        if (data[i].uuid.toString().toUpperCase().substring(4, 8) == "1818") {
          // Cycling Power
          filteredResult.add(data[i]);
        }
      }
    }
    return filteredResult;
  }

  List<BluetoothCharacteristic> _filterCharacteristic(data) {
    List<BluetoothCharacteristic> filteredResult = [];
    if (data.length != 0) {
      for (int i = 0; i < data.length; i++) {
        /*if (data[i].uuid.toString().toUpperCase().substring(4, 8) == "2A19") {
          // Battery Level
          filteredResult.add(data[i]);
        }*/
        if (data[i].uuid.toString().toUpperCase().substring(4, 8) == "2A5B") {
          // CSC Measurement
          filteredResult.add(data[i]);
        }
        if (data[i].uuid.toString().toUpperCase().substring(4, 8) == "2A63") {
          // Cycling Power Measurement
          filteredResult.add(data[i]);
        }
      }
    }
    return filteredResult;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              String text;
              VoidCallback onPressed;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  text = "DISCONNECT";
                  onPressed = () => device.disconnect();
                  break;
                case BluetoothDeviceState.disconnected:
                  text = "CONNECT";
                  onPressed = () => device.connect();
                  break;
                default:
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        .copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) => Container(
                child: Column(
              children: <Widget>[
                Center(
                  child: _connexionStatus(snapshot.data),
                ),
              ],
            )),
          ),
          StreamBuilder<List<BluetoothService>>(
            stream: device.services,
            initialData: [],
            builder: (c, snapshot) => Column(
              children: _filterService(snapshot.data)
                  .map((s) => Container(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                  '0x${s.uuid.toString().toUpperCase().substring(4, 8)}'),
                            ),
                            Column(
                                children:
                                    _filterCharacteristic(s.characteristics)
                                        .map((c) => Container(
                                              child: Column(
                                                children: <Widget>[
                                                  CharacteristicTile(
                                                    characteristic: c,
                                                    charName:
                                                        '0x${c.uuid.toString().toUpperCase().substring(4, 8)}',
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList()),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      )),
    );
  }

  Widget _connexionStatus(BluetoothDeviceState d) {
    if (d == BluetoothDeviceState.connected) {
      device.discoverServices();
      return Icon(Icons.bluetooth_connected);
    }
    return Icon(Icons.bluetooth_disabled);
  }
}

/*class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final String charName;


   CharacteristicTile({Key key,
      this.characteristic,
      this.charName,});


  @override
  Widget build(BuildContext context) {

    //return Text('0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}');

    return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        /*if(!snapshot.hasData){
          if(charName == "0x2A19"){
            print(value.toString());
          }
          else{
            characteristic.setNotifyValue(!characteristic.isNotifying);
          }
        }*/
        switch(snapshot.connectionState){
          case ConnectionState.none:
            print("no connection");
            break;
          case ConnectionState.waiting:
            print("waiting");
            break;
          case ConnectionState.active:
            print("active");
            if(value.length == 0){
              if(charName == "0x2A19"){
                characteristic.read();
              }
              else{
                characteristic.setNotifyValue(!characteristic.isNotifying);
              }
            }
            

            break;
          case ConnectionState.done:
            print("finish");
            break;
        }
        return ExpansionTile(
          title: ListTile(
            title: Column(
              children: <Widget>[
                Text('Characteristic'),
                Text(
                    '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}')
              ],
            ),
            subtitle: Text(value.toString()),
          ),
        );
      },
    );
  }
}*/

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final String charName;

  CharacteristicTile({this.characteristic, this.charName});
  @override
  _CharacteristicTileState createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  var data;
  Stream<List<int>> _stream;

  @override
  void initState() {
    _stream = widget.characteristic.value;
    /*_asyncMethode().then((result){
      print(widget.charName);
    });*/


    super.initState();
  }

  /*Future<bool> _asyncMethode() async {
    if(widget.charName == "0x2A5B" || widget.charName == "0x2A63"){
      await widget.characteristic.setNotifyValue(true);
    }
    
    return true;
  }*/


  @override
  Widget build(BuildContext context) {
    return Text(data.toString());
    /*StreamBuilder<List<int>>(
            stream: widget.characteristic.value,
            initialData: widget.characteristic.lastValue,
            builder: (c, snapshot) {
              final value = snapshot.data;
              //print(value.toString());
              return ExpansionTile(
                title: ListTile(
                  title: Column(
                    children: <Widget>[
                      Text('Characteristic'),
                      Text(
                          '0x${widget.characteristic.uuid.toString().toUpperCase().substring(4, 8)}')
                    ],
                  ),
                  subtitle: Text(value.toString()),
                ),
              );
            },
          );*/
  }
}*/
