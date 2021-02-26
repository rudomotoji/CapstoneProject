import 'dart:convert';
import 'dart:io';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/features/chat/chat.dart';
import 'package:capstone_home_doctor/features/contract/views/confirm_contract_view.dart';
import 'package:capstone_home_doctor/features/contract/views/manage_contract_view.dart';
import 'package:capstone_home_doctor/features/contract/views/request_contract_view.dart';
import 'package:capstone_home_doctor/features/health/health_record/views/create_health_record.dart';
import 'package:capstone_home_doctor/features/health/health_record/views/health_record_detail.dart';
import 'package:capstone_home_doctor/features/information/views/patient_info_views.dart';
import 'package:capstone_home_doctor/features/login/confirm_log_in_view.dart';
import 'package:capstone_home_doctor/features/login/log_in_view.dart';
import 'package:capstone_home_doctor/features/login/phone_auth.dart';
import 'package:capstone_home_doctor/features/medicine/views/medicine_history_view.dart';
import 'package:capstone_home_doctor/features/peripheral/connect_peripheral_view.dart';
import 'package:capstone_home_doctor/features/peripheral/intro_connect_view.dart';
import 'package:capstone_home_doctor/features/peripheral/peripheral_service_view.dart';
import 'package:capstone_home_doctor/features/register/register_view.dart';
import 'package:capstone_home_doctor/features/schedule/views/schedule_medicine_noti_view.dart';
import 'package:capstone_home_doctor/features/schedule/views/schedule_view.dart';
import 'package:capstone_home_doctor/models/medicine_scheduling_dto.dart';
import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/health_record_helper.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:cron/cron.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:provider/provider.dart';

final MORNING = 6;
final NOON = 11;
final AFTERNOON = 14;
final EVERNING = 18;

final List<PrescriptionDTO> _listPrescription = [
  PrescriptionDTO(
    diagnose: 'Đau đầu, tim đập nhanh, khó thở',
    healthRecordId: '1',
    startDate: '2021-02-24',
    endDate: '2021-03-03',
    listMedicine: _listMedicine1,
  ),
  PrescriptionDTO(
    diagnose: 'Đau đầu, tim đập nhanh, khó thở',
    healthRecordId: '1',
    startDate: '2021-02-16',
    endDate: '2021-02-23',
    listMedicine: _listMedicine2,
  ),
  PrescriptionDTO(
    diagnose: 'Đau đầu, tim đập nhanh, khó thở',
    healthRecordId: '1',
    startDate: '2021-02-08',
    endDate: '2021-03-15',
    listMedicine: _listMedicine3,
  ),
];

