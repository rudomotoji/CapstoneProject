import 'dart:async';
import 'dart:convert';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_sign_state.dart';
import 'package:capstone_home_doctor/models/vital_sign_detail_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

class VitalSignChartDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VitalSignChartDetail();
  }
}

final SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();

class _VitalSignChartDetail extends State<VitalSignChartDetail>
    with WidgetsBindingObserver {
  //
  VitalSignBloc _vitalSignBloc;
  String vital_type = 'HEART_RATE';
  List<int> listValueMap = [];
  List<String> listTimeXAxis = [];
  int _patientId = 0;

  int minVitalSignValue = 0;
  int maxVitalSignValue = 0;
  int everageVitalSignValue = 0;
  int _lastValueVitalSign = 0;

  VitalSignDetailDTO _vitalSignDetailDTO = VitalSignDetailDTO();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPatientId();
    _vitalSignBloc = BlocProvider.of(context);

    getDataFromJSONFile();
  }

  Future<void> getDataFromJSONFile() async {
    final String response = await rootBundle.loadString('assets/global.json');

    if (response.contains('vitalSign')) {
      final data = await json.decode(response);
      _vitalSignDetailDTO = VitalSignDetailDTO.fromJson(data['vitalSign']);

      // minVitalSignValue = _vitalSignDetailDTO.vitalSigns.first.numberMin;
      // maxVitalSignValue = _vitalSignDetailDTO.vitalSigns.first.numberMax;
      //
      minVitalSignValue = 70;
      maxVitalSignValue = 90;
      //
      var listTime =
          _vitalSignDetailDTO.vitalSignValues.heartBeatTimeValue.split(',');
      var listValue =
          _vitalSignDetailDTO.vitalSignValues.heartBeatNumberValue.split(',');

      listTime.removeLast();
      listValue.removeLast();

      listValueMap = listValue.map((data) => int.parse(data)).toList();
      listTimeXAxis = listTime.map((e) => '${e}');
    }
  }

  Future _getPatientId() async {
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
              title: 'Chi tiết sinh hiệu',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _getPatientId,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                    ),
                    heartChart(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  heartChart() {
    return Column(
      children: <Widget>[
        Divider(
          color: DefaultTheme.GREY_TOP_TAB_BAR,
          height: 0.5,
        ),
        (listTimeXAxis != null)
            ? new Container(
                width: MediaQuery.of(context).size.width,
                color: DefaultTheme.WHITE,
                height: 430,
                child: Column(
                  children: [
                    Container(
                      child: new Echarts(
                        option: '''
                                    {
                                      color: ['#FF784B'],
                                      tooltip: {
                                        trigger: "axis",
                                        axisPointer: {
                                          type: "shadow"
                                      }
                                  },
                                      xAxis: {
                                        axisTick: {
                                          alignWithLabel: true
                                        },
                                        gridIndex: 0,
                                          axisLine: {
                                            lineStyle: {
                                              color: '#303030',
                                            },
                                          },
                                        name: 'GIỜ',
                                        type: 'category',
                                        data: $listTimeXAxis,
                                        show: true,
                                        nameTextStyle: {
                                          align: "center",
                                          color: "#FF784B",
                                          fontSize: 10
                                        }
                                    },
                                    yAxis: {
                                      name: 'BPM',
                                      nameTextStyle: {
                                      verticalAlign: "middle",
                                      color: "#FF784B"
                                      },
                                      axisTick: {
                                        show: false
                                      },
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
                                    visualMap: {
                                      show: false,
                                          pieces: [{
                                              gt: 0,
                                              lte: $minVitalSignValue,
                                              color: '#FF0A0A'
                                          }, {
                                              gt: $minVitalSignValue,
                                              lte: $maxVitalSignValue,
                                              color: '#9BA5B9'
                                          }, {
                                              gt: $maxVitalSignValue,
                                              color: '#FF0A0A'
                                          }],
                                      },
                                      series: [{
                                        name: 'Nhịp tim',
                                        data: $listValueMap,
                                        type: 'line',
                                        markLine: {
                                          silent: true,
                                          lineStyle: {
                                              color: '#333'
                                          },
                                          data: [{
                                              yAxis: $minVitalSignValue
                                          }, {
                                              yAxis: $maxVitalSignValue
                                          }]
                                        }
                                      },]
                                    }
                                  ''',
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                    ),
                  ],
                ),
              )
            : Container(),
        Divider(
          color: DefaultTheme.GREY_TOP_TAB_BAR,
          height: 0.5,
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
                color: DefaultTheme.WHITE,
                border: Border.all(
                    color: DefaultTheme.GREY_TOP_TAB_BAR, width: 0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Thấp nhất',
                    style: TextStyle(color: DefaultTheme.ORANGE_TEXT),
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
                color: DefaultTheme.WHITE,
                border: Border.all(
                    color: DefaultTheme.GREY_TOP_TAB_BAR, width: 0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Cao nhất',
                    style: TextStyle(color: DefaultTheme.ORANGE_TEXT),
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
        Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
      ],
    );
  }
}
