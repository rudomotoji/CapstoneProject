import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotiHelper {
  // static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  FlutterLocalNotificationsPlugin _plugin;
  var initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveNotificationSubject => BehaviorSubject<ReceiveNotification>();

  NotiHelper.init(){
    _plugin = FlutterLocalNotificationsPlugin();
    if(Platform.isIOS){
      requestIOSPermission();
    }
    initializePlatform();
  }

  requestIOSPermission(){
    _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>().requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  initializePlatform(){
    // var initSettingAndroid = AndroidInitializationSettings('app_notification_icon');
    var initSettingAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    var initSettingIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async{
        ReceiveNotification receiveNotification = ReceiveNotification(id: id, title: title, body: body, payload: payload);
        didReceiveNotificationSubject.add(receiveNotification);
      }
    );
    initSetting = InitializationSettings(android:initSettingAndroid,iOS:initSettingIOS);
  }

  setOnNotificationReceive(Function onNotificationReceive){
    didReceiveNotificationSubject.listen((nontification) {
      onNotificationReceive(nontification);
    });
  }

  setNotificationnOnClick(Function onNotificationOnClick) async{
    await _plugin.initialize(initSetting, onSelectNotification: (String payload) async {
      onNotificationOnClick(payload);
    });
  }

  Future<void> show(ReceiveNotification receiveNotification) async{
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      // priority: Priority.Height,
      playSound: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
    await _plugin.show(
        0,
      receiveNotification.title,
      receiveNotification.body,
      platformChannel,
      payload: receiveNotification.payload,
    );
  }

  // static Future<void> init(Function onDidReceiveLocalNotification,
  //     Function onSelectNotification) async {
  //   var initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
  //   var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  //   const MacOSInitializationSettings initializationSettingsMacOS =
  //   MacOSInitializationSettings(
  //       requestAlertPermission: false,
  //       requestBadgePermission: false,
  //       requestSoundPermission: false);
  //
  //   final InitializationSettings initializationSettings = InitializationSettings(
  //       android: initializationSettingsAndroid,
  //       iOS: initializationSettingsIOS,
  //       macOS: initializationSettingsMacOS);
  //   await _plugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
  // }
  //
  // static Future<void> show(
  //     {@required String title, @required String body, String payload}) {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       showWhen: false);
  //   const NotificationDetails platformChannelSpecifics =
  //   NotificationDetails(android: androidPlatformChannelSpecifics);
  //   return _plugin.show(0, title, body, platformChannelSpecifics, payload: payload);
  // }
}

NotiHelper localNotifyManager = NotiHelper.init();

class ReceiveNotification{
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