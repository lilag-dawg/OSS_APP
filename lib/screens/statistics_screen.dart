import 'package:flutter/material.dart';

import '../constants.dart' as Constants;
import '../widgets/StatisticBox.dart';
import '../widgets/lowerNavigationBar.dart';
import '../widgets/cyclingPowerMeasurement.dart';

class StatisticsScreen extends StatelessWidget {

  final String time = "00:00:00";
  final List<bool> isInfo0x2A62 = [false, false, true];
  final List<bool> isInfo0x2A5B = [false, true];

  final PageController _currentPage;
  final Function selectHandler;
  StatisticsScreen(this._currentPage, this.selectHandler);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: LowerNavigationBar(_currentPage, context, selectHandler),
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        backgroundColor: Color(Constants.blueButtonColor),
        title: Text("Statistics page")
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            StatisticBox(370, 185, 'Moving time:', time),
            SizedBox(height: 20),
            CyclingPowerMeasurement(isInfo0x2A62, isInfo0x2A5B),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StatisticBox(175, 120, 'Calories', '582 cal'),
                StatisticBox(175, 120, 'Heart rate', '130 Bpm'),
              ]
            )
          ],
        ),
      ),
    );
  }
}