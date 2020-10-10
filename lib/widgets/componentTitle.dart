import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class ComponentTitle extends StatelessWidget {

  final String inputText;

  ComponentTitle(this.inputText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 40,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10),
      child: Text(
        inputText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        )
      ),
      decoration: BoxDecoration(
        color: Color(Constants.blueButtonColor),
        borderRadius: BorderRadius.circular(10)
      ),
    );
  }
}