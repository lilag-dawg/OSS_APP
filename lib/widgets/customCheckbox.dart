import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:oss_app/models/deviceInfo.dart';
import '../constants.dart' as Constants;


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

  Widget _buildSubtitle(BuildContext context) {
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
