import 'dart:convert';
import 'dart:io';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/features/chat/chat.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_checking_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_full_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_id_now_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_list_bloc.dart';

import 'package:capstone_home_doctor/features/contract/blocs/contract_request_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_update_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/doctor_info_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/repositories/doctor_repository.dart';
import 'package:capstone_home_doctor/features/contract/views/contract_detail_status_view.dart';
import 'package:capstone_home_doctor/features/contract/views/contract_draft_view.dart';
import 'package:capstone_home_doctor/features/contract/views/contract_share_view.dart';
import 'package:capstone_home_doctor/features/contract/views/detail_contract_view.dart';
import 'package:capstone_home_doctor/features/contract/views/doctor_information_view.dart';
import 'package:capstone_home_doctor/features/contract/views/manage_contract_view.dart';
import 'package:capstone_home_doctor/features/contract/views/reason_contract_view.dart';
import 'package:capstone_home_doctor/features/contract/views/request_contract_view.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/health_record_create_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/health_record_detail_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/health_record_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_create_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_detail_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_type_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_with_type_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/views/create_health_record.dart';
import 'package:capstone_home_doctor/features/health/health_record/views/health_record_detail.dart';
import 'package:capstone_home_doctor/features/health/medical_share/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/health/medical_share/repositories/medical_share_repository.dart';
import 'package:capstone_home_doctor/features/health/medical_share/views/medical_share_view.dart';
import 'package:capstone_home_doctor/features/health/vitalsigns/view/heart/heart.dart';
import 'package:capstone_home_doctor/features/health/vitalsigns/views/oxy_chart_view.dart';
import 'package:capstone_home_doctor/features/information/blocs/patient_bloc.dart';
import 'package:capstone_home_doctor/features/information/repositories/patient_repository.dart';
import 'package:capstone_home_doctor/features/information/views/patient_info_views.dart';
import 'package:capstone_home_doctor/features/login/blocs/account_bloc.dart';
import 'package:capstone_home_doctor/features/login/blocs/token_device_bloc.dart';
import 'package:capstone_home_doctor/features/login/events/account_event.dart';
import 'package:capstone_home_doctor/features/login/repositories/account_repository.dart';
import 'package:capstone_home_doctor/features/login/states/account_state.dart';
import 'package:capstone_home_doctor/features/login/views/log_in_view.dart';
import 'package:capstone_home_doctor/features/medicine/views/medical_history_detail.dart';
import 'package:capstone_home_doctor/features/medicine/views/medicine_history_view.dart';
import 'package:capstone_home_doctor/features/notification/blocs/notification_list_bloc.dart';
import 'package:capstone_home_doctor/features/notification/repositories/notification_repository.dart';

import 'package:capstone_home_doctor/features/peripheral/views/connect_peripheral_view.dart';
import 'package:capstone_home_doctor/features/peripheral/views/intro_connect_view.dart';
import 'package:capstone_home_doctor/features/peripheral/views/peripheral_service_view.dart';

import 'package:capstone_home_doctor/features/register/register_view.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/prescription_list_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/prescription_repository.dart';
import 'package:capstone_home_doctor/features/schedule/views/schedule_medicine_noti_view.dart';
import 'package:capstone_home_doctor/features/schedule/views/schedule_view.dart';
import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/health_record_helper.dart';
import 'package:capstone_home_doctor/services/mobile_device_helper.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cron/cron.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/health/health_record/blocs/medical_scan_image_bloc.dart';
import 'features/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

final MORNING = 6;
final NOON = 11;
final AFTERNOON = 16;
final NIGHT = 21;
final MINUTES = 00;

//repo for blocs
HealthRecordRepository _healthRecordRepository =
    HealthRecordRepository(httpClient: http.Client());
PrescriptionRepository _prescriptionRepository =
    PrescriptionRepository(httpClient: http.Client());
MedicalInstructionRepository _medicalInstructionRepository =
    MedicalInstructionRepository(httpClient: http.Client());
ContractRepository _contractRepository =
    ContractRepository(httpClient: http.Client());
AccountRepository accountRepository =
    AccountRepository(httpClient: http.Client());
PatientRepository patientRepository =
    PatientRepository(httpClient: http.Client());
NotificationRepository notificationRepository =
    NotificationRepository(httpClient: http.Client());
DoctorRepository _doctorRepository =
    DoctorRepository(httpClient: http.Client());
MedicalShareInsRepository _medicalShareInsRepository =
    MedicalShareInsRepository(httpClient: http.Client());

