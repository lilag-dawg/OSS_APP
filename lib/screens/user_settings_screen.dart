import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/blueButton.dart';
import '../widgets/sexDialog.dart';
import '../widgets/heightWeightDialog.dart';
import '../constants.dart' as Constants;
import 'package:intl/intl.dart';
import '../databases/db_user_settings_model.dart';
import '../databases/db.dart';

var _db = new
    DB(dbFormat: UserSettingsModel.dbFormat, dbName: UserSettingsModel.dbName);

class UserSettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserSettingsScreenState();
  }
}

class UserSettingsScreenState extends State<UserSettingsScreen> {
  var _birthdateParameter =
      UserSettingsModel(parameter: 'Birthday', parameterValue: null);

  var _sexParameter =
      UserSettingsModel(parameter: 'Sex', parameterValue: null);

  var _heightParameter =
      UserSettingsModel(parameter: 'Height', parameterValue: null);

  var _weightParameter =
      UserSettingsModel(parameter: 'Weight', parameterValue: null);



  void _birthdateButtonClicked() async {
    DateTime initialDate;
    if (_birthdateParameter.parameterValue != null) {
      initialDate = DateTime.parse(_birthdateParameter.parameterValue);
    } else {
      initialDate = DateTime.now();
    }

    DateTime _birthdate;
    _birthdate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.utc(1900, 1, 1, 0, 0, 0),
      lastDate: DateTime.now(),
    );
    if (_birthdate != null) {
      setState(() {
        _birthdateParameter.parameterValue =
            DateFormat('yyyy-MM-dd').format(_birthdate);
      });
    }
    await _saveParameter(_birthdateParameter);
  }

  void _sexButtonClicked() async {
    var _sex = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SexDialog(_sexParameter.parameterValue);
        });
    setState(() {
      _sexParameter.parameterValue = _sex;
    });
    await _saveParameter(_sexParameter);
  }

  void _heightButtonClicked() async {
    var _height = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return HeightWeightDialog(
            initialMeasure: _heightParameter.parameterValue,
            popHeight: true,
          );
        });
    setState(() {
      _heightParameter.parameterValue = _height;
    });
    await _saveParameter(_heightParameter);
  }

  void _weightButtonClicked() async {
    var _weight = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return HeightWeightDialog(
            initialMeasure: _weightParameter.parameterValue,
            popHeight: false,
          );
        });
    setState(() {
      _weightParameter.parameterValue = _weight;
    });
    await _saveParameter(_weightParameter);
  }

  String _generateString(UserSettingsModel parameter) {
    if (parameter.parameterValue == null) {
      return parameter.parameter;
    } else {
      return parameter.parameter + ' : ' + parameter.parameterValue;
    }
  }

    Future<void> _saveParameter(UserSettingsModel parameter) async {
    if (await _db.queryByParameter(UserSettingsModel.dbName, parameter.parameter) ==
        null) {
      await _db.insert(UserSettingsModel.dbName, parameter);
    } else {
      await _db.updateByParameter(UserSettingsModel.dbName, parameter);
    }
  }

  Future<void> _saveProfileDb() async {
    await _saveParameter(_birthdateParameter);
    await _saveParameter(_sexParameter);
    await _saveParameter(_heightParameter);
    await _saveParameter(_weightParameter);
  }

  Future<UserSettingsModel> _loadParameter(UserSettingsModel parameter) async {
    var loadedParameter =
        await _db.queryByParameter(UserSettingsModel.dbName, parameter.parameter);

    if (loadedParameter != null) {
      return UserSettingsModel.fromMap(loadedParameter);
    } else {
      return parameter;
    }
  }

  Future<void> _loadProfileDb() async {
    await _db.init();
    _birthdateParameter = await _loadParameter(_birthdateParameter);
    _sexParameter = await _loadParameter(_sexParameter);
    _heightParameter = await _loadParameter(_heightParameter);
    _weightParameter = await _loadParameter(_weightParameter);
  }

  void _resetProfileDb() async {
    await _db.delete(UserSettingsModel.dbName);
    setState(() {
      _birthdateParameter = UserSettingsModel(
          parameter: 'Birthday', parameterValue: null);

      _sexParameter =
          UserSettingsModel(parameter: 'Sex', parameterValue: null);

      _heightParameter = UserSettingsModel(
          parameter: 'Height', parameterValue: null);

      _weightParameter = UserSettingsModel(
          parameter: 'Weight', parameterValue: null);
    });
    await _saveProfileDb();
  }

  @override
  void initState() {
    super.initState();
    _loadProfileDb().then((_) => setState(() {
          _weightParameter = _weightParameter;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(Constants.backGroundBlue),
        appBar: AppBar(
          title: Text("User Settings page"),
          backgroundColor: Color(Constants.blueButtonColor),
        ),
        body: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BlueButton(
                  _generateString(_birthdateParameter),
                  _birthdateButtonClicked,
                  Icons.date_range,
                  70,
                  Constants.appWidth - 50),
              SizedBox(height: Constants.appHeight * 0.03),
              BlueButton(_generateString(_sexParameter), _sexButtonClicked,
                  Icons.date_range, 70, Constants.appWidth - 50),
              SizedBox(height: Constants.appHeight * 0.03),
              BlueButton(
                  _generateString(_heightParameter),
                  _heightButtonClicked,
                  Icons.assessment,
                  70,
                  Constants.appWidth - 50),
              SizedBox(height: Constants.appHeight * 0.03),
              BlueButton(
                  _generateString(_weightParameter),
                  _weightButtonClicked,
                  Icons.assessment,
                  70,
                  Constants.appWidth - 50),
              SizedBox(height: Constants.appHeight * 0.1),
              BlueButton('Reset Profile', _resetProfileDb, Icons.delete, 70,
                  Constants.appWidth - 50),
            ],
          ),
        ));
  }
}