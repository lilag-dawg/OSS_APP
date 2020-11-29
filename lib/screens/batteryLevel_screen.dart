import 'package:flutter/material.dart';
import 'package:oss_app/models/OSSDevice.dart';
import 'package:oss_app/models/bluetoothDeviceManager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../constants.dart' as constants;
import '../generated/l10n.dart';

import '../widgets/percentIndicator.dart';

class BatteryLevelScreen extends StatelessWidget {
  List<Device> devices = [
    new Device("Cadence sensor", true, 90),
    new Device("Speed sensor", true, 50),
    new Device("Heart beat sensor", true, 10),
    new Device("Power sensor", false, 90),
    Device("test", false, 66),
  ];

  @override
  Widget build(BuildContext context) {
    final ossDevice = Provider.of<BluetoothDeviceManager>(context);

    constants.setAppWidth(MediaQuery.of(context).size.width);
    constants.setAppHeight(MediaQuery.of(context).size.height);

    return Scaffold(
        backgroundColor: Color(constants.backGroundBlue),
        appBar: AppBar(
            backgroundColor: Color(constants.blueButtonColor),
            title: Text(S.of(context).batteryScreenAppBarTitle)),
        //body: SingleChildScrollView(
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    devices[index].deviceStatus(context),
                itemCount: devices.length,
              ),
            ),
            SizedBox(height: 50),
            Container(
              width: 200,
              height: 50,
              child: RaisedButton(
                  color: Color(constants.blueButtonColor),
                  child: Text(
                    S.of(context).batteryScreenDeviceManagement,
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
          //),
        ));
  }
}
