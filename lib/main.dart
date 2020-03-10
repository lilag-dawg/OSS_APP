import 'package:flutter/material.dart';

// Pour utiliser constants => Constants.appWidth

import './widgets/navigationBar.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"testing routes",
      home: MyNavigationBar(),

  );
  }
}