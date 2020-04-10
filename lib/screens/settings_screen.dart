import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../widgets/blueButton.dart';
import '../screens/user_settings_screen.dart';
import '../constants.dart' as Constants;

class SettingsScreen extends StatelessWidget {

  final List<BluetoothDevice> connectedDevices;

  const SettingsScreen({Key key, @required this.connectedDevices}) : super(key: key);

  void _buttonClicked() {
    print("Button Clicked");
  }

  @override
  Widget build(BuildContext context) {
    void _userSettingsPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserSettingsScreen()),
      );
    }
    void _deviceManagementPressed() {
     Navigator.of(context).pushNamed(
        "/settings/manage"
      );
    }

    return Scaffold(
        backgroundColor: Color(Constants.backGroundBlue),
        appBar: AppBar(
          title: Text("Settings page"),
          backgroundColor: Color(Constants.blueButtonColor),
        ),
        body: Padding(
          padding: EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                BlueButton("Language", _buttonClicked, Icons.language, 70,
                    Constants.appWidth - 50),
                SizedBox(height: Constants.appHeight * 0.03),
                BlueButton("Share", _buttonClicked, Icons.share, 70,
                    Constants.appWidth - 50),
                SizedBox(height: Constants.appHeight * 0.03),
                BlueButton("OSS on Facebook", _buttonClicked, Icons.thumb_up,
                    70, Constants.appWidth - 50),
                SizedBox(height: Constants.appHeight * 0.03),
                BlueButton("Logout", _buttonClicked, Icons.exit_to_app, 70,
                    Constants.appWidth - 50),
                SizedBox(height: Constants.appHeight * 0.03),
                BlueButton("Device management", _deviceManagementPressed, Icons.device_unknown, 70,
                    Constants.appWidth - 50),
                SizedBox(height: Constants.appHeight * 0.03),
                BlueButton("User Settings", _userSettingsPressed, Icons.person,
                    70, Constants.appWidth - 50),
              ],
            ),
          ),
        ));
  }
}