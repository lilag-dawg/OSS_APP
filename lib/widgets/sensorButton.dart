import 'package:flutter/material.dart';
import '../constants.dart' as Constants;

class SensorButton extends StatefulWidget {
  final Function selectHandler;
  final double buttonWidth;
  final double buttonHeight;
  final String deviceName;
  final String deviceID;

  SensorButton(this.deviceName, this.deviceID, this.selectHandler,
      this.buttonHeight, this.buttonWidth);                     //ex : SensorButton('Lilag Dawg', 'gara3103', _test, 120, Constants.appWidth - 50),

  @override
  _SensorButtonState createState() => _SensorButtonState();
}

class _SensorButtonState extends State<SensorButton> {
  bool _isDeviceSelected = false;
  String _isEnabledString = 'Disabled';
  String deviceIDString;
  String deviceNameString;
  bool _isDeviceEnabled = false;
  int _mainButtonColor = Constants.greyButtonColor;
  int _textColor = 0xFF404040;

  _metricCheckboxClicked(bool state) {
    setState(() {
      _isDeviceSelected = state;
    });
    widget.selectHandler(_isDeviceEnabled, _isDeviceSelected, widget.deviceID);
  }

  void _setStrings() {
    deviceIDString = 'ID : ' + widget.deviceID; 
    deviceNameString = 'Name : ' + widget.deviceName; 
  }

  void _mainButtonClicked() {
    setState(() {
    _isDeviceEnabled = !_isDeviceEnabled;
    if(_isDeviceEnabled){
      _mainButtonColor = Constants.blueButtonColor;
      _textColor = 0xFFFFFFFF;
      _isEnabledString = 'Enabled';
    } else {
      _mainButtonColor = Constants.greyButtonColor;
      _textColor = 0xFF606060;
      _isEnabledString = 'Disabled';
      _isDeviceSelected = false;
    }
    });

    widget.selectHandler(_isDeviceEnabled, _isDeviceSelected, widget.deviceID);
    //  void example(bool _isDeviceEnabled, bool _isDeviceSelected, String deviceID) {}
  }

  @override
  Widget build(BuildContext context) {

    _setStrings();
    return Container(
      width: widget.buttonWidth,
      height: widget.buttonHeight,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Color(_mainButtonColor), // changer la couleur
        child: Row(
          children: <Widget>[
            Container(
              width: widget.buttonWidth * .5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: widget.buttonHeight * 0.1),
                  Container(
                    child: Text(
                      deviceNameString,
                      style: TextStyle(fontSize: 18, color: Color(_textColor)),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 3),
                        borderRadius: BorderRadius.circular(7)),
                    height: widget.buttonHeight * .3,
                    width: widget.buttonWidth * .5,
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: widget.buttonHeight * 0.2),
                  Container(
                    child: Text(
                      deviceIDString,
                      style: TextStyle(fontSize: 18, color: Color(_textColor),
                    ),),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 3),
                        borderRadius: BorderRadius.circular(7)),
                    height: widget.buttonHeight * .3,
                    width: widget.buttonWidth * .5,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
            Container(
              width: widget.buttonWidth * .4,
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(height: widget.buttonHeight * 0.1),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Select :',
                            style: TextStyle(fontSize: 18, color: Color(_textColor)),
                          ),
                          Checkbox(
                              value: _isDeviceSelected,
                              onChanged: _metricCheckboxClicked),
                        ]),
                    height: widget.buttonHeight * .3,
                    width: widget.buttonWidth * .4,
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: widget.buttonHeight * 0.2),
                  Container(
                    child: Text(
                      _isEnabledString,
                      style: TextStyle(fontSize: 18, color: Color(_textColor)),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 3),
                        borderRadius: BorderRadius.circular(3)),
                    height: widget.buttonHeight * .3,
                    width: widget.buttonWidth * .3,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        onPressed: _mainButtonClicked,
      ),
    );
  }
}
