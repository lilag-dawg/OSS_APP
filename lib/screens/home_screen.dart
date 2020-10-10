import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

import '../widgets/navigationButton.dart';
import '../screens/statistics_screen.dart';
import '../screens/specification_screen.dart';
import '../screens/batteryLevel_screen.dart';
import '../screens/user_settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final PageController _currentPage;
  final Function selectHandler;

  HomeScreen(this._currentPage, this.selectHandler);

  @override
  Widget build(BuildContext context) {
    void _calibrationPressed() {
      selectHandler(0);
    }

    void _statsPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                StatisticsScreen(_currentPage, selectHandler)),
      );
    }

    void _specificationPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SpecificationScreen(_currentPage, selectHandler)),
      );
    }

    void _settingPressed() {
      selectHandler(2);
    }

    void _batterieLevelPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BatteryLevelScreen()),
      );
    }

    void _profilePressed() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserSettingsScreen()),
      );
    }

    Constants.setAppWidth(MediaQuery.of(context).size.width);
    Constants.setAppHeight(MediaQuery.of(context).size.height);

    imageCache.clear();

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
              _calibrationPressed),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              "Statistics",
              "assets/stats.png",
              _statsPressed),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              "Specifications",
              "assets/specifications.png",
              _specificationPressed),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              "Setting",
              "assets/settings.png",
              _settingPressed),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              "Battery level",
              "assets/batteryLevel.png",
              _batterieLevelPressed),
          NavigationButton(
              (Constants.getAppWidth() * 0.35),
              (Constants.getAppWidth() * 0.35),
              "Your profile",
              "assets/profile.png",
              _profilePressed),
        ],
      )),
    );
  }
}
