import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../models/deviceCharac.dart';

import '../constants.dart' as Constants;

class Rpm extends StatefulWidget {
  Rpm({this.devices, this.boxWidth, this.boxTitle, this.boxHeight}) {}

  final List<BluetoothDevice> devices;
  final double boxWidth;
  final double boxHeight;
  final String boxTitle;

  @override
  _RpmState createState() => _RpmState();
}

class _RpmState extends State<Rpm> {
  //for stream setup
  Stream<List<int>> listStream;
  List<DeviceCharacteristic> rpmDevices = [];
  bool isNotificationOn;
  bool isRpmDevicesEmpty;

  //for calculation
  List<int> lastdata = [];
  List<int> currentdata = [];
  double rpm = 0;

  Future<void> checkConnection() async {
    for (BluetoothDevice d in widget.devices) {
      await for (BluetoothDeviceState state in d.state) {
        if (state == BluetoothDeviceState.connected) {
          print("device ${d.name} still connected");
          await mydeviceServices(d);
        }
      }
    }
  }

  Future<void> mydeviceServices(BluetoothDevice d) async {
    List<BluetoothService> services = await d.discoverServices();
    services.forEach((s) {
      if ('0x${s.uuid.toString().toUpperCase().substring(4, 8)}' == "0x1816") {
        s.characteristics.forEach((c) {
          if ('0x${c.uuid.toString().toUpperCase().substring(4, 8)}' ==
              "0x2A5B") {
            rpmDevices.add(DeviceCharacteristic(device: d, characteristic: c));
            print("charact found");
            setState(() {
              isRpmDevicesEmpty = false;
            });
          }
        });
      }
    });
  }

  void _setListener(DeviceCharacteristic d) {
    listStream = d.characteristic.value;
    d.characteristic.setNotifyValue(true);
    setState(() {
      isNotificationOn = true;
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
    setLastAndCurrentData(data);
    if (lastdata.length > 0 && currentdata.length > 0) {
      int flag = currentdata[0];

      if (flag == 3 && lastdata.length == currentdata.length) {
        int crankRev = (currentdata[8] << 8) + (currentdata[7]);
        int lastCrankRev = (lastdata[8] << 8) + (lastdata[7]);
        double crankEventTime =
            ((currentdata[10] << 8) + (currentdata[9])) * (1 / 1024);
        double lastCrankEventTime =
            ((lastdata[10] << 8) + (lastdata[9])) * (1 / 1024);

        if (crankEventTime > lastCrankEventTime && crankRev > lastCrankRev) {
          rpm = 60 *
              (crankRev - lastCrankRev) /
              (crankEventTime - lastCrankEventTime);
          return rpm; // bonne nouvelle valeur
        } else if (crankEventTime == lastCrankEventTime) {
          return rpm = 0; // on detecte que le rpm n a pas change
        }
        return rpm; // on retourne la derniere valeur ajouter
      } else if (flag == 2 && lastdata.length == currentdata.length) {
        int crankRev = (currentdata[2] << 8) + (currentdata[1]);
        int lastCrankRev = (lastdata[2] << 8) + (lastdata[1]);
        double crankEventTime =
            ((currentdata[4] << 8) + (currentdata[3])) * (1 / 1024);
        double lastCrankEventTime =
            ((lastdata[4] << 8) + (lastdata[3])) * (1 / 1024);
        if (crankEventTime > lastCrankEventTime && crankRev > lastCrankRev) {
          rpm = 60 *
              (crankRev - lastCrankRev) /
              (crankEventTime - lastCrankEventTime);
          return rpm; // bonne nouvelle valeur
        } else if (crankEventTime == lastCrankEventTime) {
          return rpm = 0; // on detecte que le rpm n a pas change
        }
        return rpm; // on retourne la derniere valeur ajouter
      } else {
        return rpm; // rpm va être la même valeur qu'au dernier call
      }
    } else {
      return rpm; // rpm egale 0 (valeur pas encore charge)
    }
  }

  Widget _buildPopUp(BuildContext context) {
    return AlertDialog(
      title: Text("Select ${widget.boxTitle} device to read from"),
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rpmDevices
                  .map(
                    (d) => RaisedButton(
                      color: Color(Constants.blueButtonColor),
                      onPressed: () {
                        Navigator.pop(context);
                        _setListener(d);
                      },
                      child: Text(d.device.name,
                          style: TextStyle(color: Colors.white)),
                    ),
                  )
                  .toList()),
        ),
      ),
    );
  }

  /*Widget _test(BuildContext context) {
    return !isNotificationOn
        ? Material(
            color: Color(Constants.blueButtonColor),
            child: RaisedButton(
              elevation: 4,
              child: Text(
                "Pick Device",
                style: TextStyle(color: Colors.black),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => _buildPopUp(context));
              },
            ),
          )
        : _buildStream();
  }*/

  Widget _buildStructure(
      BuildContext context, List<DeviceCharacteristic> devices) {
    if (devices.length > 1) {
      return !isNotificationOn
          ? Material(
              color: Color(Constants.blueButtonColor),
              child: RaisedButton(
                child: Text(
                  "Pick Device",
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => _buildPopUp(context));
                },
              ),
            )
          : _buildStream();
    }
    if (devices.length == 1) {
      _setListener(devices[0]);
      return _buildStream();
    } else {
      return Text("");
    }
  }

  Widget _buildStream() {
    //_setListener(d);
    return StreamBuilder<List<int>>(
      stream: listStream,
      initialData: [],
      builder: (c, snapshot) {
        final value = snapshot.data;
        if (snapshot.connectionState == ConnectionState.active &&
            value.length != 0) {
          print(value.toString());
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
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isNotificationOn = false;
    isRpmDevicesEmpty = true;
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
              _buildStructure(context, rpmDevices)
            ],
          )),
    );
  }
}
