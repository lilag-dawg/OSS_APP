import 'package:flutter/material.dart';
import 'package:oss_app/databases/db.dart';
import 'package:oss_app/screens/calibration_screen.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/lowerNavigationBar.dart';
import '../constants.dart' as Constants;
import '../widgets/profileDialog.dart';
import '../databases/dbHelper.dart';

class MyNavigationBar extends StatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  Future navigationFuture;
  Scaffold appPages;

  static var _currentPage =
      PageController(initialPage: Constants.defaultPageIndex);

  List<Widget> _children;
  List<BluetoothDevice> _connectedDevices = [];

  void _onItemTapped(int selected) {
    setState(() {
      _currentPage.jumpToPage(selected);
    });
  }

  Future<void> buildLayout() async {
    await DatabaseProvider.database;
    await DatabaseHelper.updateCranksets();
    await DatabaseHelper.updateSprockets();
    //TODO : delete dead code

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

  Widget futureBody() {
    return FutureBuilder<void>(
      future: buildLayout(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return appPages;
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _children = [
      CalibrationScreen(),
      //HomeScreen(_currentPage, _onItemTapped,_connectedDevices),
      //SettingsScreen(),
    ];

    appPages = Scaffold(
      body: PageView(
        children: _children,
        controller: _currentPage,
      ),
      bottomNavigationBar:
          LowerNavigationBar(_currentPage, null, _onItemTapped),
    );

    return futureBody();
  }
}
