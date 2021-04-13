import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/peripheral_services.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/peripheral/blocs/hr_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_sync_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_sync_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_sign_state.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_sign_sync_state.dart';
import 'package:capstone_home_doctor/models/heart_rate_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_schedule_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_sync_dto.dart';
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
final DateValidator _dateValidator = DateValidator();

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
  VitalSignSyncBloc _vitalSignSyncBloc;

  bool isShowOtherMap = false;

  //
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

  //
  String numberValue = '';
  List<String> timeData = [];

  //
  VitalSignSyncDTO vitalSignSyncDTO = VitalSignSyncDTO();
  //

  DateTime _dateChosen = new DateTime(
      int.tryParse(DateTime.now().toString().split(' ')[0].split('-')[0]),
      int.tryParse(DateTime.now().toString().split(' ')[0].split('-')[1]),
      int.tryParse(DateTime.now().toString().split(' ')[0].split('-')[2]));
  String _dateView = '';

  //
  int minL = 0;
  int maxL = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPatientId();
    print('date chosen initial $_dateChosen');
    _vitalSignBloc = BlocProvider.of(context);
    _vitalSignSyncBloc = BlocProvider.of(context);
    _getsOffline();
  }

  _getsOffline() async {
    await _sqfLiteHelper.getVitalSignScheduleOffline().then((sOffline) async {
      if (sOffline.isNotEmpty) {
        //
        VitalSigns heartRateSchedule =
            sOffline.where((item) => item.vitalSignType == 'Nhịp tim').first;
        setState(() {
          minL = heartRateSchedule.numberMin;
          maxL = heartRateSchedule.numberMax;
        });
      }
    });
  }

  Future _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        _patientId = value;
      });
      if (_patientId != 0) {
        _vitalSignBloc.add(
            VitalSignEventGetList(type: vital_type, patientId: _patientId));
        // await _sqfLiteHelper
        //                 .getVitalSignScheduleOffline()
        //                 .then((sOffline) async {
        //               scheduleOffline = sOffline;
        //             });
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
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      //
                      setState(() {
                        _dateView = '';
                        _dateChosen = DateTime.now();
                      });
                      _showDateTimeChosing();
                    },
                    child: Container(
                      width: 150,
                      height: 30,
                      margin: EdgeInsets.only(left: 30, top: 5),
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      // width: 100,
                      decoration: BoxDecoration(
                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                          borderRadius: BorderRadius.circular(100)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: Image.asset(
                                'assets/images/ic-filter-black.png'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Text('Chọn ngày',
                              style: TextStyle(
                                color: DefaultTheme.BLACK,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  (_dateView != '')
                      ? InkWell(
                          onTap: () {
                            /////
                            setState(() {
                              _dateView = '';
                              isShowOtherMap = false;
                            });
                          },
                          child: Container(
                            height: 35,
                            child: Stack(
                              children: [
                                Container(
                                  height: 30,
                                  margin: EdgeInsets.only(top: 5),
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                      color: DefaultTheme.GREY_TOP_TAB_BAR
                                          .withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Center(
                                    child: Text(
                                        'Ngày ${_dateValidator.parseToDateView3(_dateView)}',
                                        style: TextStyle(
                                          color: DefaultTheme.BLACK,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: Image.asset(
                                        'assets/images/ic-close.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  Spacer(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _getPatientId,
                child: ListView(
                  children: <Widget>[
                    (isShowOtherMap == false)
                        ? BlocBuilder<VitalSignBloc, VitalSignState>(
                            builder: (context, state) {
                            if (state is VitalSignStateGetListSuccess) {
                              listValueMap = '';
                              listTimeXAxis.clear();

                              if (null == state.list) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  listSortedValue.sort(
                                      (a, b) => a.value1.compareTo(b.value1));
                                  for (int z = 0;
                                      z < listSortedValue.length;
                                      z++) {
                                    if (listSortedValue[z].value1 != 0) {
                                      minVitalSignValue =
                                          listSortedValue[z].value1;
                                      break;
                                    }
                                  }

                                  maxVitalSignValue =
                                      listSortedValue.last.value1;
                                  everageVitalSignValue =
                                      ((minVitalSignValue + maxVitalSignValue) /
                                              2)
                                          .toInt();
                                }
                                if (null != listSortedDateTime) {
                                  listSortedDateTime.sort((a, b) =>
                                      a.dateTime.compareTo(b.dateTime));
                                  _lastValueVitalSign =
                                      listSortedDateTime.last.value1;
                                }

                                for (int z = 0;
                                    z < listSortedDateTime.length;
                                    z++) {
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
                            return _heartRateChartToday(
                                listTimeXAxis, listValueMap);
                          })
                        : BlocBuilder<VitalSignSyncBloc, VitalSignSyncState>(
                            builder: (context, state) {
                            if (state is VitalSignSyncStateFailure) {}
                            if (state is VitalSignSyncStateSuccess) {
                              if (state.dto == null) {
                                return Container(
                                    child: Text('Không có nhịp tim'));
                              } else {
                                vitalSignSyncDTO = state.dto;
                                if (state.dto.vitalSignValues != null &&
                                    state.dto.vitalSignValues.isNotEmpty) {
                                  VitalSignValues heartRateValue = state
                                      .dto.vitalSignValues
                                      .where(
                                          (item) => item.vitalSignTypeId == 1)
                                      .first;

                                  numberValue = '';
                                  timeData.clear();
                                  int count = 0;
                                  for (String component in heartRateValue
                                      .numberValue
                                      .split(',')) {
                                    if (component != null || component != ',') {
                                      numberValue += component + ',';
                                      count++;
                                    }
                                  }
                                  for (String component
                                      in heartRateValue.timeValue.split(',')) {
                                    if (component != null || component != ',') {
                                      timeData.add('"' + component + '"');
                                    }
                                  }
                                  print('number lenght: $count');
                                }
                              }
                            }
                            print('time data: LENGTH : ${timeData.length}');

                            return _heartRateChartToday(timeData, numberValue);
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
  //comment hihi

  Widget _heartRateChartToday(List<String> listXAxis, String listYAxis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(
          color: DefaultTheme.GREY_TOP_TAB_BAR,
          height: 0.5,
        ),
        (listXAxis != null && listValueMap != null)
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
                                        data: ${listXAxis},
                                        show: true,
                                        nameTextStyle: {
                                          align: "center",
                                          color: "#F5233C",
                                          fontSize: 10
                                        }
                                    },
                                    yAxis: {
                                       max:150,
        min:0,
                                      name: 'BPM',
                                      nameTextStyle: {
                                      verticalAlign: "middle",
                                      color: "#F5233C"
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
                                      show: true,
                                         top: 20,
                                         
            right: 20,
            pieces: [{
                gt: 0,
                lte:   ${minL},
                color: '#F5233C'
            }, {
                gt:  ${minL},
                lte:  ${maxL},
                color: '#636AA7'
            }, {
                gt:  ${maxL},
                lte: 150,
                color: '#F5233C'
            }],
                                      },
                                      series: [{
                                        name: 'Nhịp tim',
                                        data: [${listYAxis}],
                                        type: 'line',
                                            markLine: {
                silent: true,
                lineStyle: {
                    color: '#303030',
                     type: 'solid',
                  
                },
   
                data: [
                 
                    {
                    yAxis: ${maxL},
                   
                }, {
                    yAxis: ${minL},
                }]
            }
                                      },]
                                    }
                                  ''',
                      ),
                      width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.only(right: 20),
                      height: 400,
                    ),
                    Text(
                        'Biểu đồ nhịp tim ngày ${_dateValidator.parseToDateView3(_dateView)}'
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: DefaultTheme.BLUE_REFERENCE,
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
                    'Trung bình',
                    style: TextStyle(color: DefaultTheme.ORANGE_TEXT),
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
        // Container(
        //   width: MediaQuery.of(context).size.width - 40,
        //   height: 45,
        //   child: ButtonHDr(
        //     style: BtnStyle.BUTTON_BLACK,
        //     label: 'Hiển thị thêm dữ liệu đo',
        //     onTap: () {
        //       Navigator.pushNamed(context, RoutesHDr.VITALSIGN_HISTORY);
        //     },
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
      ],
    );
  }

  _showDateTimeChosing() {
    _dateChosen = new DateTime(
        int.tryParse(DateTime.now().toString().split(' ')[0].split('-')[0]),
        int.tryParse(DateTime.now().toString().split(' ')[0].split('-')[1]),
        int.tryParse(DateTime.now().toString().split(' ')[0].split('-')[2]));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width - 20,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: DefaultTheme.WHITE.withOpacity(0.6),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Chọn ngày',
                            style: TextStyle(
                              fontSize: 25,
                              color: DefaultTheme.BLACK,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (dateTime) {
                              //
                              setState(() {
                                //
                                String y = dateTime.toString().split(' ')[0];
                                _dateChosen = new DateTime(
                                    int.tryParse(y.split('-')[0]),
                                    int.tryParse(y.split('-')[1]),
                                    int.tryParse(y.split('-')[2]));
                                print(
                                    'date chosen when scrolling is $_dateChosen');
                                _dateView = dateTime.toString();
                              });
                            }),
                      ),
                      ButtonHDr(
                        style: BtnStyle.BUTTON_BLACK,
                        label: 'Chọn',
                        onTap: () async {
                          String now = DateTime.now().toString().split(' ')[0];
                          DateTime xCompare = new DateTime(
                              int.tryParse(now.split('-')[0]),
                              int.tryParse(now.split('-')[1]),
                              int.tryParse(now.split('-')[2]));
                          print(
                              'date chosen $_dateChosen - xCompare $xCompare ');
                          setState(() {
                            _dateView = _dateChosen.toString();

                            if (_patientId != 0) {
                              if (_dateChosen.isAtSameMomentAs(xCompare)) {
                                //

                                isShowOtherMap = false;
                              } else {
                                _vitalSignSyncBloc.add(
                                    VitalSignSyncEventGetByDate(
                                        patientId: _patientId,
                                        date: _dateChosen
                                            .toString()
                                            .split(' ')[0]));
                                isShowOtherMap = true;
                              }
                            }
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
