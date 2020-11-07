import 'package:flutter/material.dart';
import 'package:oss_app/models/bluetoothDeviceManager.dart';
import '../widgets/blueButton.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart' as constants;

import '../models/notificationHandler.dart';

import '../main.dart';

class SettingsScreen extends StatelessWidget {
  final BluetoothDeviceManager ossManager;

  const SettingsScreen({Key key, @required this.ossManager}) : super(key: key);

  void _buttonClicked() {
    print("Button Clicked");
  }

  void _fbButtonClicked() async {
    String fbProtocolUrl;
    if (Platform.isIOS) {
      fbProtocolUrl = 'fb://profile/101298814752706';
    } else {
      fbProtocolUrl = 'fb://page/101298814752706';
    }

    String fallbackUrl =
        'https://www.facebook.com/OSS-Optimal-Shifting-Solution-101298814752706';

    try {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }

  void _userSettingsPressed() {
    MyApp.navKey.currentState.pushNamed(
      "/settings/user_settings",
    );
  }

  void _deviceManagementPressed() {
    MyApp.navKey.currentState.pushNamed(
      "/settings/manage",
      arguments: ossManager,
    );
  }

  void _notButtonClicked() async {
    showDialog(
        context: MyApp.navKey.currentContext,
        builder: (BuildContext context) => NotDialog());
  }

  @override
  Widget build(BuildContext context) {
    constants.setAppWidth(MediaQuery.of(context).size.width);
    constants.setAppHeight(MediaQuery.of(context).size.height);

    return Scaffold(
        backgroundColor: Color(constants.backGroundBlue),
        appBar: AppBar(
          title: Text("Settings page"),
          backgroundColor: Color(constants.blueButtonColor),
        ),
        body: Padding(
          padding: EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlueButton("Language", _buttonClicked, Icons.language, 70,
                    constants.getAppWidth() - 50),
                SizedBox(height: constants.getAppHeight() * 0.03),
                BlueButton("Share", _buttonClicked, Icons.share, 70,
                    constants.getAppWidth() - 50),
                SizedBox(height: constants.getAppHeight() * 0.03),
                BlueButton("OSS on Facebook", _fbButtonClicked, Icons.thumb_up,
                    70, constants.getAppWidth() - 50),
                SizedBox(height: constants.getAppHeight() * 0.03),
                BlueButton("Logout", _buttonClicked, Icons.exit_to_app, 70,
                    constants.getAppWidth() - 50),
                SizedBox(height: constants.getAppHeight() * 0.03),
                BlueButton("Notifications", _notButtonClicked, Icons.add_alarm,
                    70, constants.getAppWidth() - 50),
                SizedBox(height: constants.getAppHeight() * 0.03),
                BlueButton("Device management", _deviceManagementPressed,
                    Icons.device_unknown, 70, constants.getAppWidth() - 50),
                SizedBox(height: constants.getAppHeight() * 0.03),
              ],
            ),
          ),
        ));
  }
}
