import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

import './screens/bluetoothOffScreen.dart';
import './screens/findDevicesScreen.dart';

import './widgets/navigationBar.dart';
import './models/routeGenerator.dart';
import './models/test.dart';
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
/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConnectedDevices>(
      create: (context) => ConnectedDevices([]),
      child: MaterialApp(
        title: "testing routes",
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}*/
/*void main() {
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
}*/

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Routing App'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'First Page',
              style: TextStyle(fontSize: 50),
            ),
            RaisedButton(
              child: Text('Go to second'),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/second',
                  arguments: Arguments(data: "wassup", number: 420),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  // This is a String for the sake of an example.
  // You can use any type you want.
  final String data;
  final int number;

  SecondPage({Key key, @required this.data, this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Routing App'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Second Page',
              style: TextStyle(fontSize: 50),
            ),
            Text(
              data,
              style: TextStyle(fontSize: 20),
            ),
            Text(number.toString()),
          ],
        ),
      ),
    );
  }
}
