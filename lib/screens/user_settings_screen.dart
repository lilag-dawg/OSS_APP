import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/blueButton.dart';
import '../widgets/sexDialog.dart';
import '../widgets/heightWeightDialog.dart';
import '../constants.dart' as Constants;
import 'package:intl/intl.dart';
import '../databases/preferencesModel.dart';
import '../databases/userPreferencesModesModel.dart';
import '../databases/defaultPreferencesModel.dart';
import '../databases/userProfileModel.dart';
import '../databases/db.dart';

class UserSettingsScreen extends StatefulWidget {
  final int userId;
  UserSettingsScreen(this.userId);
  @override
  State<StatefulWidget> createState() {
    return UserSettingsScreenState();
  }
}

class UserSettingsScreenState extends State<UserSettingsScreen> {
  Future profileFuture;
  Padding profileList;

  UserProfileModel profile;

  /*var _birthdateParameter =
      UserSettingsModel(parameter: 'Birthday', parameterValue: null);

  var _sexParameter = UserSettingsModel(parameter: 'Sex', parameterValue: null);

  var _heightParameter =
      UserSettingsModel(parameter: 'Height', parameterValue: null);

  var _weightParameter =
      UserSettingsModel(parameter: 'Weight', parameterValue: null);*/

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

  Future<void> _saveParameter(UserSettingsModel parameter) async {}

  Future<void> saveProfile() async {
    await _saveParameter(_birthdateParameter);
    await _saveParameter(_sexParameter);
    await _saveParameter(_heightParameter);
    await _saveParameter(_weightParameter);
  }

  Future<void> loadDefaultProfile() async {
    profile = new UserProfileModel();

//TODO :
    await DatabaseProvider.insert(UserProfileModel.tableName, profile);

    var rows =
        await DatabaseProvider.query(UserProfileModel.tableName); // get userId
    if (rows != null) {
      profile = UserProfileModel.fromMap(rows.last);
    } else {
      profile = null; //make it crash (temporary)
    }
  }

  Future<void> loadProfile() async {
    var row = await DatabaseProvider.queryByParameters(
        UserProfileModel.tableName,
        UserProfileModel.primaryKeyWhereString,
        [widget.userId]);

    if (row != null) {
      profile = UserProfileModel.fromMap(row.first);
    }
  }

  Future<void> setProfile() async {
    profile = null;

    await loadProfile();
    if (profile == null) {
      await loadDefaultProfile();
    }
  }

  void resetProfile() async {
    await saveProfile();
  }

  Future<void> buildLayout() async {
    await setProfile();

    profileList = Padding(
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
          BlueButton(_generateString(_heightParameter), _heightButtonClicked,
              Icons.assessment, 70, Constants.appWidth - 50),
          SizedBox(height: Constants.appHeight * 0.03),
          BlueButton(_generateString(_weightParameter), _weightButtonClicked,
              Icons.assessment, 70, Constants.appWidth - 50),
          SizedBox(height: Constants.appHeight * 0.1),
          BlueButton('Reset Profile', resetProfile, Icons.delete, 70,
              Constants.appWidth - 50),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    profileFuture = buildLayout();
  }

  Widget futureBody() {
    return FutureBuilder<void>(
      future: profileFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return profileList;
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        title: Text("User Settings page"),
        backgroundColor: Color(Constants.blueButtonColor),
      ),
      body: futureBody(),
    );
  }
}
