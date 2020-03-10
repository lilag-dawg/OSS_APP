import 'package:flutter/material.dart';

import '../constants.dart' as Constants;
import '../widgets/navigationButton.dart';
import '../screens/login_screen.dart';

class ActivitiesScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    void _buttonPressed(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
    return Scaffold(
      appBar: AppBar(
        title: Text("Activities page")
      ),
      body:
        NavigationButton( 150, 150, "Statistique", "assets/stats.png", _buttonPressed),
    );
  }
}