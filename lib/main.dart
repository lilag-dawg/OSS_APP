import 'package:flutter/material.dart';
import 'package:oss_app/models/bluetoothDeviceManager.dart';
import 'package:provider/provider.dart';

import './models/routeGenerator.dart';
import './models/bluetoothDeviceManager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BluetoothDeviceManager>(
          create: (context) => BluetoothDeviceManager(),
        ),
      ],
      child: MaterialApp(
        title: "testing routes",
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
