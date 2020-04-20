import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

import '../constants.dart' as Constants;
import '../widgets/StatisticBox.dart';
import '../widgets/lowerNavigationBar.dart';
import '../widgets/rpm.dart';
import '../widgets/speed.dart';
import '../models/connectedDevices.dart';
import './bluetoothOffScreen.dart';

class StatisticsScreen extends StatelessWidget {
  final List<BluetoothDevice> connectedDevices;
  const StatisticsScreen({Key key, @required this.connectedDevices})
      : super(key: key);

  Widget _buildDataPresentBody(ConnectedDevices cd) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        StatisticBox(370, 185, 'Moving time:', "00:00:00"),
        SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              StatisticBox(175, 120, 'Heart rate', '88 Bpm'),
              Speed(
                boxWidth: 175,
                boxHeight: 120,
                boxTitle: "Speed",
                device: null,
              ),
            ]),
        SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Rpm(
                boxWidth: 175,
                boxHeight: 120,
                boxTitle: "RPM",
                device: null,
              ),
              StatisticBox(175, 120, 'Power', '90 Watts'),
            ]),
        SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              StatisticBox(175, 120, 'Calories', '582 cal'),
              StatisticBox(175, 120, 'Distance', '30 Km'),
            ]),
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
    final cd = Provider.of<ConnectedDevices>(context);

        return Scaffold(
      //bottomNavigationBar: LowerNavigationBar(_currentPage, context, selectHandler),
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        backgroundColor: Color(Constants.blueButtonColor),
        title: Text("Statistics page"),
      ),
      body: SingleChildScrollView(
        child: (Constants.isRunningOnEmulator)
          ? _buildDataPresentBody(cd)
          : (cd.deviceCount() > 0)
            ? _buildDataPresentBody(cd)
            : _buildDataNotPresentBody(context),
      ),
    );
  }
}
