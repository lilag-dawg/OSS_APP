import 'package:flutter/material.dart';
import '../constants.dart' as Constants;
import '../widgets/slideBarCombo.dart';
import '../databases/preferencesModel.dart';
import '../databases/db.dart';
import '../widgets/blueButton.dart';
import '../databases/dbHelper.dart';
import '../widgets/userPreferencesModesDialog.dart';
import '../widgets/groupsetDialog.dart';

class PreferencesScreen extends StatefulWidget {
  PreferencesScreen();

  @override
  PreferencesScreenState createState() => PreferencesScreenState();
}

class PreferencesScreenState extends State<PreferencesScreen> {
  PreferencesModel preferences;
  Container preferencesList;

  static const ftpName = 'Functional Threshold Power';
  static const targetEffortName = 'Target Average Power';
  static const shiftingResponsivenessName = 'Shifting Responsiveness';
  static const desiredRpmName = 'Desired RPM';
  static const desiredBpmName = 'Desired BPM';

  void updateSlideBarCombo(int newParameterValue, String parameterName) async {
    switch (parameterName) {
      case ftpName:
        {
          preferences.ftp = newParameterValue;
          await saveProfile();
        }
        break;
      case targetEffortName:
        {
          preferences.targetEffort = newParameterValue;
          await saveProfile();
        }
        break;
      case shiftingResponsivenessName:
        {
          preferences.shiftingResponsiveness = newParameterValue;
          await saveProfile();
        }
        break;
      case desiredRpmName:
        {
          preferences.desiredRpm = newParameterValue;
          await saveProfile();
        }
        break;
      case desiredBpmName:
        {
          preferences.desiredBpm = newParameterValue;
          await saveProfile();
        }
        break;

      default:
        {}
        break;
    }
  }

  Future<void> saveProfile() async {
    await DatabaseProvider.updateByPrimaryKey(
        PreferencesModel.tableName,
        preferences,
        PreferencesModel.primaryKeyWhereString,
        preferences.preferencesId);
    setState(() {});
  }

  Future<void> resetProfileDb() async {
    preferences =
        DatabaseHelper.getDefaultPreferencesRow(preferences.preferencesId);
    await saveProfile();
  }

  Future<void> setPreferences() async {
    preferences = await DatabaseHelper.getCurrentPreferences();
    if (preferences == null) {
      preferences = await DatabaseHelper.createDefaultPreferencesRow();
      await DatabaseHelper.createPreferencesMode(
          Constants.defaultPreferencesModeName, preferences);
      //TODO : check errors
    }
  }

  Future<void> changePreferencesMode() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return UserPreferencesModesDialog();
        });
    setState(() {});
  }

  Future<void> changeGroupset() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GroupsetDialog();
        });
    setState(() {});
  }

  Future<void> buildLayout() async {
    await setPreferences();
    var preferencesMode = await DatabaseHelper.getSelectedPreferencesMode();

    double spaceTopItem = 30;
    double spaceItem1Item2 = 35;

    preferencesList = Container(
      margin: EdgeInsets.only(left: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: spaceTopItem),
            BlueButton(preferencesMode.modeName, changePreferencesMode,
                Icons.playlist_play, 70, Constants.getAppWidth() - 50),
            SizedBox(height: spaceItem1Item2),
            BlueButton('Select Groupset', changeGroupset, Icons.settings, 70,
                Constants.getAppWidth() - 50),
            SizedBox(height: spaceTopItem),
            SlideBarCombo(
                ftpName,
                (Constants.defaultFtp ~/ 4).toDouble(),
                Constants.defaultFtp * 4.0,
                1,
                preferences.ftp,
                updateSlideBarCombo,
                Constants.ftpInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                targetEffortName,
                (Constants.defaultTargetEffort ~/ 4).toDouble(),
                Constants.defaultTargetEffort * 4.0,
                1,
                preferences.targetEffort,
                updateSlideBarCombo,
                Constants.targetEffortInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                shiftingResponsivenessName,
                (Constants.defaultShiftingResponsiveness ~/ 4).toDouble(),
                Constants.defaultShiftingResponsiveness * 4.0,
                1,
                preferences.shiftingResponsiveness,
                updateSlideBarCombo,
                Constants.shiftingResponsivenessInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                desiredRpmName,
                (Constants.defaultDesiredRpm ~/ 4).toDouble(),
                Constants.defaultDesiredRpm * 4.0,
                1,
                preferences.desiredRpm,
                updateSlideBarCombo,
                Constants.desiredRpmInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                desiredBpmName,
                (Constants.defaultDesiredBpm ~/ 4).toDouble(),
                Constants.defaultDesiredBpm * 4.0,
                1,
                preferences.desiredBpm,
                updateSlideBarCombo,
                Constants.desiredBpmInfo),
            SizedBox(height: Constants.getAppHeight() * 0.1),
            BlueButton('Reset Profile', resetProfileDb, Icons.delete, 70,
                Constants.getAppWidth() - 50),
            SizedBox(height: Constants.getAppHeight() * 0.03),
          ],
        ),
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
            {
              if (preferencesList != null) {
                return preferencesList;
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
            break;

          case ConnectionState.done:
            return preferencesList;
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
          backgroundColor: Color(Constants.blueButtonColor),
          title: Text("Preferences page")),
      body: futureBody(),
    );
  }
}
