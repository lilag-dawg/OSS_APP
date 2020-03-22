import 'package:flutter/material.dart';

import '../constants.dart' as Constants;
import '../widgets/StatisticBox.dart';
import '../widgets/stopWatch.dart';

class StatisticsScreen extends StatefulWidget {

  String time = "00:00:00";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StatisticScreenState();
  }
}

class StatisticScreenState extends State<StatisticsScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        backgroundColor: Color(Constants.blueButtonColor),
        title: Text("Statistics page")
      ),
      body: StatisticBox(150, 125, 'Moving time:', widget.time),
    );
  }
}