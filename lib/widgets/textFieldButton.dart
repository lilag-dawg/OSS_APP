import 'package:flutter/material.dart';

import '../constants.dart' as Constants;


// Define a custom Form widget.
class TextFieldButton extends StatefulWidget {

  final String textDisplay;
  final IconData iconName;
  final bool obscureText;
  
  TextFieldButton(this.textDisplay,this.iconName,this.obscureText);

  @override
  _MyCustomTextFieldState createState() => _MyCustomTextFieldState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomTextFieldState extends State<TextFieldButton> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: myController,
        decoration: InputDecoration(
          hintText: widget.textDisplay,
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Color(Constants.blueButtonColor),
          filled:true,
          prefixIcon:Icon(
            widget.iconName,
            color: Colors.black,

          ),
        ),
        obscureText: widget.obscureText,
      ),
    );
  }
}

