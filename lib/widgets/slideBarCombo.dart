import 'package:flutter/material.dart';
import '../widgets/componentTitle.dart';
import '../widgets/slider.dart';
import '../constants.dart' as Constants;
import '../widgets/infoDialog.dart';

class SlideBarCombo extends StatefulWidget {
  final String parameterName;
  final double minValue;
  final double maxValue;
  final double stepSize;
  final int currentValue;
  final Function updateSlideBarCombo;
  final String info;

  SlideBarCombo(this.parameterName, this.minValue, this.maxValue, this.stepSize,
      this.currentValue, this.updateSlideBarCombo, this.info);
      

  @override
  State<StatefulWidget> createState() {
    return SlideBarComboState();
  }
}

class SlideBarComboState extends State<SlideBarCombo> {
  double spaceTitleSlider = 15;

  void updateSlideBar(int newValue) async {
    await widget.updateSlideBarCombo(newValue, widget.parameterName);
  }

  @override
  Widget build(BuildContext context) {
    var valueCpy =
        widget.currentValue != null ? widget.currentValue.toDouble() : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
          ComponentTitle(widget.parameterName),
          RaisedButton(padding: EdgeInsets.all(10), shape: CircleBorder(), onPressed: () async => await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return InfoDialog(widget.info);
        }), color: Color(Constants.blueButtonColor), child: Icon(Icons.info),),
        ]),
        SizedBox(height: spaceTitleSlider),
        SlideBar(widget.minValue, widget.maxValue, widget.stepSize, valueCpy,
            updateSlideBar),
      ],
    );
  }
}