//AccountBloc
// AccountBloc _accountBloc = AccountBloc(accountRepository: accountRepository);

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
  print(payload);
  final dynamic notification = message['aps']['alert'];

  receiveNotification = ReceiveNotification(
      id: 0,
      title: notification["title"],
      body: notification["body"],
      payload: payload);
  localNotifyManager.show(receiveNotification);
}

void checkNotifiMedical() async {
  SQFLiteHelper _sqLiteHelper = SQFLiteHelper();
  final hour = DateTime.now().hour;
  final minute = DateTime.now().minute;
  var body = "";

  if (hour == MORNING && minute == MINUTES) {
    await _sqLiteHelper.getAllBy('morning').then((value) {
      for (var schedule in value) {
        if (!body.contains(schedule.medicationName)) {
          body += schedule.medicationName + ', ';
        }
      }
    });
  }
  if (hour == NOON && minute == MINUTES) {
    await _sqLiteHelper.getAllBy('noon').then((value) {
      for (var schedule in value) {
        if (!body.contains(schedule.medicationName)) {
          body += schedule.medicationName + ', ';
        }
      }
    });
  }
  if (hour == AFTERNOON && minute == MINUTES) {
    await _sqLiteHelper.getAllBy('afterNoon').then((value) {
      for (var schedule in value) {
        if (!body.contains(schedule.medicationName)) {
          body += schedule.medicationName + ', ';
        }
      }
    });
  }
  if (hour == NIGHT && minute == MINUTES) {
    await _sqLiteHelper.getAllBy('night').then((value) {
      for (var schedule in value) {
        if (!body.contains(schedule.medicationName)) {
          body += schedule.medicationName + ', ';
        }
      }
    });
  }
  if ((hour == MORNING || hour == NOON || hour == AFTERNOON || hour == NIGHT) &&
      minute == MINUTES) {
    var message = {
      "notification": {"title": "Nhắc nhở uống thuốc", "body": body},
      "data": {
        "NAVIGATE_TO_SCREEN": RoutesHDr.SCHEDULE,
      }
    };
    _handleGeneralMessage(message);
  }
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
  final cron = Cron()
    ..schedule(Schedule.parse('* * * * * '), () {
      checkNotifiMedical();
    });
  runApp(HomeDoctor());
}

class HomeDoctor extends StatefulWidget {
  @override
  _HomeDoctorState createState() => _HomeDoctorState();
}

class _HomeDoctorState extends State<HomeDoctor> {
  //

