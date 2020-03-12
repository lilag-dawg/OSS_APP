import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class SlideBar extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SlideBarState();
  }
}

class SlideBarState extends State<SlideBar> {

  double values = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 150,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: Color(Constants.blueButtonColor),
          inactiveTrackColor: Colors.white,
          trackHeight: 20.0,
          thumbColor: Colors.yellow,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 20.0),
          overlayColor: Colors.purple.withAlpha(32),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
        ), 
        child: Slider(
          min: 0,
          max: 4,
          value: values, 
          onChanged: (newValues) {
            setState(() {
              values = newValues;
            });
          },
          divisions: 4,
          label: "$values",
        ),
      )
    );
  }
}