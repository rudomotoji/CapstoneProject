import 'dart:async';
import 'dart:convert';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_sign_state.dart';
import 'package:capstone_home_doctor/models/vital_sign_detail_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

class VitalSignChartDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VitalSignChartDetail();
  }
}

class _VitalSignChartDetail extends State<VitalSignChartDetail>
    with WidgetsBindingObserver {
  //
  VitalSignBloc _vitalSignBloc;
  // List<int> listValueMap = [];
  // List<String> listTimeXAxis = [];
  int _patientId = 0;
  String dateTime = '';

  // int minVitalSignValue = 0;
  // int maxVitalSignValue = 0;

  VitalSignDetailDTO _vitalSignDetailDTO = VitalSignDetailDTO();
  DateValidator _dateValidator = DateValidator();

  VitalSignDetailBloc _vitalSignDetailBloc;
  int medicalInstructionId = 0;
  String timeStart = '';
  String timeCanceled = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vitalSignDetailBloc = BlocProvider.of(context);
    _getPatientId();
  }

  Future _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        _patientId = value;
      });
      if (_patientId != 0) {
        _vitalSignDetailBloc.add(VitalSignEventGetDetail(
            patientId: _patientId, medicalInstructionId: medicalInstructionId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      medicalInstructionId = arguments['medicalInstructionId'];
      timeStart = arguments['timeStared'];
      timeCanceled = arguments['timeCanceled'];
      if (dateTime == '') {
        dateTime = timeStart;
      }
    }
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
                    Row(
                      children: [
                        Text('Ngày:'),
                        FlatButton(
                          child: Text(
                            _dateValidator.convertDateCreate(
                                dateTime, 'dd/MM/yyyy', 'yyyy-MM-dd'),
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            DateTime newDateTime = await showRoundedDatePicker(
                                context: context,
                                initialDate: DateTime.parse(timeStart),
                                firstDate: DateTime.parse(timeCanceled),
                                lastDate: DateTime.now(),
                                borderRadius: 16,
                                theme: ThemeData.dark());
                            if (newDateTime != null) {
                              setState(() {
                                dateTime = newDateTime.toString();
                              });
                              _vitalSignDetailBloc.add(VitalSignEventGetDetail(
                                  patientId: _patientId,
                                  medicalInstructionId: medicalInstructionId));
                            }
                          },
                        ),
                      ],
                    ),
                    BlocBuilder<VitalSignDetailBloc, VitalSignState>(
                        builder: (context, state) {
                      if (state is VitalSignStateLoading) {
                        print('VitalSignStateLoading');
                        return Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: DefaultTheme.GREY_BUTTON),
                          child: Center(
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/images/loading.gif'),
                            ),
                          ),
                        );
                      }
                      if (state is VitalSignStateFailure) {
                        print('VitalSignStateFailure');
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text('Không có dữ liệu'),
                        );
                      }
                      if (state is VitalSignGetDetailSuccess) {
                        print('VitalSignGetDetailSuccess');
                        if (state.vitalSignDetailDTO != null &&
                            state.vitalSignDetailDTO.vitalSignValues != null) {
                          if (state.vitalSignDetailDTO.vitalSignValues.length >
                              0) {
                            _vitalSignDetailDTO = state.vitalSignDetailDTO;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  _vitalSignDetailDTO.vitalSignValues.length,
                              itemBuilder: (context, index) {
                                // var itemVitalsign;
                                var itemVitalsignValue =
                                    _vitalSignDetailDTO.vitalSignValues[index];

                                // if (index >
                                //     _vitalSignDetailDTO.vitalSigns.length) {
                                //   itemVitalsign = VitalSigns(
                                //       vitalSignType: '',
                                //       vitalSignTypeId: 1,
                                //       numberMax: 0,
                                //       numberMin: 0,
                                //       minuteDangerInterval: 1,
                                //       minuteNormalInterval: 1,
                                //       timeStart: "",
                                //       minuteAgain: 0);
                                // } else {
                                //   itemVitalsign =
                                //       _vitalSignDetailDTO.vitalSigns[index];
                                // }

                                // int minVitalSignValue = (itemVitalsign == null)
                                //     ? 0
                                //     : itemVitalsign.numberMin;
                                // int maxVitalSignValue = (itemVitalsign == null)
                                //     ? 0
                                //     : itemVitalsign.numberMax;
                                //
                                //

                                int minVitalSignValue = 0;
                                int maxVitalSignValue = 0;

                                var listTime =
                                    itemVitalsignValue.timeValue.split(',');
                                var listValue =
                                    itemVitalsignValue.numberValue.split(',');
                                listTime.removeLast();
                                listValue.removeLast();

                                if (itemVitalsignValue.vitalSignTypeId == 1 ||
                                    itemVitalsignValue.vitalSignTypeId == 3 ||
                                    itemVitalsignValue.vitalSignTypeId == 4) {
                                  List<int> listValueMap = listValue
                                      .map((data) => int.parse(data))
                                      .toList();
                                  List<String> listTimeXAxis =
                                      listTime.map((e) => '"${e}"').toList();

                                  return heartChart(
                                      listTimeXAxis,
                                      minVitalSignValue,
                                      maxVitalSignValue,
                                      listValueMap);
                                } else if (itemVitalsignValue.vitalSignTypeId ==
                                    2) {
                                  List<List<int>> listValueMap =
                                      listValue.map((data) {
                                    List<int> listNum = data
                                        .split('-')
                                        .map((e) => int.parse(e))
                                        .toList();

                                    listNum.sort();

                                    List<int> dataClone = [
                                      listNum.first,
                                      listNum.last,
                                      listNum.last,
                                      listNum.last
                                    ];

                                    return dataClone;
                                  }).toList();

                                  List<String> listTimeXAxis =
                                      listTime.map((e) => '"${e}"').toList();

                                  return bloodChart(
                                      listTimeXAxis,
                                      minVitalSignValue,
                                      maxVitalSignValue,
                                      listValueMap);
                                }
                              },
                            );
                          } else {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text('Không có dữ liệu'),
                            );
                          }
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text('Không có dữ liệu'),
                          );
                        }
                      }
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text('Vui lòng kiểm tra lại kết nối'),
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

  heartChart(List<String> listTimeXAxis, int minVitalSignValue,
      int maxVitalSignValue, List<int> listValueMap) {
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
                    Text('Biểu đồ nhịp tim'.toUpperCase(),
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
        Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
      ],
    );
  }

  bloodChart(List<String> listTimeXAxis, int minVitalSignValue,
      int maxVitalSignValue, List<List<int>> listValueMap) {
    return Column(
      children: <Widget>[
        Divider(
          color: DefaultTheme.GREY_TOP_TAB_BAR,
          height: 0.5,
        ),
        (listTimeXAxis != null)
            ? Container(
                width: MediaQuery.of(context).size.width,
                color: DefaultTheme.WHITE,
                height: 430,
                child: Column(
                  children: [
                    Container(
                      child: new Echarts(
                        option: '''
   
option = {

                                      color: '#FF784B',
                                      tooltip: {
                                        trigger: "axis",
                                        axisPointer: {
                                          type: "shadow"
                                      },
                                      formatter: function (params)  {
   
            var tar = params[0];
           
            return 'Huyết áp lúc ' + (tar.value[0]+1) + 'giờ' + '<br/>' + 'tâm thu ' + tar.value[1] + '<br/>' +'tâm trương' + tar.value[2];
        }
                                  },
    xAxis: {
        name: 'GIỜ',
                                      nameTextStyle: {
                                      verticalAlign: "middle",
                                      color: "#FF784B"
                                      },
          axisTick: {
                                        show: false
                                      },
       data: function () {
            var list = [];
            for (var i = 1; i <= 24; i++) {
                list.push(i + ':00');
            }
            return list;
        }()
    },
    yAxis: {
        max:150,
        min:0,
           name: '',
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
                                      }
                                      
                               
    },
    series: [

        {
        type: 'k',
  
        data: $listValueMap,
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
    
    }]
                        }
                                  ''',
                      ),
                      width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.only(right: 20),
                      height: 400,
                    ),
                    Text('Biểu đồ nhịp tim trong ngày'.toUpperCase(),
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
