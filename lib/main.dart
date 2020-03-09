import 'package:flutter/material.dart';


import './navigationbar.dart';




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