import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/features/activity/blocs/activity_bloc.dart';
import 'package:capstone_home_doctor/features/activity/blocs/doctor_list_bloc.dart';
import 'package:capstone_home_doctor/features/activity/repository/activity_repository.dart';
import 'package:capstone_home_doctor/features/activity/view/activity_time.dart';
import 'package:capstone_home_doctor/features/activity/view/activity_view.dart';
import 'package:capstone_home_doctor/features/background/repositories/background_repository.dart';
import 'package:capstone_home_doctor/features/chat/chat.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_checking_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_full_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_id_now_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/views/update_health_record.dart';
import 'package:capstone_home_doctor/features/schedule/events/prescription_list_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_sync_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_sync_repository.dart';
import 'package:capstone_home_doctor/models/appointment_dto.dart';
import 'package:capstone_home_doctor/services/doctor_helper.dart';
import 'package:capstone_home_doctor/features/vital_sign/views/vital_sign_chart_detail.dart';
import 'package:capstone_home_doctor/services/notifications_bloc.dart';
import 'package:capstone_home_doctor/services/reminder_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_request_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_update_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/disease_list_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/doctor_info_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/repositories/disease_repository.dart';
import 'package:capstone_home_doctor/features/contract/repositories/doctor_repository.dart';
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
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_schedule_bloc.dart';
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
import 'package:capstone_home_doctor/models/vital_sign_push_dto.dart';
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
import 'package:sentry_flutter/sentry_flutter.dart';

//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//helper
final AuthenticateHelper authenHelper = AuthenticateHelper();
final PeripheralHelper peripheralHelper = PeripheralHelper();
final HealthRecordHelper hrHelper = HealthRecordHelper();
final MobileDeviceHelper mobileDeviceHelper = MobileDeviceHelper();
final ContractHelper contractHelper = ContractHelper();
final MedicalShareHelper _medicalShareHelper = MedicalShareHelper();
final VitalSignHelper _vitalSignHelper = VitalSignHelper();
final ReminderHelper _reminderHelper = ReminderHelper();
final AppointmentHelper _appointmentHelper = AppointmentHelper();
final MedicalInstructionHelper _medicalInstructionHelper =
    MedicalInstructionHelper();
final DoctorHelper _doctorHelper = DoctorHelper();
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
ActivityRepository _activityRepository =
    ActivityRepository(httpClient: http.Client());
VitalSignSyncRepository _vitalSignSyncRepository =
    VitalSignSyncRepository(httpClient: http.Client());
//AccountBloc
// AccountBloc _accountBloc = AccountBloc(accountRepository: accountRepository);
//
VitalSignScheduleDTO _vitalSignScheduleDTO = VitalSignScheduleDTO();

void _handleGeneralMessage(Map<String, dynamic> message) async {
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
  //
  if (notification["body"]
      .toString()
      .contains('Bạn có một lịch đo sinh hiệu mới')) {
    _saveVitalSignScheduleOffline();
    print('CATCHED THIS NOTI TO DOWNLOAD NEW SCHEDULE');
  }
}

void _handleIOSGeneralMessage(Map<String, dynamic> message) async {
  String payload = jsonEncode(message);
  ReceiveNotification receiveNotification;
  final dynamic notification = message['aps']['alert'];

  receiveNotification = ReceiveNotification(
      id: 0,
      title: notification["title"],
      body: notification["body"],
      payload: payload);
  localNotifyManager.show(receiveNotification);
  if (notification["body"]
      .toString()
      .contains('Bạn có một lịch đo sinh hiệu mới')) {
    _saveVitalSignScheduleOffline();
    print('CATCHED THIS NOTI TO DOWNLOAD NEW SCHEDULE');
  }
}

