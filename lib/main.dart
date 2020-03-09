import 'package:flutter/material.dart';

import './TextFieldButton.dart';
import './blueButton.dart';
import 'constants.dart' as Constants;
// Pour utiliser constants => Constants.appWidth


void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  void _loginFunction(){
    print("Login pressed");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Wrap(
          spacing: 20,
          children: <Widget>[
            TextFieldButton("Username",Icons.account_circle,false),
            TextFieldButton("Password",Icons.lock,true),
            BlueButton("Language", _loginFunction, Icons.language, 40, Constants.appWidth-50),
            BlueButton("Share", _loginFunction, Icons.share, 40, Constants.appWidth-50),
            BlueButton("OSS on facebook", _loginFunction, Icons.thumb_up, 40, Constants.appWidth-50),
            BlueButton("Logout", _loginFunction, Icons.exit_to_app, 40, Constants.appWidth-50),
            BlueButton("Notifications", _loginFunction, Icons.add_alarm, 40, Constants.appWidth-50)
          ],
          )
      ),
    );
  }
}