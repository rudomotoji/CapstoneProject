import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/heart_rate_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/heart_rate_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/heart_rate_state.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_sign_state.dart';
import 'package:capstone_home_doctor/models/heart_rate_dto.dart';
import 'package:capstone_home_doctor/models/history_vivtal_sign.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
//
final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

class HistoryVitalSign extends StatefulWidget {
  @override
  _HistoryVitalSignState createState() => _HistoryVitalSignState();
}

class _HistoryVitalSignState extends State<HistoryVitalSign> {
  List<HistoryVitalSignDTO> _lists = [
    HistoryVitalSignDTO(dateCreate: '19 tháng 3', data: [
      DataDTO(
        time: "12:00",
        status: "Cao bất thường",
        value: "92",
      ),
      DataDTO(
        time: "12:00",
        status: "Cao bất thường",
        value: "92",
      ),
      DataDTO(
        time: "12:00",
        status: "Cao bất thường",
        value: "92",
      ),
    ]),
    HistoryVitalSignDTO(dateCreate: '19 tháng 3', data: [
      DataDTO(
        time: "12:00",
        status: "Cao bất thường",
        value: "92",
      ),
      DataDTO(
        time: "12:00",
        status: "Cao bất thường",
        value: "92",
      ),
      DataDTO(
        time: "12:00",
        status: "Cao bất thường",
        value: "92",
      ),
    ]),
  ];

  List<VitalSignDTO> listHeartRate = [];

  String vital_type = 'HEART_RATE';
  // HeartRateBloc _heartRateBloc;
  VitalSignBloc _vitalSignBloc;
  int _patientId = 0;

  @override
  void initState() {
    _vitalSignBloc = BlocProvider.of(context);
    _getPatientId();
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
            title: 'Lịch sử đo',
            isMainView: false,
            buttonHeaderType: ButtonHeaderType.BACK_HOME,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                // _listHistory(),
                BlocBuilder<VitalSignBloc, VitalSignState>(
                  builder: (context, state) {
                    //
                    if (state is VitalSignStateLoading) {
                      print('state load');
                    }
                    if (state is VitalSignStateFailure) {
                      print('state fail');
                    }
                    if (state is VitalSignStateGetListSuccess) {
                      listHeartRate = state.list;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: listHeartRate.length,
                        itemBuilder: (BuildContext context, int index) {
                          //
                          return Container(
                              width: MediaQuery.of(context).size.width - 20,
                              padding: EdgeInsets.only(
                                  bottom: 20, top: 20, left: 20, right: 20),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: DefaultTheme.GREY_VIEW,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  //
                                  Text(
                                      '${listHeartRate[index].dateTime.split('.')[0]}'),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Container(
                                        width: 100,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                              '${listHeartRate[index].value1}'),
                                        ),
                                      ),
                                      Container(
                                          width: 100,
                                          child: (listHeartRate[index].value1 >
                                                  90)
                                              ? Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text('Cao bất thường'),
                                                )
                                              : (listHeartRate[index].value1 <
                                                      60)
                                                  ? Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text('Thấp'),
                                                    )
                                                  : Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text('Ổn định'),
                                                    )),
                                    ],
                                  ),
                                ],
                              ));
                        },
                      );
                    }

                    return Container();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
