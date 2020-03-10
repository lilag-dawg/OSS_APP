import 'package:flutter/material.dart';

import './TextFieldButton.dart';
import './blueButton.dart';
import 'constants.dart' as Constants;
// Pour utiliser constants => Constants.appWidth

import './widgets/navigationBar.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  void _loginFunction(){
    print("Login pressed");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"testing routes",
      home: MyNavigationBar(),

  );
  }
}