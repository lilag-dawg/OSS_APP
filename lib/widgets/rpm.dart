import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../constants.dart' as Constants;

class Rpm extends StatefulWidget {
  Rpm({this.devices, this.boxWidth, this.boxTitle, this.boxHeight}) {}

  final BluetoothDevice devices;
  final double boxWidth;
  final double boxHeight;
  final String boxTitle;

  @override
  _RpmState createState() => _RpmState();
}

class _RpmState extends State<Rpm> {
  //for stream setup
  Stream<List<int>> listStream;
  bool isNotificationOn;

  //for calculation
  List<int> lastdata = [];
  List<int> currentdata = [];
  double lastRpm = 0;
  double currentRpm = 0;

  Future<void> checkConnection() async {
    await for (BluetoothDeviceState state in widget.devices.state) {
      if (state == BluetoothDeviceState.connected) {
        print("still connected");
        mydeviceServices();
      }
    }
  }

  Future<void> mydeviceServices() async {
    List<BluetoothService> services = await widget.devices.discoverServices();
    services.forEach((s) {
      if ('0x${s.uuid.toString().toUpperCase().substring(4, 8)}' == "0x1816") {
        s.characteristics.forEach((c) {
          if ('0x${c.uuid.toString().toUpperCase().substring(4, 8)}' ==
              "0x2A5B") {
            listStream = c.value;
            c.setNotifyValue(true);
            print("caracteristique set pour notification");
            setState(() {
              isNotificationOn = true;
            });
          }
        });
      }
    });
  }

  void setLastAndCurrentData(List<int> data) {
    if (lastdata.length == 0) {
      lastdata = data;
      currentdata = data;
    } else {
      lastdata = currentdata;
      currentdata = data;
    }
  }

  double interpretReceivedData(List<int> data) {
    double rpm = 0;

    setLastAndCurrentData(data);
    if (lastdata != null && currentdata != null) {
      int flags = currentdata[0];

      bool wheelRevFlag = (flags & 0x01 > 0);
      bool crankRevFlag = (flags & 0x02 > 0);

      //todo

      if (wheelRevFlag) {
        int wheelRev = 0;
        int lasWheelRev = 0;
      }
      if (crankRevFlag) {
        //convert little to big endian
        int crankRev = (currentdata[8] << 8) + (currentdata[7]);
        int lastCrankRev = (lastdata[8] << 8) + (lastdata[7]);
        double crankEventTime =
            ((currentdata[10] << 8) + (currentdata[9])) * (1 / 1024);
        double lastCrankEventTime =
            ((lastdata[10] << 8) + (lastdata[9])) * (1 / 1024);

        if (crankEventTime != lastCrankEventTime && crankRev != lastCrankRev) {
          currentRpm = 60 *
              (crankRev - lastCrankRev) /
              ((crankEventTime - lastCrankEventTime));
        } else {
          currentRpm = 0;
        }

        if (lastRpm == 0) {
          lastRpm = currentRpm;
        }
        if (lastRpm == currentRpm || currentRpm < 0) {
          rpm = lastRpm;
        } else {
          rpm = currentRpm;
          currentRpm = lastRpm;
        }
      }
    }
    return rpm;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isNotificationOn = false;

    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(Constants.blueButtonColor)),
      child: SizedBox(
          width: widget.boxWidth,
          height: widget.boxHeight,
          child: Column(
            children: <Widget>[
              SizedBox(height: widget.boxHeight / 12.5),
              Text(
                widget.boxTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.boxWidth / 7.5,
                ),
              ),
              SizedBox(height: 125 / 8.33),
              StreamBuilder<List<int>>(
                stream: listStream,
                initialData: [],
                builder: (c, snapshot) {
                  final value = snapshot.data;
                  if (snapshot.connectionState == ConnectionState.active &&
                      value.length != 0) {
                      final rpm = interpretReceivedData(value);
                    return Text(
                      rpm.toStringAsFixed(0),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[300],
                        fontSize: widget.boxWidth / 6,
                      ),
                    );
                  } else {
                    return Text(
                      "N/A",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[300],
                        fontSize: widget.boxWidth / 6,
                      ),
                    );
                  }
                },
              ),
            ],
          )),
    );
  }
}
