import 'package:flutter/material.dart';
import 'constants.dart' as Constants;

class BlueButton extends StatelessWidget {
  final String inputText;
  final Function selectHandler;

  BlueButton(this.inputText, this.selectHandler);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.appWidth/2,
      height: Constants.appHeight/16,
      child: RaisedButton(
        color: Colors.blue[900] ,
        child: Text(
          inputText,
          style: 
          TextStyle(
            color: Colors.white
            ),
          ), 
        onPressed: selectHandler,
      ),
    );
  }
}