void checkNotifiMedical() async {
  SQFLiteHelper _sqLiteHelper = SQFLiteHelper();
  final hour = DateTime.now().hour;
  final minute = DateTime.now().minute;
  var body = "";
  int MORNING = 0;
  int NOON = 0;
  int AFTERNOON = 0;
  int NIGHT = 0;
  int MINUTES = 00;

  final String response = await rootBundle.loadString('assets/global.json');
  if (response.contains('session')) {
    final data = await json.decode(response);
    var session = data['session'];
    MORNING = session['morning'];
    NOON = session['noon'];
    AFTERNOON = session['afternoon'];
    NIGHT = session['night'];
    MINUTES = session['minutes'];
  }

  if (appointment == null) {
    await getCalendarAppointment();
  }

  if (hour == MORNING && minute == MINUTES) {
    await _sqLiteHelper.getAllBy('morning').then((value) {
      if (value.length > 0) {
        for (var schedule in value) {
          if (!body.contains(schedule.medicationName)) {
            body += schedule.medicationName + ', ';
            if (value.length == 1) {
              body = schedule.medicationName;
            }
          }
        }
      }
    });

    if (appointment != null) {
      for (var item in appointment.appointments) {
        DateTime timeDate =
            new DateFormat('yyyy-MM-ddThh:mm:ss').parse(item.dateExamination);
        int hourAppointment = timeDate.hour;
        int minuteAppointment = timeDate.minute;
        if (MORNING <= hourAppointment && hourAppointment <= NOON) {
          print('MORNING: $hourAppointment');
          var messageAppointment = {
            "notification": {
              "title": "LỊCH TÁI KHÁM",
              "body":
                  'Hôm nay bạn có lịch hẹn với ${item.fullNameDoctor} lúc ${hourAppointment}:${minuteAppointment}',
              "data": {
                "notiTypeId": '8',
              }
            }
          };
          _handleGeneralMessage(messageAppointment);
        }
      }
    }
  }
  if (hour == NOON && minute == MINUTES) {
    await _sqLiteHelper.getAllBy('noon').then((value) {
      if (value.length > 0) {
        for (var schedule in value) {
          if (!body.contains(schedule.medicationName)) {
            body += schedule.medicationName + ', ';
            if (value.length == 1) {
              body = schedule.medicationName;
            }
          }
        }
      }
    });
    if (appointment != null) {
      for (var item in appointment.appointments) {
        DateTime timeDate =
            new DateFormat('yyyy-MM-ddThh:mm:ss').parse(item.dateExamination);
        int hourAppointment = timeDate.hour;
        int minuteAppointment = timeDate.minute;
        if (NOON <= hourAppointment && hourAppointment <= AFTERNOON) {
          print('NOON: $hourAppointment');
          var messageAppointment = {
            "notification": {
              "title": "LỊCH TÁI KHÁM",
              "body":
                  'Hôm nay bạn có lịch hẹn với ${item.fullNameDoctor} lúc ${hourAppointment}:${minuteAppointment}',
              "data": {
                "notiTypeId": '8',
              }
            }
          };
          _handleGeneralMessage(messageAppointment);
        }
      }
    }
  }
  if (hour == AFTERNOON && minute == MINUTES) {
    await _sqLiteHelper.getAllBy('afterNoon').then((value) {
      if (value.length > 0) {
        for (var schedule in value) {
          if (!body.contains(schedule.medicationName)) {
            body += schedule.medicationName + ', ';
            if (value.length == 1) {
              body = schedule.medicationName;
            }
          }
        }
      }
    });
    if (appointment != null) {
      for (var item in appointment.appointments) {
        DateTime timeDate =
            new DateFormat('yyyy-MM-ddThh:mm:ss').parse(item.dateExamination);
        int hourAppointment = timeDate.hour;
        int minuteAppointment = timeDate.minute;
        if (AFTERNOON <= hourAppointment && hourAppointment <= NIGHT) {
          print('AFTERNOON: $hourAppointment');
          var messageAppointment = {
            "notification": {
              "title": "LỊCH TÁI KHÁM",
              "body":
                  'Hôm nay bạn có lịch hẹn với ${item.fullNameDoctor} lúc ${hourAppointment}:${minuteAppointment}',
              "data": {
                "notiTypeId": '8',
              }
            }
          };
          _handleGeneralMessage(messageAppointment);
        }
      }
    }
  }
  if (hour == NIGHT && minute == MINUTES) {
    await _sqLiteHelper.getAllBy('night').then((value) {
      if (value.length > 0) {
        for (var schedule in value) {
          if (!body.contains(schedule.medicationName)) {
            body += schedule.medicationName + ', ';
            if (value.length == 1) {
              body = schedule.medicationName;
            }
          }
        }
      }
    });
  }
  print('body: $body');
  if ((hour == MORNING || hour == NOON || hour == AFTERNOON || hour == NIGHT) &&
      minute == MINUTES &&
      body != null &&
      body != '') {
    var message = {
      "notification": {"title": "Nhắc nhở uống thuốc", "body": body},
      "data": {
        "NAVIGATE_TO_SCREEN": RoutesHDr.SCHEDULE,
      }
    };

    Future.delayed(Duration(seconds: 3), () {
      _handleGeneralMessage(message);
    });
  }
}

