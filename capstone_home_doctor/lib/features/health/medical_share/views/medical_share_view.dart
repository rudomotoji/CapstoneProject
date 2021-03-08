import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class MedicalShare extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MedicalShare();
  }
}

class _MedicalShare extends State<MedicalShare> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Chia sẻ bệnh án',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.NONE,
            ),
          ],
        ),
      ),
    );
  }
}
