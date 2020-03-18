import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';


import './widgets/navigationBar.dart';
import './screens/bluetooth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"testing routes",
      home: BluetoothStuff(),

  );
  }
}

 
