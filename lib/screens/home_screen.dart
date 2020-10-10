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
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: <Widget>[
          NavigationButton(150, 150, "Calibration", "assets/activities.png",
              () => _calibrationPressed(context)),
          NavigationButton(150, 150, "Statistics", "assets/stats.png",
              () => _statsPressed(context)),
          NavigationButton(150, 150, "Preferences", "assets/specifications.png",
              () => _preferencePressed(context)),
          NavigationButton(150, 150, "Setting", "assets/setting.png",
              () => _settingPressed(context, ossManager)),
          NavigationButton(150, 150, "Battery level",
              "assets/batterieLevel.png", () => _batterieLevelPressed(context)),
          NavigationButton(150, 150, "Your profile", "assets/profil.png",
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
