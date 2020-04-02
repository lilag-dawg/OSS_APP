import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

import '../widgets/percentIndicator.dart';

class BatteryLevelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        backgroundColor: Color(Constants.blueButtonColor),
        title: Text("Calibration page")
      ),
      body: RoutinePage(),
    );
  }
}