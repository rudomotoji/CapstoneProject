import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'overview.dart';
import 'profile.dart';
import 'timeline.dart';
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
    final segmentedControlMaxWidth = 500.0;
    final children = <int, Widget>{
      0: Text('Tổng quan'), //overview
      1: Text('Timeline'), //timeline
      2: Text('Sinh hiệu'), //vitalsign
      3: Text('Hồ sơ'), //profile
    };
    final List<Widget> childrenWidget = [
      OverviewTab(),
      TimelineTab(),
      VitalSignTab(),
      ProfileTab(),
    ];
    return CupertinoPageScaffold(
      // navigationBar: CupertinoNavigationBar(
      //   automaticallyImplyLeading: false,
      //   middle: Text('asdasdasd'),
      // ),
      child: DefaultTextStyle(
        // style: CupertinoTheme.of(context)
        //     .textTheme
        //     .textStyle
        //     .copyWith(fontSize: 13),
        style: TextStyle(color: DefaultTheme.GREY_LIGHT),
        child: SafeArea(
          child: ListView(
            children: [
              HeaderWidget(
                title: 'Sức khoẻ',
                isMainView: true,
                buttonHeaderType: ButtonHeaderType.AVATAR,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: segmentedControlMaxWidth,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CupertinoSlidingSegmentedControl<int>(
                    backgroundColor: DefaultTheme.GREY_TOP_TAB_BAR,
                    thumbColor: Colors.white,
                    children: children,
                    onValueChanged: onValueChanged,
                    groupValue: currentSegment,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                // height: 300,
                alignment: Alignment.center,
                child: childrenWidget.elementAt(currentSegment),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