  //helper
  final AuthenticateHelper authenHelper = AuthenticateHelper();
  final PeripheralHelper peripheralHelper = PeripheralHelper();
  final HealthRecordHelper hrHelper = HealthRecordHelper();
  final MobileDeviceHelper mobileDeviceHelper = MobileDeviceHelper();
  //
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String _token = '';
  String mobileDevice = '';
  Widget _startScreen = Scaffold(
    body: Container(),
  );

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
    if (!prefs.containsKey('TOKEN_DEVICE')) {
      mobileDeviceHelper.initialTokenDevice();
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
          // _startScreen = ContractStatusDetail();
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
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _fcm.getToken().then((String token) {
      assert(token != null);
      setState(() {
        print('TOKEN IN DEVICE $token');
        _token = '$token';
        if (_token != '') {
          mobileDeviceHelper.updatelTokenDevice(_token);
          mobileDeviceHelper.getTokenDevice().then((value) {
            mobileDevice = value;
          });
        }
      });
      //
    });
    // _fcm.subscribeToTopic("");

    // localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setNotificationnOnClick(selectNotificationSubject);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<RequestContractBloc>(
            create: (BuildContext context) =>
                RequestContractBloc(requestContractAPI: _contractRepository),
          ),
          BlocProvider<HealthRecordListBloc>(
            create: (BuildContext context) => HealthRecordListBloc(
                healthRecordRepository: _healthRecordRepository),
          ),
          BlocProvider<HealthRecordCreateBloc>(
            create: (BuildContext context) => HealthRecordCreateBloc(
                healthRecordRepository: _healthRecordRepository),
          ),
          BlocProvider<PrescriptionListBloc>(
              create: (BuildContext context) => PrescriptionListBloc(
                  prescriptionRepository: _prescriptionRepository)),
          BlocProvider<MedInsWithTypeListBloc>(
              create: (BuildContext context) => MedInsWithTypeListBloc(
                  medicalInstructionRepository: _medicalInstructionRepository)),
          BlocProvider<HealthRecordDetailBloc>(
            create: (BuildContext context) => HealthRecordDetailBloc(
                healthRecordRepository: _healthRecordRepository),
          ),
          BlocProvider<AccountBloc>(
            create: (BuildContext context) =>
                AccountBloc(accountRepository: accountRepository),
          ),
          BlocProvider<PatientBloc>(
            create: (BuildContext context) =>
                PatientBloc(patientRepository: patientRepository),
          ),
          BlocProvider<MedicalInstructionListBloc>(
            create: (BuildContext context) => MedicalInstructionListBloc(
                medicalInstructionRepository: _medicalInstructionRepository),
          ),
          BlocProvider<MedInsTypeListBloc>(
            create: (BuildContext context) => MedInsTypeListBloc(
                medicalInstructionRepository: _medicalInstructionRepository),
          ),
          BlocProvider<MedInsCreateBloc>(
            create: (BuildContext context) => MedInsCreateBloc(
                medicalInstructionRepository: _medicalInstructionRepository),
          ),
          BlocProvider<NotificationListBloc>(
            create: (BuildContext context) => NotificationListBloc(
                notificationRepository: notificationRepository),
          ),
          BlocProvider<MedInsScanTextBloc>(
            create: (BuildContext context) => MedInsScanTextBloc(
                medicalInstructionRepository: _medicalInstructionRepository),
          ),
          BlocProvider<MedicalInstructionDetailBloc>(
            create: (BuildContext context) => MedicalInstructionDetailBloc(
                medicalInstructionRepository: _medicalInstructionRepository),
          ),
          BlocProvider<ContractIdNowBloc>(
            create: (BuildContext context) =>
                ContractIdNowBloc(contractRepository: _contractRepository),
          ),
          BlocProvider<ContractFullBloc>(
            create: (BuildContext context) =>
                ContractFullBloc(contractRepository: _contractRepository),
          ),
          BlocProvider<ContractUpdateBloc>(
            create: (BuildContext context) =>
                ContractUpdateBloc(contractRepository: _contractRepository),
          ),
          BlocProvider<ContractListBloc>(
            create: (BuildContext context) =>
                ContractListBloc(contractAPI: _contractRepository),
          ),
          BlocProvider<DoctorInfoBloc>(
            create: (BuildContext context) =>
                DoctorInfoBloc(doctorAPI: _doctorRepository),
          ),
          BlocProvider<MedicalShareBloc>(
            create: (BuildContext context) => MedicalShareBloc(
                healthRecordRepository: _healthRecordRepository),
          ),
          BlocProvider<TokenDeviceBloc>(
            create: (BuildContext context) =>
                TokenDeviceBloc(accountRepository: accountRepository),
          ),
          BlocProvider<CheckingContractBloc>(
            create: (BuildContext context) =>
                CheckingContractBloc(requestContractAPI: _contractRepository),
          ),
          BlocProvider<MedicalShareInsBloc>(
            create: (BuildContext context) => MedicalShareInsBloc(
                medicalShareInsRepository: _medicalShareInsRepository),
          ),
        ],
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: MultiProvider(
            providers: [
              // ChangeNotifierProvider(
              //   create: (context) => PhoneAuthDataProvider(),
              // ),
              ChangeNotifierProvider(
                create: (context) => RequestContractDTOProvider(),
              ),
              // ChangeNotifierProvider(
              //   create: (context) => RContractProvider(),
              // )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              // theme: ThemeData(fontFamily: 'SFPro'),
              initialRoute: RoutesHDr.INITIAL_ROUTE,
              routes: {
                RoutesHDr.LOG_IN: (context) => Login(),
                RoutesHDr.REGISTER: (context) => Register(),
                // RoutesHDr.CONFIRM_LOG_IN: (context) => ConfirmLogin(),
                RoutesHDr.MAIN_HOME: (context) => MainHome(),
                // RoutesHDr.CONFIRM_CONTRACT: (context) => RequestContract(),
                RoutesHDr.INTRO_CONNECT_PERIPHERAL: (context) =>
                    IntroConnectDevice(),
                RoutesHDr.CONNECT_PERIPHERAL: (context) => ConnectPeripheral(),
                RoutesHDr.CHAT: (context) => ChatScreen(),
                RoutesHDr.MANAGE_CONTRACT: (context) => ManageContract(),
                RoutesHDr.PERIPHERAL_SERVICE: (context) => PeripheralService(),
                // RoutesHDr.CONFIRM_CONTRACT_VIEW: (context) => ConfirmContract(),
                RoutesHDr.SCHEDULE: (context) => ScheduleView(),
                RoutesHDr.HISTORY_PRESCRIPTION: (context) => MedicineHistory(),
                RoutesHDr.PATIENT_INFORMATION: (context) =>
                    PatientInformation(),
                RoutesHDr.CONTRACT_REASON_VIEW: (context) =>
                    ReasonContractView(),
                RoutesHDr.CREATE_HEALTH_RECORD: (context) =>
                    CreateHealthRecord(_doNothing()),
                RoutesHDr.HEALTH_RECORD_DETAIL: (context) =>
                    HealthRecordDetail(),
                RoutesHDr.HEART: (context) => Heart(),
                RoutesHDr.MEDICINE_NOTI_VIEW: (context) =>
                    ScheduleMedNotiView(),
                RoutesHDr.OXY_CHART_VIEW: (context) => OxyChartView(),
                RoutesHDr.MEDICAL_SHARE: (context) => MedicalShare(),
                RoutesHDr.CONTRACT_DETAIL_STATUS: (context) =>
                    ContractStatusDetail(),
                RoutesHDr.DETAIL_CONTRACT_VIEW: (context) =>
                    DetailContractView(),
                RoutesHDr.DOCTOR_INFORMATION: (context) => DoctorInformation(),
                RoutesHDr.CONTRACT_SHARE_VIEW: (context) => ContractShareView(),

                RoutesHDr.CONTRACT_DRAFT_VIEW: (context) => ContractDraftView(),

                RoutesHDr.MEDICAL_HISTORY_DETAIL: (context) =>
                    MedicalHistoryDetailView(),
              },
              home: _startScreen,
            ),
            // child: RepositoryProvider.value(
            //   value: accountRepository,
            //   child: BlocProvider(
            //     create: (_) => AccountBloc(accountRepository: accountRepository)
            //       ..add(AccountEventStartScreen()),
            //     child: StartingHDr(),
            //   ),
            // ),
          ),
        ));
  }

  _doNothing() {
    //
  }
}

