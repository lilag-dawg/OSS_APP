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
        body: Column(
          children: <Widget>[
            TextFieldButton("Username",Icons.account_circle,false),
            TextFieldButton("Password",Icons.lock,true),
            BlueButton("Login", _loginFunction, Icons.language)
          ],
          )
      ),
    );
  }
}