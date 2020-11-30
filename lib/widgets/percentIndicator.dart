import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../constants.dart' as constants;
import "../generated/l10n.dart";

class Device {
  String name;
  double batteryLevel;
  bool battCompatible;

  Device(String name, bool status, double batteryLevel) {
    this.name = name;
    this.batteryLevel = batteryLevel;
    this.battCompatible = status;
  }

  Color _currentProgressColor() {
    if (batteryLevel >= 30 && batteryLevel < 60) {
      return Colors.orange;
    }
    if (batteryLevel >= 60) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  String _statusText() {
    if (battCompatible) {
      return S.current.batteryScreenCompatible;
    }
    return S.current.batteryScreenIncompatible;
  }

  Color _statusColor() {
    if (battCompatible) {
      return Colors.green;
    }
    return Colors.red;
  }

  AssetImage _statusIcon() {
    if (!battCompatible) {
      return AssetImage("assets/BatteryIconMissing.png");
    }
    if (batteryLevel > 20 && batteryLevel <= 50) {
      return AssetImage("assets/BatteryIconMed.png");
    }
    if (batteryLevel > 50) {
      return AssetImage("assets/BatteryIconFull.png");
    }
    return AssetImage("assets/BatteryIconLow.png");
  }

  Widget deviceStatus(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      width: constants.getAppWidth(),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(
                image: _statusIcon(),
                height: constants.getAppHeight() * 0.05,
                width: constants.getAppHeight() * 0.05,
              ),
              Column(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: constants.getAppWidth() * 0.05,
                    ),
                  ),
                  Text(
                    battCompatible == true
                        ? "$batteryLevel" + "%"
                        : S.of(context).batteryScreenDeviceUnavailable,
                    style: new TextStyle(
                      fontSize: constants.getAppWidth() * 0.045,
                    ),
                  ),
                ],
              ),
              Text(
                _statusText(),
                style: TextStyle(
                  color: _statusColor(),
                  fontSize: constants.getAppWidth() * 0.035,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RoutinePage extends StatefulWidget {
  final Device device;

  RoutinePage(this.device);

  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  double progress = 0;
  double percProgress = 0;
  String connectedOrNot = "Connected";
  Color connectColor = Colors.green;

  currentProgressColor() {
    if (percProgress >= 0.3 && percProgress < 0.6) {
      return Colors.orange;
    }
    if (percProgress >= 0.6) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.device.battCompatible == false) {
      connectedOrNot = "Disconnected";
      progress = 0;
      connectColor = Colors.red;
    } else {
      progress = widget.device.batteryLevel;
      percProgress = progress / 100;
    }

    return Column(
      children: <Widget>[
        Text(
          connectedOrNot,
          style: TextStyle(
            color: connectColor,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        Text(
          widget.device.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        LinearPercentIndicator(
          width: constants.getAppWidth() * 0.85,
          lineHeight: 30.0,
          percent: progress / 100,
          center: Text(
            widget.device.battCompatible == true
                ? "$progress" + "%"
                : "Not connected",
            style: new TextStyle(fontSize: 20.0),
          ),
          linearStrokeCap: LinearStrokeCap.roundAll,
          backgroundColor: Colors.grey,
          progressColor: currentProgressColor(),
          alignment: MainAxisAlignment.center,
        )
      ],
    );
  }
}
