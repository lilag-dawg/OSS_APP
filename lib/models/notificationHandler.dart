import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../constants.dart' as constants;
import '../generated/l10n.dart';

class NotificationHandler {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    /*
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.of(context).pushNamed(
                "/preference",
              );
            },
          )
        ],
      ),
    );*/
  } //This is an iOS-related function, does not work live and can't debug

  Future<void> _onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await MyApp.navKey.currentState.pushNamed("/preference");
  }

  void settingsInitiation() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('bike_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  void requestPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /*void showATestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('notSetting')) {
      await flutterLocalNotificationsPlugin.show(0, 'OSS Quick Profile Change',
          'Click here to change your profile', platformChannelSpecifics);
    }
  }*/

  void notificationToggler() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(constants.notKey) ?? false) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
              'profileChangeChannel',
              'OSS Profile Change Channel',
              'This channel is used to give a direct link to the profile change channel',
              importance: Importance.none,
              priority: Priority.min,
              showWhen: false,
              enableVibration: false);
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.periodicallyShow(
          0,
          S.current.notificationTitle,
          S.current.notificationInfo,
          RepeatInterval.everyMinute,
          platformChannelSpecifics,
          androidAllowWhileIdle: true);
    } else {
      await flutterLocalNotificationsPlugin.cancel(0);
    }
  }
}

class NotDialog extends StatefulWidget {
  @override
  NotDialogState createState() => NotDialogState();
}

class NotDialogState extends State<NotDialog> {
  bool notSetting;
  final NotificationHandler notificationHandler = NotificationHandler();

  Future _setSavedSetting(bool setting) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(constants.notKey)) {
      prefs.setBool(constants.notKey, setting);
    } else {
      prefs.setBool(constants.notKey, false);
    }

    notificationHandler.notificationToggler();

    MyApp.navKey.currentState.pop();
  }

  Future _getSavedSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(constants.notKey) ?? false;

    setState(() {
      notSetting = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _getSavedSetting();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).notificationSettingDialogTitle),
      content: Container(
        alignment: Alignment.center,
        width: constants.getAppWidth() * 0.6,
        height: constants.getAppHeight() * 0.01,
        child: Switch(
          value: notSetting,
          onChanged: (value) {
            setState(
              () {
                notSetting = value;
              },
            );
          },
        ),
      ),
      actions: [
        FlatButton(
          child: new Text(S.of(context).dialogSave),
          color: Color(constants.blueButtonColor),
          onPressed: () async {
            await _setSavedSetting(notSetting);
          },
        ),
      ],
    );
  }
}
