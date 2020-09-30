import 'package:flutter/material.dart';
import '../constants.dart' as Constants;
import '../widgets/lowerNavigationBar.dart';
import '../widgets/slideBarCombo.dart';
import '../databases/preferencesModel.dart';
import '../databases/userPreferencesModesModel.dart';
import '../databases/db.dart';
import '../widgets/blueButton.dart';
import '../databases/dbHelper.dart';

class PreferencesScreen extends StatefulWidget {
  final PageController _currentPage;
  final Function selectHandler;
  PreferencesScreen(this._currentPage, this.selectHandler);

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

    setState(() {});
  }

  Future<void> saveProfile() async {
    await DatabaseProvider.updateByPrimaryKey(
        PreferencesModel.tableName,
        preferences,
        PreferencesModel.primaryKeyWhereString,
        preferences.preferencesId);
  }

  Future<void> loadPreferences(String userName) async {
    //TODO : use helper
    var rows = await DatabaseProvider.queryByParameters(
        UserPreferencesModesModel.tableName,
        UserPreferencesModesModel.userWhereString,
        [userName]);

    if (rows.length != 0) {
      int preferencesId;

      for (int i = 0; i < rows.length; i++) {
        if (UserPreferencesModesModel.fromMap(rows[i]).selected ==
            Constants.isSelected) {
          preferencesId =
              UserPreferencesModesModel.fromMap(rows[i]).preferencesId;
        }
      }
      if (preferencesId != null) {
        var preferencesRow = await DatabaseProvider.queryByParameters(
            PreferencesModel.tableName,
            PreferencesModel.primaryKeyWhereString,
            [preferencesId]);

        if (preferencesRow.length != 0) {
          preferences = PreferencesModel.fromMap(preferencesRow.first);
        }
      }
    }
  }

  Future<void> loadDefaultPreferences(String userName) async {
    preferences = new PreferencesModel(
        ftp: Constants.defaultFtp,
        targetEffort: Constants.defaultTargetEffort,
        shiftingResponsiveness: Constants.defaultShiftingResponsiveness,
        desiredRpm: Constants.defaultDesiredRpm,
        desiredBpm: Constants.defaultDesiredBpm);

    await DatabaseProvider.insert(PreferencesModel.tableName, preferences);
    var rows = await DatabaseProvider.query(
        PreferencesModel.tableName); // get preferencesId
    if (rows.length != 0) {
      preferences = PreferencesModel.fromMap(rows.last);
    } else {
      preferences = null; //make it crash (temporary)
    }

    var userPreferencesMode = new UserPreferencesModesModel(
        //assumes no other selected is true
        userName: userName,
        preferencesId: preferences.preferencesId,
        selected: Constants.isSelected,
        modeName: Constants.defaultPreferencesModeName);

    await DatabaseProvider.insert(
        UserPreferencesModesModel.tableName, userPreferencesMode);
  }

  Future<void> resetProfileDb() async {
    preferences = new PreferencesModel(
        preferencesId: preferences.preferencesId,
        ftp: Constants.defaultFtp,
        targetEffort: Constants.defaultTargetEffort,
        shiftingResponsiveness: Constants.defaultShiftingResponsiveness,
        desiredRpm: Constants.defaultDesiredRpm,
        desiredBpm: Constants.defaultDesiredBpm);
    await saveProfile();
    setState(() {});
  }

  Future<void> setPreferences() async {
    var profile = await DatabaseHelper.getSelectedUserProfile();

    if (profile == null) {
    } //TODO : check errors
    else {
      await loadPreferences(profile.userName);
      if (preferences == null) {
        await loadDefaultPreferences(profile.userName);
      }
    }
  }

  Future<void> changePreferencesMode() async {
    
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
            BlueButton(preferencesMode.modeName, changePreferencesMode, Icons.person, 70,
              Constants.appWidth - 50),
            SizedBox(height: spaceTopItem),
            SlideBarCombo(
                ftpName,
                (Constants.defaultFtp ~/ 4).toDouble(),
                Constants.defaultFtp * 4.0,
                1,
                preferences.ftp,
                updateSlideBarCombo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                targetEffortName,
                (Constants.defaultTargetEffort ~/ 4).toDouble(),
                Constants.defaultTargetEffort * 4.0,
                1,
                preferences.targetEffort,
                updateSlideBarCombo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                shiftingResponsivenessName,
                (Constants.defaultShiftingResponsiveness ~/ 4).toDouble(),
                Constants.defaultShiftingResponsiveness * 4.0,
                1,
                preferences.shiftingResponsiveness,
                updateSlideBarCombo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                desiredRpmName,
                (Constants.defaultDesiredRpm ~/ 4).toDouble(),
                Constants.defaultDesiredRpm * 4.0,
                1,
                preferences.desiredRpm,
                updateSlideBarCombo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                desiredBpmName,
                (Constants.defaultDesiredBpm ~/ 4).toDouble(),
                Constants.defaultDesiredBpm * 4.0,
                1,
                preferences.desiredBpm,
                updateSlideBarCombo),
            SizedBox(height: Constants.appHeight * 0.1),
            BlueButton('Reset Profile', resetProfileDb, Icons.delete, 70,
                Constants.appWidth - 50),
            SizedBox(height: Constants.appHeight * 0.03),
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
    return Scaffold(
      bottomNavigationBar: LowerNavigationBar(
          widget._currentPage, context, widget.selectHandler),
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
          backgroundColor: Color(Constants.blueButtonColor),
          title: Text("Preferences page")),
      body: futureBody(),
    );
  }
}
