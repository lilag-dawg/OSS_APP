import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:oss_app/models/bluetoothDeviceManager.dart';
import 'package:provider/provider.dart';

import '../constants.dart' as constants;

class StatisticsScreen extends StatelessWidget {
  final List<BluetoothDevice> connectedDevices;
  StatisticsScreen({Key key, @required this.connectedDevices})
      : super(key: key);

  final List<bool> isInfo0x2A62 = [false, false, true];
  final List<bool> isInfo0x2A5B = [true, true];

  Widget _buildDataPresentBody() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        SizedBox(height: 20),
        Stack(
          children: <Widget>[],
        ),
        SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[])
      ],
    );
  }

  Widget _buildDataNotPresentBody(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("No device Connected",
                style: TextStyle(fontSize: 30.0, color: Colors.white)),
            RaisedButton(
              color: Colors.red,
              child: Text("Manage Devices"),
              onPressed: () =>
                  Navigator.of(context).popAndPushNamed("/settings/manage"),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cd = Provider.of<BluetoothDeviceManager>(context);

    return Scaffold(
      //bottomNavigationBar: LowerNavigationBar(_currentPage, context, selectHandler),
      backgroundColor: Color(constants.backGroundBlue),
      appBar: AppBar(
        backgroundColor: Color(constants.blueButtonColor),
        title: Text("Statistics page"),
      ),
      body: SingleChildScrollView(),
    );
  }
}