//patientId
int _patientId = 0;
int _accountId = 0;
var uuid = Uuid();
DateValidator _dateValidator = DateValidator();
AppointmentDTO appointment;

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
  _getAccountId();
  await _getPatientId();
  await getCalendarAppointment();

  //connect device for 1st time and when bluetooth is on
  FlutterBlue.instance.state.listen((state) async {
    if (state == BluetoothState.on) {
      if (_patientId != 0) {
        await _connectFirstOpenApp();
        await _saveVitalSignScheduleOffline();
      }
    }
  });
  //THIS IS CRON
  final cron = Cron()
    ..schedule(Schedule.parse('* * * * * '), () async {
      checkNotifiMedical();

      //DO BLUETOOTH CONNECT AND GET HEART RATE
      print('At ${DateTime.now()} to Check Bluetooth funcs background');

      ///////-----------------------------------------------
      ///FOR HEART RATE PROCESSING
      int countConnectBg = 0;
      int countDangerousLosingBluetooth = 0;
      int countSummary = 0;
      await authenHelper.getPatientId().then((pIdCron) async {
        _patientId = pIdCron;
        if (_patientId != 0) {
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

                  if (countInBackGround == backGroundSetting.backgroundRun) {
                    print(
                        'Every $countInBackGround minute(s), check heart rate (not insert)');
                    //
                    //check bluetooth on or off, then do action connect and get value
                    FlutterBlue.instance.state.listen((state) async {
                      print('state is ${state}');
                      if (state == BluetoothState.turningOn) {
                        //
                        Future.delayed(const Duration(seconds: 1), () async {
                          //
                          await _connectFirstOpenApp();
                        });
                      } else if (state == BluetoothState.on) {
                        if (countDangerousLosingBluetooth == 0) {
                          await _connectInBackground(
                              backGroundSetting.insertLocal);
                          await _reminderHelper.updateValueBluetooth(true);
                        }
                        countDangerousLosingBluetooth++;
                      } else if (state == BluetoothState.off) {
                        if (countDangerousLosingBluetooth == 0) {
                          //BLUETOOTH OF BUT USER STIL DANGER
                          await _reminderHelper.updateValueBluetooth(false);
                          int dangerPlus = 0;
                          //IF HAS SCHEDULE OFFLINE
                          List<VitalSigns> scheduleOffline = [];

                          await _sqfLiteHelper
                              .getVitalSignScheduleOffline()
                              .then((sOffline) async {
                            scheduleOffline = sOffline;
                          });
                          if (scheduleOffline.isNotEmpty) {
                            //DANGEROUS IS COUNTING BUT LOSE DEVICE CONNECTION
                            //
                            VitalSigns heartRateSchedule = scheduleOffline
                                .where(
                                    (item) => item.vitalSignType == 'Nhịp tim')
                                .first;
                            print(
                                'Heart rate schedule from server: min ${heartRateSchedule.numberMin}- max ${heartRateSchedule.numberMax}\nDanger minute is ${heartRateSchedule.minuteDangerInterval}- minute normal is ${heartRateSchedule.minuteNormalInterval}');
                            //DANGEROUS IS COUNTING BUT LOSE DEVICE CONNECTION
                            //
                            await vitalSignHelper
                                .getCountDownDangerous()
                                .then((countDown) async {
                              //
                              if (dangerPlus == 0) {
                                //
                                if (countDown > 0) {
                                  //
                                  print(
                                      'lose bluetooth connection AND the last people status is dangerous');
                                  await vitalSignHelper
                                      .updateCountDownDangerous(countDown += 1);
                                  print(
                                      'DANGEROUS HR (LOSE DEVICE CONNECTION). COUNT DOWN DANGEROUS IS ${countDown}');
                                  if (countDown ==
                                      heartRateSchedule.minuteDangerInterval) {
                                    ////////////////////////
                                    //LOCAL EXECUTE HERE
                                    //
                                    var dangerousNotification = {
                                      "notification": {
                                        "title": "Sinh hiệu bất thường",
                                        "body":
                                            "Nhịp tim của bạn có dấu hiệu bất thường.",
                                      },
                                      "data": {
                                        "NAVIGATE_TO_SCREEN":
                                            RoutesHDr.MAIN_HOME,
                                      }
                                    };
                                    await _vitalSignHelper
                                        .updatePeopleStatus('DANGER')
                                        .then((isOk) {
                                      if (isOk) {
                                        ReceiveNotification notiData =
                                            ReceiveNotification(
                                                id: 0,
                                                title: "reload heart rate",
                                                body: "",
                                                payload: "");
                                        HeartRefreshBloc.instance
                                            .newNotification(notiData);
                                      }
                                    });
                                    _handleGeneralMessage(
                                        dangerousNotification);
                                    ////////////////////////
                                    //SERVER EXECUTE HERE

                                    //
                                    //KICK VARIABLE CHECK DANGER TO NORMAL
                                    await _vitalSignHelper
                                        .updateCheckToNormal(true);

                                    //CHANGE STATUS PEOPLE
                                    await notificationRepository
                                        .changePersonalStatus(
                                            _patientId, 'DANGER')
                                        .then((isSuccess) async {
                                      NotificationPushDTO notiPushDTO =
                                          NotificationPushDTO(
                                              deviceType: 2,
                                              notificationType: 2,
                                              recipientAccountId:
                                                  _vitalSignScheduleDTO
                                                      .doctorAccountId,
                                              senderAccountId: _accountId);
                                      print(
                                          'CHECK TO OBJECT NOTIFICATION: !!!!!!!!!!!!senderAccountId: ${_accountId}');
                                      //PUSH NOTI
                                      if (isSuccess) {
                                        await notificationRepository
                                            .pushNotification(notiPushDTO);
                                        print(
                                            'update people to danger successful');
                                      }
                                    });
                                  }
                                  // // set into 0 when normal
                                  // if (countDown >= heartRateSchedule.minuteDangerInterval) {
                                  //   await vitalSignHelper.updateCountDownDangerous(0);
                                  // }
                                  //
                                } else {
                                  print(
                                      'lose bluetooth connection but the last people status is normal');
                                  FlutterBlue.instance.state
                                      .listen((state) async {
                                    print('state is ${state}');
                                    if (state == BluetoothState.on) {
                                      //
                                      Future.delayed(const Duration(seconds: 1),
                                          () async {
                                        //
                                        await _connectFirstOpenApp();
                                      });
                                    }
                                  });
                                }
                                dangerPlus++;
                              }
                            });
                          }
                        }
                        countDangerousLosingBluetooth++;
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

          //
          ///SUMMARY EVERY END OF DATE
          if (countSummary == 0) {
            //
            await _backgroundRepository
                .getSummarySetting()
                .then((summarySettingDTO) async {
              //
              if (summarySettingDTO != null) {
                print(
                    'CHECK BACKGROUND SUMMARY END DATE at ${summarySettingDTO.timeSum}');

                int hour =
                    int.tryParse(summarySettingDTO.timeSum.split(':')[0]);
                int minute =
                    int.tryParse(summarySettingDTO.timeSum.split(':')[1]);
                String now = DateTime.now().toString();
                String timeNow = now.split(' ')[1];
                int hourNow = int.tryParse(timeNow.split(':')[0]);
                int minuteNow =
                    int.tryParse(timeNow.split(':')[1].split('.')[0]);
                int countTIME = 0;
                if (countTIME == 0) {
                  if (hour == hourNow && minute == minuteNow) {
                    //
                    print('DO SUMMARY VALUE TO SERVER');
                    await _sqfLiteHelper
                        .getVitalSignScheduleOffline()
                        .then((sOffline) async {
                      if (sOffline.isNotEmpty) {
                        //
                        VitalSigns heartRateSchedule = sOffline
                            .where((item) => item.vitalSignType == 'Nhịp tim')
                            .first;

                        ///PUSH VITAL SIGN INTO SERVER
                        ///
                        String listValue = '';
                        String listTime = '';
                        int countGetList = 0;
                        _sqfLiteHelper
                            .getListVitalSign('HEART_RATE', _patientId)
                            .then((listHeartRate) async {
                          if (countGetList == 0) {
                            for (VitalSignDTO dto in listHeartRate) {
                              listValue += dto.value1.toString() + ',';
                              listTime += dto.toDatePush() + ',';
                            }
                          }
                          //
                          countGetList++;
                          print('list value: $listValue');
                          print('list time: $listTime');
                          VitalSignPushDTO vitalSignPush = VitalSignPushDTO(
                            patientId: _patientId,
                            vitalSignTypeId: 1,
                            numberValue: listValue,
                            timeValue: listTime,
                          );
                          // print(
                          //     'DTO HEREEE: \n vitalSignScheduleId: ${vitalSignPush.vitalSignScheduleId}\ncurrentDate: ${vitalSignPush.currentDate}\nnumberValue: ${vitalSignPush.numberValue}\ntimeValue: ${vitalSignPush.timeValue}');

                          print(
                              '\n\nJSON OBJECT: \n\n ${vitalSignPush.toJson().toString()}\n\n');
                          await _vitalSignServerRepository
                              .pushVitalSign(vitalSignPush)
                              .then((isSuccess) async {
                            if (isSuccess) {
                              print('SUCCESSFUL PUSH DATA HEART RATE');
                              await _sqfLiteHelper
                                  .deleteRecordsVitalSign(
                                      'HEART_RATE', _patientId)
                                  .then((isDeleted) async {
                                //
                                if (isDeleted) {
                                  print(
                                      'DELETE HEART RATE VALUE END DATE SUCCESSFUL');
                                } else {
                                  //
                                }
                              });
                            } else {
                              print('FAILED TO PUSH DATA HEART RATE');
                            }
                          });
                        });
                      } else {
                        //HAVING NO SCHEDULE CALENDAR
                        //SHOULD I DELETE AFTER DAY OR KEEP ALL VALUE ULTIL HAVING SCHEDULE ???
                      }
                    });
                  }
                  countTIME++;
                }
              }
            });
            countSummary++;
          }
        } else {
          print('user has logged out of system');
        }
      });

      ///
      ///////-----------------------------------------------
      ///FOR ANOTHER VITAL SIGN EXCEPT HEART RATE
      int countNotiSchedule = 0;
      if (countNotiSchedule == 0) {
        List<VitalSigns> schedulePSOffline = [];

        await _sqfLiteHelper
            .getVitalSignScheduleOffline()
            .then((sOffline) async {
          VitalSigns pressureSchedule =
              sOffline.where((item) => item.vitalSignType == 'Huyết áp').first;
          print(
              'Time start of a day for pressure: ${pressureSchedule.timeStart}');
          //
          if (pressureSchedule.timeStart != null) {
            if (pressureSchedule.timeStart.isNotEmpty) {
              //
              int hour = int.tryParse(pressureSchedule.timeStart.split(':')[0]);
              int minute =
                  int.tryParse(pressureSchedule.timeStart.split(':')[1]);
              String now = DateTime.now().toString();
              String timeNow = now.split(' ')[1];
              int hourNow = int.tryParse(timeNow.split(':')[0]);
              int minuteNow = int.tryParse(timeNow.split(':')[1].split('.')[0]);
              if (hour == hourNow && minute == minuteNow) {
                var dangerousNotification = {
                  "notification": {
                    "title": "Nhắc nhở đo sinh hiệu",
                    "body":
                        "Bác sĩ nhắc bạn đo và ghi nhận huyết áp vào khoảng thời gian này.",
                  },
                  "data": {
                    "NAVIGATE_TO_SCREEN": RoutesHDr.PRESSURE_CHART_VIEW,
                  }
                };
                _handleGeneralMessage(dangerousNotification);
              }
            }
          }
          countNotiSchedule++;
        });
      }
    });
  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn =
  //         'https://0ccf617d2df8401a93b955bb5ea55728@o440638.ingest.sentry.io/5698108';
  //   },
  //   appRunner: () => runApp(HomeDoctor()),
  // );
  runApp(HomeDoctor());
}

_getPatientId() async {
  await authenHelper.getPatientId().then((value) {
    _patientId = value;
  });
}

getCalendarAppointment() async {
  DateTime curentDateNow = new DateFormat('dd/MM/yyyy')
      .parse(DateFormat('dd/MM/yyyy').format(DateTime.now()));
  if (_accountId != 0) {
    await _appointmentRepository.getAppointment(_accountId, '').then((value) {
      for (var item in value) {
        DateTime dateCheck =
            new DateFormat('dd/MM/yyyy').parse(item.dateExamination);
        if (dateCheck.millisecondsSinceEpoch ==
            curentDateNow.millisecondsSinceEpoch) {
          appointment = item;
          break;
        }
      }
    });
  } else {
    await authenHelper.getAccountId().then((value) {
      if (value != 0) {
        _appointmentRepository.getAppointment(value, '').then((value) {
          for (var item in value) {
            DateTime dateCheck =
                new DateFormat('dd/MM/yyyy').parse(item.dateExamination);
            if (dateCheck.millisecondsSinceEpoch ==
                curentDateNow.millisecondsSinceEpoch) {
              appointment = item;
              break;
            }
          }
        });
      }
    });
  }
}

_saveVitalSignScheduleOffline() async {
  await _vitalSignServerRepository
      .getVitalSignSchedule(_patientId)
      .then((scheduleDTO) async {
    //insert schedule vitalsign into local db
    if (_vitalSignScheduleDTO != null) {
      await _sqfLiteHelper.deleteVitalSignSchedule();
      _vitalSignScheduleDTO = scheduleDTO;
      for (VitalSigns x in scheduleDTO.vitalSigns) {
        VitalSigns vitalSignDTO = VitalSigns(
          id: uuid.v1(),
          idSchedule: _vitalSignScheduleDTO.medicalInstructionId,
          vitalSignScheduleId: _vitalSignScheduleDTO.vitalSignScheduleId,
          vitalSignType: x.vitalSignType,
          minuteAgain: x.minuteAgain,
          minuteDangerInterval: x.minuteDangerInterval,
          minuteNormalInterval: x.minuteNormalInterval,
          numberMax: x.numberMax,
          numberMin: x.numberMin,
          timeStart: x.timeStart,
        );

        await _sqfLiteHelper.insertVitalSignSchedule(vitalSignDTO);
      }
    }
  });
}

//
_connectFirstOpenApp() async {
  await _peripheralHelper.getPeripheralId().then((value) async {
    if (value != '') {
      await _peripheralRepository
          .connectDeviceInBackground(value)
          .catchError((e) {
        if (e.toString().contains(
            'error at getHeartRateValueFromDevice PlatformException(set_notification_error, error when writing the descriptor, null, null)')) {
          // //
          _peripheralRepository.connectDeviceInBackground(value);
        }
      });
    }
  });
}

//insert hr into db
_insertHeartRateIntoDb() async {
  await vitalSignHelper.getHeartRateValue().then((heartRateValue) async {
    if (_patientId != 0) {
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
          }
          if (timeToInsertLocalDB >= timeInsert) {
            //reset space time to 0 and count space time again
            await vitalSignHelper.updateCountingHR(0);
          }

          insertPlus++;
        }
      });
      //

      //////////////////////////////
      //
      //Check dangerous and push notification
      if (_patientId != 0) {
        // print('patient ID before get vital sign schedule ${_patientId}');
        //
        List<VitalSigns> scheduleOffline = [];

        await _sqfLiteHelper
            .getVitalSignScheduleOffline()
            .then((sOffline) async {
          scheduleOffline = sOffline;
        });

        if (scheduleOffline.isNotEmpty) {
          print('THERE ARE ELEMENTS IN TABLE SCHEDULE OFFLINE: ');
          for (VitalSigns a in scheduleOffline) {
            print('${a.vitalSignType}');
          }
          //
          //
          print('vital sign schedule now ${scheduleOffline[0].idSchedule}');
        }

        if (scheduleOffline.isEmpty) {
          await _backgroundRepository
              .getSafeScopeHeartRate()
              .then((scopeHearRate) async {
            //
            print(
                'scope heart rate DEFAULT is ${scopeHearRate.minSafeHeartRate} - max ${scopeHearRate.maxSafeHeartRate}. Dangerous count is ${scopeHearRate.dangerousCount}');
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
                        ////////////////////////
                        //INSERT HEART RATE DANGEROUS
                        await vitalSignHelper
                            .getCountingHR()
                            .then((timeToInsertLocalDB) async {
                          if (timeToInsertLocalDB != 0) {
                            print(
                                'timeToInsertLocalDB: $timeToInsertLocalDB - timeInsert: $timeInsert');
                            //
                            await _insertHeartRateIntoDb();
                            print(
                                'Insert Dangerous Heart Rate without timely ');
                          }
                          //
                        });

                        //
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
                          await _vitalSignHelper
                              .updatePeopleStatus('DANGER')
                              .then((isOk) {
                            if (isOk) {
                              ReceiveNotification notiData =
                                  ReceiveNotification(
                                      id: 0,
                                      title: "reload heart rate",
                                      body: "",
                                      payload: "");
                              HeartRefreshBloc.instance
                                  .newNotification(notiData);
                            }
                          });

                          _handleGeneralMessage(dangerousNotification);
                          //
                          /////////////
                          //KICK VARIABLE CHECK DANGER TO NORMAL
                          await _vitalSignHelper.updateCheckToNormal(true);
                        }
                        // set into 0 when normal
                        if (countDown >= scopeHearRate.dangerousCount) {
                          await vitalSignHelper.updateCountDownDangerous(0);
                        }
                        dangerPlus++;
                      }
                    });
                  } else {
                    //
                    await vitalSignHelper
                        .getCountDownDangerous()
                        .then((countDown) async {
                      //NORMAL HEART RATE. RESET DANGEROUS BACK TO 0
                      if (countDown > 0) {
                        await vitalSignHelper.updateCountDownDangerous(0);
                      }
                      print('NORMAL HR. COUNT DOWN DANGEROUS IS ${countDown}');

                      //
                      await vitalSignHelper
                          .isCheckToNormal()
                          .then((isCheckToNormal) async {
                        //
                        if (isCheckToNormal == true) {
                          print('CHECK DANGER TO MORNAL IS KICKED ON');

                          ///COUNT TO NORMAL
                          await vitalSignHelper
                              .getCountToNormal()
                              .then((countToNormal) async {
                            //
                            await vitalSignHelper
                                .updateCountToNormal(countToNormal += 1);

                            ///
                            print(
                                'COUNT TO NORMAL IS ${countToNormal} at ${DateTime.now()}');
                            if (countToNormal >= scopeHearRate.normalCount) {
                              print(
                                  'CHANGE DEFAULT normal people status successful!');
                              await _vitalSignHelper
                                  .updatePeopleStatus('NORMAL')
                                  .then((isOk) {
                                if (isOk) {
                                  ReceiveNotification notiData =
                                      ReceiveNotification(
                                          id: 0,
                                          title: "reload heart rate",
                                          body: "",
                                          payload: "");
                                  HeartRefreshBloc.instance
                                      .newNotification(notiData);
                                }
                              });
                              //UPDATE VARIABLE CHECK DANGEROUS TO NORMAL = FALSE
                              await _vitalSignHelper.updateCheckToNormal(false);
                            }
                            if (countToNormal >= scopeHearRate.normalCount) {
                              await vitalSignHelper.updateCountToNormal(0);
                              await _vitalSignHelper.updateCheckToNormal(false);
                            }
                          });
                        }
                      });
                    });
                  }
                } else {
                  //DANGEROUS IS COUNTING BUT LOSE DEVICE CONNECTION
                  //
                  await vitalSignHelper
                      .getCountDownDangerous()
                      .then((countDown) async {
                    //
                    if (dangerPlus == 0) {
                      //
                      if (countDown > 0) {
                        print(
                            'lose connection AND the last people status is dangerous');
                        //
                        await vitalSignHelper
                            .updateCountDownDangerous(countDown += 1);
                        print(
                            'DANGEROUS HR (LOSE DEVICE CONNECTION). COUNT DOWN DANGEROUS IS ${countDown}');
                        if (countDown == scopeHearRate.dangerousCount) {
                          ////////////////////////
                          //LOCAL EXECUTE HERE
                          //
                          var dangerousNotification = {
                            "notification": {
                              "title": "Sinh hiệu bất thường",
                              "body":
                                  "Nhịp tim của bạn có dấu hiệu bất thường.",
                            },
                            "data": {
                              "NAVIGATE_TO_SCREEN": RoutesHDr.MAIN_HOME,
                            }
                          };
                          _handleGeneralMessage(dangerousNotification);
                          await _vitalSignHelper
                              .updatePeopleStatus('DANGER')
                              .then((isOK) {
                            if (isOK) {
                              ReceiveNotification notiData =
                                  ReceiveNotification(
                                      id: 0,
                                      title: "reload heart rate",
                                      body: "",
                                      payload: "");
                              HeartRefreshBloc.instance
                                  .newNotification(notiData);
                            }
                          });
                        }
                        //
                      } else {
                        print(
                            'lose bluetooth connection but the last people status is normal');
                        FlutterBlue.instance.state.listen((state) async {
                          print('state is ${state}');
                          if (state == BluetoothState.on) {
                            //
                            Future.delayed(const Duration(seconds: 1),
                                () async {
                              //
                              await _connectFirstOpenApp();
                              await _vitalSignHelper
                                  .updatePeopleStatus('NORMAL')
                                  .then((isOk) {
                                if (isOk) {
                                  ReceiveNotification notiData =
                                      ReceiveNotification(
                                          id: 0,
                                          title: "reload heart rate",
                                          body: "",
                                          payload: "");
                                  HeartRefreshBloc.instance
                                      .newNotification(notiData);
                                }
                              });
                            });
                          }
                        });
                      }
                      dangerPlus++;
                    }
                  });
                }
              });
              //
              countLastValue++;
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
              'Heart rate schedule from server: min ${heartRateSchedule.numberMin}- max ${heartRateSchedule.numberMax}\nDanger minute is ${heartRateSchedule.minuteDangerInterval}- minute normal is ${heartRateSchedule.minuteNormalInterval}');
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
                      ////////////////////////
                      //INSERT HEART RATE DANGEROUS
                      await vitalSignHelper
                          .getCountingHR()
                          .then((timeToInsertLocalDB) async {
                        if (timeToInsertLocalDB != 0) {
                          await _insertHeartRateIntoDb();
                          print('Insert Dangerous Heart Rate without timely ');
                        }
                        //
                      });

                      //
                      if (countDown == heartRateSchedule.minuteDangerInterval) {
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
                        await _vitalSignHelper
                            .updatePeopleStatus('DANGER')
                            .then((isOk) {
                          if (isOk) {
                            ReceiveNotification notiData = ReceiveNotification(
                                id: 0,
                                title: "reload heart rate",
                                body: "",
                                payload: "");
                            HeartRefreshBloc.instance.newNotification(notiData);
                          }
                        });
                        ////////////////////////
                        //SERVER EXECUTE HERE

                        //
                        /////////
                        ///PUSH VITAL SIGN INTO SERVER
                        ///
                        String listValue = '';
                        String listTime = '';
                        int countGetList = 0;
                        _sqfLiteHelper
                            .getListVitalSign('HEART_RATE', _patientId)
                            .then((listHeartRate) async {
                          if (countGetList == 0) {
                            for (VitalSignDTO dto in listHeartRate) {
                              listValue += dto.value1.toString() + ',';
                              listTime += dto.toDatePush() + ',';
                            }
                          }
                          //

                          countGetList++;
                          print('list value: $listValue');
                          print('list time: $listTime');
                          VitalSignPushDTO vitalSignPush = VitalSignPushDTO(
                            // vitalSignScheduleId:
                            //     heartRateSchedule.vitalSignScheduleId,
                            // currentDate:
                            //     DateTime.now().toString().split(' ')[0],
                            patientId: _patientId,
                            vitalSignTypeId: 1,
                            numberValue: listValue,
                            timeValue: listTime,
                          );
                          print(
                              'DTO HEREEE: \nnumberValue: ${vitalSignPush.numberValue}\ntimeValue: ${vitalSignPush.timeValue}');

                          print(
                              '\n\nJSON OBJECT: \n\n ${vitalSignPush.toJson().toString()}\n\n');
                          await _vitalSignServerRepository
                              .pushVitalSign(vitalSignPush)
                              .then((isSuccess) {
                            if (isSuccess) {
                              print('SUCCESSFUL PUSH DATA HEART RATE');
                            } else {
                              print('FAILED TO PUSH DATA HEART RATE');
                            }
                          });
                        });

                        //
                        //CHANGE STATUS PEOPLE
                        await notificationRepository
                            .changePersonalStatus(_patientId, 'DANGER')
                            .then((isSuccess) async {
                          // print('patient id before change? $_patientId');
                          // print('CHANGE STATUS DANGER IS? ${isSuccess}');
                          if (isSuccess) {
                            //
                            //NOTI
                            NotificationPushDTO notiPushDTO =
                                NotificationPushDTO(
                                    deviceType: 2,
                                    notificationType: 2,
                                    recipientAccountId:
                                        _vitalSignScheduleDTO.doctorAccountId,
                                    senderAccountId: _accountId);
                            await notificationRepository
                                .pushNotification(notiPushDTO);
                            print(
                                'CHECK TO OBJECT NOTIFICATION: !!!!!!!!!!!!senderAccountId: ${_accountId}');
                            //KICK VARIABLE CHECK DANGER TO NORMAL
                            await _vitalSignHelper.updateCheckToNormal(true);
                            print('update people to danger successful');
                          }
                        });

                        /////////////

                      }
                      // set into 0 when normal
                      if (countDown >= heartRateSchedule.minuteDangerInterval) {
                        await vitalSignHelper.updateCountDownDangerous(0);
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
                    //NORMAL HEART RATE. RESET DANGEROUS BACK TO 0
                    if (countDown > 0) {
                      await vitalSignHelper.updateCountDownDangerous(0);
                    }
                    print('NORMAL HR. COUNT DOWN DANGEROUS IS ${countDown}');
                    //
                    await vitalSignHelper
                        .isCheckToNormal()
                        .then((isCheckToNormal) async {
                      //
                      if (isCheckToNormal == true) {
                        print('CHECK DANGER TO MORNAL IS KICKED ON');

                        ///COUNT TO NORMAL
                        await vitalSignHelper
                            .getCountToNormal()
                            .then((countToNormal) async {
                          //
                          await vitalSignHelper
                              .updateCountToNormal(countToNormal += 1);

                          ///
                          print(
                              'COUNT TO NORMAL IS ${countToNormal} at ${DateTime.now()}');
                          if (countToNormal >=
                              heartRateSchedule.minuteNormalInterval) {
                            //UPDATE NORMAL STATUS
                            await notificationRepository
                                .changePersonalStatus(_patientId, 'NORMAL')
                                .then((isSuccess) async {
                              //
                              if (isSuccess) {
                                await _vitalSignHelper
                                    .updatePeopleStatus('NORMAL')
                                    .then((isOk) {
                                  if (isOk) {
                                    ReceiveNotification notiData =
                                        ReceiveNotification(
                                            id: 0,
                                            title: "reload heart rate",
                                            body: "",
                                            payload: "");
                                    HeartRefreshBloc.instance
                                        .newNotification(notiData);
                                  }
                                });
                                print(
                                    'Updated normal people status successful!');
                                //UPDATE VARIABLE CHECK DANGEROUS TO NORMAL = FALSE
                                //
                                //PUSH NOTI TO NORMAL
                                //PUSH NOTI
                                NotificationPushDTO notiPushDTO =
                                    NotificationPushDTO(
                                        deviceType: 2,
                                        notificationType: 17,
                                        recipientAccountId:
                                            _vitalSignScheduleDTO
                                                .doctorAccountId,
                                        senderAccountId: _accountId);
                                await notificationRepository
                                    .pushNotification(notiPushDTO);
                                await _vitalSignHelper
                                    .updateCheckToNormal(false);
                              }
                            });
                          }
                          if (countToNormal >=
                              heartRateSchedule.minuteNormalInterval) {
                            await vitalSignHelper.updateCountToNormal(0);
                            await _vitalSignHelper.updateCheckToNormal(false);
                          }
                        });
                      }
                    });
                  });
                }
              } else {
                //DANGEROUS IS COUNTING BUT LOSE DEVICE CONNECTION
                //
                await vitalSignHelper
                    .getCountDownDangerous()
                    .then((countDown) async {
                  //
                  if (dangerPlus == 0) {
                    //
                    if (countDown > 0) {
                      //
                      print(
                          'lose bluetooth connection AND the last people status is dangerous');
                      await vitalSignHelper
                          .updateCountDownDangerous(countDown += 1);
                      print(
                          'DANGEROUS HR (LOSE DEVICE CONNECTION). COUNT DOWN DANGEROUS IS ${countDown}');
                      if (countDown == heartRateSchedule.minuteDangerInterval) {
                        ////////////////////////
                        //LOCAL EXECUTE HERE
                        //
                        var dangerousNotification = {
                          "notification": {
                            "title": "Sinh hiệu bất thường",
                            "body": "Nhịp tim của bạn có dấu hiệu bất thường.",
                          },
                          "data": {
                            "NAVIGATE_TO_SCREEN": RoutesHDr.MAIN_HOME,
                          }
                        };
                        _handleGeneralMessage(dangerousNotification);
                        await _vitalSignHelper
                            .updatePeopleStatus('DANGER')
                            .then((isOk) {
                          if (isOk) {
                            ReceiveNotification notiData = ReceiveNotification(
                                id: 0,
                                title: "reload heart rate",
                                body: "",
                                payload: "");
                            HeartRefreshBloc.instance.newNotification(notiData);
                          }
                        });
                        ////////////////////////
                        //SERVER EXECUTE HERE
                        //CHANGE STATUS PEOPLE
                        await notificationRepository
                            .changePersonalStatus(_patientId, 'DANGER')
                            .then((isSuccess) async {
                          if (isSuccess) {
                            NotificationPushDTO notiPushDTO =
                                NotificationPushDTO(
                                    deviceType: 2,
                                    notificationType: 2,
                                    recipientAccountId:
                                        _vitalSignScheduleDTO.doctorAccountId,
                                    senderAccountId: _accountId);
                            print(
                                'CHECK TO OBJECT NOTIFICATION: !!!!!!!!!!!!senderAccountId: ${_accountId}');
                            //
                            //PUSH NOTI
                            await notificationRepository
                                .pushNotification(notiPushDTO);
                            print('update people to danger successful');
                          }
                        });

                        //

                      }
                      // // set into 0 when normal
                      // if (countDown >= heartRateSchedule.minuteDangerInterval) {
                      //   await vitalSignHelper.updateCountDownDangerous(0);
                      // }
                      //
                    } else {
                      print(
                          'lose bluetooth connection but the last people status is normal');
                      FlutterBlue.instance.state.listen((state) async {
                        print('state is ${state}');
                        if (state == BluetoothState.on) {
                          //
                          Future.delayed(const Duration(seconds: 1), () async {
                            //
                            await _connectFirstOpenApp();
                          });
                        }
                      });
                    }
                    dangerPlus++;
                  }
                });
              }
            });
            countLastValue++;
          }
        }

        //

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
    if (!prefs.containsKey('DANGER_TO_NORMAL')) {
      _vitalSignHelper.initialCheckToNormal();
    }
    if (!prefs.containsKey('COUNT_TO_NORMAL')) {
      _vitalSignHelper.initialCountToNormal();
    }
    if (!prefs.containsKey('AVAILABLE_DAY_CONTRACT')) {
      contractHelper.initialAvailableDay();
    }
    if (!prefs.containsKey('CHECK_TO_CREATE_OR_LIST')) {
      _medicalInstructionHelper.initialCheckToCreateOrList();
    }
    if (!prefs.containsKey('CHECK_CREATE_FROM_LIST')) {
      _medicalInstructionHelper.initialCreateHRFromDetail();
    }
    if (!prefs.containsKey('DOCTOR_ACCOUNT_ID')) {
      _doctorHelper.initialDoctor();
    }
    if (!prefs.containsKey('STATUS_PEOPLE')) {
      _vitalSignHelper.initialPeopleStatus();
    }
    if (!prefs.containsKey('BLUETOOTH_CONNECTION')) {
      _reminderHelper.initialBluetoothConnection();
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
        value = 'NO ID PERIPHERAL';
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
        print('on launch msg: ${message.values}');
        if (message.values.contains('Bạn có một lịch đo sinh hiệu mới')) {
          //
          await _saveVitalSignScheduleOffline();
        }
        // if (message.containsValue('Bạn có một lịch đo sinh hiệu mới')) {
        //   //DO INSERT LOCAL DB VITAL SIGN SCHEDULE
        //   //
        //   await _saveVitalSignScheduleOffline();
        //   print('CATCHED THIS NOTI TO PUSH NEW SCHEDULE');
        // }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        print('on launch msg: ${message.values}');
        if (message.values.contains('Bạn có một lịch đo sinh hiệu mới')) {
          //
          await _saveVitalSignScheduleOffline();
        }
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
    // localNotifyManager.setNotificationnOnClick(selectNotificationSubject);
  }

  onNotificationReceive(message) {
    print('message: $message');
    String payload = jsonEncode(message);
    ReceiveNotification notiData;

    if (Platform.isIOS) {
      final dynamic notification = message['aps']['alert'];
      notiData = ReceiveNotification(
          id: 0,
          title: notification["title"],
          body: notification["body"],
          payload: payload);

      NotificationsBloc.instance.newNotification(notiData);
    }
    if (Platform.isAndroid) {
      if (message.containsKey('data')) {
        final dynamic data = message['data'];
        payload = jsonEncode(data);
      }
      final dynamic notification = message['notification'];
      notiData = ReceiveNotification(
          id: 0,
          title: notification["title"],
          body: notification["body"],
          payload: payload);

      NotificationsBloc.instance.newNotification(notiData);
    }

    if (notiData.title.toLowerCase().contains('lịch') ||
        notiData.title.toLowerCase().contains('hẹn')) {
      getCalendarAppointment();
    }

    _saveVitalSignScheduleOffline();
    if (notiData.body.contains('Bạn có một lịch đo sinh hiệu mới')) {
      _saveVitalSignScheduleOffline();
      print('CATCHED THIS NOTI TO DOWNLOAD NEW SCHEDULE');
    }
    //
    //
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
          BlocProvider<BatteryDeviceBloc>(
            create: (BuildContext context) =>
                BatteryDeviceBloc(peripheralRepository: _peripheralRepository),
          ),
          BlocProvider<VitalSignBloc>(
            create: (BuildContext context) => VitalSignBloc(
                vitalSignRepository: _vitalSignRepository,
                sqfLiteHelper: _sqfLiteHelper),
          ),
          // BlocProvider<VitalSignDangerousBloc>(
          //   create: (BuildContext context) =>
          //       VitalSignDangerousBloc(sqfLiteHelper: _sqfLiteHelper),
          // ),
          BlocProvider<VitalScheduleBloc>(
            create: (BuildContext context) => VitalScheduleBloc(
                vitalSignServerRepository: _vitalSignServerRepository),
          ),
          BlocProvider<DoctorListBloc>(
            create: (BuildContext context) =>
                DoctorListBloc(doctorrepository: _doctorRepository),
          ),
          BlocProvider<ActivityBloc>(
            create: (BuildContext context) =>
                ActivityBloc(activityRepository: _activityRepository),
          ),
          BlocProvider<VitalSignDetailBloc>(
            create: (BuildContext context) => VitalSignDetailBloc(
                vitalSignServerRepository: _vitalSignServerRepository),
          ),
          BlocProvider<VitalSignSyncBloc>(
            create: (BuildContext context) => VitalSignSyncBloc(
                vitalSignSyncRepository: _vitalSignSyncRepository),
          ),
          BlocProvider<MedInsTypeReqListBloc>(
            create: (BuildContext context) => MedInsTypeReqListBloc(
                medicalInstructionRepository: _medicalInstructionRepository),
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
              // localizationsDelegates: [
              //   // ... app-specific localization delegate[s] here
              //   // GlobalMaterialLocalizations.delegate,
              //   // GlobalWidgetsLocalizations.delegate,
              //   DefaultCupertinoLocalizations.delegate,
              // ],
              // supportedLocales: [
              //   const Locale('en', 'US'), // English
              //   const Locale('vi', 'VI'),
              //   // ... other locales the app supports
              // ],
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
                // RoutesHDr.CHAT: (context) => ChatScreen(),
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
                RoutesHDr.UPDATE_HEALTH_RECORD: (context) =>
                    UpdateHealthRecord(),
                RoutesHDr.HEALTH_RECORD_DETAIL: (context) =>
                    HealthRecordDetail(),
                RoutesHDr.HEART: (context) => HeartDetailView(),
                RoutesHDr.MEDICINE_NOTI_VIEW: (context) =>
                    ScheduleMedNotiView(),
                RoutesHDr.MEDICAL_SHARE: (context) => MedicalShare(),

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
                RoutesHDr.ACTIVITY_VIEW: (context) => ActivityView(),
                RoutesHDr.ACTIVITY_TIME_VIEW: (context) => ActivityTimeView(),
                RoutesHDr.VITAL_SIGN_CHART_DETAIL: (context) =>
                    VitalSignChartDetail(),
              },
              localizationsDelegates: [
                // ... app-specific localization delegate[s] here
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en'), // English
                const Locale('vi'), // Vietnamese
              ],
              home: _startScreen,
            ),
          ),
        ));
  }

  _doNothing() {
    //
  }
}
