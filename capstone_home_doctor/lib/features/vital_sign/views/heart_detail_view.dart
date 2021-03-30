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

class HeartDetailView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HeartDetailView();
  }
}

final SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();

class _HeartDetailView extends State<HeartDetailView>
    with WidgetsBindingObserver {
  //
  VitalSignBloc _vitalSignBloc;
  String vital_type = 'HEART_RATE';
  String listValueMap = '';
  List<String> listTimeXAxis = [];
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
              title: 'Nhịp tim',
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
                        listTimeXAxis.clear();

                        if (null == state.list) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset(
                                        'assets/images/ic-heart-rate.png'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 30),
                                  ),
                                  Text(
                                    'Không có dữ liệu cho biểu đồ nhịp tim',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state.list.isNotEmpty ||
                            state.list != null) {
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
                            listSortedDateTime.sort(
                                (a, b) => a.dateTime.compareTo(b.dateTime));
                            _lastValueVitalSign = listSortedValue.last.value1;
                          }

                          for (int z = 0; z < listSortedDateTime.length; z++) {
                            //
                            listTimeXAxis.add('"' +
                                '${listSortedDateTime[z].toDateString()}' +
                                '"');

                            //
                            listValueMap +=
                                listSortedDateTime[z].toValueString();
                          }
                        }
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
                          Divider(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            height: 0.5,
                          ),
                          (listTimeXAxis != null && listValueMap != null)
                              ? new Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: DefaultTheme.WHITE,
                                  height: 430,
                                  child: Column(
                                    children: [
                                      Container(
                                        child:
                                            // ListView(
                                            //   shrinkWrap: true,
                                            //   scrollDirection: Axis.horizontal,
                                            //   children: <Widget>[
                                            //
                                            new Echarts(
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
                                        data: ${listTimeXAxis},
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
                                      series: [{
                                        name: 'Nhịp tim',
                                        data: [${listValueMap}],
                                        type: 'line'
                                      },]
                                    }
                                  ''',
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        // padding: EdgeInsets.only(right: 20),
                                        height: 400,
                                      ),
                                      Text(
                                          'Biểu đồ nhịp tim trong ngày'
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: DefaultTheme.ORANGE_TEXT,
                                          )),
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
                                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                                      width: 0.5),
                                ),
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
                                  color: DefaultTheme.WHITE,
                                  border: Border.all(
                                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                                      width: 0.5),
                                ),
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
                                  color: DefaultTheme.WHITE,
                                  border: Border.all(
                                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                                      width: 0.5),
                                ),
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
            ),
          ],
        ),
      ),
    );
  }
}
