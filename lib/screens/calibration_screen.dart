import 'package:flutter/material.dart';

import '../constants.dart' as constants;
import '../widgets/stopWatch.dart';

import '../generated/l10n.dart';

class CalibrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(constants.backGroundBlue),
      appBar: AppBar(
          backgroundColor: Color(constants.blueButtonColor),
          title: Text(S.of(context).calibrationScreenAppBarTitle)),
      body: SingleChildScrollView(child: MyStopWatch()),
    );
  }
}
