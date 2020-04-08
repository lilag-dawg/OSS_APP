import '../constants.dart' as Constants;

import 'package:flutter/material.dart';

class StatisticBox extends StatelessWidget {
  final double boxWidth;
  final double boxHeight;
  final String boxTitle;
  final String boxContent;

  StatisticBox(this.boxWidth, this.boxHeight, this.boxTitle, this.boxContent);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(Constants.blueButtonColor)
      ),
      child: SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: boxHeight/12.5
            ),
            Text(
              boxTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: boxWidth/7.5,
              ),
            ),
            SizedBox(
              height: 125/8.33
            ),
            Text(
              boxContent,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[300],
                fontSize: boxWidth/6,
              ),
            )
          ],
        )
      ),
    );
  }
}