// class StartingHDr extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _StartingHDr();
//   }
// }

// class _StartingHDr extends State<StartingHDr> with WidgetsBindingObserver {
//   final _navigatorKey = GlobalKey<NavigatorState>();
//   NavigatorState get _navigator => _navigatorKey.currentState;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // theme: ThemeData(fontFamily: 'SFPro'),
//       initialRoute: RoutesHDr.INITIAL_ROUTE,
//       routes: {
//         RoutesHDr.LOG_IN: (context) => Login(),
//         RoutesHDr.REGISTER: (context) => Register(),
//         // RoutesHDr.CONFIRM_LOG_IN: (context) => ConfirmLogin(),
//         RoutesHDr.MAIN_HOME: (context) => MainHome(),
//         RoutesHDr.CONFIRM_CONTRACT: (context) => RequestContract(),
//         RoutesHDr.INTRO_CONNECT_PERIPHERAL: (context) => IntroConnectDevice(),
//         RoutesHDr.CONNECT_PERIPHERAL: (context) => ConnectPeripheral(),
//         RoutesHDr.CHAT: (context) => ChatScreen(),
//         RoutesHDr.MANAGE_CONTRACT: (context) => ManageContract(),
//         RoutesHDr.PERIPHERAL_SERVICE: (context) => PeripheralService(),
//         RoutesHDr.CONFIRM_CONTRACT_VIEW: (context) => ConfirmContract(),
//         RoutesHDr.SCHEDULE: (context) => ScheduleView(),
//         RoutesHDr.HISTORY_PRESCRIPTION: (context) => MedicineHistory(),
//         RoutesHDr.PATIENT_INFORMATION: (context) => PatientInformation(),
//         //RoutesHDr.CREATE_HEALTH_RECORD: (context) => CreateHealthRecord(),
//         RoutesHDr.HEALTH_RECORD_DETAIL: (context) => HealthRecordDetail(),
//         RoutesHDr.HEART: (context) => Heart(),
//         RoutesHDr.MEDICINE_NOTI_VIEW: (context) => ScheduleMedNotiView(),
//         RoutesHDr.OXY_CHART_VIEW: (context) => OxyChartView(),
//         RoutesHDr.MEDICAL_SHARE: (context) => MedicalShare(),
//       },
//       navigatorKey: _navigatorKey,
//       builder: (context, child) {
//         //
//         return BlocListener(
//           listener: (context, state) {
//             if (state is AccountStateUnauthenticate) {
//               _navigator.pushAndRemoveUntil<void>(
//                 Login.route(),
//                 (route) => false,
//               );
//             }
//             if (state is AccountStateAuthenticated) {
//               _navigator.pushAndRemoveUntil<void>(
//                 Login.route(),
//                 (route) => false,
//               );
//             }
//           },
//           child: child,
//         );
//       },
//     );
//   }
// }
