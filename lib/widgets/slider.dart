import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class SlideBar extends StatefulWidget {
  final List<String> selectionMenu;
  final double value;
  final Function _updateSlideBar;

  SlideBar(this.selectionMenu, this.value, this._updateSlideBar);

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
        min: 0,
        max: widget.selectionMenu.length.toDouble() - 1,
        value: widget.value,
        onChanged: widget._updateSlideBar,
        divisions: widget.selectionMenu.length.toInt() - 1,
        label: widget.selectionMenu[widget.value.toInt()],
      ),
    ));
  }
}
