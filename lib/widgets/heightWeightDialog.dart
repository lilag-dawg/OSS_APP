import 'package:flutter/material.dart';
import '../constants.dart' as Constants;
import '../databases/dbHelper.dart';
import '../databases/userProfileModel.dart';
import '../databases/db.dart';
import '../generated/l10n.dart';

class HeightWeightDialog extends StatefulWidget {
  final double initialMeasure;
  final bool popHeight;
  final int isMetric;
  HeightWeightDialog(
      {this.initialMeasure, @required this.popHeight, @required this.isMetric});
  @override
  State<StatefulWidget> createState() {
    return HeightWeightDialogState();
  }
}

class HeightWeightDialogState extends State<HeightWeightDialog> {
  int _isMetric;
  double measure;
  String measureString;

  void _metricCheckboxClicked(bool state) {
    setState(() {
      _isMetric = Constants.isSelected;
      _measureConversion();
    });
  }

  void _imperialCheckboxClicked(bool state) {
    setState(() {
      _isMetric = Constants.isNotSelected;
      _measureConversion();
    });
  }

  void _measureConversion() {
    if (widget.popHeight) {
      measureString = heightConversion(_isMetric, measure);
    } else {
      measureString = weightConversion(_isMetric, measure);
    }
  }

  static String heightConversion(int _isMetric, double measure) {
    var measureString;
    if (_isMetric == Constants.isSelected) {
      measureString = measure.round().toString() + ' cm';
    } else {
      int feet = (measure / Constants.footToCm).floor();
      int inch = ((measure.round() - (feet * Constants.footToCm).round()) /
              Constants.inchToCm)
          .round();
      if (inch == 12) {
        //5.97 feet will give 5'12", we want 6'0"
        inch = 0;
        feet++;
      }
      measureString = feet.toString() + '\'' + inch.toString() + '\"';
    }
    return measureString;
  }

  static String weightConversion(int _isMetric, double measure) {
    var measureString;
    if (_isMetric == Constants.isSelected) {
      measureString = measure.round().toString() + ' kg';
    } else {
      measureString =
          (measure / Constants.poundsToKg).round().toString() + ' lbs';
    }
    return measureString;
  }

  void _addButtonClicked() {
    if (widget.popHeight && measure < Constants.maxCm ||
        !widget.popHeight && measure < Constants.maxKg) {
      setState(() {
        if (_isMetric == Constants.isSelected) {
          measure += 1;
        } else {
          if (widget.popHeight) {
            measure += Constants.inchToCm;
          } else {
            measure += Constants.poundsToKg;
          }
        }
        _measureConversion();
      });
    }
  }

  void _removeButtonClicked() {
    if (widget.popHeight && measure > Constants.minCm ||
        !widget.popHeight && measure > Constants.minKg) {
      setState(() {
        if (_isMetric == Constants.isSelected) {
          measure -= 1;
        } else {
          if (widget.popHeight) {
            measure -= Constants.inchToCm;
          } else {
            measure -= Constants.poundsToKg;
          }
        }
        _measureConversion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (measure == null) {
      if (widget.initialMeasure != null) {
        measure = widget.initialMeasure;
      } else {
        widget.popHeight == true
            ? measure = Constants.defaultHeight
            : measure = Constants.defaultWeight;
      }
      if (widget.isMetric != null) {
        _isMetric = widget.isMetric;
      } else {
        _isMetric = Constants.isSelected;
      }
    }

    _measureConversion();

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(4, 20, 4, 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(S.of(context).heightWeightDialogMetric)),
                Checkbox(
                    value: _isMetric == Constants.isSelected,
                    onChanged: _metricCheckboxClicked),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(S.of(context).heightWeightDialogImperial)),
                Checkbox(
                    value: _isMetric == Constants.isNotSelected,
                    onChanged: _imperialCheckboxClicked),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: 70,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Icon(Icons.remove_circle_outline),
                      onPressed: _removeButtonClicked,
                    ),
                  ),
                ),
                Container(
                  width: 90,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(measureString,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline)),
                ),
                SizedBox(
                  width: 70,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Icon(Icons.add_circle_outline),
                      onPressed: _addButtonClicked,
                    ),
                  ),
                )
              ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text(S.of(context).dialogSubmit),
              onPressed: () async {
                var profile = await DatabaseHelper.getSelectedUserProfile();
                if (widget.popHeight) {
                  profile.height = measure;
                  profile.metricHeight = _isMetric;
                } else {
                  profile.weight = measure;
                  profile.metricWeight = _isMetric;
                }
                await DatabaseProvider.updateByPrimaryKey(
                    UserProfileModel.tableName,
                    profile,
                    UserProfileModel.primaryKeyWhereString,
                    profile.userName);

                Navigator.of(context, rootNavigator: true).pop(measureString);
              },
            ),
          ),
        ],
      ),
    );
  }
}
