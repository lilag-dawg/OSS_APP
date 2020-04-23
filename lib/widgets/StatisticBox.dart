import 'package:oss_app/models/streamPackage.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../constants.dart' as Constants;

import 'package:flutter/material.dart';

class StatisticBox extends StatelessWidget {
  final double boxWidth;
  final double boxHeight;
  final String boxTitle;
  final String boxContent;

  StatisticBox(this.boxWidth, this.boxHeight, this.boxTitle, this.boxContent);

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
              Text(
                boxContent,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[300],
                  fontSize: boxWidth / 6,
                ),
              )
            ],
          )),
    );
  }
}

class StatisticBoxCustom extends StatelessWidget {
  final double boxWidth;
  final double boxHeight;
  final String boxTitle;
  final StreamPackage boxContent;

  StatisticBoxCustom(
      this.boxWidth, this.boxHeight, this.boxTitle, this.boxContent);

  Widget _buildConnextionStatus() {
    return StreamBuilder<BluetoothDeviceState>(
      stream: boxContent.getConnexion(),
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothDeviceState.connected) {
          print(state.toString());
          return _buildDataStream();
        }
        boxContent.characteristicStreamingStatus(false);
        return Icon(Icons.block);
      },
    );
  }

  Widget _buildDataStream() {
    return StreamBuilder<int>(
      stream: boxContent.getStream(),
      builder: (c, snapshot) {
        final value = snapshot.data;
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          return Text(
            value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[300],
              fontSize: boxWidth / 6,
            ),
          );
        }
        return Text(
          "N/A",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green[300],
            fontSize: boxWidth / 6,
          ),
        );
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
              _buildConnextionStatus(),
            ],
          )),
    );
  }
}
