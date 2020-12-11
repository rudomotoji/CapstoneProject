import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'Item.dart';
import 'common/constant/evn.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'services/noti_helper.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

final Map<String, Item> _items = <String, Item>{};
Item _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
  final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))
    ..status = data['status'];
  return item;
}

void main() {
  runApp(MyApp(env: EnvValue.development));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Env env;

  MyApp({Key key, @required this.env}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String _token = 'Generate Token';

  // Widget _buildDialog(BuildContext context, Item item) {
  //   return AlertDialog(
  //     content: Text("Item ${item.itemId} has been updated"),
  //     actions: <Widget>[
  //       FlatButton(
  //         child: const Text('CLOSE'),
  //         onPressed: () {
  //           Navigator.pop(context, false);
  //         },
  //       ),
  //       FlatButton(
  //         child: const Text('SHOW'),
  //         onPressed: () {
  //           Navigator.pop(context, true);
  //         },
  //       ),
  //     ],
  //   );
  // }

  void _handleGeneralMessage(Map<String, dynamic> message) {
    String payload;
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      payload = jsonEncode(data);
    }
    final dynamic notification = message['notification'];
    // NotiHelper.show(
    //     title: notification["title"],
    //     body: notification["body"],
    //     payload: payload);
  }

  void _handleIOSGeneralMessage(Map<String, dynamic> message) {
    String payload = jsonEncode(message);

    final dynamic notification = message['aps']['alert'];
    // NotiHelper.show(
    //     title: notification["title"],
    //     body: notification["body"],
    //     payload: payload);
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true));
      _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
        Platform.isIOS
            ? _handleIOSGeneralMessage(message)
            : _handleGeneralMessage(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
      },
    );
    _fcm.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _token = '$token';
      });
      print('acctoken: $token');
    });
    // _fcm.subscribeToTopic("");

    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setNotificationnOnClick(onNotificationOnClick);
  }

  onNotificationReceive(ReceiveNotification notification){
print('Notification receive: ${notification.id}');
  }

  onNotificationOnClick(String payload){
    print('Notification onclick: ${payload}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text('$_token'),
              RaisedButton(
                onPressed: ()=>{
                  localNotifyManager.show()
                },
                child: Text('push'),
              )
            ],
          )
        ),
      ),
    );
  }
}