final List<MedicineDTO> _listMedicine1 = [
  MedicineDTO(
    medicationName: 'Cefadroxil',
    content: '10 mg',
    description: 'mô tả số 1. Mô tả số 1. Mô tả số 1.',
    afternoon: 0,
    morning: 2,
    night: 2,
    noon: 2,
    unit: 'viên',
    useTime: 'Trước bữa ăn',
  ),
  MedicineDTO(
    medicationName: 'Medicine2',
    content: '20 mg',
    description: 'mô tả số 12. Mô tả số 2. Mô tả số 2.',
    afternoon: 0,
    morning: 4,
    night: 4,
    noon: 2,
    unit: 'viên',
    useTime: 'Sau bữa ăn',
  ),
  MedicineDTO(
    medicationName: 'Medicine3',
    content: '24 mg',
    description: 'mô tả số 4. Mô tả số 3. Mô tả số 3.',
    afternoon: 0,
    morning: 2,
    night: 2,
    noon: 0,
    unit: 'viên',
    useTime: 'Sau bữa ăn',
  ),
  MedicineDTO(
    medicationName: 'Medicine4',
    content: '10 mg',
    description: 'mô tả số 4. Mô tả số 4. Mô tả số 4.',
    afternoon: 0,
    morning: 2,
    night: 2,
    noon: 2,
    unit: 'viên',
    useTime: 'Trước bữa ăn',
  ),
  MedicineDTO(
    medicationName: 'Medicine5',
    content: '10 mg',
    description: 'mô tả số 5. Mô tả số 4. Mô tả số 5.',
    afternoon: 0,
    morning: 4,
    night: 0,
    noon: 2,
    unit: 'viên',
    useTime: 'Trước bữa ăn',
  ),
];
final List<MedicineDTO> _listMedicine2 = [
  MedicineDTO(
    medicationName: 'Cefadroxil222',
    content: '10 mg',
    description: 'mô tả số 1. Mô tả số 1. Mô tả số 1.',
    afternoon: 0,
    morning: 2,
    night: 2,
    noon: 2,
    unit: 'viên',
    useTime: 'Trước bữa ăn',
  ),
  MedicineDTO(
    medicationName: 'Medicine233',
    content: '20 mg',
    description: 'mô tả số 12. Mô tả số 2. Mô tả số 2.',
    afternoon: 0,
    morning: 4,
    night: 4,
    noon: 2,
    unit: 'viên',
    useTime: 'Sau bữa ăn',
  ),
  MedicineDTO(
    medicationName: 'Medicine344',
    content: '10 mg',
    description: 'mô tả số 4. Mô tả số 3. Mô tả số 3.',
    afternoon: 0,
    morning: 2,
    night: 2,
    noon: 0,
    unit: 'viên',
    useTime: 'Sau bữa ăn',
  ),
  MedicineDTO(
    medicationName: 'Medicine455',
    content: '10 mg',
    description: 'mô tả số 4. Mô tả số 4. Mô tả số 4.',
    afternoon: 0,
    morning: 2,
    night: 2,
    noon: 2,
    unit: 'viên',
    useTime: 'Trước bữa ăn',
  ),
  MedicineDTO(
    medicationName: 'Medicine566',
    content: '40 mg',
    description: 'mô tả số 5. Mô tả số 4. Mô tả số 5.',
    afternoon: 0,
    morning: 4,
    night: 0,
    noon: 2,
    unit: 'viên',
    useTime: 'Trước bữa ăn',
  ),
];
final List<MedicineDTO> _listMedicine3 = [
  MedicineDTO(
    medicationName: 'Cefadroxil666',
    content: '30 mg',
    description: 'mô tả số 1. Mô tả số 1. Mô tả số 1.',
    afternoon: 0,
    morning: 2,
    night: 2,
    noon: 2,
    unit: 'viên',
    useTime: 'Trước bữa ăn',
  ),
  MedicineDTO(
    medicationName: 'Medicine2666',
    content: '20 mg',
    description: 'mô tả số 12. Mô tả số 2. Mô tả số 2.',
    afternoon: 0,
    morning: 4,
    night: 4,
    noon: 2,
    unit: 'viên',
    useTime: 'Sau bữa ăn',
  ),
  MedicineDTO(
    medicationName: 'Medicine344',
    content: '10 mg',
    description: 'mô tả số 4. Mô tả số 3. Mô tả số 3.',
    afternoon: 0,
    morning: 2,
    night: 2,
    noon: 0,
    unit: 'viên',
    useTime: 'Sau bữa ăn',
  ),
  MedicineDTO(
    medicationName: 'Medicine456',
    content: '30 mg',
    description: 'mô tả số 4. Mô tả số 4. Mô tả số 4.',
    afternoon: 0,
    morning: 2,
    night: 2,
    noon: 2,
    unit: 'viên',
    useTime: 'Trước bữa ăn',
  ),
  MedicineDTO(
    medicationName: 'Medicine5523',
    content: '20 mg',
    description: 'mô tả số 5. Mô tả số 4. Mô tả số 5.',
    afternoon: 0,
    morning: 4,
    night: 0,
    noon: 2,
    unit: 'viên',
    useTime: 'Trước bữa ăn',
  ),
];
PrescriptionDTO _currentPrescription = PrescriptionDTO();
//this is the name given to the background fetch
const simpleTaskKey = "simpleTask";
const simpleDelayedTask = "simpleDelayedTask";
const simplePeriodicTask = "simplePeriodicTask";
const simplePeriodic1HourTask = "simplePeriodic1HourTask";

