import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

import '../constants.dart' as Constants;
import '../widgets/StatisticBox.dart';
import '../widgets/lowerNavigationBar.dart';
import '../widgets/cscMeasurement.dart';
import '../widgets/cyclingPowerMeasurement.dart';
import '../models/connectedDevices.dart';
import './bluetoothOffScreen.dart';

class StatisticsScreen extends StatelessWidget {
  final List<BluetoothDevice> connectedDevices;
  StatisticsScreen({Key key, @required this.connectedDevices})
      : super(key: key);
  
  final List<bool> isInfo0x2A62 = [false, false, true];
  final List<bool> isInfo0x2A5B = [true, true];

  Widget _buildDataPresentBody(ConnectedDevices cd) {
    //BluetoothDevice cscDevice = cd.assignDevice("0x1816");
    cd.findFeatureInDeviceList("Power");
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        StatisticBox(370, 185, 'Moving time:', "00:00:00"),
        SizedBox(height: 20),
        Stack(
          children: <Widget>[
            CSCMeasurement(
              isInfo0x2A5B: isInfo0x2A5B,
              isInfo0x2A62: isInfo0x2A62,
              boxHeight: 120,
              boxWidth: 175,
            ),
            CyclingPowerMeasurement(isInfo0x2A62, isInfo0x2A5B),
          ],
        ),
        SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              StatisticBoxCustom(175, 120, 'Calories', cd.getRpm()),
              StatisticBoxCustom(175, 120, 'Heart rate', cd.getSpeed()),
            ])
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
