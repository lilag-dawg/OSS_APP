import 'package:flutter/material.dart';

class SexDialog extends StatefulWidget {
  final String _initialSexString;
  SexDialog(this._initialSexString);
  @override
  State<StatefulWidget> createState() {
    return SexDialogState();
  }
}

class SexDialogState extends State<SexDialog> {
  String _sexString;
  bool _isSexInitialized = false;

  void _sexMaleCheckboxClicked(bool state) => setState(() { _sexString = 'Male';});
  void _sexFemaleCheckboxClicked(bool state) => setState(() { _sexString = 'Female';});
  void _sexOtherCheckboxClicked(bool state) => setState(() { _sexString = 'Other';});

  @override
  Widget build(BuildContext context) {
    if (!_isSexInitialized) {
      _sexString = widget._initialSexString;
      _isSexInitialized = true;
    }

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
                Checkbox(
                    value: _sexString == 'Male',
                    onChanged: _sexMaleCheckboxClicked),
                Checkbox(
                    value: _sexString == 'Female',
                    onChanged: _sexFemaleCheckboxClicked),
                Checkbox(
                    value: _sexString == 'Other',
                    onChanged: _sexOtherCheckboxClicked)
              ],
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text("Submit"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(_sexString);
              },
            ),
          ),
        ],
      ),
    );
  }
}
