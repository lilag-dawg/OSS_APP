import 'package:flutter/material.dart';

import '../constants.dart' as Constants;
import '../widgets/stopWatch.dart';

class CalibrationScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        backgroundColor: Color(Constants.blueButtonColor),
        title: Text("Calibration page")
      ),
      body: MyStopWatch(),
    );
  }
}