import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class NotiHelper {
  // static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  FlutterLocalNotificationsPlugin _plugin;
  var initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  NotiHelper.init() {
    _plugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }

  requestIOSPermission() {
    _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  initializePlatform() async {
    // var initSettingAndroid = AndroidInitializationSettings('app_notification_icon');
    var initSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initSettingIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceiveNotification receiveNotification = ReceiveNotification(
              id: id, title: title, body: body, payload: payload);
          didReceiveNotificationSubject.add(receiveNotification);
        });
    initSetting = InitializationSettings(
        android: initSettingAndroid, iOS: initSettingIOS);

    await _plugin.initialize(initSetting,
        onSelectNotification: selectNotification);
  }

  // setOnNotificationReceive(Function onNotificationReceive) {
  //   didReceiveNotificationSubject.listen((nontification) {
  //     onNotificationReceive(nontification);
  //   });
  // }

  // setNotificationnOnClick(Function onNotificationOnClick) async {
  //   await _plugin.initialize(initSetting,
  //       onSelectNotification: (String payload) async {
  //     onNotificationOnClick(payload);
  //   });
  // }
  //
  Future selectNotification(String payload) async {
    selectNotificationSubject.add(payload);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveNotificationSubject.listen((nontification) {
      onNotificationReceive(nontification);
    });
  }

  // setNotificationnOnClick(BehaviorSubject selectNotificationSubject) async {
  //   await _plugin.initialize(initSetting,
  //       onSelectNotification: (String payload) async {
  //     selectNotificationSubject.add(payload);
  //   });
  // }

  Future<void> show(ReceiveNotification receiveNotification) async {
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      // priority: Priority.Height,
      playSound: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await _plugin.show(
      0,
      receiveNotification.title,
      receiveNotification.body,
      platformChannel,
      payload: receiveNotification.payload,
    );
  }
}

NotiHelper localNotifyManager = NotiHelper.init();

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  ReceiveNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
