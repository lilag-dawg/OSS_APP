import 'package:flutter/material.dart';
import '../widgets/componentTitle.dart';
import '../widgets/slider.dart';

class SlideBarCombo extends StatefulWidget {
  final String parameterName;
  final List<int> possibleValues;
  final int currentValue;
  final Function _updateSlideBarCombo;
  

  SlideBarCombo(
      this.parameterName, this.possibleValues, this.currentValue, this._updateSlideBarCombo);

  @override
  State<StatefulWidget> createState() {
    return SlideBarComboState();
  }
}

class SlideBarComboState extends State<SlideBarCombo> {
  double spaceTitleSlider = 15;

  void _updateSlideBar(double newValue) async {
    await widget._updateSlideBarCombo(newValue, widget.parameterName);
  }

  @override
  Widget build(BuildContext context) {
    var valueCpy = widget.currentValue != null
        ? widget.currentValue.toDouble()
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ComponentTitle(widget.parameterName),
        SizedBox(height: spaceTitleSlider),
        SlideBar((widget.possibleValues as List<String>),
            valueCpy, _updateSlideBar),
      ],
    );
  }
}
