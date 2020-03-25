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

  List<BluetoothService> _filterResult(data) {
    //return data;
    List<BluetoothService> filteredResult = [];
    if (data.length != 0) {
      for (int i = 0; i < data.length; i++) {
        //print(data[i].device.name);
        if (data[i].uuid.toString().toUpperCase().substring(4, 8) == "1816") {
          filteredResult.add(data[i]);
          //print(data[i].device.state);
        }
        if (data[i].uuid.toString().toUpperCase().substring(4, 8) == "180F") {
          filteredResult.add(data[i]);
          //print(data[i].device.state);
        }
        if (data[i].uuid.toString().toUpperCase().substring(4, 8) == "1818") {
          filteredResult.add(data[i]);
          //print(data[i].device.state);
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
              children: _filterResult(snapshot.data)
                  .map((s) => Container(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                  '0x${s.uuid.toString().toUpperCase().substring(4, 8)}'),
                            )
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
