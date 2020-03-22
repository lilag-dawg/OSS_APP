import '../constants.dart' as Constants;

import 'package:flutter/material.dart';

class StatisticBox extends StatefulWidget {
  final double boxWidth;
  final double boxHeight;
  final String boxTitle;
  final String boxContent;

  StatisticBox(this.boxWidth, this.boxHeight, this.boxTitle, this.boxContent);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StatisticBoxState();
  }
}

class StatisticBoxState extends State<StatisticBox>{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(Constants.blueButtonColor)
      ),
      child: SizedBox(
        width: widget.boxWidth,
        height: widget.boxHeight,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: widget.boxHeight/12.5
            ),
            Text(
              widget.boxTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: widget.boxWidth/7.5,
              ),
            ),
            SizedBox(
              height: 125/8.33
            ),
            Text(
              widget.boxContent,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[300],
                fontSize: widget.boxWidth/4.3,
              ),
            )
          ],
        )
      ),
    );
  }
}