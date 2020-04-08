import 'package:flutter/material.dart';
import 'package:oss_app/screens/calibration_screen.dart';

import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/lowerNavigationBar.dart';
import '../constants.dart' as Constants;

class MyNavigationBar extends StatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  static var _currentPage =
      PageController(initialPage: Constants.defaultPageIndex);

  List<Widget> _children;

  void _onItemTapped(int selected) {
    setState(() {
      _currentPage.jumpToPage(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    _children = [
      CalibrationScreen(),
      HomeScreen(_currentPage, _onItemTapped),
      SettingsScreen(),
    ];

    return Scaffold(
      body: PageView(
        children: _children,
        controller: _currentPage,
      ),
      bottomNavigationBar:
          LowerNavigationBar(_currentPage, null, _onItemTapped),
    );
  }
}
