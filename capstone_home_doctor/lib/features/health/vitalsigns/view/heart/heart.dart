import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/health/vitalsigns/view/heart/heart_day.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Heart extends StatefulWidget {
  @override
  _HeartState createState() => _HeartState();
}

class _HeartState extends State<Heart> {
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
      0: Text('Ngày'),
      1: Text('Tháng'),
      2: Text('Năm'),
    };
    final List<Widget> childrenWidget = [
      HeartDay(),
      HeartDay(),
      HeartDay(),
    ];
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              HeaderWidget(
                title: 'Nhịp tim',
                isMainView: false,
                buttonHeaderType: ButtonHeaderType.BACK_HOME,
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
