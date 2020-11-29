import 'package:flutter/material.dart';
import 'dart:math';

import '../constants.dart' as Constants;

class SlideBar extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double stepSize;
  final double value;
  final Function updateSlideBar;

  SlideBar(this.minValue, this.maxValue, this.stepSize, this.value,
      this.updateSlideBar);

  @override
  State<StatefulWidget> createState() {
    return SlideBarState();
  }
}

class SlideBarState extends State<SlideBar> {
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
        min: widget.minValue,
        max: widget.maxValue,
        value: widget.value,
        onChanged: (double value) async {
          await widget.updateSlideBar(value);
        },
        divisions: ((widget.maxValue - widget.minValue) ~/ widget.stepSize),
        label: widget.value.toStringAsFixed(
            (log(1.0 / widget.stepSize.toDouble()) / log(10)).ceil()),
      ),
    ));
  }
}
