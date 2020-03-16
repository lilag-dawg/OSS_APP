import 'package:flutter/material.dart';

import '../widgets/componentTitle.dart';
import '../constants.dart' as Constants;

import '../widgets/slider.dart';

class SpecificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

      var sliderStepsMap = [
      {
        'typeOfData' : 'Desired effort',
        'selectionMenu' : ['Low', 'medium', 'High', 'Very high']
      },
      {
        'typeOfData' : 'Desired RPM',
        'selectionMenu' : ['Low', 'medium', 'High', 'Very high']
      },
      {
        'typeOfData' : 'desired pulse',
        'selectionMenu' : ['Low', 'medium', 'High', 'Very high']
      },
    ];

    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        backgroundColor: Color(Constants.blueButtonColor),
        title: Text("Specification page")
      ),
      body: Center(
        child: SlideBar((sliderStepsMap[1]['selectionMenu'] as List<String>).map((selectionMenu){
          return selectionMenu;
        }).toList())
      ), 
    );
  }
}