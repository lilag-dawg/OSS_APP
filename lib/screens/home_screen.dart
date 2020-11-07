import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oss_app/databases/db.dart';

import '../constants.dart' as constants;

import '../widgets/navigationButton.dart';
import '../widgets/profileDialog.dart';
import '../databases/dbHelper.dart';

import '../models/bluetoothDeviceManager.dart';
import '../main.dart';

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

  void _preferencePressed(BuildContext context) {
    MyApp.navKey.currentState.pushNamed("/preference");
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
    await DatabaseProvider.database;
    await DatabaseHelper.updateCranksets();
    await DatabaseHelper.updateSprockets();

    var user = await DatabaseHelper.getSelectedUserProfile();

    if (user == null) {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return ProfileDialog();
          });
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
    constants.setAppWidth(MediaQuery.of(context).size.width);
    constants.setAppHeight(MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: Color(constants.backGroundBlue),
      appBar: AppBar(
        title: Text("Home Screen"),
        backgroundColor: Color(constants.blueButtonColor),
      ),
      body: Container(
          child: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20.0),
        mainAxisSpacing: constants.getAppWidth() * 0.05,
        crossAxisSpacing: constants.getAppWidth() * 0.05,
        children: <Widget>[
          NavigationButton(
              (constants.getAppWidth() * 0.35),
              (constants.getAppWidth() * 0.35),
              "Calibration",
              "assets/activities.png",
              () => _calibrationPressed(context)),
          NavigationButton(
              (constants.getAppWidth() * 0.35),
              (constants.getAppWidth() * 0.35),
              "Statistics",
              "assets/stats.png",
              () => _statsPressed(context)),
          NavigationButton(
              (constants.getAppWidth() * 0.35),
              (constants.getAppWidth() * 0.35),
              "Preferences",
              "assets/specifications.png",
              () => _preferencePressed(context)),
          NavigationButton(
              (constants.getAppWidth() * 0.35),
              (constants.getAppWidth() * 0.35),
              "Setting",
              "assets/settings.png",
              () => _settingPressed(context, ossManager)),
          NavigationButton(
              (constants.getAppWidth() * 0.35),
              (constants.getAppWidth() * 0.35),
              "Battery level",
              "assets/batteryLevel.png",
              () => _batterieLevelPressed(context)),
          NavigationButton(
              (constants.getAppWidth() * 0.35),
              (constants.getAppWidth() * 0.35),
              "Your profile",
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
