import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

import '../widgets/componentTitle.dart';
import '../widgets/slider.dart';
import '../widgets/navigationBar.dart';

class SpecificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double spaceTopItem = 30;
    double spaceTitleSlider = 15;
    double spaceItem1Item2 = 75;

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
        'typeOfData' : 'Desired pulse',
        'selectionMenu' : ['Low', 'medium', 'High', 'Very high']
      },
    ];

    return Scaffold(
      backgroundColor: Color(Constants.backGroundBlue),
      appBar: AppBar(
        backgroundColor: Color(Constants.blueButtonColor),
        title: Text("Specification page")
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: spaceTopItem),
              ComponentTitle(sliderStepsMap[0]['typeOfData']),
              SizedBox(height: spaceTitleSlider),
              SlideBar((sliderStepsMap[0]['selectionMenu'] as List<String>).map((selectionMenu){
                return selectionMenu;
              }).toList()),
              SizedBox(height: spaceItem1Item2),
              ComponentTitle(sliderStepsMap[1]['typeOfData']),
              SizedBox(height: spaceTitleSlider),
              SlideBar((sliderStepsMap[1]['selectionMenu'] as List<String>).map((selectionMenu){
                return selectionMenu;
              }).toList()),
              SizedBox(height: spaceItem1Item2),
              ComponentTitle(sliderStepsMap[2]['typeOfData']),
              SizedBox(height: spaceTitleSlider),
              SlideBar((sliderStepsMap[2]['selectionMenu'] as List<String>).map((selectionMenu){
                return selectionMenu;
              }).toList()),
            ],
          ),
        ),
      ), 
    );
  }
}