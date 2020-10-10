import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oss_app/databases/db.dart';

import '../constants.dart' as Constants;

import '../widgets/navigationButton.dart';
import '../widgets/profileDialog.dart';
import '../databases/dbHelper.dart';

import '../models/bluetoothDeviceManager.dart';

class HomeScreen extends StatelessWidget {
  //final PageController _currentPage;
  //final Function selectHandler;

  const HomeScreen({Key key}) : super(key: key);

  void _calibrationPressed(BuildContext context) {
    Navigator.of(context).pushNamed("/calibration");
  }

  void _statsPressed(BuildContext context) {
    Navigator.of(context).pushNamed("/statistics");
  }

  void _preferencePressed(BuildContext context) {
    Navigator.of(context).pushNamed(
      "/preference",
      //arguments: ossManager,
    );
  }

  void _settingPressed(
      BuildContext context, BluetoothDeviceManager ossManager) {
    Navigator.of(context).pushNamed(
      "/settings",
      arguments: ossManager,
    );
  }

  void _batterieLevelPressed(BuildContext context) {
    Navigator.of(context).pushNamed(
      "/batterie",
      //arguments: ossManager,
    );
  }

  void _profilePressed(BuildContext context) {
    Navigator.of(context).pushNamed(
      "/profile",
    );
  }

  Future<void> buildLayout(BuildContext context) async {
    await DatabaseProvider.database;

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
    Constants.setAppWidth(MediaQuery.of(context).size.width);
    Constants.setAppHeight(MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        title: Text("Home Screen"),
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
              "Calibration",
              "assets/activities.png",
              () => _calibrationPressed(context)),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              "Statistics",
              "assets/stats.png",
              () => _statsPressed(context)),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              "Preferences",
              "assets/specifications.png",
              () => _preferencePressed(context)),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              "Setting",
              "assets/settings.png",
              () => _settingPressed(context, ossManager)),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              "Battery level",
              "assets/batteryLevel.png",
              () => _batterieLevelPressed(context)),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
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
