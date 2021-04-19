import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class UpdatePersonalInfo extends StatefulWidget {
  @override
  _UpdatePersonalInfoState createState() => _UpdatePersonalInfoState();
}

class _UpdatePersonalInfoState extends State<UpdatePersonalInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Cập nhật tài khoản',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.NONE,
            ),
            Expanded(
              child: ListView(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
