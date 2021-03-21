import 'dart:convert';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/features/dashboard/dashboard.dart';
import 'package:capstone_home_doctor/features/health/health.dart';
import 'package:capstone_home_doctor/features/message/message.dart';
import 'package:capstone_home_doctor/features/notification/blocs/notification_list_bloc.dart';
import 'package:capstone_home_doctor/features/notification/events/notification_list_event.dart';
import 'package:capstone_home_doctor/features/notification/states/notification_list_state.dart';
import 'package:capstone_home_doctor/features/notification/views/notification_view.dart';
import 'package:capstone_home_doctor/models/notification_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:flutter/material.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _currentIndex = 0;
  int _accountId = 0;
  NotificationListBloc _notificationListBloc;
  int countNoti = 0;

  @override
  void initState() {
    super.initState();
    _initialServiceHelper();
    _notificationListBloc = BlocProvider.of(context);
    _getAccountId();
    selectNotificationSubject.stream.listen((String payload) async {
      print(payload);
      var navigate = jsonDecode(payload);
      _getAccountId();
      await Navigator.pushNamed(context, navigate['NAVIGATE_TO_SCREEN']);
    });
  }

  _getAccountId() async {
    await _authenticateHelper.getAccountId().then((value) {
      _accountId = value;
    });
    if (_accountId != 0) {
      print('accound id in home view to get noti count is ${_accountId}');
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

    return BlocBuilder<NotificationListBloc, NotificationListState>(
      builder: (context, state) {
        countNoti = 0;
        if (state is NotificationListStateLoading) {}
        if (state is NotificationListStateFailure) {}
        if (state is NotificationListStateSuccess) {
          if (state.listNotification == null) {
            print('having no list noti');
          } else {
            print('get list noti success');
          }
          for (NotificationDTO x in state.listNotification) {
            for (int z = 0; z < x.notifications.length; z++) {
              if (x.notifications[z].status == false) {
                countNoti += 1;
              }
            }
          }
        }
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
    );
  }
}
