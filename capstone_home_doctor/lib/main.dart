import 'dart:convert';
import 'dart:io';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/features/background/repositories/background_repository.dart';
import 'package:capstone_home_doctor/features/chat/chat.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_checking_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_full_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_id_now_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_list_bloc.dart';

import 'package:capstone_home_doctor/features/contract/blocs/contract_request_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_update_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/disease_list_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/doctor_info_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/repositories/disease_repository.dart';
import 'package:capstone_home_doctor/features/contract/repositories/doctor_repository.dart';
import 'package:capstone_home_doctor/features/contract/views/contract_detail_status_view.dart';
import 'package:capstone_home_doctor/features/contract/views/contract_draft_view.dart';
import 'package:capstone_home_doctor/features/contract/views/contract_share_view.dart';
import 'package:capstone_home_doctor/features/contract/views/detail_contract_view.dart';
import 'package:capstone_home_doctor/features/contract/views/doctor_information_view.dart';
import 'package:capstone_home_doctor/features/contract/views/manage_contract_view.dart';
import 'package:capstone_home_doctor/features/contract/views/reason_contract_view.dart';

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
import 'package:capstone_home_doctor/features/health/health_record/views/create_medical_instruction.dart';
import 'package:capstone_home_doctor/features/health/health_record/views/health_record_detail.dart';
import 'package:capstone_home_doctor/features/health/medical_share/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/health/medical_share/repositories/medical_share_repository.dart';
import 'package:capstone_home_doctor/features/health/medical_share/views/medical_share_view.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_repository.dart';
import 'package:capstone_home_doctor/features/vital_sign/views/heart_detail_view.dart';
import 'package:capstone_home_doctor/features/vital_sign/views/history_vital_sign.dart';
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
import 'package:capstone_home_doctor/features/peripheral/blocs/peripheral_bloc.dart';
import 'package:capstone_home_doctor/features/peripheral/events/peripheral_event.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repository.dart';

import 'package:capstone_home_doctor/features/peripheral/views/connect_peripheral_view.dart';
import 'package:capstone_home_doctor/features/peripheral/views/intro_connect_view.dart';
import 'package:capstone_home_doctor/features/peripheral/views/peripheral_service_view.dart';

import 'package:capstone_home_doctor/features/register/register_view.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/appointment_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/prescription_list_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/appointment_repository.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/prescription_repository.dart';
import 'package:capstone_home_doctor/features/schedule/views/schedule_medicine_noti_view.dart';
import 'package:capstone_home_doctor/features/schedule/views/schedule_view.dart';
import 'package:capstone_home_doctor/features/vital_sign/views/pressure_detail_view.dart';
import 'package:capstone_home_doctor/features/vital_sign/views/vital_sign_schedule_view.dart';
import 'package:capstone_home_doctor/models/notification_dto.dart';
import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:capstone_home_doctor/models/setting_background_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_schedule_dto.dart';
import 'package:capstone_home_doctor/services/appointment_helper.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:capstone_home_doctor/services/health_record_helper.dart';
import 'package:capstone_home_doctor/services/medical_instruction_helper.dart';
import 'package:capstone_home_doctor/services/medical_share_helper.dart';
import 'package:capstone_home_doctor/services/mobile_device_helper.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:capstone_home_doctor/services/vital_sign_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cron/cron.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:uuid/uuid.dart';
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

//helper
final AuthenticateHelper authenHelper = AuthenticateHelper();
final PeripheralHelper peripheralHelper = PeripheralHelper();
final HealthRecordHelper hrHelper = HealthRecordHelper();
final MobileDeviceHelper mobileDeviceHelper = MobileDeviceHelper();
final ContractHelper contractHelper = ContractHelper();
final MedicalShareHelper _medicalShareHelper = MedicalShareHelper();
final VitalSignHelper _vitalSignHelper = VitalSignHelper();
final AppointmentHelper _appointmentHelper = AppointmentHelper();
final MedicalInstructionHelper _medicalInstructionHelper =
    MedicalInstructionHelper();
//
/////////////////////
final PeripheralHelper _peripheralHelper = PeripheralHelper();
final VitalSignHelper vitalSignHelper = VitalSignHelper();
final BackgroundRepository _backgroundRepository =
    BackgroundRepository(httpClient: http.Client());
final VitalSignServerRepository _vitalSignServerRepository =
    VitalSignServerRepository(httpClient: http.Client());

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
DiseaseRepository _diseaseRepository =
    DiseaseRepository(httpClient: http.Client());
