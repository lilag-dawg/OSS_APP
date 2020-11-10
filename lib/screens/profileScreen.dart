import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/blueButton.dart';
import '../widgets/sexDialog.dart';
import '../widgets/heightWeightDialog.dart';
import '../constants.dart' as Constants;
import 'package:intl/intl.dart';
import '../databases/userProfileModel.dart';
import '../databases/dbHelper.dart';
import '../widgets/profileDialog.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen();
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  Padding profileList;
  String height;
  String weight;

  UserProfileModel profile;
  bool dialogIsOpened = false;

  void _birthdateButtonClicked() async {
    await getProfile();
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
    await getProfile();
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
    await getProfile();
    var _height = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return HeightWeightDialog(
              initialMeasure: profile.height == null ? null : profile.height,
              popHeight: true,
              isMetric: profile.metricHeight);
        });
    setState(() {
      height = _height;
    });
  }

  void _weightButtonClicked() async {
    await getProfile();
    var _weight = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return HeightWeightDialog(
              initialMeasure: profile.weight == null ? null : profile.weight,
              popHeight: false,
              isMetric: profile.metricWeight);
        });
    setState(() {
      weight = _weight;
    });
  }

  String _generateString(String parameterString, String parameter) {
    if (parameter == null) {
      return parameterString;
    } else {
      return parameterString + ' : ' + parameter;
    }
  }

  Future<void> saveProfile() async {
    await DatabaseHelper.updateUser(profile, profile.userName);
  }

  Future<void> changeProfile() async {
    if (!dialogIsOpened) {
      dialogIsOpened = true;
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return ProfileDialog();
          });
      dialogIsOpened = false;
      profile = await DatabaseHelper.getSelectedUserProfile();
      setState(() {});
    }
  }

  Future<void> getProfile() async {
    profile = await DatabaseHelper.getSelectedUserProfile();

    if (profile == null) {
      await changeProfile();
    }
  }

  void resetProfile() async {
    await getProfile();
    setState(() {
      profile = new UserProfileModel(
          userName: profile.userName, selected: profile.selected);
    });
    await saveProfile();
  }

  Future<void> buildLayout() async {
    await getProfile();

    if (profile != null) {
      profileList = Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlueButton(profile.userName, changeProfile, Icons.person, 70,
                Constants.getAppWidth() - 50),
            SizedBox(height: Constants.getAppHeight() * 0.09),
            BlueButton(
                _generateString("Birthday", profile.birthday),
                _birthdateButtonClicked,
                Icons.date_range,
                70,
                Constants.getAppWidth() - 50),
            SizedBox(height: Constants.getAppHeight() * 0.03),
            BlueButton(_generateString("Sex", profile.sex), _sexButtonClicked,
                Icons.pregnant_woman, 70, Constants.getAppWidth() - 50),
            SizedBox(height: Constants.getAppHeight() * 0.03),
            BlueButton(
                _generateString(
                    "Height",
                    profile.height == null
                        ? null
                        : HeightWeightDialogState.heightConversion(
                            profile.metricHeight, profile.height)),
                _heightButtonClicked,
                Icons.assessment,
                70,
                Constants.getAppWidth() - 50),
            SizedBox(height: Constants.getAppHeight() * 0.03),
            BlueButton(
                _generateString(
                    "Weight",
                    profile.weight == null
                        ? null
                        : HeightWeightDialogState.weightConversion(
                            profile.metricWeight, profile.weight)),
                _weightButtonClicked,
                Icons.assessment,
                70,
                Constants.getAppWidth() - 50),
            SizedBox(height: Constants.getAppHeight() * 0.09),
            BlueButton('Reset Profile', resetProfile, Icons.delete, 70,
                Constants.getAppWidth() - 50),
          ],
        ),
      );
    }
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
    Constants.setAppWidth(MediaQuery.of(context).size.width);
    Constants.setAppHeight(MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        title: Text("User Settings page"),
        backgroundColor: Color(Constants.blueButtonColor),
      ),
      body: SingleChildScrollView(child: futureBody()),
    );
  }
}
