import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/features/dashboard/dashboard.dart';
import 'package:capstone_home_doctor/features/health/health.dart';
import 'package:capstone_home_doctor/features/message/message.dart';
import 'package:capstone_home_doctor/features/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initialServiceHelper();
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
                ],
              ),
            ),
            activeIcon: new Image.asset(
              'assets/images/ic-noti-selected.png',
              height: 30,
              width: 30,
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
  }
}
