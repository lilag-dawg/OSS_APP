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
        title: Text("Battery Level")
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child:Column(
          children: <Widget>[
            RoutinePage("Cadence sensor", true, 90),
            SizedBox(height: 80),
            RoutinePage("Heart beat sensor", true, 10),
            SizedBox(height: 80),
            RoutinePage("Power sensor", false, 50),
            SizedBox(height: 50),
            Container(
              width: 200,
              height: 50,
              child: RaisedButton(
                color: Color(Constants.blueButtonColor),
                child: Text(
                  "Device management",
                  style:TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                onPressed: (){}
              ),
            )
          ],
        )
      )
    );
  }
}