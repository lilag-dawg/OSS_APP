import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import './screens/bluetoothOffScreen.dart';
import './screens/findDevicesScreen.dart';


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