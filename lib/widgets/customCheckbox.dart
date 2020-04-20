import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:oss_app/models/deviceResult.dart';
import '../constants.dart' as Constants;

class CustomTile extends StatelessWidget {
  final DeviceResult currentDevice;
  final Function(BluetoothDevice, bool) onPressed;

  const CustomTile({this.currentDevice, this.onPressed});

  void _handlePress() {
    onPressed(currentDevice.device, !currentDevice.connexionStatus);
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
    if (currentDevice.connexionStatus) {
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
    if (currentDevice.connexionStatus) {
      return Text("Enabled", style: TextStyle(color: Colors.green));
    } else {
      return Text("Disabled", style: TextStyle(color: Colors.red));
    }
  }

  Widget _buildTrailing() {
    if (currentDevice.connexionStatus) {
      return Icon(Icons.mood);
    } else {
      return Icon(Icons.mood_bad);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: _buildLeading(),
        title: _buildTitle(),
        subtitle: _buildSubtitle(),
        onTap: () {
          _handlePress();
        },
        trailing: _buildTrailing(),
      ),
      color: currentDevice.connexionStatus ? Colors.green[100] : Colors.red[100],
    );
  }
}
