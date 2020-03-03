import 'package:flutter/material.dart';
import 'constants.dart' as Constants;

class BlueButton extends StatelessWidget {
  final String inputText;
  final Function selectHandler;
  final IconData inputIcon;

  BlueButton(this.inputText, this.selectHandler, this.inputIcon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.appWidth/2,
      height: Constants.appHeight/16,
      child: RaisedButton(
        color: Colors.blue[900] , // changer la couleur
        child: Row(children: <Widget>[
            Icon(inputIcon),
            Text(
            inputText,
            style: 
            TextStyle(
              color: Colors.white
              ),
            ), 
          ],
        ),
        onPressed: selectHandler,
      ),
    );
  }
}