AppointmentRepository _appointmentRepository =
    AppointmentRepository(httpClient: http.Client());
SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
PeripheralRepository _peripheralRepository = PeripheralRepository();
VitalSignRepository _vitalSignRepository = VitalSignRepository();

//AccountBloc
// AccountBloc _accountBloc = AccountBloc(accountRepository: accountRepository);
//
VitalSignScheduleDTO _vitalSignScheduleDTO = VitalSignScheduleDTO();

void _handleGeneralMessage(Map<String, dynamic> message) {
  print('message android: $message');
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
  print('payload ios: $payload');
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
          if (value.length == 1) {
            body = schedule.medicationName;
          }
        }
      }
    });
  }
  if (hour == NOON && minute == MINUTES) {
    await _sqLiteHelper.getAllBy('noon').then((value) {
      for (var schedule in value) {
        if (!body.contains(schedule.medicationName)) {
          body += schedule.medicationName + ', ';
          if (value.length == 1) {
            body = schedule.medicationName;
          }
        }
      }
    });
  }
  if (hour == AFTERNOON && minute == MINUTES) {
    await _sqLiteHelper.getAllBy('afterNoon').then((value) {
      for (var schedule in value) {
        if (!body.contains(schedule.medicationName)) {
          body += schedule.medicationName + ', ';
          if (value.length == 1) {
            body = schedule.medicationName;
          }
        }
      }
    });
  }
  if (hour == NIGHT && minute == MINUTES) {
    await _sqLiteHelper.getAllBy('night').then((value) {
      for (var schedule in value) {
        if (!body.contains(schedule.medicationName)) {
          body += schedule.medicationName + ', ';
          if (value.length == 1) {
            body = schedule.medicationName;
          }
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

//patientId
int _patientId = 0;
int _accountId = 0;
var uuid = Uuid();

/////////
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: DefaultTheme.TRANSPARENT,
    systemNavigationBarColor: DefaultTheme.TRANSPARENT,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  await _getAccountId();
  await _getPatientId();

  //connect device for 1st time and when bluetooth is on
  FlutterBlue.instance.state.listen((state) async {
    if (state == BluetoothState.on) {
      if (_patientId != 0) {
        await _connectFirstOpenApp();
      }
    }
  });
  //THIS IS CRON
  final cron = Cron()
    ..schedule(Schedule.parse('* * * * * '), () async {
      checkNotifiMedical();
      //
      //DO BLUETOOTH CONNECT AND GET HEART RATE
      print('At ${DateTime.now()} to Check Bluetooth funcs background');

      int countConnectBg = 0;

      await authenHelper.getPatientId().then((pIdCron) async {
        _patientId = pIdCron;
        if (_patientId != 0) {
          await FlutterBlue.instance.state.listen((state) async {
            if (state == BluetoothState.on) {
              //
              //check API Background setting
              if (countConnectBg == 0) {
                await _backgroundRepository
                    .getSettingBackground()
                    .then((backGroundSetting) async {
                  SettingBackgroundDTO settingDTO = SettingBackgroundDTO(
                    backgroundRun: backGroundSetting.backgroundRun,
                    insertLocal: backGroundSetting.insertLocal,
                  );
                  if (settingDTO != null) {
                    print(
                        'FROM setting API: check heart rate every ${backGroundSetting.backgroundRun} minute(s), and insert every ${backGroundSetting.insertLocal} times');
                    //COUNT IN BACKGROUND

                    await vitalSignHelper
                        .getCountInBackground()
                        .then((countInBackGround) async {
                      //countInBackGround += 1
                      await vitalSignHelper
                          .updateCountInBackground(countInBackGround += 1);
                      //

                      if (countInBackGround ==
                          backGroundSetting.backgroundRun) {
                        print(
                            'Every $countInBackGround minute(s), check heart rate (not insert)');
                        //
                        //check bluetooth on or off, then do action connect and get value
                        FlutterBlue.instance.state.listen((state) async {
                          print('state is ${state}');
                          if (state == BluetoothState.on) {
                            await _connectInBackground(
                                backGroundSetting.insertLocal);
                          }
                        });
                        //
                        //reset count in background
                        await vitalSignHelper.updateCountInBackground(0);
                      }
                    });
                  }
                });
                countConnectBg++;
              }
            }
          });
        } else {
          print('user has logged out of system');
        }
      });
    });
  runApp(HomeDoctor());
}

_getPatientId() async {
  await authenHelper.getPatientId().then((value) {
    _patientId = value;
  });
  if (_patientId != 0) {
    await _vitalSignServerRepository
        .getVitalSignSchedule(_patientId)
        .then((scheduleDTO) async {
      _vitalSignScheduleDTO = scheduleDTO;
      await _sqfLiteHelper.deleteVitalSignSchedule();
      //insert schedule vitalsign into local db
      if (_vitalSignScheduleDTO != null) {
        for (VitalSigns x in _vitalSignScheduleDTO.vitalSigns) {
          VitalSigns vitalSignDTO = VitalSigns(
            id: uuid.v1(),
            idSchedule: _vitalSignScheduleDTO.medicalInstructionId,
            vitalSignType: x.vitalSignType,
            minuteAgain: x.minuteAgain,
            minuteDangerInterval: x.minuteDangerInterval,
            numberMax: x.numberMax,
            numberMin: x.numberMin,
            timeStart: x.timeStart,
          );

          await _sqfLiteHelper.insertVitalSignSchedule(vitalSignDTO);
        }
      }
    });
  }
}

//
_connectFirstOpenApp() async {
  await _peripheralHelper.getPeripheralId().then((value) async {
    if (value != '') {
      await _peripheralRepository.connectDeviceInBackground(value);
    }
  });
}

//insert hr into db
_insertHeartRateIntoDb() async {
  await vitalSignHelper.getHeartRateValue().then((heartRateValue) async {
    if (heartRateValue != 0 && _patientId != 0) {
      VitalSignDTO vitalSignDTO = VitalSignDTO(
        id: uuid.v1(),
        patientId: _patientId,
        valueType: 'HEART_RATE',
        value1: heartRateValue,
        value2: null,
        dateTime: DateTime.now().toString(),
      );

      await _sqfLiteHelper.insertVitalSign(vitalSignDTO);
    }
  });
}

_getAccountId() async {
  await authenHelper.getAccountId().then((value) {
    _accountId = value;
  });
}

//connect device in bg
_connectInBackground(int timeInsert) async {
  //count when dangerous plus
  int dangerPlus = 0;
  //count when insert db
  int insertPlus = 0;

//    print('time insert duoc truyen vao ${timeInsert} ');
  await _peripheralHelper.getPeripheralId().then((peripheralId) async {
    if (peripheralId != '') {
      //
      //test battery
      await _vitalSignRepository
          .getBatteryDevice(peripheralId)
          .then((batteryValue) {
        //
        print('BATTERY OF DEVICE IS ${batteryValue}');
      });

      //
      //count dangerous means for every measurement again, get the first value to
      //regconized value to notify server
      int countLastValue = 0;

      //function get heart rate from device
      await _vitalSignRepository.getHeartRateValueFromDevice(peripheralId);
      //
      //
      //getCountingHR means space time for insert local DB
      await vitalSignHelper.getCountingHR().then((timeToInsertLocalDB) async {
        if (insertPlus == 0) {
          //get and count += 1
          await vitalSignHelper.updateCountingHR(timeToInsertLocalDB += 1);
          //
          print('Its just be ${timeToInsertLocalDB} times');
          //
          if (timeToInsertLocalDB == timeInsert) {
            //
            print(
                'COUNTED: ${timeToInsertLocalDB}.DO INSERT HEART RATE INTO LOCAL DB');
            await _insertHeartRateIntoDb();
            if (timeToInsertLocalDB >= timeInsert) {
              //reset space time to 0 and count space time again
              await vitalSignHelper.updateCountingHR(0);
            }
          }

          insertPlus++;
        }
      });
      //
      //
      if (_patientId != 0) {
        // print('patient ID before get vital sign schedule ${_patientId}');
        //

        await _sqfLiteHelper
            .getVitalSignScheduleOffline()
            .then((scheduleOffline) async {
          print('THERE ARE ELEMENTS IN TABLE SCHEDULE OFFLINE: ');
          for (VitalSigns a in scheduleOffline) {
            print('${a.vitalSignType}');
          }
          //
          //
          print(
              'vital sign schedule now ${_vitalSignScheduleDTO.medicalInstructionId}');
          if (scheduleOffline == null) {
            await _backgroundRepository
                .getSafeScopeHeartRate()
                .then((scopeHearRate) async {
              //
              print(
                  'scope heart rate is ${scopeHearRate.minSafeHeartRate} - max ${scopeHearRate.maxSafeHeartRate}. Dangerous count is ${scopeHearRate.dangerousCount}');
              //
              if (countLastValue == 0) {
                await vitalSignHelper.getHeartRateValue().then((value) async {
                  if (value != 0) {
                    if (value < scopeHearRate.minSafeHeartRate ||
                        value > scopeHearRate.maxSafeHeartRate) {
                      await vitalSignHelper
                          .getCountDownDangerous()
                          .then((countDown) async {
                        //
                        if (dangerPlus == 0) {
                          await vitalSignHelper
                              .updateCountDownDangerous(countDown += 1);
                          print(
                              'DANGEROUS HR. COUNT DOWN DANGEROUS IS ${countDown} at ${DateTime.now()}');
                          if (countDown == scopeHearRate.dangerousCount) {
                            ////////////////////////
                            //LOCAL EXECUTE HERE
                            //
                            var dangerousNotification = {
                              "notification": {
                                "title": "Sinh hiệu bất thường",
                                "body":
                                    "Nhịp tim của bạn có dấu hiệu bất thường.\n${value} BPM vào lúc ${DateTime.now().toString().split(' ')[1].split('.')[0]}",
                              },
                              "data": {
                                "NAVIGATE_TO_SCREEN": RoutesHDr.MAIN_HOME,
                              }
                            };
                            _handleGeneralMessage(dangerousNotification);
                            if (countDown >= scopeHearRate.dangerousCount) {
                              await vitalSignHelper.updateCountDownDangerous(0);
                            }
                          }

                          dangerPlus++;
                        }
                      });
                    } else {
                      //
                      await vitalSignHelper
                          .getCountDownDangerous()
                          .then((countDown) async {
                        //
                        if (countDown > 0) {
                          await vitalSignHelper
                              .updateCountDownDangerous(countDown -= 1);
                        }
                        print(
                            'NORMAL HR. COUNT DOWN DANGEROUS IS ${countDown}');
                      });
                    }
                  }
                });
                //
                countLastValue++;
              } else {
                //
                print(
                    'value heart rate == 0. it means cannot get heart rate or disconnected');
              }
              //
            });
          } else {
            //
            //schedule heart rate first
            VitalSigns heartRateSchedule = scheduleOffline
                .where((item) => item.vitalSignType == 'Nhịp tim')
                .first;
            print(
                'Heart rate schedule: min ${heartRateSchedule.numberMin}-${heartRateSchedule.numberMax}');
            if (countLastValue == 0) {
              //
              await vitalSignHelper.getHeartRateValue().then((value) async {
                //
                if (value != 0) {
                  if (value < heartRateSchedule.numberMin ||
                      value > heartRateSchedule.numberMax) {
                    //
                    await vitalSignHelper
                        .getCountDownDangerous()
                        .then((countDown) async {
                      //
                      if (dangerPlus == 0) {
                        await vitalSignHelper
                            .updateCountDownDangerous(countDown += 1);
                        print(
                            'DANGEROUS HR. COUNT DOWN DANGEROUS IS ${countDown}');
                        if (countDown ==
                            heartRateSchedule.minuteDangerInterval) {
                          ////////////////////////
                          //LOCAL EXECUTE HERE
                          //
                          var dangerousNotification = {
                            "notification": {
                              "title": "Sinh hiệu bất thường",
                              "body":
                                  "Nhịp tim của bạn có dấu hiệu bất thường.\n${value} BPM vào lúc ${DateTime.now().toString().split(' ')[1].split('.')[0]}",
                            },
                            "data": {
                              "NAVIGATE_TO_SCREEN": RoutesHDr.MAIN_HOME,
                            }
                          };
                          _handleGeneralMessage(dangerousNotification);
                          ////////////////////////
                          //SERVER EXECUTE HERE

                          NotificationPushDTO notiPushDTO = NotificationPushDTO(
                              deviceType: 2,
                              notificationType: 2,
                              recipientAccountId:
                                  _vitalSignScheduleDTO.doctorAccountId,
                              senderAccountId: _accountId);
                          //PUSH NOTI
                          await notificationRepository
                              .pushNotification(notiPushDTO);
                          //
                          //CHANGE STATUS PEOPLE
                          await notificationRepository.changePersonalStatus(
                              _patientId, 'DANGER');
                          if (countDown >=
                              heartRateSchedule.minuteDangerInterval) {
                            await vitalSignHelper.updateCountDownDangerous(0);
                          }
                        }

                        dangerPlus++;
                      }

                      //
                    });
                  } else {
                    //
                    await vitalSignHelper
                        .getCountDownDangerous()
                        .then((countDown) async {
                      //
                      if (countDown > 0) {
                        await vitalSignHelper
                            .updateCountDownDangerous(countDown -= 1);
                      }
                      print('NORMAL HR. COUNT DOWN DANGEROUS IS ${countDown}');
                    });
                  }
                } else {
                  //
                  print(
                      'value heart rate == 0. it means cannot get heart rate or disconnected');
                }
              });
              countLastValue++;
            }
          }

          //
        });
      }

      //

    } else {
      print('user logged in but not connect with peripheral');
    }
  });
}

class HomeDoctor extends StatefulWidget {
  @override
  _HomeDoctorState createState() => _HomeDoctorState();
}

class _HomeDoctorState extends State<HomeDoctor> {
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
    if (!prefs.containsKey('HEALTH_RECORD_RESPONSE')) {
      hrHelper.initialHRRsponse();
    }
    if (!prefs.containsKey('TOKEN_DEVICE')) {
      mobileDeviceHelper.initialTokenDevice();
    }
    if (!prefs.containsKey('CONTRACT_REQUEST')) {
      contractHelper.initialContractSendRequest();
    }
    if (!prefs.containsKey('DOCTOR_ID')) {
      contractHelper.initialDoctorId();
    }
    if (!prefs.containsKey('CONTRACT_CHECKING')) {
      contractHelper.initialContractCheckingRequest();
    }
    if (!prefs.containsKey('CONTRACT_ID')) {
      contractHelper.initialContracId();
    }
    if (!prefs.containsKey('MED_SHARE_CHECKING')) {
      _medicalShareHelper.initialMedicalShareChecking();
    }
    if (!prefs.containsKey('HEART_RATE_VALUE')) {
      _vitalSignHelper.initialHeartRateValue();
    }
    if (!prefs.containsKey('HEART_RATE_COUNTING_TIME')) {
      _vitalSignHelper.initalCountingHR();
    }
    if (!prefs.containsKey('APPOINTMENT_CHANGE_DATE')) {
      _appointmentHelper.initialAppointmentChangeDate();
    }
    if (!prefs.containsKey('COUNT_DOWN_DANGEROUS')) {
      _vitalSignHelper.initialCountDownDangerous();
    }
    if (!prefs.containsKey('COUNT_IN_BACKGROUND')) {
      _vitalSignHelper.initialCountInBackground();
    }
    if (!prefs.containsKey('MED_INSTRUCTION_CREATE')) {
      _medicalInstructionHelper.initialMedicalInstructionCreate();
    }
  }

  @override
  void initState() {
    super.initState();

    _initialServiceHelper();
    peripheralHelper.isPeripheralConnected().then((value) {
      print('peripheral connect state is ${value}');
    });
    peripheralHelper.getPeripheralId().then((value) {
      if (value == '') {
        value = 'NOTHING';
      }
      print('peripheral connect id is ${value}');
    });
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
        onNotificationReceive(message);
        Platform.isIOS
            ? _handleIOSGeneralMessage(message)
            : _handleGeneralMessage(message);
      },
      // onBackgroundMessage: (Map<String, dynamic> message) async {
      //   print('onBackgroundMessage: $message');
      // },
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

  onNotificationReceive(message) {
    print('message: $message');
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
          BlocProvider<DiseaseListBloc>(
            create: (BuildContext context) =>
                DiseaseListBloc(diseaseRepository: _diseaseRepository),
          ),
          BlocProvider<AppointmentBloc>(
            create: (BuildContext context) =>
                AppointmentBloc(appointmentRepository: _appointmentRepository),
          ),
          BlocProvider<PeripheralBloc>(
            create: (BuildContext context) =>
                PeripheralBloc(peripheralRepository: _peripheralRepository),
          ),
          BlocProvider<VitalSignBloc>(
            create: (BuildContext context) => VitalSignBloc(
                vitalSignRepository: _vitalSignRepository,
                sqfLiteHelper: _sqfLiteHelper),
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
                RoutesHDr.HEART: (context) => HeartDetailView(),
                RoutesHDr.MEDICINE_NOTI_VIEW: (context) =>
                    ScheduleMedNotiView(),
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
                RoutesHDr.VITALSIGN_HISTORY: (context) => HistoryVitalSign(),
                RoutesHDr.PRESSURE_CHART_VIEW: (context) =>
                    PressureDetailView(),
                RoutesHDr.VITAL_SIGN_SCHEDULE_VIEW: (context) =>
                    VitalSignScheduleView(),
                RoutesHDr.CREATE_MEDICAL_INSTRUCTION: (context) =>
                    CreateMedicalInstructionView(),
              },
              home: _startScreen,
            ),
          ),
        ));
  }

  _doNothing() {
    //
  }
}
