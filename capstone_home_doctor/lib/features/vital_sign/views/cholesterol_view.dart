import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/terminology.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/home/home.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/blood_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/blood_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_repository.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/blood_state.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_sign_state.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_push_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

final AuthenticateHelper authenHelper = AuthenticateHelper();
final SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
final DateValidator _dateValidator = DateValidator();
final ArrayValidator _arrayValidator = ArrayValidator();
final VitalSignServerRepository _vitalSignServerRepository =
    VitalSignServerRepository(httpClient: http.Client());

class CholView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CholView();
  }
}

class _CholView extends State<CholView> {
  int _patientId = 0;
  var uuid = Uuid();
  Future<void> _launchURL;
  DateTime dateNow;
  VitalSignBloodBloc _vitalSignBloc;
  String vital_type = 'CHOL';
  List<VitalSignDTO> listSortedDateTime = [];
  double _lastValue3VitalSign = 0.0;

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
            BloodPressureEventGet(type: vital_type, patientId: _patientId));
      }
    });
  }

  _getDateTimeNow() {
    setState(() {
      dateNow = DateTime.now();
    });
  }

  @override
  void dispose() {
    super.dispose();
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
                title: 'Cholesterol',
                isMainView: false,
                buttonHeaderType: ButtonHeaderType.BACK_HOME),
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
                    BlocBuilder<VitalSignBloodBloc, BloodState>(
                        builder: (context, state) {
                      //

                      if (state is BloodPressureStateFailure) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            child: Center(
                              child: Text('Không thể tải biểu đồ'),
                            ));
                      }
                      if (state is BloodPressureStateGetListSuccess) {
                        if (state.list == null || state.list.isEmpty) {
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
                                        'assets/images/ic-spo2.png'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 30),
                                  ),
                                  Text(
                                    'Không có dữ liệu',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          //
                          print('length of state list: ${state.list.length}');
                          print(
                              'component-0: id:${state.list[0].id} -time:${state.list[0].dateTime} -value1${state.list[0].value1}-value2${state.list[0].value2} -value3${state.list[0].value3} -pID:${state.list[0].patientId}');
                          listSortedDateTime = state.list;
                          if (null != listSortedDateTime) {
                            listSortedDateTime.sort(
                                (a, b) => a.dateTime.compareTo(b.dateTime));
                            _lastValue3VitalSign =
                                listSortedDateTime.last.value3;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // Text('${state.list[0].value3}'),
                                // //
                                // Text('Lần đo gần đây: '),
                                // Text(
                                //     'Cholesterol: ${_lastValue3VitalSign} mmol/L'),
                                // Text(
                                //     'Lúc: ${listSortedDateTime.last.dateTime}'),

                                //
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 20, bottom: 10),
                                  child: Text('Lần đo gần đây',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                                Center(
                                  child: Container(
                                    width: 250,
                                    height: 250,
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(250),
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            DefaultTheme.GRADIENT_1,
                                            DefaultTheme.GRADIENT_2,
                                          ]),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(250),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5.0, sigmaY: 5.0),
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                left: 1,
                                                right: 1,
                                                bottom: 1,
                                                top: 1),
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 10,
                                                bottom: 10),
                                            width: 249,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(250),
                                              color: DefaultTheme.WHITE
                                                  .withOpacity(0.4),
                                            ),
                                            // padding: EdgeInsets.only(
                                            //     left: 10, right: 10, top: 10, bottom: 10),
                                            height: 249,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // Row(
                                                //   children: [
                                                //     Column(
                                                //       crossAxisAlignment:
                                                //           CrossAxisAlignment
                                                //               .start,
                                                //       children: [
                                                //         Text(
                                                //           '${_dateValidator.getHourAndMinute(listSortedDateTime.last.dateTime)}',
                                                //           style: TextStyle(
                                                //             fontSize: 20,
                                                //             fontWeight:
                                                //                 FontWeight.w500,
                                                //             color: DefaultTheme
                                                //                 .WHITE,
                                                //           ),
                                                //         ),
                                                //         Text(
                                                //           '${_dateValidator.parseToDateView3(listSortedDateTime.last.dateTime)}',
                                                //           style: TextStyle(
                                                //             color: DefaultTheme
                                                //                 .WHITE,
                                                //           ),
                                                //         ),
                                                //       ],
                                                //     ),
                                                //     Spacer(),
                                                //     Text('mmHg',
                                                //         style: TextStyle(
                                                //           color: DefaultTheme
                                                //               .WHITE,
                                                //         )),
                                                //   ],
                                                // ),

                                                Text('${_lastValue3VitalSign}',
                                                    style: TextStyle(
                                                      color: DefaultTheme
                                                          .BLUE_DARK,
                                                      fontFamily: 'NewYork',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 40,
                                                    )),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                ),
                                                Text('mmol/L',
                                                    style: TextStyle(
                                                      color: DefaultTheme
                                                          .BLUE_DARK,
                                                      fontSize: 20,
                                                    )),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.only(
                                      top: 30, left: 20, bottom: 10),
                                  child: Text('Tìm hiểu thêm về Cholesterol',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: DefaultTheme.GREY_BUTTON),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 20, 20, 10),
                                            child: Text(
                                              Terminology.CHOLESTEROL,
                                              style: TextStyle(
                                                wordSpacing: 0.2,
                                                color:
                                                    DefaultTheme.BLACK_BUTTON,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Spacer(),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                child: InkWell(
                                                  child: Text(
                                                    'Theo Vinmec, xem tiếp',
                                                    style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: DefaultTheme
                                                          .BLUE_REFERENCE,
                                                      fontSize: 13,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  onTap: () => setState(() {
                                                    _launchURL = _launchInBrowser(
                                                        Terminology
                                                            .CHOLESTEROL_URL);
                                                  }),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 30, left: 20, bottom: 10),
                                  child: Text('Lịch sử đo Cholesterol',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: listSortedDateTime.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(
                                          left: 20, right: 20, bottom: 5),
                                      height: 80,
                                      color: DefaultTheme.GREY_VIEW,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  '${listSortedDateTime[index].value3}',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: DefaultTheme
                                                          .BLUE_DARK)),
                                              Text('mmol/L',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  )),
                                            ],
                                          ),
                                          Spacer(),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${_dateValidator.getHourAndMinute(listSortedDateTime[index].dateTime)}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                '${_dateValidator.parseToDateView3(listSortedDateTime[index].dateTime)}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
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

  //launch URL
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onButtonShowModelSheet() {
    _getDateTimeNow();
    final _mmol = TextEditingController();
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
                                          'assets/images/ic-spo2.png'),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                    ),
                                    Text(
                                      'Cholesterol',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Spacer(),
                                    Text('(mmol/L)')
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
                            label: 'Giá trị',
                            placeHolder: '',
                            inputType: TFInputType.TF_TEXT,
                            controller: _mmol,
                            keyboardAction: TextInputAction.next,
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
                                if (_arrayValidator
                                    .isNumeric(_mmol.text.trim())) {
                                  //
                                  if (_patientId != 0) {
                                    //
                                    VitalSignDTO vitalSignDTO = VitalSignDTO(
                                      id: uuid.v1(),
                                      patientId: _patientId,
                                      valueType: vital_type,
                                      value3: double.tryParse(_mmol.text),
                                      dateTime: dateNow.toString(),
                                    );
                                    await _sqfLiteHelper
                                        .insertVitalSign2(vitalSignDTO);
                                    print(
                                        'vital sign DTO:\n\n id: ${vitalSignDTO.id} - patientId: ${vitalSignDTO.patientId} - value type: ${vitalSignDTO.valueType} - value3: ${vitalSignDTO.value3} - date time: ${vitalSignDTO.dateTime}');
                                    VitalSignPushDTO vitalSignPush =
                                        VitalSignPushDTO(
                                      patientId: _patientId,
                                      vitalSignTypeId: 3,
                                      numberValue: '${_mmol.text.trim()}',
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
                                            'SUCCESSFUL PUSH DATA CHOLESTEROL');
                                      } else {
                                        print(
                                            'FAILED TO PUSH DATA CHOLESTEROL');
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
