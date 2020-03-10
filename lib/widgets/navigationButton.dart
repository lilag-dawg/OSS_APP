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
        color: Color(Constants.paleBlue),
        onPressed: selectHandler, 
        child: Column(
          children: <Widget>[
            Text(inputText),
            SizedBox(width: buttonWidth*0.05, ),
            Image.asset(url)
          ],
        ),
      )
    );
  }
}