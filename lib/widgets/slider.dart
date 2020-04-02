import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class SlideBar extends StatefulWidget {

  final List<String> selectionMenu;

  SlideBar(this.selectionMenu);

  @override
  State<StatefulWidget> createState() {
    return SlideBarState();
  }
}

class SlideBarState extends State<SlideBar> {

  double values = 0;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: Color(Constants.blueButtonColor),
          inactiveTrackColor: Colors.grey[300],
          trackHeight: 15.0,
          thumbColor: Colors.white,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
          overlayColor: Colors.grey,
          overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
        ), 
        child: Slider(
          min: 0,
          max: 3,
          value: values, 
          onChanged: (newValues) {
            setState(() {
              values = newValues;
            });
          },
          divisions: 3,
          label: widget.selectionMenu[values.toInt()],
        ),
      )
    );
  }
}