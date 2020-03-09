import 'package:flutter/material.dart';

import './homepage.dart';
import './loginpage.dart';


import 'constants.dart' as Constants;
// Pour utiliser constants => Constants.appWidth


void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"testing routes",
      initialRoute: "/",
      routes: {
        "/" : (context) => HomeScreen(),
        "/login" : (context) => LoginScreen(),
      },

  );
  }
}