import 'package:flutter/material.dart';
import 'package:oss_app/models/OSSDevice.dart';
import 'package:oss_app/models/bluetoothDeviceManager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../constants.dart' as Constants;

import '../widgets/percentIndicator.dart';

class BatteryLevelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ossDevice = Provider.of<BluetoothDeviceManager>(context);

    Constants.setAppWidth(MediaQuery.of(context).size.width);
    Constants.setAppHeight(MediaQuery.of(context).size.height);

    return Scaffold(
        backgroundColor: Color(Constants.backGroundBlue),
        appBar: AppBar(
            backgroundColor: Color(Constants.blueButtonColor),
            title: Text("Battery Level")),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(25.0),
              child: Column(
                children: <Widget>[
                  RoutinePage("Cadence sensor", true, 90),
                  SizedBox(height: 80),
                  RoutinePage("Heart beat sensor", true, 10),
                  SizedBox(height: 80),
                  RoutinePage("Power sensor", false, 50),
                  SizedBox(height: 50),
                  Container(
                    width: 200,
                    height: 50,
                    child: RaisedButton(
                        color: Color(Constants.blueButtonColor),
                        child: Text(
                          "Device management",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {}),
                  ),
                ],
              )),
        ));
  }
}
