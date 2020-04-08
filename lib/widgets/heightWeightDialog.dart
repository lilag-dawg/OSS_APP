import 'package:flutter/material.dart';

class HeightWeightDialog extends StatefulWidget {
  final String initialMeasure;
  final bool popHeight;
  //HeightWeightDialog({this.heightString});
  HeightWeightDialog({this.initialMeasure, @required this.popHeight});
  @override
  State<StatefulWidget> createState() {
    return HeightWeightDialogState();
  }
}

class HeightWeightDialogState extends State<HeightWeightDialog> {
  bool _isMetric = true;
  double _measure;
  bool _isMeasureInitialized = false;
  String measureString;

  int _impToMetIdx;
  List<double> _imperialToMetric = [454 / 1000, 2.54]; // poundsToKg, inchToCm
  List<double> _maxValues = [200, 250]; // Kg, Cm
  List<double> _minValues = [20, 50]; // Kg, Cm
  final feetToInch = 12;
  final _defaultHeight = 175.0;
  final _defaultWeight = 70.0;

  void _metricCheckboxClicked(bool state) {
    setState(() {
      _isMetric = true;
      _measureConversion();
    });
  }

  void _imperialCheckboxClicked(bool state) {
    setState(() {
      _isMetric = false;
      _measureConversion();
    });
  }

  void _measureConversion() {
    if (widget.popHeight) {
      _heightConversion();
    } else {
      _weightConversion();
    }
  }

  void _heightConversion() {
    if (_isMetric) {
      measureString = _measure.round().toString() + ' cm';
    } else {
      print(_measure);
      int _feetHeightTemp =
          (_measure / feetToInch / _imperialToMetric[_impToMetIdx]).floor();
      int _inchHeightTemp = ((_measure.round() -
                  (_feetHeightTemp *
                          feetToInch *
                          _imperialToMetric[_impToMetIdx])
                      .round()) /
              _imperialToMetric[_impToMetIdx])
          .round();
      if (_inchHeightTemp == 12) {
        //5.97 feet will give 5'12", we want 6'0"
        _inchHeightTemp = 0;
        _feetHeightTemp++;
      }
      measureString =
          _feetHeightTemp.toString() + '\'' + _inchHeightTemp.toString() + '\"';
    }
  }

  void _weightConversion() {
    if (_isMetric) {
      measureString = _measure.round().toString() + ' kg';
    } else {
      measureString =
          (_measure / _imperialToMetric[_impToMetIdx]).round().toString() +
              ' lbs';
    }
  }

  void _addButtonClicked() {
    if (_measure < _maxValues[_impToMetIdx]) {
      setState(() {
        if (_isMetric) {
          _measure += 1;
        } else {
          _measure += _imperialToMetric[_impToMetIdx];
        }
        _measureConversion();
      });
    }
  }

  void _removeButtonClicked() {
    if (_measure > _minValues[_impToMetIdx]) {
      setState(() {
        if (_isMetric) {
          _measure -= 1;
        } else {
          _measure -= _imperialToMetric[_impToMetIdx];
        }
        _measureConversion();
      });
    }
  }

  void _setMeasure() {
    if (widget.popHeight) {
      _setHeight();
    } else {
      _setWeight();
    }
  }

  void _setHeight() {
    if (measureString != null) {
      if (measureString.contains('\'')) {
        _isMetric = false;
        int feetIndex = measureString.indexOf('\'');
        String _feetHeightTemp = measureString.substring(0, feetIndex);
        int inchIndex = measureString.indexOf('\"');
        String _inchHeightTemp =
            measureString.substring(feetIndex + 1, inchIndex);
        _measure = double.parse(_feetHeightTemp) *
                feetToInch *
                _imperialToMetric[_impToMetIdx] +
            double.parse(_inchHeightTemp) * _imperialToMetric[_impToMetIdx];
      } else if (measureString.contains('cm')) {
        _isMetric = true;
        int index = measureString.indexOf(' ');
        _measure = double.parse(measureString.substring(0, index));
      }
    } else {
      _isMetric = true;
      _measure = _defaultHeight;
    }
  }

  void _setWeight() {
    if (measureString != null) {
      if (measureString.contains('lbs')) {
        _isMetric = false;
        int index = measureString.indexOf(' ');
        String _weightTemp = measureString.substring(0, index);
        _measure = double.parse(_weightTemp) * _imperialToMetric[_impToMetIdx];
      } else if (measureString.contains('kg')) {
        _isMetric = true;
        int index = measureString.indexOf(' ');
        String _weightTemp = measureString.substring(0, index);
        _measure = double.parse(_weightTemp);
      }
    } else {
      _isMetric = true;
      _measure = _defaultWeight;
    }
  }

  @override
  Widget build(BuildContext context) {

    if (!_isMeasureInitialized) {
      measureString = widget.initialMeasure;
      _impToMetIdx = widget.popHeight ? 1 : 0;
      _setMeasure();
      _isMeasureInitialized = true;
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
                    padding: const EdgeInsets.all(10.0), child: Text('Metric')),
                Checkbox(value: _isMetric, onChanged: _metricCheckboxClicked),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Imperial')),
                Checkbox(
                    value: !_isMetric, onChanged: _imperialCheckboxClicked),
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
              child: Text("Submit"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(measureString);
              },
            ),
          ),
        ],
      ),
    );
  }
}
