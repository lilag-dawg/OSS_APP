import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class NavigationButton extends StatelessWidget {
  final double buttonWidth;
  final double buttonHeight;
  final String inputText;
  final String url;
  final Function selectHandler;

  NavigationButton(this.buttonHeight, this.buttonWidth, this.inputText, this.url, this.selectHandler);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      child: 
      FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        padding: EdgeInsets.all(0.0),
        color: Color(Constants.blueButtonColor),
        onPressed: selectHandler, 
        child: Column(
          children: <Widget>[
            SizedBox(width: buttonWidth*0.05, ),
            Text(
              inputText,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 50),
            Image.asset(url)
          ],
        ),
      )
    );
  }
}