import 'package:flutter/material.dart';
import 'package:oss_app/screens/batteryLevel_screen.dart';
import 'package:oss_app/screens/calibration_screen.dart';
import 'package:oss_app/screens/home_screen.dart';
import 'package:oss_app/screens/manageDevicesScreen.dart';
import 'package:oss_app/screens/specification_screen.dart';



import '../screens/findDevicesScreen.dart';
import '../screens/settings_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/home_screen.dart';
import '../screens/user_settings_screen.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => HomeScreen(
                ));
      case "/settings":
        return MaterialPageRoute(
            builder: (_) => SettingsScreen(
                  ossManager: args,
                ));
      case "/batterie":
        return MaterialPageRoute(
            builder: (_) => BatteryLevelScreen());
      case "/calibration":
        return MaterialPageRoute(
            builder: (_) => CalibrationScreen());
      case "/settings/user_serttings":
        return MaterialPageRoute(
            builder: (_) => UserSettingsScreen());

      case "/settings/manage":
        return MaterialPageRoute(builder: (_) => FindDevicesScreen(ossManager: args));
      case "/settings/manage/pairing":
        return MaterialPageRoute(builder: (_) => ManageDevicesScreen());
      case "/statistics":
        return MaterialPageRoute(
            builder: (_) => StatisticsScreen(
                  connectedDevices: args,
                ));
      case "/specification":
        return MaterialPageRoute(builder: (_) => SpecificationScreen(ossManager: args));
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
