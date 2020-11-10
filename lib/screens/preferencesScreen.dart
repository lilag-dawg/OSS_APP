import 'package:flutter/material.dart';
import '../constants.dart' as Constants;
import '../widgets/slideBarCombo.dart';
import '../databases/preferencesModel.dart';
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

  void updateSlideBarCombo(
      double newParameterValue, String parameterName) async {
    switch (parameterName) {
      case ftpName:
        {
          preferences.ftp = newParameterValue.toInt();
        }
        break;
      case targetEffortName:
        {
          preferences.targetEffort = newParameterValue.toInt();
        }
        break;
      case shiftingResponsivenessName:
        {
          preferences.shiftingResponsiveness = newParameterValue;
        }
        break;
      case desiredRpmName:
        {
          preferences.desiredRpm = newParameterValue.toInt();
        }
        break;
      case desiredBpmName:
        {
          preferences.desiredBpm = newParameterValue.toInt();
        }
        break;

      default:
        {}
        break;
    }
    setState(() {});
  }

  Future<void> saveProfile() async {
    await DatabaseHelper.updatePreferences(preferences);
    setState(() {});
  }

  Future<void> resetProfileDb() async {
    preferences =
        DatabaseHelper.getDefaultPreferencesRow(preferences.preferencesId);
    await saveProfile();
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
    if (preferences == null) {
      preferences = await DatabaseHelper.getCurrentPreferences();
    }

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
            SizedBox(height: spaceItem1Item2),
            BlueButton('Save Preferences', saveProfile, Icons.save, 70,
                Constants.getAppWidth() - 50),
            SizedBox(height: spaceTopItem),
            SlideBarCombo(
                ftpName,
                Constants.minFtp.toDouble(),
                Constants.maxFtp.toDouble(),
                10,
                preferences.ftp.toDouble(),
                updateSlideBarCombo,
                Constants.ftpInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                targetEffortName,
                Constants.minTargetEffort.toDouble(),
                Constants.maxTargetEffort.toDouble(),
                10,
                preferences.targetEffort.toDouble(),
                updateSlideBarCombo,
                Constants.targetEffortInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                shiftingResponsivenessName,
                Constants.minShiftingResponsiveness.toDouble(),
                Constants.maxShiftingResponsiveness.toDouble(),
                0.1,
                preferences.shiftingResponsiveness,
                updateSlideBarCombo,
                Constants.shiftingResponsivenessInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                desiredRpmName,
                Constants.minDesiredRpm.toDouble(),
                Constants.maxDesiredRpm.toDouble(),
                1,
                preferences.desiredRpm.toDouble(),
                updateSlideBarCombo,
                Constants.desiredRpmInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                desiredBpmName,
                Constants.minDesiredBpm.toDouble(),
                Constants.maxDesiredBpm.toDouble(),
                1,
                preferences.desiredBpm.toDouble(),
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
            if (preferencesList != null) {
              return preferencesList;
            } else {
              return Center(child: CircularProgressIndicator());
            }
            break;
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
