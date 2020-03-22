import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

import '../widgets/navigationButton.dart';
import '../screens/calibration_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/specification_screen.dart';
import '../screens/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    void _calibrationPressed(){
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CalibrationScreen()),
      );
    }

    void _statsPressed(){
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StatisticsScreen()),
      );
    }

    void _specificationPressed(){
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SpecificationScreen()),
      );
    }

    void _settingPressed(){
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    }

    
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
            NavigationButton( 150, 150, "Calibration", "assets/activities.png", _calibrationPressed),
            NavigationButton( 150, 150, "Statistics", "assets/stats.png", _statsPressed),
            NavigationButton( 150, 150, "Specifications", "assets/specifications.png", _specificationPressed),
            NavigationButton( 150, 150, "Setting", "assets/setting.png", _settingPressed),
          ],
        )
      ),
    );
  }
}