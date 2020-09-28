import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/blueButton.dart';
import '../widgets/sexDialog.dart';
import '../widgets/heightWeightDialog.dart';
import '../constants.dart' as Constants;
import 'package:intl/intl.dart';
import '../databases/userProfileModel.dart';
import '../databases/db.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen();
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  Padding profileList;

  UserProfileModel profile;

  void _birthdateButtonClicked() async {
    DateTime initialDate;
    if (profile.birthday != null) {
      initialDate = DateTime.parse(profile.birthday);
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
        profile.birthday = DateFormat('yyyy-MM-dd').format(_birthdate);
      });
    }
    await saveProfile();
  }

  void _sexButtonClicked() async {
    var _sex = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SexDialog(profile.sex);
        });
    setState(() {
      profile.sex = _sex;
    });
    await saveProfile();
  }

  void _heightButtonClicked() async {
    var _height = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return HeightWeightDialog(
            initialMeasure: profile.height.toString(),
            popHeight: true,
          );
        });
    setState(() {
      profile.height = _height;
    });
    await saveProfile();
  }

  void _weightButtonClicked() async {
    var _weight = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return HeightWeightDialog(
            initialMeasure: profile.weight.toString(),
            popHeight: false,
          );
        });
    setState(() {
      profile.weight = _weight;
    });
    await saveProfile();
  }

  String _generateString(String parameterString, String parameter) {
    if (parameter == null) {
      return parameterString;
    } else {
      return parameterString + ' : ' + parameter;
    }
  }

  Future<void> saveProfile() async {
    await DatabaseProvider.updateByPrimaryKey(UserProfileModel.tableName,
        profile, UserProfileModel.primaryKeyWhereString, profile.userName);
  }

  /*Future<void> loadDefaultProfile() async {
    profile = new UserProfileModel();

    await DatabaseProvider.insert(UserProfileModel.tableName, profile);

    var rows =
        await DatabaseProvider.query(UserProfileModel.tableName); // get userId
    if (rows != null) {
      profile = UserProfileModel.fromMap(rows.last);
    } else {
      profile = null; //make it crash (temporary)
    }
  }*/

  Future<void> loadProfile(String userName) async {
    var row = await DatabaseProvider.queryByParameters(
        UserProfileModel.tableName,
        UserProfileModel.primaryKeyWhereString,
        [userName]);

    if (row.length != 0) {
      profile = UserProfileModel.fromMap(row.first);
    } else {
      profile = null; //make it crash (temporary)
    }
  }

  Future<void> setProfile() async {
    profile = null;

    var userRow = await DatabaseProvider.queryByParameters(
        UserProfileModel.tableName, UserProfileModel.getSelectedString, [Constants.isSelected]); 

    if (userRow.length == 0) {
    } else {
      await loadProfile(UserProfileModel.fromMap(userRow.first).userName);
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
              _generateString("Birthday", profile.birthday),
              _birthdateButtonClicked,
              Icons.date_range,
              70,
              Constants.appWidth - 50),
          SizedBox(height: Constants.appHeight * 0.03),
          BlueButton(_generateString("Sex", profile.sex), _sexButtonClicked,
              Icons.date_range, 70, Constants.appWidth - 50),
          SizedBox(height: Constants.appHeight * 0.03),
          BlueButton(
              _generateString("Height",profile.height == null ? null : profile.height.toString()),
              _heightButtonClicked,
              Icons.assessment,
              70,
              Constants.appWidth - 50),
          SizedBox(height: Constants.appHeight * 0.03),
          BlueButton(
              _generateString("Weight", profile.weight == null ? null : profile.weight.toString()),
              _weightButtonClicked,
              Icons.assessment,
              70,
              Constants.appWidth - 50),
          SizedBox(height: Constants.appHeight * 0.1),
          BlueButton('Reset Profile', resetProfile, Icons.delete, 70,
              Constants.appWidth - 50),
        ],
      ),
    );
  }

  Widget futureBody() {
    return FutureBuilder<void>(
      future: buildLayout(),
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
