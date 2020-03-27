import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'package:flutter_blue_example/widgets.dart';

void main() {
  runApp(FlutterBlueApp());
}

class FlutterBlueApp extends StatelessWidget {
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
              return FindDevicesScreen();
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

class FindDevicesScreen extends StatelessWidget {
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
        if (data[i].uuid.toString().toUpperCase().substring(4, 8) == "2A19") {
          // Battery Level
          //data[i].read();
          filteredResult.add(data[i]);
        }
        if (data[i].uuid.toString().toUpperCase().substring(4, 8) == "2A5B") {
          // CSC Measurement
          data[i].setNotifyValue(!data[i].isNotifying);
          filteredResult.add(data[i]);
        }
        if (data[i].uuid.toString().toUpperCase().substring(4, 8) == "2A63") {
          // Cycling Power Measurement
          data[i].setNotifyValue(!data[i].isNotifying);
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

class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  final VoidCallback onNotificationPressed;

  const CharacteristicTile(
      {Key key,
      this.characteristic,
      this.onReadPressed,
      this.onWritePressed,
      this.onNotificationPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Characteristic'),
                Text(
                    '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
                    style: Theme.of(context).textTheme.body1.copyWith(
                        color: Theme.of(context).textTheme.caption.color))
              ],
            ),
            subtitle: Text(value.toString()),
            contentPadding: EdgeInsets.all(0.0),
          ),
        );
      },
    );
  }
}
