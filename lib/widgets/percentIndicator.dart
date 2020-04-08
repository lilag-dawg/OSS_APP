import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../constants.dart' as Constants;

class RoutinePage extends StatefulWidget {

  final String title;
  final bool isConnected;
  final double percentProgress;

  RoutinePage(this.title, this.isConnected, this.percentProgress);

  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  double progress = 0;
  double percProgress = 0;
  String connectedOrNot = "Connected";
  Color connectColor = Colors.green;

  currentProgressColor() {
    if (percProgress >= 0.3 && percProgress < 0.6) {
      return Colors.orange;
    }
    if(percProgress >= 0.6){
      return Colors.green;
    }
    else{
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {

    if (widget.isConnected == false){
      connectedOrNot = "Disconnected";
      progress = 0;
      connectColor = Colors.red;
    }
    else{
      progress = widget.percentProgress;
      percProgress = progress/100;
    }

    return Column(
      children: <Widget>[
        Text(
          connectedOrNot,
          style: TextStyle(
            color: connectColor,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        LinearPercentIndicator(
          width: 360.0,
          lineHeight: 30.0,
          percent: progress/100,
          center: Text(
            widget.isConnected == true? "$progress" + "%": "Not connected",
            style: new TextStyle(fontSize: 20.0),
          ),
          linearStrokeCap: LinearStrokeCap.roundAll,
          backgroundColor: Colors.grey,
          progressColor: currentProgressColor(),
        )
      ],
    );
  }
}