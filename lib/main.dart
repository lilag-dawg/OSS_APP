import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

import './screens/bluetoothOffScreen.dart';
import './screens/findDevicesScreen.dart';

import './widgets/navigationBar.dart';
import './models/routeGenerator.dart';
import './models/connectedDevices.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectedDevices>(
          create: (context) => ConnectedDevices([]),
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
