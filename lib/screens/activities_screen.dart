import 'package:flutter/material.dart';

import '../constants.dart' as Constants;
import '../widgets/navigationButton.dart';
import '../screens/login_screen.dart';

class ActivitiesScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activities page")
      ),
    );
  }
}