import 'dart:convert';
import 'dart:io';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/features/chat/chat.dart';
import 'package:capstone_home_doctor/features/contract/views/manage_contract_view.dart';
import 'package:capstone_home_doctor/features/contract/views/request_contract_view.dart';
import 'package:capstone_home_doctor/features/login/confirm_log_in_view.dart';
import 'package:capstone_home_doctor/features/login/log_in_view.dart';
import 'package:capstone_home_doctor/features/login/phone_auth.dart';
import 'package:capstone_home_doctor/features/peripheral/connect_peripheral_view.dart';
import 'package:capstone_home_doctor/features/peripheral/intro_connect_view.dart';
import 'package:capstone_home_doctor/features/peripheral/peripheral_service_view.dart';
import 'package:capstone_home_doctor/features/register/register_view.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'features/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: DefaultTheme.TRANSPARENT,
    systemNavigationBarColor: DefaultTheme.TRANSPARENT,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(HomeDoctor());
}

class HomeDoctor extends StatefulWidget {
  @override
  _HomeDoctorState createState() => _HomeDoctorState();
}

class _HomeDoctorState extends State<HomeDoctor> {
  //helper
  final AuthenticateHelper authenHelper = AuthenticateHelper();
  final PeripheralHelper peripheralHelper = PeripheralHelper();

  //
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String _token = 'Generate Token';
  Widget _startScreen = Scaffold(
    body: Container(),
  );

  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    Platform.isIOS
        ? _handleIOSGeneralMessage(message)
        : _handleGeneralMessage(message);
  }

  void _handleGeneralMessage(Map<String, dynamic> message) {
    String payload;
    ReceiveNotification receiveNotification;
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
    receiveNotification = ReceiveNotification(
        id: 0,
        title: notification["title"],
        body: notification["body"],
        payload: payload);
    localNotifyManager.show(receiveNotification);
  }

  void _handleIOSGeneralMessage(Map<String, dynamic> message) {
    String payload = jsonEncode(message);
    ReceiveNotification receiveNotification;

    final dynamic notification = message['aps']['alert'];

    receiveNotification = ReceiveNotification(
        id: 0,
        title: notification["title"],
        body: notification["body"],
        payload: payload);
    localNotifyManager.show(receiveNotification);
  }

  Future<void> _initialServiceHelper() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('AUTHENTICATION') ||
        prefs.getBool('AUTHENTICATION') == null) {
      authenHelper.innitalAuthen();
    }
    if (!prefs.containsKey('IS_PERIPHERALS_CONNECTED')) {
      peripheralHelper.initialPeripheralChecking();
    }
  }

  @override
  void initState() {
    super.initState();
    _initialServiceHelper();
    authenHelper.isAuthenticated().then((value) {
      print('value authen now ${value}');
      setState(() {
        if (value) {
          _startScreen = MainHome();
        } else {
          _startScreen = Login();
        }
      });
    });

    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true));
      _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        Platform.isIOS
            ? _handleIOSGeneralMessage(message)
            : _handleGeneralMessage(message);
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
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
    });
    // _fcm.subscribeToTopic("");

    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setNotificationnOnClick(onNotificationOnClick);
  }

  onNotificationReceive(ReceiveNotification notification) {
    print('Notification receive: ${notification.id}');
  }

  onNotificationOnClick(String payload) {
    print('Notification onclick: ${payload}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => PhoneAuthDataProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => RequestContractDTOProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // theme: ThemeData(fontFamily: 'SFPro'),
          initialRoute: RoutesHDr.INITIAL_ROUTE,
          routes: {
            RoutesHDr.LOG_IN: (context) => Login(),
            RoutesHDr.REGISTER: (context) => Register(),
            RoutesHDr.CONFIRM_LOG_IN: (context) => ConfirmLogin(),
            RoutesHDr.MAIN_HOME: (context) => MainHome(),
            RoutesHDr.CONFIRM_CONTRACT: (context) => RequestContract(),
            RoutesHDr.INTRO_CONNECT_PERIPHERAL: (context) =>
                IntroConnectDevice(),
            RoutesHDr.CONNECT_PERIPHERAL: (context) => ConnectPeripheral(),
            RoutesHDr.CHAT: (context) => ChatScreen(),
            RoutesHDr.MANAGE_CONTRACT: (context) => ManageContract(),
            RoutesHDr.PERIPHERAL_SERVICE: (context) => PeripheralService(),
          },
          // home: _startScreen,
          home: MainHome(),
        ),
      ),
    );
  }
}
