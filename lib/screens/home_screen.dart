import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart' as Constants;

import '../widgets/navigationButton.dart';
import '../databases/dbHelper.dart';

import '../models/bluetoothDeviceManager.dart';
import '../main.dart';
import '../generated/l10n.dart';

class HomeScreen extends StatelessWidget {
  //final PageController _currentPage;
  //final Function selectHandler;

  const HomeScreen({Key key}) : super(key: key);

  void _calibrationPressed(BuildContext context) {
    MyApp.navKey.currentState.pushNamed("/calibration");
  }

  void _statsPressed(BuildContext context) {
    MyApp.navKey.currentState.pushNamed("/statistics");
  }

  void _preferencePressed(BuildContext context,  BluetoothDeviceManager ossManager) {
     MyApp.navKey.currentState.pushNamed(
      "/preference",
      arguments: ossManager,
    );
  }

  void _settingPressed(
      BuildContext context, BluetoothDeviceManager ossManager) {
    MyApp.navKey.currentState.pushNamed(
      "/settings",
      arguments: ossManager,
    );
  }

  void _batterieLevelPressed(BuildContext context) {
    MyApp.navKey.currentState.pushNamed("/batterie");
  }

  void _profilePressed(BuildContext context) {
    MyApp.navKey.currentState.pushNamed("/profile");
  }

  Future<void> buildLayout(BuildContext context) async {
    await DatabaseHelper.initDatabase();
    await DatabaseHelper.updateCranksets();
    await DatabaseHelper.updateSprockets();

    var user = await DatabaseHelper.getSelectedUserProfile();

    if (user == null) {
      await DatabaseHelper.createUser(Constants.defaultProfileName);
    }
  }

  Widget futureBody(BuildContext context, BluetoothDeviceManager ossManager) {
    return FutureBuilder<void>(
      future: buildLayout(context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return scaffold(context, ossManager);
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget scaffold(BuildContext context, BluetoothDeviceManager ossManager) {
    Constants.setAppWidth(MediaQuery.of(context).size.width);
    Constants.setAppHeight(MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        title: Text(S.of(context).homeScreenAppBarTitle),
        backgroundColor: Color(Constants.blueButtonColor),
      ),
      body: Container(
          child: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20.0),
        mainAxisSpacing: Constants.getAppWidth() * 0.05,
        crossAxisSpacing: Constants.getAppWidth() * 0.05,
        children: <Widget>[
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              S.of(context).homeScreenCalibration,
              "assets/activities.png",
              () => _calibrationPressed(context)),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              S.of(context).homeScreenStatistics,
              "assets/stats.png",
              () => _statsPressed(context)),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              S.of(context).homeScreenPreferences,
              "assets/specifications.png",
              () => _preferencePressed(context, ossManager)),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              S.of(context).homeScreenSettings,
              "assets/settings.png",
              () => _settingPressed(context, ossManager)),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              S.of(context).homeScreenBatteryLevel,
              "assets/batteryLevel.png",
              () => _batterieLevelPressed(context)),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              S.of(context).homeScreenProfile,
              "assets/profile.png",
              () => _profilePressed(context)),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ossManager = Provider.of<BluetoothDeviceManager>(context);

    return futureBody(context, ossManager);
  }
}
