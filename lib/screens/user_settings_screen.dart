import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/blueButton.dart';
import '../widgets/sexDialog.dart';
import '../widgets/heightWeightDialog.dart';
import '../constants.dart' as Constants;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class UserSettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserSettingsScreenState();
  }
}

class UserSettingsScreenState extends State<UserSettingsScreen> {
  static DateTime _birthdate;
  String _birthdateString;
  String _birthdateStringComplete = 'Birthday';
  String _sexString;
  String _sexStringComplete = 'Sex';
  String _heightString;
  String _heightStringComplete = 'Height';
  String _weightString;
  String _weightStringComplete = 'Weight';

  bool _isProfileInitialized = false;

  void _birthdateButtonClicked() async {
    DateTime initialDate;
    if (_birthdateString != null) {
      initialDate = DateTime.parse(_birthdateString);
    } else {
      initialDate = DateTime.now();
    }

    _birthdate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.utc(1900, 1, 1, 0, 0, 0),
      lastDate: DateTime.now(),
    );
    if (_birthdate != null) {
      setState(() {
        _birthdateString = DateFormat('yyyy-MM-dd').format(_birthdate);
        _birthdateStringComplete = 'Birthday : ' + _birthdateString;
      });
    }
    _saveProfile();
  }

  Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> _localFile() async {
    final path = await _localPath();
    print(path);
    return new File('$path/user_settings.txt');
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile();

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }

  Future<File> writeToFile(String profile) async {
    final file = await _localFile();

    // Write the file.
    return file.writeAsString(profile);
  }

  void _saveProfile() async {
    String _profileString = '1.' +
        _birthdateStringComplete +
        '\n' +
        '2.' +
        _sexStringComplete +
        '\n' +
        '3.' +
        _heightStringComplete +
        '\n' +
        '4.' +
        _weightStringComplete;
    writeToFile(_profileString);
  }

  String _extractData(String string) {
    if (string != null) {
      if (string.contains(':')) {
        String data = string.substring(string.indexOf(':') + 2);
        return data;
      }
    }
    return null;
  }

  void _loadProfile() async {
    String _profileString = await readFile();
    if (_profileString != null) {
      if (_profileString.contains('1.')) {
        int index1 = _profileString.indexOf('1.');
        int index2 = _profileString.indexOf('2.');
        int index3 = _profileString.indexOf('3.');
        int index4 = _profileString.indexOf('4.');

        setState(() {
          _birthdateStringComplete =
              _profileString.substring(index1 + 2, index2 - 1);
          _sexStringComplete = _profileString.substring(index2 + 2, index3 - 1);
          _heightStringComplete =
              _profileString.substring(index3 + 2, index4 - 1);
          _weightStringComplete = _profileString.substring(index4 + 2);
        });

        _birthdateString = _extractData(_birthdateStringComplete);
        _sexString = _extractData(_sexStringComplete);
        _heightString = _extractData(_heightStringComplete);
        _weightString = _extractData(_weightStringComplete);
      }
    } else {
      _saveProfile();
    }
  }

  void _resetProfile() {
    _birthdateString = null;
    _sexString = null;
    _heightString = null;
    _weightString = null;

    setState(() {
      _birthdateStringComplete = 'Birthday';
      _sexStringComplete = 'Sex';
      _heightStringComplete = 'Height';
      _weightStringComplete = 'Weight';
    });
    _saveProfile();
  }

  void _sexButtonClicked() async {
    _sexString = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SexDialog(_sexString);
        });
    setState(() {
      if (_sexString != null) {
        _sexStringComplete = 'Sex : ' + _sexString;
      }
    });
    _saveProfile();
  }

  void _heightButtonClicked() async {
    _heightString = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return HeightWeightDialog(
            initialMeasure: double.parse(_heightString),
            popHeight: true,
            isMetric: 0,
          );
        });
    setState(() {
      _heightStringComplete = 'Height : ' + _heightString;
    });
    _saveProfile();
  }

  void _weightButtonClicked() async {
    _weightString = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return HeightWeightDialog(
            initialMeasure: double.parse(_weightString),
            popHeight: false,
            isMetric: 0,
          );
        });
    setState(() {
      _weightStringComplete = 'Weight : ' + _weightString;
    });
    _saveProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isProfileInitialized) {
      _loadProfile();
      _isProfileInitialized = true;
    }

    Constants.setAppWidth(MediaQuery.of(context).size.width);
    Constants.setAppHeight(MediaQuery.of(context).size.height);

    return Scaffold(
        backgroundColor: Color(Constants.backGroundBlue),
        appBar: AppBar(
          title: Text("User Settings page"),
          backgroundColor: Color(Constants.blueButtonColor),
        ),
        body: Padding(
          padding: EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlueButton(_birthdateStringComplete, _birthdateButtonClicked,
                    Icons.date_range, 70, Constants.getAppWidth() - 50),
                SizedBox(height: Constants.getAppHeight() * 0.03),
                BlueButton(_sexStringComplete, _sexButtonClicked,
                    Icons.date_range, 70, Constants.getAppWidth() - 50),
                SizedBox(height: Constants.getAppHeight() * 0.03),
                BlueButton(_heightStringComplete, _heightButtonClicked,
                    Icons.assessment, 70, Constants.getAppWidth() - 50),
                SizedBox(height: Constants.getAppHeight() * 0.03),
                BlueButton(_weightStringComplete, _weightButtonClicked,
                    Icons.assessment, 70, Constants.getAppWidth() - 50),
                SizedBox(height: (70 + Constants.getAppHeight() * 0.06)),
                BlueButton('Reset Profile', _resetProfile, Icons.delete, 70,
                    Constants.getAppWidth() - 50),
              ],
            ),
          ),
        ));
  }
}
