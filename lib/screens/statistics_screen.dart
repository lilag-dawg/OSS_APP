import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../constants.dart' as Constants;
import '../widgets/StatisticBox.dart';
import '../widgets/rpm.dart';

class StatisticsScreen extends StatelessWidget {


  final List<BluetoothDevice> devices;
  const StatisticsScreen({Key key, this.devices}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        backgroundColor: Color(Constants.blueButtonColor),
        title: Text("Statistics page"),
        leading: IconButton( 
          icon: Icon(Icons.chevron_left),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          StatisticBox(370, 185, 'Moving time:', "00:00:00"),
          SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StatisticBox(175, 120, 'Heart rate', '88 Bpm'),
                StatisticBox(175, 120, 'Speed', '12,8 kmph'),
              ]),
          SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Rpm(
                  boxWidth: 175,
                  boxHeight: 120,
                  boxTitle: "RPM",
                  devices: devices,
                ),
                StatisticBox(175, 120, 'Power', '90 Watts'),
              ]),
          SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StatisticBox(175, 120, 'Calories', '582 cal'),
                StatisticBox(175, 120, 'Distance', '30 Km'),
              ])
        ],
      ),
    );
  }
}

/*class StatisticsScreen extends StatefulWidget {
  final List<BluetoothDevice> devices;
  const StatisticsScreen({Key key, this.devices}) : super(key: key);
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}*/