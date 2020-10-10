import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../models/deviceConnexionStatus.dart';

class CustomTile extends StatelessWidget {
  final DeviceConnexionStatus currentDevice;
  final Function(String) onTapTile;

  const CustomTile({this.currentDevice, this.onTapTile});

  void _handleTapTile() {
    onTapTile(currentDevice.connexionStatus);
  }

  void _handlePressTrailing(BuildContext context) {
    Navigator.of(context).pushNamed(
       "/settings/manage/pairing",
      );
  } 

  Widget _buildTitle() {
    if (currentDevice.device.name.length > 0) {
      return Text(currentDevice.device.name,
          style: TextStyle(color: Colors.white));
    } else {
      return Text(currentDevice.device.id.toString(),
          style: TextStyle(color: Colors.white));
    }
  }

  Widget _buildLeading() {
    if (currentDevice.connexionStatus == DeviceConnexionStatus.connected) {
      return Icon(
        Icons.bluetooth_connected,
        color: Colors.green,
      );
    } else {
      return Icon(
        Icons.bluetooth_disabled,
        color: Colors.red,
      );
    }
  }

  Widget _buildSubtitle() {
    if (currentDevice.connexionStatus == DeviceConnexionStatus.connected) {
      return Text("Enabled", style: TextStyle(color: Colors.green));
    } else if (currentDevice.connexionStatus == DeviceConnexionStatus.inTransistion) {
      return Text("In transition...", style: TextStyle(color: Colors.grey));
    } else {
      return Text("Disabled", style: TextStyle(color: Colors.red));
    }
  }

  Widget _buildTrailing(BuildContext context) {
    if (currentDevice.connexionStatus == DeviceConnexionStatus.connected) {
      return IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            _handlePressTrailing(context);
          });
    } else {
      return SizedBox.shrink();
    }
  }

  Color _buildColor() {
    if (currentDevice.connexionStatus == DeviceConnexionStatus.connected) {
      return Colors.green[100];
    } else if (currentDevice.connexionStatus == DeviceConnexionStatus.inTransistion) {
      return Colors.black38;
    } else {
      return Colors.red[100];
    }
  }

  @override
  Widget build(BuildContext context) {
    print(currentDevice.connexionStatus + " " + currentDevice.device.name);
    return Card(
      child: ListTile(
          leading: _buildLeading(),
          title: _buildTitle(),
          subtitle: _buildSubtitle(),
          onTap: () {
            _handleTapTile();
          },
          trailing: _buildTrailing(context),
          enabled:
              (currentDevice.connexionStatus == DeviceConnexionStatus.inTransistion)
                  ? false
                  : true),
      color:_buildColor()
    );
  }
}
