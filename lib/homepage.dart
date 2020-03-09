import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen")
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Lauch screen"),
          onPressed: (){
            Navigator.pushNamed(context,"/login");
          },),
        ),
      
    );
  }
}