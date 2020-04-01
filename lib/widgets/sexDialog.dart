import 'package:flutter/material.dart';

class SexDialog extends StatefulWidget {
  String _sexString = 'Undefined';
  SexDialog(this._sexString);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SexDialogState();
  }
}

class SexDialogState extends State<SexDialog> {
  bool _isMale = false;
  bool _isFemale = false;
  bool _isOther = false;

  void _sexMaleCheckboxClicked(bool state) {
    widget._sexString = 'Male';
    _setSex();
  }

  void _sexFemaleCheckboxClicked(bool state) {
    widget._sexString = 'Female';
    _setSex();
  }

  void _sexOtherCheckboxClicked(bool state) {
    widget._sexString = 'Other';
    _setSex();
  }

  void _setSex() {
    _isMale = false;
    _isFemale = false;
    _isOther = false;
    setState(() {
    if (widget._sexString.contains('Male')) {
      _isMale = true;
    } else if (widget._sexString.contains('Female')) {
      _isFemale = true;
    } else if (widget._sexString.contains('Other')) {
      _isOther = true;
    }
    });

    if(!_isMale && !_isFemale && !_isOther) {
      _isMale = true;
      widget._sexString = 'Male';
    }
  }

  @override
  Widget build(BuildContext context) {
    _setSex();

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Male'),
                  Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text('Female')),
                  Text('Other'),
                ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Checkbox(value: _isMale, onChanged: _sexMaleCheckboxClicked),
                Checkbox(
                    value: _isFemale, onChanged: _sexFemaleCheckboxClicked),
                Checkbox(value: _isOther, onChanged: _sexOtherCheckboxClicked)
              ],
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text("Submit"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(widget._sexString);
              },
            ),
          ),
        ],
      ),
    );
  }
}
