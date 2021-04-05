import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'overview.dart';
import 'health_record/views/profile.dart';
import 'vitalsign.dart';

class HealthPage extends StatefulWidget {
  @override
  _HealthState createState() => _HealthState();
}

class _HealthState extends State<HealthPage> {
  int currentSegment = 0;

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final segmentedControlMaxWidth = MediaQuery.of(context).size.width - 40;
    final children = <int, Widget>{
      0: Text('Tổng quan'), //overview
      1: Text('Sinh hiệu'), //vitalsign
    };
    final List<Widget> childrenWidget = [
      OverviewTab(),
      VitalSignTab(),
    ];
    return CupertinoPageScaffold(
      child: DefaultTextStyle(
        // style: CupertinoTheme.of(context)
        //     .textTheme
        //     .textStyle
        //     .copyWith(fontSize: 13),
        style: TextStyle(color: DefaultTheme.BLACK_BUTTON),
        // style: TextStyle(color: DefaultTheme.GREY_LIGHT),
        child: SafeArea(
          child: Column(
            children: [
              HeaderWidget(
                title: 'Sức khoẻ',
                isMainView: true,
                buttonHeaderType: ButtonHeaderType.AVATAR,
              ),
              SizedBox(
                height: 60,
                width: segmentedControlMaxWidth,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                  child: CupertinoSlidingSegmentedControl<int>(
                    backgroundColor: DefaultTheme.GREY_TOP_TAB_BAR,
                    thumbColor: DefaultTheme.WHITE,
                    children: children,
                    onValueChanged: onValueChanged,
                    groupValue: currentSegment,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: ListView(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: childrenWidget.elementAt(currentSegment),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
