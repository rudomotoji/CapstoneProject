import 'dart:async';
import 'dart:convert';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_repository.dart';
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
import 'package:http/http.dart' as http;

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
  // VitalSignBloc _vitalSignBloc;
  // List<int> listValueMap = [];
  // List<String> listTimeXAxis = [];
  int _patientId = 0;
  String dateTime = '';

  // int minVitalSignValue = 0;
  // int maxVitalSignValue = 0;

  VitalSignDetailDTO _vitalSignDetailDTO = VitalSignDetailDTO();
  DateValidator _dateValidator = DateValidator();

  VitalSignServerRepository vitalSignServerRepository =
      VitalSignServerRepository(httpClient: http.Client());

  VitalSignDetailBloc _vitalSignDetailBloc;
  int medicalInstructionId = 0;
  String timeStart = '';
  String timeCanceled = '';
  String dropdownValue;
  List<String> listDays = [];

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
        // _vitalSignDetailBloc.add(VitalSignEventGetDetail(
        //     patientId: _patientId, medicalInstructionId: medicalInstructionId));
        //
        vitalSignServerRepository
            .getVitalSign(_patientId, medicalInstructionId)
            .then((value) {
          if (value.vitalSignValues.length > 0) {
            _vitalSignDetailDTO = value;
            listDays.clear();
            for (var item in value.vitalSignValues) {
              setState(() {
                listDays.add(item.dateCreated.toString());
              });
            }

            setState(() {
              dropdownValue = listDays.first;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      medicalInstructionId = arguments['medicalInstructionId'];
      print(medicalInstructionId);
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
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Bắt đầu ngày: ${_dateValidator.convertDateCreate(timeStart, 'dd/MM/yyyy', 'yyyy-MM-dd')}'),
                              Text(
                                  'Kết thúc ngày:  ${_dateValidator.convertDateCreate(timeCanceled, 'dd/MM/yyyy', 'yyyy-MM-dd')}'),
                            ],
                          ),
                          _selectContract(),
                        ],
                      ),
                    ),
                    // BlocBuilder<VitalSignDetailBloc, VitalSignState>(
                    //     builder: (context, state) {
                    //   if (state is VitalSignStateLoading) {
                    //     print('VitalSignStateLoading');
                    //     return Container(
                    //       margin: EdgeInsets.only(left: 20, right: 20),
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(6),
                    //           color: DefaultTheme.GREY_BUTTON),
                    //       child: Center(
                    //         child: SizedBox(
                    //           width: 60,
                    //           height: 60,
                    //           child: Image.asset('assets/images/loading.gif'),
                    //         ),
                    //       ),
                    //     );
                    //   }
                    //   if (state is VitalSignStateFailure) {
                    //     print('VitalSignStateFailure');
                    //     return Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       child: Text('Không có dữ liệu'),
                    //     );
                    //   }
                    //   if (state is VitalSignGetDetailSuccess) {
                    //     print('VitalSignGetDetailSuccess');
                    //     if (state.vitalSignDetailDTO != null &&
                    //         state.vitalSignDetailDTO.vitalSignValues != null) {
                    //       if (state.vitalSignDetailDTO.vitalSignValues.length >
                    //           0) {
                    //         _vitalSignDetailDTO = state.vitalSignDetailDTO;
                    //         listDays.clear();
                    //         for (var item
                    //             in state.vitalSignDetailDTO.vitalSignValues) {
                    //           listDays.add(item.dateCreated.toString());
                    //         }

                    //         return Container();

                    //         // return ListView.builder(
                    //         //   shrinkWrap: true,
                    //         //   physics: NeverScrollableScrollPhysics(),
                    //         //   itemCount:
                    //         //       _vitalSignDetailDTO.vitalSignValues.length,
                    //         //   itemBuilder: (context, index) {
                    //         //     // var itemVitalsign;
                    //         //     var itemVitalsignValue =
                    //         //         _vitalSignDetailDTO.vitalSignValues[index];

                    //         //     // if (index >
                    //         //     //     _vitalSignDetailDTO.vitalSigns.length) {
                    //         //     //   itemVitalsign = VitalSigns(
                    //         //     //       vitalSignType: '',
                    //         //     //       vitalSignTypeId: 1,
                    //         //     //       numberMax: 0,
                    //         //     //       numberMin: 0,
                    //         //     //       minuteDangerInterval: 1,
                    //         //     //       minuteNormalInterval: 1,
                    //         //     //       timeStart: "",
                    //         //     //       minuteAgain: 0);
                    //         //     // } else {
                    //         //     //   itemVitalsign =
                    //         //     //       _vitalSignDetailDTO.vitalSigns[index];
                    //         //     // }

                    //         //     // int minVitalSignValue = (itemVitalsign == null)
                    //         //     //     ? 0
                    //         //     //     : itemVitalsign.numberMin;
                    //         //     // int maxVitalSignValue = (itemVitalsign == null)
                    //         //     //     ? 0
                    //         //     //     : itemVitalsign.numberMax;
                    //         //     //
                    //         //     //

                    //         //     int minVitalSignValue = 0;
                    //         //     int maxVitalSignValue = 0;

                    //         //     var listTime =
                    //         //         itemVitalsignValue.timeValue.split(',');
                    //         //     var listValue =
                    //         //         itemVitalsignValue.numberValue.split(',');
                    //         //     listTime.removeLast();
                    //         //     listValue.removeLast();

                    //         //     if (itemVitalsignValue.vitalSignTypeId == 1 ||
                    //         //         itemVitalsignValue.vitalSignTypeId == 3 ||
                    //         //         itemVitalsignValue.vitalSignTypeId == 4) {
                    //         //       for (var val
                    //         //           in _vitalSignDetailDTO.vitalSigns) {
                    //         //         if (val.vitalSignTypeId ==
                    //         //             itemVitalsignValue.vitalSignTypeId) {
                    //         //           minVitalSignValue = val.numberMin;
                    //         //           maxVitalSignValue = val.numberMax;
                    //         //         }
                    //         //       }
                    //         //       List<int> listValueMap = listValue
                    //         //           .map((data) => int.parse(data))
                    //         //           .toList();
                    //         //       List<String> listTimeXAxis =
                    //         //           listTime.map((e) => '"${e}"').toList();

                    //         //       return heartChart(
                    //         //           listTimeXAxis,
                    //         //           minVitalSignValue,
                    //         //           maxVitalSignValue,
                    //         //           listValueMap,
                    //         //           _dateValidator.convertDateCreate(
                    //         //               itemVitalsignValue.dateCreated,
                    //         //               'dd/MM/yyyy',
                    //         //               'yyyy-MM-dd'));
                    //         //     } else if (itemVitalsignValue.vitalSignTypeId ==
                    //         //         2) {
                    //         //       List<List<int>> listValueMap =
                    //         //           listValue.map((data) {
                    //         //         List<int> listNum = data
                    //         //             .split('-')
                    //         //             .map((e) => int.parse(e))
                    //         //             .toList();

                    //         //         listNum.sort();

                    //         //         List<int> dataClone = [
                    //         //           listNum.first,
                    //         //           listNum.last,
                    //         //           listNum.last,
                    //         //           listNum.last
                    //         //         ];

                    //         //         return dataClone;
                    //         //       }).toList();

                    //         //       List<String> listTimeXAxis =
                    //         //           listTime.map((e) => '"${e}"').toList();

                    //         //       return bloodChart(
                    //         //           listTimeXAxis,
                    //         //           minVitalSignValue,
                    //         //           maxVitalSignValue,
                    //         //           listValueMap,
                    //         //           _dateValidator.convertDateCreate(
                    //         //               itemVitalsignValue.dateCreated,
                    //         //               'dd/MM/yyyy',
                    //         //               'yyyy-MM-dd'));
                    //         //     }
                    //         //   },
                    //         // );
                    //       } else {
                    //         return Container(
                    //           width: MediaQuery.of(context).size.width,
                    //           child: Text('Không có dữ liệu'),
                    //         );
                    //       }
                    //     } else {
                    //       return Container(
                    //         width: MediaQuery.of(context).size.width,
                    //         child: Text('Không có dữ liệu'),
                    //       );
                    //     }
                    //   }
                    //   return Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     child: Text('Vui lòng kiểm tra lại kết nối'),
                    //   );
                    // }),
                    detailVitalSign(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  detailVitalSign() {
    if (dropdownValue != null) {
      VitalSignValues vitalSignValue = _vitalSignDetailDTO.vitalSignValues
          .where((element) => element.dateCreated.contains(dropdownValue))
          .toList()
          .first;

      int minVitalSignValue = 0;
      int maxVitalSignValue = 0;

      var listTime = vitalSignValue.timeValue.split(',');
      var listValue = vitalSignValue.numberValue.split(',');
      listTime.removeLast();
      listValue.removeLast();

      if (vitalSignValue.vitalSignTypeId == 1 ||
          vitalSignValue.vitalSignTypeId == 3 ||
          vitalSignValue.vitalSignTypeId == 4) {
        for (var val in _vitalSignDetailDTO.vitalSigns) {
          if (val.vitalSignTypeId == vitalSignValue.vitalSignTypeId) {
            minVitalSignValue = val.numberMin;
            maxVitalSignValue = val.numberMax;
          }
        }
        List<int> listValueMap =
            listValue.map((data) => int.parse(data)).toList();
        List<String> listTimeXAxis = listTime.map((e) => '"${e}"').toList();

        return heartChart(
            listTimeXAxis,
            minVitalSignValue,
            maxVitalSignValue,
            listValueMap,
            _dateValidator.convertDateCreate(
                vitalSignValue.dateCreated, 'dd/MM/yyyy', 'yyyy-MM-dd'));
      } else if (vitalSignValue.vitalSignTypeId == 2) {
        List<List<int>> listValueMap = listValue.map((data) {
          List<int> listNum = data.split('-').map((e) => int.parse(e)).toList();

          listNum.sort();

          List<int> dataClone = [
            listNum.first,
            listNum.last,
            listNum.last,
            listNum.last
          ];

          return dataClone;
        }).toList();

        List<String> listTimeXAxis = listTime.map((e) => '"${e}"').toList();

        return bloodChart(
            listTimeXAxis,
            minVitalSignValue,
            maxVitalSignValue,
            listValueMap,
            _dateValidator.convertDateCreate(
                vitalSignValue.dateCreated, 'dd/MM/yyyy', 'yyyy-MM-dd'));
      }
    } else {
      return Container();
    }
  }

  _selectContract() {
    if (listDays.isNotEmpty && listDays != null) {
      return Container(
        width: MediaQuery.of(context).size.width - 200,
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
              color: DefaultTheme.GREY_VIEW,
              borderRadius: BorderRadius.circular(6)),
          child: DropdownButton<String>(
            value: dropdownValue,
            items: listDays.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(
                  _dateValidator.convertDateCreate(
                      value, 'dd/MM/yyyy', 'yyyy-MM-dd'),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
            dropdownColor: DefaultTheme.GREY_VIEW,
            elevation: 1,
            hint: Container(
              width: MediaQuery.of(context).size.width - 284,
              child: Text(
                'Chọn ngày',
                style: TextStyle(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            underline: Container(
              width: 0,
            ),
            isExpanded: false,
            onChanged: (res) async {
              setState(() {
                dropdownValue = res;
              });
            },
          ),
          //  DropdownButton<String>(
          //   value: dropdownValue,
          //   items: listDays.map((String value) {
          //     return new DropdownMenuItem<String>(
          //       value: value,
          //       child: new Text(
          //         value,
          //         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          //       ),
          //     );
          //   }).toList(),
          //   dropdownColor: DefaultTheme.GREY_VIEW,
          //   elevation: 1,
          //   hint: Container(
          //     width: MediaQuery.of(context).size.width - 284,
          //     child: Text(
          //       'Chọn ngày',
          //       style: TextStyle(fontWeight: FontWeight.w600),
          //       overflow: TextOverflow.ellipsis,
          //       maxLines: 1,
          //     ),
          //   ),
          //   underline: Container(
          //     width: 0,
          //   ),
          //   isExpanded: false,
          //   onChanged: (res) async {
          //     ///
          //     setState(() {
          //       dropdownValue = res;
          //     });
          //     //
          //   },
          // ),
        ),
      );
    } else {
      return Container();
    }
  }

  heartChart(List<String> listTimeXAxis, int minVitalSignValue,
      int maxVitalSignValue, List<int> listValueMap, String dateCreate) {
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
                height: 450,
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
                    Text('Thời gian tạo: ${dateCreate}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: DefaultTheme.GREY_TEXT,
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
      int maxVitalSignValue, List<List<int>> listValueMap, String dateCreate) {
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
                height: 450,
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
                    Text('Biểu đồ huyết áp'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: DefaultTheme.ORANGE_TEXT,
                        )),
                    Text('Thời gian tạo: ${dateCreate}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: DefaultTheme.GREY_TEXT,
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
