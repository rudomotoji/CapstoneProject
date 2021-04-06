import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/home/home.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_repository.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_sign_state.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_push_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

final AuthenticateHelper authenHelper = AuthenticateHelper();
final SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
final DateValidator _dateValidator = DateValidator();
final ArrayValidator _arrayValidator = ArrayValidator();
final VitalSignServerRepository _vitalSignServerRepository =
    VitalSignServerRepository(httpClient: http.Client());

class PressureDetailView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PressureDetailView();
  }
}

class _PressureDetailView extends State<PressureDetailView> {
  int _patientId = 0;
  var uuid = Uuid();
  DateTime dateNow;
  VitalSignBloc _vitalSignBloc;
  String vital_type = 'PRESSURE';
  List<VitalSignDTO> listSortedDateTime = [];
  int _lastValue1VitalSign = 0;
  int _lastValue2VitalSign = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vitalSignBloc = BlocProvider.of(context);
    _getPatientId();
  }

  Future _getPatientId() async {
    await authenHelper.getPatientId().then((value) {
      setState(() {
        _patientId = value;
      });
      if (_patientId != 0) {
        _vitalSignBloc.add(
            VitalSignEventGetList(type: vital_type, patientId: _patientId));
      }
    });
  }

  _getDateTimeNow() {
    setState(() {
      dateNow = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: ListView(padding: const EdgeInsets.all(24), children: <Widget>[
      //   _lineChartBloodPressure(),
      // ]),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //
            HeaderWidget(
              title: 'Huyết áp',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _getPatientId,
                child: ListView(
                  children: <Widget>[
                    //
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: ButtonHDr(
                        style: BtnStyle.BUTTON_BLACK,
                        label: 'Thêm dữ liệu',
                        onTap: () {
                          _onButtonShowModelSheet();
                        },
                      ),
                    ),
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
                                        'assets/images/ic-blood-pressure.png'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 30),
                                  ),
                                  Text(
                                    'Không có dữ liệu cho biểu đồ huyết áp',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state.list.isNotEmpty ||
                            state.list != null) {
                          //
                          listSortedDateTime = state.list;
                          if (null != listSortedDateTime) {
                            listSortedDateTime.sort(
                                (a, b) => a.dateTime.compareTo(b.dateTime));
                            _lastValue1VitalSign =
                                listSortedDateTime.last.value1;
                            _lastValue2VitalSign =
                                listSortedDateTime.last.value2;
                            return Column(
                              children: <Widget>[
                                //
                                Text('Lần đo gần đây: '),
                                Text('Tâm thu: ${_lastValue1VitalSign}'),
                                Text('Tâm trương: ${_lastValue2VitalSign}'),
                                Text(
                                    'Lúc: ${listSortedDateTime.last.dateTime}'),
                              ],
                            );
                          }
                        }
                      }
                      return Container();
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

  void _onButtonShowModelSheet() {
    _getDateTimeNow();
    final _tamThuController = TextEditingController();
    final _tamTruongController = TextEditingController();
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05),
                  color: DefaultTheme.TRANSPARENT,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                      color: DefaultTheme.WHITE.withOpacity(0.9),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //

                          Padding(
                            padding:
                                EdgeInsets.only(top: 30, left: 20, right: 30),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset(
                                          'assets/images/ic-blood-pressure.png'),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                    ),
                                    Text(
                                      'Huyết áp',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Spacer(),
                                    Text('(mmHg)')
                                  ],
                                )),
                          ),

                          Padding(padding: EdgeInsets.only(top: 20)),
                          Divider(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            height: 0.25,
                          ),
                          TextFieldHDr(
                            style: TFStyle.NO_BORDER,
                            label: 'Tâm thu',
                            placeHolder: '',
                            inputType: TFInputType.TF_NUMBER,
                            controller: _tamThuController,
                            keyboardAction: TextInputAction.next,
                            onChange: (text) {
                              //
                            },
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            height: 0.25,
                          ),
                          TextFieldHDr(
                            style: TFStyle.NO_BORDER,
                            label: 'Tâm trương',
                            placeHolder: '',
                            inputType: TFInputType.TF_NUMBER,
                            controller: _tamTruongController,
                            keyboardAction: TextInputAction.done,
                            onChange: (text) {
                              //
                            },
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            height: 0.25,
                          ),
                          Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Ngày',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                    '${_dateValidator.parseToDateView3(dateNow.toString())}'),
                              ],
                            ),
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            height: 0.25,
                          ),
                          Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Thời gian',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                    '${_dateValidator.getHourAndMinute(dateNow.toString())}'),
                              ],
                            ),
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            height: 0.25,
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            child: ButtonHDr(
                              style: BtnStyle.BUTTON_BLACK,
                              label: 'Thêm',
                              onTap: () async {
                                //
                                if (_arrayValidator.isNumeric(
                                        _tamThuController.text.trim()) &&
                                    _arrayValidator.isNumeric(
                                        _tamTruongController.text.trim())) {
                                  //
                                  if (_patientId != 0) {
                                    //
                                    VitalSignDTO vitalSignDTO = VitalSignDTO(
                                      id: uuid.v1(),
                                      patientId: _patientId,
                                      valueType: 'PRESSURE',
                                      value1:
                                          int.tryParse(_tamThuController.text),
                                      value2: int.tryParse(
                                          _tamTruongController.text),
                                      dateTime: dateNow.toString(),
                                    );
                                    await _sqfLiteHelper
                                        .insertVitalSign(vitalSignDTO);
                                    print(
                                        'vital sign DTO:\n\n id: ${vitalSignDTO.id} - patientId: ${vitalSignDTO.patientId} - value type: ${vitalSignDTO.valueType} - value1: ${vitalSignDTO.value1} - value2 : ${vitalSignDTO.value2} - date time: ${vitalSignDTO.dateTime}');
                                    VitalSignPushDTO vitalSignPush =
                                        VitalSignPushDTO(
                                      patientId: _patientId,
                                      vitalSignTypeId: 2,
                                      numberValue:
                                          '${_tamThuController.text.trim()}-${_tamTruongController.text.trim()}',
                                      timeValue:
                                          '${_dateValidator.getHourAndMinute(dateNow.toString())}',
                                    );
                                    // print(
                                    //     'DTO HEREEE: \n vitalSignScheduleId: ${vitalSignPush.vitalSignScheduleId}\ncurrentDate: ${vitalSignPush.currentDate}\nnumberValue: ${vitalSignPush.numberValue}\ntimeValue: ${vitalSignPush.timeValue}');

                                    print(
                                        '\n\nJSON OBJECT: \n\n ${vitalSignPush.toJson().toString()}\n\n');
                                    await _vitalSignServerRepository
                                        .pushVitalSign(vitalSignPush)
                                        .then((isSuccess) async {
                                      if (isSuccess) {
                                        print(
                                            'SUCCESSFUL PUSH DATA BLOOD PRESSURE');
                                      } else {
                                        print('FAILED TO PUSH DATA HEART RATE');
                                      }
                                    });

                                    Future.delayed(const Duration(seconds: 1),
                                        () async {
                                      await _getPatientId();
                                    });
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 30)),
                        ]),
                  ),
                ),
                Positioned(
                  top: 23,
                  left: MediaQuery.of(context).size.width * 0.3,
                  height: 5,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.3),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 15,
                    decoration: BoxDecoration(
                        color: DefaultTheme.WHITE.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // Widget _lineChartBloodPressure() {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  //     color: Colors.white,
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 16.0),
  //       child: BarChart(
  //         BarChartData(
  //           alignment: BarChartAlignment.start,
  //           barTouchData: BarTouchData(
  //             enabled: false,
  //           ),
  //           titlesData: FlTitlesData(
  //             show: true,
  //             bottomTitles: SideTitles(
  //               showTitles: true,
  //               getTextStyles: (value) =>
  //                   const TextStyle(color: Color(0xff939393), fontSize: 10),
  //               margin: 5,
  //             ),
  //             leftTitles: SideTitles(
  //               showTitles: true,
  //               getTextStyles: (value) => const TextStyle(
  //                   color: Color(
  //                     0xff939393,
  //                   ),
  //                   fontSize: 10),
  //               margin: 0,
  //               getTitles: (double value) {
  //                 if (value % 10 == 0) return '${value.floor()}';
  //               },
  //             ),
  //           ),
  //           borderData: FlBorderData(
  //             show: false,
  //           ),
  //           barGroups: getData(),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // List<BarChartGroupData> getData() {
  //   return [
  //     BarChartGroupData(
  //       x: 0,
  //       barRods: [
  //         BarChartRodData(
  //           y: 100,
  //           rodStackItems: [
  //             BarChartRodStackItem(0, 50, DefaultTheme.WHITE),
  //             BarChartRodStackItem(50, 100, DefaultTheme.RED_CALENDAR),
  //           ],
  //         ),
  //         BarChartRodData(
  //           y: 100,
  //           rodStackItems: [
  //             BarChartRodStackItem(0, 10, DefaultTheme.WHITE),
  //             BarChartRodStackItem(10, 30, DefaultTheme.RED_CALENDAR),
  //             BarChartRodStackItem(30, 100, DefaultTheme.WHITE),
  //           ],
  //         ),
  //       ],
  //     ),
  //   ];
  // }

}
