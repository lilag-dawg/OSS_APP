import 'package:flutter/material.dart';
import 'package:oss_app/models/bluetoothDeviceManager.dart';
import '../widgets/blueButton.dart';
import '../constants.dart' as Constants;

class SettingsScreen extends StatelessWidget {
  final BluetoothDeviceManager ossManager;

  const SettingsScreen({Key key, @required this.ossManager}) : super(key: key);

  void _buttonClicked() {
    print("Button Clicked");
  }

  @override
  Widget build(BuildContext context) {
    void _userSettingsPressed() {
      Navigator.of(context).pushNamed(
        "/settings/user_serttings",
      );
    }

    void _deviceManagementPressed() {
      Navigator.of(context)
          .pushNamed("/settings/manage", arguments: ossManager);
    }

    Constants.setAppWidth(MediaQuery.of(context).size.width);
    Constants.setAppHeight(MediaQuery.of(context).size.height);

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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlueButton("Language", _buttonClicked, Icons.language, 70,
                    Constants.getAppWidth() - 50),
                SizedBox(height: Constants.getAppHeight() * 0.03),
                BlueButton("Share", _buttonClicked, Icons.share, 70,
                    Constants.getAppWidth() - 50),
                SizedBox(height: Constants.getAppHeight() * 0.03),
                BlueButton("OSS on Facebook", _buttonClicked, Icons.thumb_up,
                    70, Constants.getAppWidth() - 50),
                SizedBox(height: Constants.getAppHeight() * 0.03),
                BlueButton("Logout", _buttonClicked, Icons.exit_to_app, 70,
                    Constants.getAppWidth() - 50),
                SizedBox(height: Constants.getAppHeight() * 0.03),
                BlueButton("Notifications", _buttonClicked, Icons.add_alarm, 70,
                    Constants.getAppWidth() - 50),
                SizedBox(height: Constants.getAppHeight() * 0.03),
              ],
            ),
          ),
        ));
  }
}
