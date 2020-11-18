import 'package:flutter/material.dart';
import '../constants.dart' as constants;
import '../widgets/slideBarCombo.dart';
import '../databases/preferencesModel.dart';
import '../databases/db.dart';
import '../widgets/blueButton.dart';
import '../databases/dbHelper.dart';
import '../widgets/userPreferencesModesDialog.dart';
import '../widgets/groupsetDialog.dart';
import '../generated/l10n.dart';

class PreferencesScreen extends StatefulWidget {
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
          constants.defaultPreferencesModeName, preferences);
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
                Icons.playlist_play, 70, constants.getAppWidth() - 50),
            SizedBox(height: spaceItem1Item2),
            BlueButton(
                S.of(context).preferencesScreenSelectGroupset,
                changeGroupset,
                Icons.settings,
                70,
                constants.getAppWidth() - 50),
            SizedBox(height: spaceTopItem),
            SlideBarCombo(
                S.of(context).preferencesScreenThresholdPower,
                (constants.defaultFtp ~/ 4).toDouble(),
                constants.defaultFtp * 4.0,
                1,
                preferences.ftp,
                updateSlideBarCombo,
                S.of(context).preferencesScreenThresholdPowerInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                S.of(context).preferencesScreenAveragePower,
                (constants.defaultTargetEffort ~/ 4).toDouble(),
                constants.defaultTargetEffort * 4.0,
                1,
                preferences.targetEffort,
                updateSlideBarCombo,
                S.of(context).preferencesScreenAveragePowerInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                S.of(context).preferencesScreenResponsiveness,
                (constants.defaultShiftingResponsiveness ~/ 4).toDouble(),
                constants.defaultShiftingResponsiveness * 4.0,
                1,
                preferences.shiftingResponsiveness,
                updateSlideBarCombo,
                S.of(context).preferencesScreenResponsivenessInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                S.of(context).preferencesScreenDesiredRPM,
                (constants.defaultDesiredRpm ~/ 4).toDouble(),
                constants.defaultDesiredRpm * 4.0,
                1,
                preferences.desiredRpm,
                updateSlideBarCombo,
                S.of(context).preferencesScreenDesiredRPMInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                S.of(context).preferencesScreenDesiredBPM,
                (constants.defaultDesiredBpm ~/ 4).toDouble(),
                constants.defaultDesiredBpm * 4.0,
                1,
                preferences.desiredBpm,
                updateSlideBarCombo,
                S.of(context).preferencesScreenDesiredBPMInfo),
            SizedBox(height: constants.getAppHeight() * 0.1),
            BlueButton(S.of(context).preferencesScreenResetProfile,
                resetProfileDb, Icons.delete, 70, constants.getAppWidth() - 50),
            SizedBox(height: constants.getAppHeight() * 0.03),
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
    constants.setAppWidth(MediaQuery.of(context).size.width);
    constants.setAppHeight(MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: Color(constants.backGroundBlue),
      appBar: AppBar(
          backgroundColor: Color(constants.blueButtonColor),
          title: Text(S.of(context).preferencesScreenAppBarTitle)),
      body: futureBody(),
    );
  }
}
