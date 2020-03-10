import 'package:flutter/material.dart';

import '../widgets/TextFieldButton.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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