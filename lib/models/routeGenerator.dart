import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:oss_app/screens/home_screen.dart';
import '../main.dart';

import '../widgets/navigationBar.dart';
import '../screens/findDevicesScreen.dart';
import '../screens/settings_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/home_screen.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => HomeScreen(
                  connectedDevices: args,
                ));
      case "/settings":
        return MaterialPageRoute(
            builder: (_) => SettingsScreen(
                  connectedDevices: args,
                ));

      case "/settings/manage":
        return MaterialPageRoute(builder: (_) => FindDevicesScreen());
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
