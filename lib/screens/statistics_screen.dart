import 'package:flutter/material.dart';

import '../constants.dart' as Constants;
import '../widgets/StatisticBox.dart';
import '../widgets/rpm.dart';

class StatisticsScreen extends StatelessWidget {

  String time = "00:00:00";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        backgroundColor: Color(Constants.blueButtonColor),
        title: Text("Statistics page")
      ),
      body: Column(
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
              Rpm(
                boxWidth: 175,
                boxHeight: 120,
                boxTitle: "RPM",
              ),
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
    );
  }
}