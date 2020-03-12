import 'package:flutter/material.dart';

import '../widgets/TextFieldButton.dart';
import '../constants.dart' as Constants;

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        backgroundColor: Color(Constants.blueButtonColor),
        title:Text("Login Screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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