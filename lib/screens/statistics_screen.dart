import 'package:flutter/material.dart';

import '../constants.dart' as Constants;
import '../widgets/StatisticBox.dart';
import '../widgets/lowerNavigationBar.dart';

class StatisticsScreen extends StatelessWidget {

  String time = "00:00:00";

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StatisticBox(175, 120, 'Heart rate', '88 Bpm'),
                StatisticBox(175, 120, 'Speed', '12,8 kmph'),
              ]
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StatisticBox(175, 120, 'Cadence', '62 Rpm'),
                StatisticBox(175, 120, 'Power', '90 Watts'),
              ]
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StatisticBox(175, 120, 'Calories', '582 cal'),
                StatisticBox(175, 120, 'Distance', '30 Km'),
              ]
            )
          ],
        ),
      ),
    );
  }
}