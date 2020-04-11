import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

import '../widgets/navigationButton.dart';
import '../screens/statistics_screen.dart';
import '../screens/preferences_screen.dart';
import '../screens/batteryLevel_screen.dart';
import '../screens/user_settings_screen.dart';

class HomeScreen extends StatelessWidget {

  final PageController _currentPage;
  final Function selectHandler;

  HomeScreen(this._currentPage, this.selectHandler);


  @override
  Widget build(BuildContext context) {

    void _calibrationPressed(){
      selectHandler(0);
    }

    void _statsPressed(){
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StatisticsScreen(_currentPage, selectHandler)),
      );
    }

    void _specificationPressed(){
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SpecificationScreen(_currentPage, selectHandler)),
      );
    }

    void _settingPressed(){
      selectHandler(2);
    }

    void _batterieLevelPressed(){
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BatteryLevelScreen()),
      );
    }

    void _profilePressed(){
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserSettingsScreen()),
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
            NavigationButton( 150, 150, "Preferences", "assets/specifications.png", _specificationPressed),
            NavigationButton( 150, 150, "Setting", "assets/setting.png", _settingPressed),
            NavigationButton( 150, 150, "Battery level", "assets/batterieLevel.png", _batterieLevelPressed),
            NavigationButton( 150, 150, "Your profile", "assets/profil.png", _profilePressed),
          ],
        )
      ),
    );
  }
}