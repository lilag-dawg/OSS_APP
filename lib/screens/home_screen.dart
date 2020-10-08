import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart' as Constants;

import '../widgets/navigationButton.dart';
import '../screens/statistics_screen.dart';
import 'preferencesScreen.dart';
import '../screens/batteryLevel_screen.dart';
import 'profileScreen.dart';

import '../models/bluetoothDeviceManager.dart';

class HomeScreen extends StatelessWidget {

  //final PageController _currentPage;
  //final Function selectHandler;

 const HomeScreen({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final ossManager = Provider.of<BluetoothDeviceManager>(context);

    void _calibrationPressed(){
      Navigator.of(context).pushNamed(
        "/calibration"
      );
    }

    void _statsPressed(){
      Navigator.of(context).pushNamed(
        "/statistics"
      );

    }

    void _specificationPressed(){
     Navigator.of(context).pushNamed(
       "/prefererence",
       //arguments: ossManager,
      );
    }

    void _settingPressed(){
     Navigator.of(context).pushNamed(
       "/settings",
       arguments: ossManager,
     );
    }

    void _batterieLevelPressed(){
     Navigator.of(context).pushNamed(
       "/batterie",
       arguments: ossManager,
     );
    }


    void _profilePressed(){
     Navigator.of(context).pushNamed(
       "/profile",
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