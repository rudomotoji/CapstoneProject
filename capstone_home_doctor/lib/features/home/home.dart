import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';
import 'package:capstone_home_doctor/features/activity/view/activity_view.dart';
import 'package:capstone_home_doctor/features/background/repositories/background_repository.dart';
import 'package:capstone_home_doctor/features/dashboard/dashboard.dart';
import 'package:capstone_home_doctor/features/health/health.dart';
import 'package:capstone_home_doctor/features/health/health_record/views/profile.dart';
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
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:capstone_home_doctor/services/medical_instruction_helper.dart';
import 'package:capstone_home_doctor/services/notifications_bloc.dart';
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
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final PeripheralHelper _peripheralHelper = PeripheralHelper();
final VitalSignHelper vitalSignHelper = VitalSignHelper();
final VitalSignRepository _vitalSignRepository = VitalSignRepository();
final BackgroundRepository _backgroundRepository =
    BackgroundRepository(httpClient: http.Client());
final VitalSignServerRepository _vitalSignServerRepository =
    VitalSignServerRepository(httpClient: http.Client());

final MedicalInstructionHelper _medicalInstructionHelper =
    MedicalInstructionHelper();

// //
// final FirebaseMessaging _fcm = FirebaseMessaging();
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
  int arguments = 0;

  int count = 0;
  //for check connection
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Stream<ReceiveNotification> _notificationsStream;
  final ContractHelper _contractHelper = ContractHelper();

  @override
  void initState() {
    super.initState();
    _initialServiceHelper();
    _notificationListBloc = BlocProvider.of(context);
    _peripheralBloc = BlocProvider.of(context);
    _vitalSignBloc = BlocProvider.of(context);
    _getPatientId();
    _getAccountId();

    //
    selectNotificationSubject.stream.listen((String payload) async {
      print('payload');

      var navigate = jsonDecode(payload);
      if (payload.contains('NAVIGATE_TO_SCREEN')) {
        await Navigator.pushNamed(context, navigate['NAVIGATE_TO_SCREEN']);
      }

      print('payload home page: $payload');
      if (payload.contains('notiTypeId')) {
        int notificationType = navigate['notiTypeId'];
        int contractId = navigate['contractId'];
        int medicalInstructionId = navigate['medicalInstructionId'];
        int appointmentId = navigate['appointmentId'];

        if (notificationType == 1 ||
            notificationType == 4 ||
            notificationType == 5 ||
            notificationType == 9 ||
            notificationType == 10) {
          //Navigate hợp đồng detail
          if (contractId != null) {
            await _contractHelper.updateContractId(contractId);

            Navigator.of(context).pushNamed(RoutesHDr.DETAIL_CONTRACT_VIEW);
          }
        } else if (notificationType == 2) {
          //Navigate Screen overview
          //
        } else if (notificationType == 7) {
          //Navigate Lịch sinh hiệu
          //
          int currentIndex = 1;
          Navigator.of(context).pushNamedAndRemoveUntil(
              RoutesHDr.MAIN_HOME, (Route<dynamic> route) => false,
              arguments: currentIndex);
        } else if (notificationType == 6) {
          //Navigate thuốc detail
          //
          Navigator.pushNamed(context, RoutesHDr.MEDICAL_HISTORY_DETAIL,
              arguments: medicalInstructionId);
        } else if (notificationType == 8) {
          //Navigate hẹn hẹn detail
          //
          int _indexPage = 1;
          Navigator.of(context)
              .pushNamed(RoutesHDr.SCHEDULE, arguments: _indexPage);
        } else if (notificationType == 12) {
          //Navigate share medical instruction
          //

        } else if (notificationType == 11) {
          //Navigate connect device screen
          //
          Navigator.of(context).pushNamed(RoutesHDr.INTRO_CONNECT_PERIPHERAL);
        }
      }
    });

    _notificationsStream = NotificationsBloc.instance.notificationsStream;
    _notificationsStream.listen((notification) {
      _getAccountId();
    });

    //check wifi/mobile or offline connection
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  //handle local notification for danger heart rate

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      _patientId = value;
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
    if (count == 0) {
      setState(() {
        arguments = ModalRoute.of(context).settings.arguments;
        if (arguments != null) {
          _currentIndex = arguments;
        } else {}
      });
      count++;
    } else {
      arguments = null;
    }

    final List<Widget> _widgetOptions = [
      DashboardPage(),
      HealthPage(),
      // MessagePage(),
      ProfileTab(),
      ActivityView(),
      NotificationPage(),
    ];

    print('connection status: ${_connectionStatus}');
    return (_connectionStatus == 'ConnectivityResult.wifi' ||
            _connectionStatus == 'ConnectivityResult.mobile')
        ? BlocBuilder<NotificationListBloc, NotificationListState>(
            builder: (context, state) {
              countNoti = 0;
              if (state is NotificationListStateSuccess) {
                if (state.listNotification == null) {
                  return _offlineView(_widgetOptions);
                }
                // else {
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
              return _onlineGetNotiView(_widgetOptions);
            },
          )
        : _offlineView(_widgetOptions);
  }

  _onlineGetNotiView(List<Widget> widgetOption) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('ssss'),
      // ),
      body: Center(
        child: widgetOption.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: DefaultTheme.GREY_TAB_BAR,
        elevation: 1,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedLabelStyle: TextStyle(fontSize: 12, color: DefaultTheme.BLACK),
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
            label: 'Trang chủ',
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
            label: 'Sức khoẻ',
          ),
          BottomNavigationBarItem(
            icon: new Image.asset(
              'assets/images/ic-health-record-u.png',
              height: 30,
              width: 30,
            ),
            activeIcon: new Image.asset(
              'assets/images/ic-health-record.png',
              height: 30,
              width: 30,
            ),
            label: 'Hồ sơ',
          ),
          BottomNavigationBarItem(
            icon: new Image.asset(
              'assets/images/ic-acti-u.png',
              height: 30,
              width: 30,
            ),
            activeIcon: new Image.asset(
              'assets/images/ic-acti.png',
              height: 30,
              width: 30,
            ),
            label: 'Hoạt động',
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
                                    color: DefaultTheme.WHITE, fontSize: 10),
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
            label: 'Thông báo',
          ),
        ],
        onTap: (index) {
          setState(() {
            print('index: $index');
            arguments = null;
            _currentIndex = 0;
            _currentIndex = index;
          });
        },
      ),
    );
  }

  _offlineView(List<Widget> widgetOption) {
    return Scaffold(
      body: Center(
        child: widgetOption.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: DefaultTheme.GREY_TAB_BAR,
        selectedLabelStyle: TextStyle(fontSize: 12, color: DefaultTheme.BLACK),
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
            label: 'Trang chủ',
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
              label: 'Sức khoẻ'),
          BottomNavigationBarItem(
            icon: new Image.asset(
              'assets/images/ic-health-record-u.png',
              height: 30,
              width: 30,
            ),
            activeIcon: new Image.asset(
              'assets/images/ic-health-record.png',
              height: 30,
              width: 30,
            ),
            label: 'Hồ sơ',
          ),
          BottomNavigationBarItem(
              icon: new Image.asset(
                'assets/images/ic-acti-u.png',
                height: 30,
                width: 30,
              ),
              activeIcon: new Image.asset(
                'assets/images/ic-acti.png',
                height: 30,
                width: 30,
              ),
              label: 'Hoạt động'),
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
            label: 'Thông báo',
          ),
        ],
        onTap: (index) {
          _getAccountId();
          setState(() {
            arguments = null;
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
