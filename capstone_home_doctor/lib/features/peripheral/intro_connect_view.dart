import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class IntroConnectDevice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IntroConnectDevice();
  }
}

class _IntroConnectDevice extends State<IntroConnectDevice>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: '',
              isMainView: false,
            ),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 500,
                child: Image.asset('assets/images/img-device.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Kết nối thiết bị',
                style: TextStyle(
                  color: DefaultTheme.BLACK,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 40, left: 40, right: 40),
              child: Text(
                'Thông tin về sức khoẻ của bạn được ghi nhận xuyên suốt thông qua thiết bị kết nối',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DefaultTheme.GREY_TEXT,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ButtonHDr(
              style: BtnStyle.BUTTON_BLACK,
              label: 'Tiếp theo',
              onTap: () {
                Navigator.pushNamed(context, RoutesHDr.CONNECT_PERIPHERAL);
              },
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
            ),
          ],
        ),
      ),
    );
  }
}
