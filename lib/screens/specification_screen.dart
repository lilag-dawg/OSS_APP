import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

import '../widgets/slider.dart';

class SpecificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        backgroundColor: Color(Constants.blueButtonColor),
        title: Text("Specification page")
      ),
      body: Center(
        child: SlideBar()
      ), 
    );
  }
}