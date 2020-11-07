import 'package:flutter/material.dart';

import '../constants.dart' as constants;
import '../widgets/stopWatch.dart';

class CalibrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(constants.backGroundBlue),
      appBar: AppBar(
          backgroundColor: Color(constants.blueButtonColor),
          title: Text("Calibration page")),
      body: SingleChildScrollView(child: MyStopWatch()),
    );
  }
}
