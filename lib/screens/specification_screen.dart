import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class SpecificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        backgroundColor: Color(Constants.blueButtonColor),
        title: Text("Specification page")
      ),
      
    );
  }
}