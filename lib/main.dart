import 'package:flutter/material.dart';

import './TextFieldButton.dart';


void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
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
          ],
          )
      ),
    );
  }
}