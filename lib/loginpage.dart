import 'package:flutter/material.dart';

import './TextFieldButton.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Login Screen"),
      ),
      body: Column(
        children: <Widget>[
          TextFieldButton("Username",Icons.account_circle,false),
          TextFieldButton("Password",Icons.lock,true),
          RaisedButton(
            child:
            Text("LOGIN"),
            onPressed:(){
              Navigator.pop(context);
            } ,)
        ],
      )
      
    );
  }
}