void _handleGeneralMessage(Map<String, dynamic> message) {
  String payload;
  ReceiveNotification receiveNotification;
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
    payload = jsonEncode(data);
  }
  final dynamic notification = message['notification'];
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

void checkNotifiMedical() {
  final hour = DateTime.now().hour;
  final minute = DateTime.now().minute;
  _listPrescription.sort((a, b) => b.startDate.compareTo(a.startDate));
  _currentPrescription = _listPrescription[0];
  if ((hour == MORNING || hour == NOON || hour == AFTERNOON) && minute == 02) {
    var message = {
      "notification": {
        "title": "Nhắc nhở uống thuốc",
        "body":
            "${_listMedicine1[0].medicationName}, ${_listMedicine1[1].medicationName}, ${_listMedicine1[2].medicationName}, ${_listMedicine1[3].medicationName}, ${_listMedicine1[4].medicationName}"
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "screen": "screenA",
        "message": "ACTION"
      }
    };
    _handleGeneralMessage(message);
  }
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    switch (task) {
      case simpleTaskKey:
        break;
      case simpleDelayedTask:
        break;
      case simplePeriodicTask:
        break;
      case simplePeriodic1HourTask:
        break;
      case Workmanager.iOSBackgroundTask:
        break;
    }
    checkNotifiMedical();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: DefaultTheme.TRANSPARENT,
    systemNavigationBarColor: DefaultTheme.TRANSPARENT,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  if (Platform.isAndroid) {
    await Workmanager.initialize(callbackDispatcher,
        isInDebugMode:
            true); //to true if still in testing lev turn it to false whenever you are launching the app
    await Workmanager.registerPeriodicTask(
      "5", simplePeriodicTask,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(minutes: 15), //when should it check the link
      initialDelay:
          Duration(seconds: 5), //duration before showing the notification
      // constraints: Constraints(
      //   networkType: NetworkType.connected,
      // ),
    );
  }
  if (Platform.isIOS) {
    final cron = Cron()
      ..schedule(Schedule.parse('* * * * * '), () {
        checkNotifiMedical();
        print(DateTime.now());
      });
  }
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
  final HealthRecordHelper hrHelper = HealthRecordHelper();

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

  Future<void> _initialServiceHelper() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('AUTHENTICATION') ||
        prefs.getBool('AUTHENTICATION') == null) {
      authenHelper.innitalAuthen();
    }
    if (!prefs.containsKey('IS_PERIPHERALS_CONNECTED')) {
      peripheralHelper.initialPeripheralChecking();
    }
    if (!prefs.containsKey('HEALTH_RECORD_ID')) {
      hrHelper.initialHRId();
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      final int helloAlarmID = 0;
      AndroidAlarmManager.initialize();
      AndroidAlarmManager.periodic(
        const Duration(minutes: 1),
        helloAlarmID,
        checkNotifiMedical,
        wakeup: true,
      );
    }
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
    //
  }

  onNotificationOnClick(String payload) {
    print('Notification onclick: ${payload}');
    Navigator.pushNamed(context, RoutesHDr.MEDICINE_NOTI_VIEW);
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
          ChangeNotifierProvider(
            create: (context) => RContractProvider(),
          )
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
            RoutesHDr.CONFIRM_CONTRACT_VIEW: (context) => ConfirmContract(),
            RoutesHDr.SCHEDULE: (context) => ScheduleView(),
            RoutesHDr.HISTORY_PRESCRIPTION: (context) => MedicineHistory(),
            RoutesHDr.PATIENT_INFORMATION: (context) => PatientInformation(),
            //RoutesHDr.CREATE_HEALTH_RECORD: (context) => CreateHealthRecord(),
            RoutesHDr.HEALTH_RECORD_DETAIL: (context) => HealthRecordDetail(),
            RoutesHDr.MEDICINE_NOTI_VIEW: (context) => ScheduleMedNotiView(),
          },
          // home: _startScreen,
          home: MainHome(),
        ),
      ),
    );
  }
}
