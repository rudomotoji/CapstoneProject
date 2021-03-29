import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';
import 'package:capstone_home_doctor/features/background/repositories/background_repository.dart';
import 'package:capstone_home_doctor/features/dashboard/dashboard.dart';
import 'package:capstone_home_doctor/features/health/health.dart';
import 'package:capstone_home_doctor/features/message/message.dart';
import 'package:capstone_home_doctor/features/notification/blocs/notification_list_bloc.dart';
import 'package:capstone_home_doctor/features/notification/events/notification_list_event.dart';
import 'package:capstone_home_doctor/features/notification/states/notification_list_state.dart';
import 'package:capstone_home_doctor/features/notification/views/notification_view.dart';
import 'package:capstone_home_doctor/features/peripheral/blocs/peripheral_bloc.dart';
import 'package:capstone_home_doctor/features/peripheral/events/peripheral_event.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repository.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_repository.dart';
import 'package:capstone_home_doctor/models/notification_dto.dart';
import 'package:capstone_home_doctor/models/setting_background_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_schedule_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:capstone_home_doctor/services/vital_sign_helper.dart';
import 'package:flutter/material.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cron/cron.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:http/http.dart' as http;
//
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final PeripheralHelper _peripheralHelper = PeripheralHelper();
final VitalSignHelper vitalSignHelper = VitalSignHelper();
final VitalSignRepository _vitalSignRepository = VitalSignRepository();
final BackgroundRepository _backgroundRepository =
    BackgroundRepository(httpClient: http.Client());
final VitalSignServerRepository _vitalSignServerRepository =
    VitalSignServerRepository(httpClient: http.Client());

