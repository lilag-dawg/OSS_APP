import 'package:flutter/material.dart';
import 'package:oss_app/screens/batteryLevel_screen.dart';
import 'package:oss_app/screens/calibration_screen.dart';
import 'package:oss_app/screens/home_screen.dart';
import 'package:oss_app/screens/manageDevicesScreen.dart';
import 'package:oss_app/screens/preferencesScreen.dart';
import 'package:oss_app/screens/profileScreen.dart';

import '../screens/findDevicesScreen.dart';
import '../screens/settings_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/home_screen.dart';

import '../widgets/userPreferencesModesDialog.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case "/settings":
        return MaterialPageRoute(
            builder: (_) => SettingsScreen(
                  ossManager: args,
                ));
      case "/batterie":
        return MaterialPageRoute(builder: (_) => BatteryLevelScreen());
      case "/calibration":
        return MaterialPageRoute(builder: (_) => CalibrationScreen());
      case "/profile":
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case "/preference":
        return MaterialPageRoute(builder: (_) => PreferencesScreen(
          ossManager: args
        ));
      case "/settings/manage":
        return MaterialPageRoute(
            builder: (_) => FindDevicesScreen(ossManager: args));
      case "/settings/manage/pairing":
        return MaterialPageRoute(builder: (_) => ManageDevicesScreen());
      case "/statistics":
        return MaterialPageRoute(
            builder: (_) => StatisticsScreen(
                  connectedDevices: args,
                ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
