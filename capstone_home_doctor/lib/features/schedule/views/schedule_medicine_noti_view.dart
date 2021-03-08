import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/models/medicine_scheduling_dto.dart';
import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:flutter/material.dart';

class ScheduleMedNotiView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScheduleMedNotiView();
  }
}

class _ScheduleMedNotiView extends State<ScheduleMedNotiView>
    with WidgetsBindingObserver {
  PrescriptionDTO _currentPrescription = PrescriptionDTO();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeaderWidget(
              title: 'Dùng thuốc',
              isMainView: false,
            ),
          ],
        ),
      ),
    );
  }
}