//
final FirebaseMessaging _fcm = FirebaseMessaging();
//

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  var uuid = Uuid();
  int _currentIndex = 0;
  int _accountId = 0;
  NotificationListBloc _notificationListBloc;
  PeripheralBloc _peripheralBloc;
  VitalSignBloc _vitalSignBloc;
  int countNoti = 0;
  int _patientId = 0;

  //for check connection
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initialServiceHelper();
    _notificationListBloc = BlocProvider.of(context);
    _peripheralBloc = BlocProvider.of(context);
    _vitalSignBloc = BlocProvider.of(context);
    _getPatientId();
    _getAccountId();
    //connect device for 1st time and when bluetooth is on
    FlutterBlue.instance.state.listen((state) async {
      if (state == BluetoothState.on) {
        if (_patientId != 0) {
          await _connectFirstOpenApp();
        }
      }
    });
    selectNotificationSubject.stream.listen((String payload) async {
      print(payload);
      var navigate = jsonDecode(payload);
      _getAccountId();
      await Navigator.pushNamed(context, navigate['NAVIGATE_TO_SCREEN']);
    });

    final Cron cron = new Cron()
      ..schedule(Schedule.parse('* * * * * '), () async {
        print('At ${DateTime.now()} to Check Bluetooth funcs background');
        int countConnectBg = 0;

        //test local noti
        // var dangerousNotification = {
        //   "notification": {
        //     "title": "Sinh hiệu bất thường",
        //     "body":
        //         "Nhịp tim của bạn có dấu hiệu bất thường.\n150 BPM vào lúc ${DateTime.now().toString().split(' ')[1].split('.')[0]}",
        //   },
        //   "data": {
        //     "NAVIGATE_TO_SCREEN": RoutesHDr.HEART,
        //   }
        // };
        // _handleGeneralMessage(dangerousNotification);
        await _authenticateHelper.getPatientId().then((pIdCron) async {
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

    //

    //check wifi/mobile or offline connection
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    //local notification
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true));
      _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        // print("Settings registered: $settings");
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
    localNotifyManager.setNotificationnOnClick(selectNotificationSubject);
    //
  }

  //handle local notification for danger heart rate

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

  _connectFirstOpenApp() async {
    await _peripheralHelper.getPeripheralId().then((value) async {
      if (value != '') {
        _peripheralBloc
            .add(PeripheralEventConnectBackground(peripheralId: value));
      }
    });
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      _patientId = value;
    });
  }

  //insert hr into db
  _insertHeartRateIntoDb() {
    vitalSignHelper.getHeartRateValue().then((heartRateValue) {
      setState(() {
        if (heartRateValue != 0 && _patientId != 0) {
          VitalSignDTO vitalSignDTO = VitalSignDTO(
            id: uuid.v1(),
            patientId: _patientId,
            valueType: 'HEART_RATE',
            value1: heartRateValue,
            value2: null,
            dateTime: DateTime.now().toString(),
          );
          _vitalSignBloc.add(VitalSignEventInsert(dto: vitalSignDTO));
        }
      });
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
        _vitalSignBloc.add(
            VitalSignEventGetHeartRateFromDevice(peripheralId: peripheralId));

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
            if (timeToInsertLocalDB > timeInsert) {
              //reset space time to 0 and count space time again
              await vitalSignHelper.updateCountingHR(0);
            }
            insertPlus++;
          }
        });
        //
        //
        if (_patientId != 0) {
          // print('patient ID before get vital sign schedule ${_patientId}');
          //
          await _vitalSignServerRepository
              .getVitalSignSchedule(_patientId)
              .then((vitalSignSchedule) async {
            //
            print(
                'vital sign schedule now ${vitalSignSchedule.medicalInstructionId}');
            if (vitalSignSchedule == null ||
                vitalSignSchedule.medicalInstructionId == null) {
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
                            }
                            if (countDown > scopeHearRate.dangerousCount) {
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
              VitalSigns heartRateSchedule = vitalSignSchedule.vitalSigns
                  .where((item) => item.vitalSignType == 'Nhịp tim')
                  .first;
              print(
                  'Heart rate schedule: min ${heartRateSchedule.numberMin}-${heartRateSchedule.numberMax}');
              if (countLastValue == 0) {
                //
                await vitalSignHelper.getHeartRateValue().then((value) async {
                  //
                  if (value != 0) {
                    //TÍ SỬA CÁI NÀY GẤP. ĐỔI DẤU LẠI
                    if (value > heartRateSchedule.numberMin ||
                        value < heartRateSchedule.numberMax) {
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
                            //
                            //           NotificationPushDTO notiPushDTO = NotificationPushDTO(
                            //               deviceType: 2,
                            //               notificationType: 2,
                            //               recipientAccountId: 2,
                            //               senderAccountId: _accountId);
                            //PUSH NOTI
                            //           _notificationListBloc
                            //               .add(NotiPushEvent(notiPushDTO: notiPushDTO));

                            //           //
                            //CHANGE STATUS PEOPLE
                            //           _notificationListBloc.add(NotiChangePeopleStatusEvent(
                            //               patientId: _patientId, status: 'DANGER'));
                            //           await vitalSignHelper.updateCountDownDangerous(0);
                            //         }
                          }
                          if (countDown >
                              heartRateSchedule.minuteDangerInterval) {
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
                        //
                        if (countDown > 0) {
                          await vitalSignHelper
                              .updateCountDownDangerous(countDown -= 1);
                        }
                        print(
                            'NORMAL HR. COUNT DOWN DANGEROUS IS ${countDown}');
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
          });
          //check default min-max heart rate
        }

        //

      } else {
        print('user logged in but not connect with peripheral');
      }
    });
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  _getAccountId() async {
    await _authenticateHelper.getAccountId().then((value) {
      _accountId = value;
    });
    if (_accountId != 0) {
      //print('accound id in home view to get noti count is ${_accountId}');
      _notificationListBloc
          .add(NotificationListEventGet(accountId: _accountId));
    }
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  Future<void> _initialServiceHelper() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.containsKey('NAVIGATOR')) {
    //   Navigator.pushNamed(context, prefs.getString('NAVIGATOR'));
    // }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = [
      DashboardPage(),
      HealthPage(),
      MessagePage(),
      NotificationPage(),
    ];

    print('connection status: ${_connectionStatus}');
    return (_connectionStatus == 'ConnectivityResult.wifi' ||
            _connectionStatus == 'ConnectivityResult.mobile')
        ? BlocBuilder<NotificationListBloc, NotificationListState>(
            builder: (context, state) {
              countNoti = 0;
              if (state is NotificationListStateSuccess) {
                // if (state.listNotification == null) {
                //   print('having no list noti');
                // } else {
                //   print('get list noti success');
                // }
                for (NotificationDTO x in state.listNotification) {
                  for (int z = 0; z < x.notifications.length; z++) {
                    if (x.notifications[z].status == false) {
                      countNoti += 1;
                    }
                  }
                }
              }
              //
              return Scaffold(
                // appBar: AppBar(
                //   title: Text('ssss'),
                // ),
                body: Center(
                  child: _widgetOptions.elementAt(_currentIndex),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: DefaultTheme.GREY_TAB_BAR,
                  items: [
                    BottomNavigationBarItem(
                      icon: new Image.asset(
                        'assets/images/ic-dashboard.png',
                        height: 30,
                        width: 30,
                      ),
                      activeIcon: new Image.asset(
                        'assets/images/ic-dashboard-selected.png',
                        height: 30,
                        width: 30,
                      ),
                      title: Text(
                        'Trang chủ',
                        style: TextStyle(color: DefaultTheme.GREY_TEXT),
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: new Image.asset(
                        'assets/images/ic-health.png',
                        height: 30,
                        width: 30,
                      ),
                      activeIcon: new Image.asset(
                        'assets/images/ic-health-selected.png',
                        height: 30,
                        width: 30,
                      ),
                      title: Text(
                        'Sức khỏe',
                        style: TextStyle(color: DefaultTheme.GREY_TEXT),
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: new Image.asset(
                        'assets/images/ic-msg.png',
                        height: 30,
                        width: 30,
                      ),
                      activeIcon: new Image.asset(
                        'assets/images/ic-msg-selected.png',
                        height: 30,
                        width: 30,
                      ),
                      title: Text(
                        'Tin nhắn',
                        style: TextStyle(color: DefaultTheme.GREY_TEXT),
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        child: Stack(
                          children: [
                            new Image.asset(
                              'assets/images/ic-noti.png',
                              height: 30,
                              width: 30,
                            ),
                            (countNoti != 0)
                                ? Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        // color: DefaultTheme.RED_CALENDAR,
                                        gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              DefaultTheme.GRADIENT_5,
                                              DefaultTheme.RED_CALENDAR,
                                            ]),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${countNoti}',
                                          style: TextStyle(
                                              color: DefaultTheme.WHITE,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  )
                                : Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 0,
                                      height: 0,
                                    ),
                                  )
                          ],
                        ),
                      ),

                      //
                      activeIcon: new Stack(
                        children: [
                          new Image.asset(
                            'assets/images/ic-noti-selected.png',
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                      title: Text(
                        'Thông báo',
                        style: TextStyle(color: DefaultTheme.GREY_TEXT),
                      ),
                    ),
                  ],
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              );
            },
          )
        : Scaffold(
            // appBar: AppBar(
            //   title: Text('ssss'),
            // ),
            body: Center(
              child: _widgetOptions.elementAt(_currentIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: DefaultTheme.GREY_TAB_BAR,
              items: [
                BottomNavigationBarItem(
                  icon: new Image.asset(
                    'assets/images/ic-dashboard.png',
                    height: 30,
                    width: 30,
                  ),
                  activeIcon: new Image.asset(
                    'assets/images/ic-dashboard-selected.png',
                    height: 30,
                    width: 30,
                  ),
                  title: Text(
                    'Trang chủ',
                    style: TextStyle(color: DefaultTheme.GREY_TEXT),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: new Image.asset(
                    'assets/images/ic-health.png',
                    height: 30,
                    width: 30,
                  ),
                  activeIcon: new Image.asset(
                    'assets/images/ic-health-selected.png',
                    height: 30,
                    width: 30,
                  ),
                  title: Text(
                    'Sức khỏe',
                    style: TextStyle(color: DefaultTheme.GREY_TEXT),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: new Image.asset(
                    'assets/images/ic-msg.png',
                    height: 30,
                    width: 30,
                  ),
                  activeIcon: new Image.asset(
                    'assets/images/ic-msg-selected.png',
                    height: 30,
                    width: 30,
                  ),
                  title: Text(
                    'Tin nhắn',
                    style: TextStyle(color: DefaultTheme.GREY_TEXT),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    child: Stack(
                      children: [
                        new Image.asset(
                          'assets/images/ic-noti.png',
                          height: 30,
                          width: 30,
                        ),
                      ],
                    ),
                  ),

                  //
                  activeIcon: new Stack(
                    children: [
                      new Image.asset(
                        'assets/images/ic-noti-selected.png',
                        height: 30,
                        width: 30,
                      ),
                    ],
                  ),
                  title: Text(
                    'Thông báo',
                    style: TextStyle(color: DefaultTheme.GREY_TEXT),
                  ),
                ),
              ],
              onTap: (index) {
                _getAccountId();
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          );
    ;
  }
}
