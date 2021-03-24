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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vitalSignBloc = BlocProvider.of(context);
    _refresh();
  }

  Future _refresh() {
    _vitalSignBloc.add(VitalSignEventGetList(type: vital_type));
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

                      listValue = state.list;

                      //state.list[0].toTimeString();
                      for (VitalSignDTO x in state.list) {
                        listValueMap += x.toValueString();
                        // listDateMap += x.toDateString();
                        String minHour = listValue.first.dateTime
                            .split(' ')[1]
                            .split(':')[0]
                            .toString();
                        int min = int.tryParse(minHour);
                        String maxHour = listValue.last.dateTime
                            .split(' ')[1]
                            .split(':')[0]
                            .toString();
                        int max = int.tryParse(maxHour);
                        int space = max - min;
                        listDateMap = '';
                        for (int i = min; i <= max; i++) {
                          listDateMap += i.toString() + ',';
                        }
                        // listDateMap = minHour + ',' + maxHour;
                      }
                    }
                    return Column(
                      children: <Widget>[
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
        type: 'category',
        data: [${listDateMap}]
      },
      yAxis: {
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
                          height: 500,
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
