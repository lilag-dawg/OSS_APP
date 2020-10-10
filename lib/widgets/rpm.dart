import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../constants.dart' as Constants;

class Rpm extends StatelessWidget {
  Rpm(
      {this.device,
      this.boxWidth,
      this.boxTitle,
      this.boxHeight,});

  final BluetoothDevice device;
  final double boxWidth;
  final double boxHeight;
  final String boxTitle;

  Widget _buildConnextionStatus(BluetoothDevice d) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: d.state,
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothDeviceState.connected) {
          print(state.toString());
          return _buildFindServices(d);
        }
        return Icon(Icons.block);
      },
    );
  }

  Widget _buildFindServices(BluetoothDevice d) {
    return FutureBuilder<List<BluetoothService>>(
      future: d.discoverServices(),
      builder: (c, snapshot) {
        final services = snapshot.data;
        if (snapshot.hasData) {
          return _buildFilterData(d, services);
        }
        return Text("Device doesnt support cycling service");
      },
    );
  }

  Widget _buildFilterData(BluetoothDevice d, List<BluetoothService> services) {
    bool isServiceFound = false;
    bool isCharacteristicFound = false;
    BluetoothCharacteristic characteristic;

    services.forEach((s) {
      if ('0x${s.uuid.toString().toUpperCase().substring(4, 8)}' == "0x1816") {
        isServiceFound = true;
        s.characteristics.forEach((c) {
          if ('0x${c.uuid.toString().toUpperCase().substring(4, 8)}' ==
              "0x2A5B") {
            isCharacteristicFound = true;
            characteristic = c;
          }
        });
      }
    });

    if (!isServiceFound) {
      return Text("Service not found");
    } else if (!isCharacteristicFound) {
      return Text("Characteristic not found");
    }
    return _buildNotification(characteristic);
  }

  Widget _buildNotification(BluetoothCharacteristic characteristic) {
    return (characteristic.isNotifying)
    ? _buildStream(characteristic)
    : FutureBuilder(
      future: characteristic.setNotifyValue(true),
      builder: (c, snapshot) {
        final isNotiticationOn = snapshot.data;
        if (snapshot.hasData && isNotiticationOn) {
          return _buildStream(characteristic);
        }
        return Text("cant set to true");
      },
    );
  }

  Widget _buildStream(BluetoothCharacteristic characteristic) {
    return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: [],
      builder: (c, snapshot) {
        final value = snapshot.data;
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          print(value.toString());
          //final rpm = interpretReceivedData(value);
          return Text(
            value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[300],
              fontSize: boxWidth / 6,
            ),
          );
        } else {
          return Text(
            "N/A",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[300],
              fontSize: boxWidth / 6,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(Constants.blueButtonColor)),
      child: SizedBox(
          width: boxWidth,
          height: boxHeight,
          child: Column(
            children: <Widget>[
              SizedBox(height: boxHeight / 12.5),
              Text(
                boxTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: boxWidth / 7.5,
                ),
              ),
              SizedBox(height: 125 / 8.33),
             _buildConnextionStatus(device),
            ],
          )),
    );
  }
}
