import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:oss_app/models/OSSDevice.dart';

import '../widgets/customTile.dart';
import '../models/deviceConnexionStatus.dart';
import '../models/bluetoothDeviceManager.dart';
import '../models/OSSDevice.dart';

import '../constants.dart' as Constants;
import '../generated/l10n.dart';

class FindDevicesScreen extends StatefulWidget {
  final BluetoothDeviceManager ossManager;
  FindDevicesScreen({Key key, @required this.ossManager}) : super(key: key);

  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen>
    with SingleTickerProviderStateMixin {
  List<BluetoothDevice> alreadyConnectedDevices = [];
  List<DeviceConnexionStatus> devicesConnexionStatus = [];
  StreamSubscription<List<ScanResult>> scanSubscription;
  bool isDoneScanning;

  //animation stuff
  Animation<double> animation;
  AnimationController controller;

  Future<void> performScan() async {
    scanSubscription = FlutterBlue.instance.scanResults.listen((scanResults) {
      for (ScanResult r in scanResults) {
        bool isDeviceAlreadyAdded =
            devicesConnexionStatus.any((d) => d.getDevice == r.device);
        if (!isDeviceAlreadyAdded && r.device.name.length != 0) { //added r.device.name.length != 0 to only add named device
          devicesConnexionStatus.add(DeviceConnexionStatus(
            device: r.device,
            connexionStatus: DeviceConnexionStatus.disconnected,
          ));
        }
      }
    });

    await getConnectedDevice().then((alreadyConnectedDevices) async {
      for (BluetoothDevice d in alreadyConnectedDevices) {
        bool isDeviceAlreadyAdded =
            devicesConnexionStatus.any((device) => device.getDevice == d);
        if (!isDeviceAlreadyAdded) {
          devicesConnexionStatus.add(DeviceConnexionStatus(
            device: d,
            connexionStatus: DeviceConnexionStatus.connected,
          ));
          await addOSSDevice(d);
        } else {
          int errorFromScanResult = devicesConnexionStatus
              .indexWhere((device) => device.getDevice == d);
          devicesConnexionStatus[errorFromScanResult].setConnexionStatus =
              DeviceConnexionStatus.connected;
        }
      }
    });
  }

  Future<List<BluetoothDevice>> getConnectedDevice() async {
    List<BluetoothDevice> devices = await FlutterBlue.instance.connectedDevices;
    return devices;
  }

  Future<void> addOSSDevice(BluetoothDevice device) async {
    await OSSDevice.create(device).then((createdOSSDevice) {
      widget.ossManager.setDevice(createdOSSDevice);
    });
  }

  Future<void> _handleOnpressChanged(
      DeviceConnexionStatus c, String currentStatus) async {
    final selectedDevice =
        devicesConnexionStatus.firstWhere((item) => item == c);
    if (currentStatus == DeviceConnexionStatus.connected) {
      await c.device
          .disconnect()
          .then((_) => currentStatus = DeviceConnexionStatus.disconnected);
      widget.ossManager.remove();
    } else {
      await c.device
          .connect()
          .then((value) async =>
              await addOSSDevice(c.device).then((value) async {
                currentStatus = DeviceConnexionStatus.connected;
                for (DeviceConnexionStatus dc in devicesConnexionStatus) {
                  if (dc.connexionStatus == DeviceConnexionStatus.connected &&
                      dc != c) {
                    await dc.device.disconnect().then((_) => dc
                        .connexionStatus = DeviceConnexionStatus.disconnected);
                  }
                }
              }))
          .timeout(Duration(seconds: 10), onTimeout: () {
        currentStatus = DeviceConnexionStatus.disconnected;
        return null; //on pourrait rajouter un snackbar pour montrer à l'utilisateur que le connexion avec l'appareil n'a pas pu être établie
      });
    }
    setState(() {
      selectedDevice.setConnexionStatus = currentStatus;
    });
  }

  void __handleTrailingPressed(BuildContext context) {
    Navigator.of(context).pushNamed(
      "/settings/manage/pairing",
    );
  }

  List<Widget> _buildCustomTiles(List<DeviceConnexionStatus> result) {
    return result
        .map(
          (d) => CustomTile(
            currentDevice: d,
            onTapTile: (String currentStatus) async {
              setState(() {
                d.setConnexionStatus = DeviceConnexionStatus.inTransistion;
              });
              await _handleOnpressChanged(d, currentStatus);
            },
            onTrailingPress: (BuildContext context) {
              __handleTrailingPressed(context);
            },
          ),
        )
        .toList();
  }

  Widget _buildScanningButton() {
    return StreamBuilder(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return Container(
              child: RaisedButton(
                child: Text(S.of(context).findDeviceScreenSearchLater),
                color: Colors.red,
                onPressed: () => FlutterBlue.instance.stopScan(),
              ),
            );
          } else {
            return RaisedButton(
                child: Text(S.of(context).findDeviceScreenLookingFor),
                onPressed: () {
                  controller.reset();
                  controller.forward();
                  setState(() {
                    isDoneScanning = false;
                  });
                  startAScan();
                });
          }
        });
  }

  Widget _buildAnimations() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Center(
            child: AnimatedLogo(
              animation: animation,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Text(S.of(context).findDeviceScreenCurrentlyLooking),
          ),
        ],
      ),
    );
  }

  void startAScan() {
    isDoneScanning = false;
    if (!Constants.isWorkingOnEmulator) {
      FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)).then((_) {
        setState(() {
          isDoneScanning = true;
        });
      });
      performScan();
    }
  }

  @override
  void initState() {
    startAScan();
    controller =
        AnimationController(duration: Duration(seconds: 4), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
    controller.forward();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    if (!Constants.isWorkingOnEmulator) {
      FlutterBlue.instance.stopScan();
      scanSubscription.cancel();
    }
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(Constants.backGroundBlue),
        appBar: AppBar(
          title: Text("Bluetooth Manager"),
          backgroundColor: Color(Constants.blueButtonColor),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            (isDoneScanning)
                ? Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Column(
                          children: _buildCustomTiles(devicesConnexionStatus),
                        ),
                      ),
                    ],
                  )
                : _buildAnimations(),
            (Constants.isWorkingOnEmulator)
                ? RaisedButton(
                    child: Text("Remettre à plus tard"),
                    color: Colors.red,
                    onPressed: () {})
                : _buildScanningButton(),
          ]),
    ));
  }
}

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);
  static final _animateRotate = Tween<double>(begin: -1, end: 2);
  static final _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  );

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Container(
        height: 200,
        color: Color(Constants.backGroundBlue),
        child: SlideTransition(
          position: _offsetAnimation.animate(animation),
          child: Transform.rotate(
            angle: _animateRotate.evaluate(animation),
            child: Image.asset("assets/oss_logo_blanc.png"),
          ),
        ),
      ),
    );
  }
}
