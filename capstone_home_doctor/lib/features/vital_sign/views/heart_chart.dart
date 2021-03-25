import 'dart:async';

import 'package:capstone_home_doctor/commons/constants/peripheral_services.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/peripheral/blocs/hr_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_sign_state.dart';
import 'package:capstone_home_doctor/models/heart_rate_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

class HeartChart extends StatefulWidget {
  @override
  _HeartChartState createState() => _HeartChartState();
}

final SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();

class _HeartChartState extends State<HeartChart> with WidgetsBindingObserver {
  //
  VitalSignBloc _vitalSignBloc;
  String vital_type = 'HEART_RATE';
  String listValueMap = '';
  String listDateMap = '';
  List<VitalSignDTO> listValue = [];
  List<VitalSignDTO> listSortedValue = [];
  List<VitalSignDTO> listSortedDateTime = [];
  int _patientId = 0;

  int minVitalSignValue = 0;
  int maxVitalSignValue = 0;
  int everageVitalSignValue = 0;
  int _lastValueVitalSign = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPatientId();
    _vitalSignBloc = BlocProvider.of(context);
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        _patientId = value;
      });
      if (_patientId != 0) {
        _vitalSignBloc.add(
            VitalSignEventGetList(type: vital_type, patientId: _patientId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  BlocBuilder<VitalSignBloc, VitalSignState>(
                      builder: (context, state) {
                    //
                    if (state is VitalSignStateLoading) {
                      return Container(
                        width: 200,
                        height: 200,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset('assets/images/loading.gif'),
                        ),
                      );
                    }
                    if (state is VitalSignStateFailure) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Center(
                            child: Text('Không thể tải biểu đồ'),
                          ));
                    }
                    if (state is VitalSignStateGetListSuccess) {
                      listValueMap = '';
                      listDateMap = '';
                      listSortedDateTime = state.list;
                      listSortedValue = state.list;
                      if (null != listSortedValue) {
                        listSortedValue
                            .sort((a, b) => a.value1.compareTo(b.value1));
                        minVitalSignValue = listSortedValue.first.value1;
                        maxVitalSignValue = listSortedValue.last.value1;
                        everageVitalSignValue =
                            ((minVitalSignValue + maxVitalSignValue) / 2)
                                .toInt();
                      }
                      if (null != listSortedDateTime) {
                        listSortedDateTime
                            .sort((a, b) => a.dateTime.compareTo(b.dateTime));
                      }
                      for (VitalSignDTO x in listSortedDateTime) {
                        listDateMap = '';
                        listValueMap += x.toValueString();

                        int minTime = int.tryParse(
                            listSortedDateTime.first.toDateString());
                        int maxTime = int.tryParse(
                            listSortedDateTime.last.toDateString());
                        _lastValueVitalSign = listSortedDateTime.last.value1;
                        for (int i = minTime; i <= maxTime; i++) {
                          listDateMap += i.toString() + ',';
                        }
                      }
                      print('$listValueMap');
                    }
                    return Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              //
                              Text('Nhịp tim gần đây'),
                              Text('${_lastValueVitalSign} BPM'),
                              Text(
                                  '${listSortedDateTime.last.dateTime.split(' ')[1].split('.')[0]}'),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: DefaultTheme.WHITE,
                          height: 430,
                          child: Column(
                            children: [
                              Container(
                                child: Echarts(
                                  option: '''
    {
    
      color: ['#FF784B'],
      xAxis: {
        gridIndex: 0,
                        axisTick: {
                          show: false,
                        },
                        axisLine: {
                          lineStyle: {
                            color: '#303030',
                          },
                        },
        name: 'GIỜ',
        type: 'category',
        data: [${listDateMap}]
      },
      yAxis: {
         name: 'BPM',
        type: 'value',
        
                     
                      
                   
                        axisLine: {
                          lineStyle: {
                            color: '#303030',
                          },
                        },
                        axisLabel: {
                          color: '#303030',
                        },
      },
      series: [{
        data: [${listValueMap}],
        type: 'line'
      },]
    }
  ''',
                                ),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(right: 10),
                                height: 400,
                              ),
                              Text('Biểu đồ nhịp tim trong ngày'.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: DefaultTheme.ORANGE_TEXT,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Spacer(),
                            Container(
                              width: 100,
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: DefaultTheme.WHITE),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Thấp nhất',
                                    style: TextStyle(
                                        color: DefaultTheme.ORANGE_TEXT),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                  ),
                                  Text(
                                    '$minVitalSignValue',
                                    style: TextStyle(
                                      color: DefaultTheme.BLACK_BUTTON,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'BPM',
                                    style: TextStyle(
                                      color: DefaultTheme.GREY_TEXT,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Container(
                              width: 100,
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: DefaultTheme.WHITE),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Trung bình',
                                    style: TextStyle(
                                        color: DefaultTheme.ORANGE_TEXT),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                  ),
                                  Text(
                                    '$everageVitalSignValue',
                                    style: TextStyle(
                                      color: DefaultTheme.BLACK_BUTTON,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'BPM',
                                    style: TextStyle(
                                      color: DefaultTheme.GREY_TEXT,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Container(
                              width: 100,
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: DefaultTheme.WHITE),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Cao nhất',
                                    style: TextStyle(
                                        color: DefaultTheme.ORANGE_TEXT),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                  ),
                                  Text(
                                    '$maxVitalSignValue',
                                    style: TextStyle(
                                      color: DefaultTheme.BLACK_BUTTON,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'BPM',
                                    style: TextStyle(
                                      color: DefaultTheme.GREY_TEXT,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          height: 45,
                          child: ButtonHDr(
                            style: BtnStyle.BUTTON_BLACK,
                            label: 'Hiển thị thêm dữ liệu đo',
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutesHDr.VITALSIGN_HISTORY);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
