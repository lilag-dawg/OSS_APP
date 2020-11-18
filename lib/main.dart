import 'package:flutter/material.dart';
import 'package:oss_app/models/bluetoothDeviceManager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './models/routeGenerator.dart';
import './models/bluetoothDeviceManager.dart';

import './models/notificationHandler.dart';
import './generated/l10n.dart';

final NotificationHandler notificationHandler = NotificationHandler();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationHandler.settingsInitiation();
  notificationHandler.requestPermission();
  notificationHandler.notificationToggler();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BluetoothDeviceManager>(
          create: (context) => BluetoothDeviceManager(),
        ),
      ],
      child: MaterialApp(
        title: "OSS",
        initialRoute: "/",
        navigatorKey: navKey,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.generateRoute,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
