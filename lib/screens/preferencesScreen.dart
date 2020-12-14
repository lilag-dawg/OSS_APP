import 'package:flutter/material.dart';
import 'package:oss_app/models/bluetoothDeviceCharacteristic.dart';
import 'package:provider/provider.dart';
import '../constants.dart' as Constants;
import '../widgets/slideBarCombo.dart';
import '../databases/preferencesModel.dart';
import '../widgets/blueButton.dart';
import '../databases/dbHelper.dart';
import '../widgets/userPreferencesModesDialog.dart';
import '../widgets/groupsetDialog.dart';
import '../models/bluetoothDeviceManager.dart';
import '../generated/l10n.dart';
import '../databases/db.dart';

class PreferencesScreen extends StatefulWidget {
  final BluetoothDeviceManager ossManager;

  const PreferencesScreen({Key key, @required this.ossManager}) : super(key: key);

  @override
  PreferencesScreenState createState() => PreferencesScreenState();
}

class PreferencesScreenState extends State<PreferencesScreen> {
  PreferencesModel preferences;
  Container preferencesList;

  static const ftpName = 'Functional Threshold Power';
  static const shiftingResponsivenessName = 'Shifting Responsiveness';
  static const desiredRpmName = 'Desired RPM';
  static const desiredBpmName = 'Desired BPM';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void updateSlideBarCombo(
      double newParameterValue, String parameterName) async {
    switch (parameterName) {
      case ftpName:
        {
          preferences.ftp = newParameterValue.toInt();
        }
        break;
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

  Future<void> _writeToMCU(BluetoothDeviceManager ossManager, List<int> dataToSend) async {
      BluetoothDeviceCharacteristic calibrationCharact = ossManager.ossDevice
          .getService(BluetoothDeviceManager.cablibrationService)
          .getCharacteristic(BluetoothDeviceManager.calibrationCharact);

      await calibrationCharact.characteristic.write(dataToSend);
  }

  Future<void> saveProfile() async {

    var test = DatabaseProvider.getSize();

    var test2 = test;
    
    /*if(this.widget.ossManager.ossDevice != null){
      showInSnackBar("Preferences saved!");
      await DatabaseHelper.updatePreferences(preferences);
      var crankset = await DatabaseHelper.getSelectedCrankset();
      var sprocket = await DatabaseHelper.getSelectedSprocket();
      //var preference = await DatabaseHelper.getCurrentPreferences();

      List<int> result =  BluetoothDeviceManager.sendCalibrationCharact(crankset, sprocket, preferences);

      await _writeToMCU(this.widget.ossManager, result);

      setState(() {});
    }
    else{
      showInSnackBar("Error, no device connected");
    }*/

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
    //await saveProfile();
    await DatabaseHelper.updatePreferences(preferences);
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GroupsetDialog();
        });

    preferences = await DatabaseHelper.getCurrentPreferences();
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
            BlueButton(S.of(context).preferencesScreenSelectGroupset, changeGroupset, Icons.settings, 70,
                Constants.getAppWidth() - 50),
            SizedBox(height: spaceItem1Item2),
            BlueButton('Save Preferences', saveProfile, Icons.save, 70,
                Constants.getAppWidth() - 50),
            SizedBox(height: spaceTopItem),
            SlideBarCombo(
                S.of(context).preferencesScreenThresholdPower,
                Constants.minFtp.toDouble(),
                Constants.maxFtp.toDouble(),
                10,
                preferences.ftp.toDouble(),
                updateSlideBarCombo,
                S.of(context).preferencesScreenThresholdPowerInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                S.of(context).preferencesScreenResponsiveness,
                Constants.minShiftingResponsiveness.toDouble(),
                Constants.maxShiftingResponsiveness.toDouble(),
                0.1,
                preferences.shiftingResponsiveness,
                updateSlideBarCombo,
                S.of(context).preferencesScreenResponsivenessInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                S.of(context).preferencesScreenDesiredRPM,
                Constants.minDesiredRpm.toDouble(),
                Constants.maxDesiredRpm.toDouble(),
                1,
                preferences.desiredRpm.toDouble(),
                updateSlideBarCombo,
                S.of(context).preferencesScreenDesiredRPMInfo),
            SizedBox(height: spaceItem1Item2),
            SlideBarCombo(
                S.of(context).preferencesScreenDesiredBPM,
                Constants.minDesiredBpm.toDouble(),
                Constants.maxDesiredBpm.toDouble(),
                1,
                preferences.desiredBpm.toDouble(),
                updateSlideBarCombo,
                S.of(context).preferencesScreenDesiredBPMInfo),
            SizedBox(height: Constants.getAppHeight() * 0.1),
            BlueButton(S.of(context).preferencesScreenResetProfile,
                resetProfileDb, Icons.delete, 70, Constants.getAppWidth() - 50),
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


void showInSnackBar(String value) {
    final snackBar = SnackBar(
      content: Text(value),
       action: SnackBarAction(
        label: 'OK',
          onPressed: () {
                // Some code to undo the change.
              },
            ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
}

  @override
  Widget build(BuildContext context) {
    Constants.setAppWidth(MediaQuery.of(context).size.width);
    Constants.setAppHeight(MediaQuery.of(context).size.height);

    //todo faire une verification si aucun device n'est present

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
          backgroundColor: Color(Constants.blueButtonColor),
          title: Text(S.of(context).preferencesScreenAppBarTitle)),
      body: futureBody(),
    );
  }
}