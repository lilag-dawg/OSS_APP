import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:oss_app/models/deviceInfo.dart';
import '../constants.dart' as Constants;

class CustomCheckboxTile extends StatefulWidget {
  final String deviceName;
  final String deviceID;
  final double buttonWidth;
  final double buttonHeight;

  CustomCheckboxTile(
      {this.deviceID, this.deviceName, this.buttonHeight, this.buttonWidth});

  @override
  _CustomCheckboxTileState createState() => _CustomCheckboxTileState();
}

class _CustomCheckboxTileState extends State<CustomCheckboxTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.buttonWidth,
      height: widget.buttonHeight,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Color(Constants.greyButtonColor), // changer la couleur
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
                      'Name : ' + widget.deviceName,
                      style: TextStyle(fontSize: 18, color: Color(0xFF404040)),
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
                      'ID : ' + widget.deviceID,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF404040),
                      ),
                    ),
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
                            style: TextStyle(
                                fontSize: 18, color: Color(0xFF404040)),
                          ),
                          Checkbox(value: true, onChanged: (bool val) {}),
                        ]),
                    height: widget.buttonHeight * .3,
                    width: widget.buttonWidth * .4,
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: widget.buttonHeight * 0.2),
                  Container(
                    child: Text(
                      "Disabled",
                      style: TextStyle(fontSize: 18, color: Color(0xFF404040)),
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
        onPressed: () {
          print("onpressed button");
        },
      ),
    );
  }
}

class Test12 extends StatelessWidget {
  final Function(BluetoothDevice, bool) onChanged;
  final DeviceInfo currendDevice;
  final bool value;
  final String name;

  const Test12({this.onChanged, this.value, this.currendDevice, this.name});

  void _handleOnChanged(bool value) {
    onChanged(currendDevice.device, value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Text(name),
      Checkbox(
        value: value,
        onChanged: _handleOnChanged,
      ),
    ]));
  }
}

class TestEnabledOrDisabled extends StatelessWidget {
  final String deviceName;
  final String deviceID;
  final String status;
  final Function(BluetoothDevice, bool) onPressed;
  final DeviceInfo currendDevice;

  const TestEnabledOrDisabled(
      {this.deviceName,
      this.deviceID,
      this.status,
      this.onPressed,
      this.currendDevice});

  void _handlePress() {
    onPressed(currendDevice.device, !currendDevice.connexionStatus);
  }

  String _handleStatus() {
    if (currendDevice.connexionStatus) {
      return "Disable";
    } else {
      return "Enable";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: <Widget>[
      Column(children: <Widget>[Text(deviceName), Text(deviceID)]),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            child: Text(_handleStatus()),
            onPressed: _handlePress,
          )
        ],
      )
    ]));
  }
}

class CustomTile extends StatelessWidget {
  final DeviceInfo currentDevice;
  final Function(BluetoothDevice, bool) onPressed;
  final Function(BluetoothDevice, bool) onChanged;
  final bool checkStatus;

  const CustomTile(
      {this.currentDevice, this.onPressed, this.onChanged, this.checkStatus});

  void _handlePress() {
    onPressed(currentDevice.device, !currentDevice.connexionStatus);
  }

  void _handleOnChanged(bool value) {
    onChanged(currentDevice.device, value);
  }

  Widget _buildTitle(BuildContext context) {
    if (currentDevice.device.name.length > 0) {
      return Text(currentDevice.device.name);
    } else {
      return Text(currentDevice.device.id.toString());
    }
  }

  Widget _buildLeading(BuildContext context) {
    if (currentDevice.connexionStatus) {
      return Icon(Icons.bluetooth_connected, color: Colors.green,);
    } else {
      return Icon(Icons.bluetooth_disabled, color: Colors.red,);
    }
  }

  Widget _buildSubtitle(BuildContext conext) {
    if (currentDevice.connexionStatus) {
      return Text("Enabled");
    } else {
      return Text("Disabled");
    }
  }

  Widget _buildTrailing(BuildContext context) {
    if (currentDevice.connexionStatus) {
      return Checkbox(
        value: checkStatus,
        onChanged: _handleOnChanged,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: _buildLeading(context),
        title: _buildTitle(context),
        subtitle: _buildSubtitle(context),
        onTap: () {
          _handlePress();
        },
        trailing: _buildTrailing(context),
      ),
    );
  }
}
