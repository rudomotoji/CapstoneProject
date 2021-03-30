import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/home/home.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uuid/uuid.dart';

final AuthenticateHelper authenHelper = AuthenticateHelper();
final SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPatientId();
  }

  _getPatientId() async {
    await authenHelper.getPatientId().then((value) {
      _patientId = value;
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
              child: ListView(
                children: <Widget>[
                  //
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
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
                  _lineChartBloodPressure(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onButtonShowModelSheet() {
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
                          Padding(padding: EdgeInsets.only(top: 50)),
                          Divider(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            height: 0.25,
                          ),
                          TextFieldHDr(
                            style: TFStyle.NO_BORDER,
                            label: 'Tâm thu',
                            placeHolder: '',
                            inputType: TFInputType.TF_TEXT,
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
                            inputType: TFInputType.TF_TEXT,
                            controller: _tamTruongController,
                            keyboardAction: TextInputAction.next,
                            onChange: (text) {
                              //
                            },
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            height: 0.25,
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child: ButtonHDr(
                              style: BtnStyle.BUTTON_BLACK,
                              label: 'Thêm',
                              onTap: () async {
                                //
                                if (_patientId != 0) {
                                  //
                                  VitalSignDTO vitalSignDTO = VitalSignDTO(
                                    id: uuid.v1(),
                                    patientId: _patientId,
                                    valueType: 'PRESSURE',
                                    value1:
                                        int.tryParse(_tamThuController.text),
                                    value2:
                                        int.tryParse(_tamTruongController.text),
                                    dateTime: DateTime.now().toString(),
                                  );
                                  await _sqfLiteHelper
                                      .insertVitalSign(vitalSignDTO);
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

  Widget _lineChartBloodPressure() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.start,
            barTouchData: BarTouchData(
              enabled: false,
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) =>
                    const TextStyle(color: Color(0xff939393), fontSize: 10),
                margin: 5,
              ),
              leftTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Color(
                      0xff939393,
                    ),
                    fontSize: 10),
                margin: 0,
                getTitles: (double value) {
                  if (value % 10 == 0) return '${value.floor()}';
                },
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: getData(),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> getData() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            y: 100,
            rodStackItems: [
              BarChartRodStackItem(0, 50, DefaultTheme.WHITE),
              BarChartRodStackItem(50, 100, DefaultTheme.RED_CALENDAR),
            ],
          ),
          BarChartRodData(
            y: 100,
            rodStackItems: [
              BarChartRodStackItem(0, 10, DefaultTheme.WHITE),
              BarChartRodStackItem(10, 30, DefaultTheme.RED_CALENDAR),
              BarChartRodStackItem(30, 100, DefaultTheme.WHITE),
            ],
          ),
        ],
      ),
    ];
  }
}
