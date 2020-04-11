import 'package:flutter/material.dart';
import '../widgets/componentTitle.dart';
import '../widgets/slider.dart';
import '../databases/db_preferences_model.dart';

class SlideBarCombo extends StatefulWidget {
  final Map<String, Object> sliderStepsMap;
  final Function _updateSlideBarCombo;
  final PreferencesModel preference;

  SlideBarCombo(
      this.sliderStepsMap, this._updateSlideBarCombo, this.preference);

  @override
  State<StatefulWidget> createState() {
    return SlideBarComboState();
  }
}

class SlideBarComboState extends State<SlideBarCombo> {
  double spaceTitleSlider = 15;

  void _updateSlideBar(double newValue) {
    widget._updateSlideBarCombo(newValue, widget.preference.parameter);
  }

  @override
  Widget build(BuildContext context) {
    var valueCpy = widget.preference.parameterValue != null
        ? widget.preference.parameterValue.toDouble()
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ComponentTitle(widget.preference.parameter),
        SizedBox(height: spaceTitleSlider),
        SlideBar((widget.sliderStepsMap['selectionMenu'] as List<String>),
            valueCpy, _updateSlideBar),
      ],
    );
  }
}
