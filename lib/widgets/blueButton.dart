import 'package:flutter/material.dart';
import '../constants.dart' as Constants;

class BlueButton extends StatelessWidget {
  final String inputText;
  final Function selectHandler;
  final IconData inputIcon;
  final double buttonWidth;
  final double buttonHeight;

  BlueButton(this.inputText, this.selectHandler, this.inputIcon, this.buttonHeight, this.buttonWidth);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      child: RaisedButton(
        color: Color(Constants.blueButtonColor) , // changer la couleur
        child: Row(children: <Widget>[
            Icon(inputIcon),
            SizedBox(width: buttonWidth*0.05, ),
            Text(
              inputText,
              style: 
              TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ), 
          ],
        ),
        onPressed: selectHandler,
      ),
    );
  }
}