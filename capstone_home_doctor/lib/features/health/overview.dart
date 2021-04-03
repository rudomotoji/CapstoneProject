import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/features/home/home.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_schedule_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_schedule_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_schedule_state.dart';
import 'package:capstone_home_doctor/models/vital_sign_schedule_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:capstone_home_doctor/services/notifications_bloc.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

//
final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
final DateValidator _dateValidator = DateValidator();

class OverviewTab extends StatefulWidget {
  @override
  _OverviewTabState createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  VitalScheduleBloc _vitalScheduleBloc;
  int _patientId = 0;
  var uuid = Uuid();

  Stream<ReceiveNotification> _notificationsStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPatientId();
    _vitalScheduleBloc = BlocProvider.of(context);

    _notificationsStream = NotificationsBloc.instance.notificationsStream;
    _notificationsStream.listen((notification) {
      _getPatientId();
    });
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        _patientId = value;
      });
      if (_patientId != 0) {
        _vitalScheduleBloc.add(VitalScheduleEventGet(patientId: _patientId));
      }
    });
  }

  _saveVitalSignScheduleOffline(
      VitalSignScheduleDTO _vitalSignScheduleDTO) async {
    //insert schedule vitalsign into local db
    if (_vitalSignScheduleDTO != null) {
      await _sqfLiteHelper.deleteVitalSignSchedule();

      for (VitalSigns x in _vitalSignScheduleDTO.vitalSigns) {
        VitalSigns vitalSignDTO = VitalSigns(
          id: uuid.v1(),
          idSchedule: _vitalSignScheduleDTO.medicalInstructionId,
          vitalSignScheduleId: _vitalSignScheduleDTO.vitalSignScheduleId,
          vitalSignType: x.vitalSignType,
          minuteAgain: x.minuteAgain,
          minuteDangerInterval: x.minuteDangerInterval,
          minuteNormalInterval: x.minuteNormalInterval,
          numberMax: x.numberMax,
          numberMin: x.numberMin,
          timeStart: x.timeStart,
        );

        await _sqfLiteHelper.insertVitalSignSchedule(vitalSignDTO);
        print('insert new Schedule successful');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: BlocBuilder<VitalScheduleBloc, VitalScheduleState>(
              builder: (context, state) {
            if (state is VitalScheduleStateLoading) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/loading.gif'),
                ),
              );
            }
            if (state is VitalScheduleStateFailure) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  child: Center(
                    child: Text('Không thể tải'),
                  ));
            }
            if (state is VitalScheduleStateSuccess) {
              if (state.dto.medicalInstructionId == null) {
                return Container();
              } else {
                _saveVitalSignScheduleOffline(state.dto);
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: DefaultTheme.GREY_VIEW,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                            'Bác sĩ đã đặt các chỉ số đo sinh hiệu cho bạn'),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: (state.dto.dateStarted != null)
                            ? Text(
                                'Bắt đầu từ ngày ${_dateValidator.parseToDateView(state.dto.dateStarted)}')
                            : Container(),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.dto.vitalSigns.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: (state.dto.vitalSigns[index]
                                                  .vitalSignType ==
                                              'Nhịp tim')
                                          ? Image.asset(
                                              'assets/images/ic-heart-rate.png')
                                          : (state.dto.vitalSigns[index]
                                                      .vitalSignType ==
                                                  'Huyết áp')
                                              ? Image.asset(
                                                  'assets/images/ic-blood-pressure.png')
                                              : Image.asset(
                                                  'assets/images/ic-health-selected.png'),
                                    ),
                                    Text(
                                        '${state.dto.vitalSigns[index].vitalSignType}'),
                                  ],
                                ),
                                (state.dto.vitalSigns[index].vitalSignType ==
                                        'Nhịp tim')
                                    ? Text(
                                        'Nhịp tim của bạn an toàn trong khoảng ${state.dto.vitalSigns[index].numberMin} - ${state.dto.vitalSigns[index].numberMax}')
                                    : (state.dto.vitalSigns[index]
                                                .vitalSignType ==
                                            'Huyết áp')
                                        ? Text(
                                            'Huyết áp  được đo bắt đầu vào ${state.dto.vitalSigns[index].timeStart} giờ, cách ${(state.dto.vitalSigns[index].minuteAgain / 60).toInt()} tiếng đo lại.')
                                        : Text(''),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
            }
            return Container();
          }),
        ),
        // Container(
        //   width: MediaQuery.of(context).size.width - 60,
        //   height: 150,
        //   decoration: BoxDecoration(
        //     boxShadow: [
        //       BoxShadow(
        //         color: DefaultTheme.GREY_LIGHT.withOpacity(0.4),
        //         spreadRadius: 3,
        //         blurRadius: 7,
        //         offset: Offset(0, 2), // changes position of shadow
        //       ),
        //     ],
        //     color: DefaultTheme.WHITE,
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Column(
        //     children: <Widget>[
        //       Container(
        //         alignment: Alignment.centerLeft,
        //         padding: EdgeInsets.only(left: 20, top: 10),
        //         child: Text(
        //           'BMI',
        //           style: TextStyle(
        //             fontWeight: FontWeight.w500,
        //             fontSize: 20,
        //           ),
        //         ),
        //       ),
        //       Row(
        //         children: <Widget>[
        //           //
        //           Container(
        //             width: (MediaQuery.of(context).size.width - 60) / 2,
        //             height: 110,
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: <Widget>[
        //                 Row(
        //                   children: [
        //                     Padding(
        //                       padding: EdgeInsets.only(left: 20),
        //                     ),
        //                     Container(
        //                       width: 10,
        //                       height: 10,
        //                       decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(5),
        //                         color: DefaultTheme.BLUE_REFERENCE
        //                             .withOpacity(0.8),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: EdgeInsets.only(left: 20),
        //                     ),
        //                     Align(
        //                       alignment: Alignment.centerLeft,
        //                       child: Text('Thiếu cân'),
        //                     ),
        //                   ],
        //                 ),
        //                 Padding(
        //                   padding: EdgeInsets.only(bottom: 5),
        //                 ),
        //                 Row(
        //                   children: [
        //                     Padding(
        //                       padding: EdgeInsets.only(left: 20),
        //                     ),
        //                     Container(
        //                       width: 10,
        //                       height: 10,
        //                       decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(5),
        //                         color: DefaultTheme.GRADIENT_1.withOpacity(0.8),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: EdgeInsets.only(left: 20),
        //                     ),
        //                     Align(
        //                       alignment: Alignment.centerLeft,
        //                       child: Text('Bình thường'),
        //                     ),
        //                   ],
        //                 ),
        //                 Padding(
        //                   padding: EdgeInsets.only(bottom: 5),
        //                 ),
        //                 Row(
        //                   children: [
        //                     Padding(
        //                       padding: EdgeInsets.only(left: 20),
        //                     ),
        //                     Container(
        //                       width: 10,
        //                       height: 10,
        //                       decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(5),
        //                         color:
        //                             DefaultTheme.RED_CALENDAR.withOpacity(0.8),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: EdgeInsets.only(left: 20),
        //                     ),
        //                     Align(
        //                       alignment: Alignment.centerLeft,
        //                       child: Text('Thừa cân'),
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Container(
        //             width: (MediaQuery.of(context).size.width - 60) / 2,
        //             height: 110,
        //             child: Center(
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: [
        //                   Container(
        //                     width: 50,
        //                     height: 2,
        //                     decoration: BoxDecoration(
        //                       color: DefaultTheme.GRADIENT_1.withOpacity(0.8),
        //                       borderRadius: BorderRadius.circular(25),
        //                     ),
        //                   ),
        //                   Text(
        //                     '21.5',
        //                     style: TextStyle(
        //                         color: DefaultTheme.BLACK,
        //                         fontSize: 30,
        //                         fontWeight: FontWeight.w500),
        //                   ),
        //                   Padding(
        //                     padding: EdgeInsets.only(top: 5),
        //                   ),
        //                   Text(
        //                     'kg/m2',
        //                     style: TextStyle(
        //                         color: DefaultTheme.GREY_TEXT,
        //                         fontSize: 15,
        //                         fontWeight: FontWeight.w400),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        // //
        // Padding(
        //   padding: EdgeInsets.only(bottom: 10),
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: <Widget>[
        //     Padding(
        //       padding: EdgeInsets.only(left: 25),
        //     ),
        //     Container(
        //       width: (MediaQuery.of(context).size.width - 60) / 2,
        //       child: Column(
        //         children: <Widget>[
        //           Container(
        //             height: 120,
        //             width: (MediaQuery.of(context).size.width - 60 - 10) / 2,
        //             decoration: BoxDecoration(
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: DefaultTheme.GREY_LIGHT.withOpacity(0.4),
        //                   spreadRadius: 3,
        //                   blurRadius: 7,
        //                   offset: Offset(0, 2), // changes position of shadow
        //                 ),
        //               ],
        //               color: DefaultTheme.WHITE,
        //               borderRadius: BorderRadius.circular(12),
        //             ),
        //             child: Column(
        //               children: [
        //                 Row(
        //                   children: [
        //                     Container(
        //                       alignment: Alignment.centerLeft,
        //                       padding: EdgeInsets.only(left: 20, top: 10),
        //                       child: Text(
        //                         'Giới tính',
        //                         style: TextStyle(
        //                           fontWeight: FontWeight.w500,
        //                           fontSize: 15,
        //                         ),
        //                       ),
        //                     ),
        //                     Spacer(),
        //                     Container(
        //                       alignment: Alignment.bottomRight,
        //                       padding: EdgeInsets.only(right: 20, top: 10),
        //                       child: Text(
        //                         'Nam',
        //                         style: TextStyle(
        //                           fontWeight: FontWeight.w400,
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 Expanded(
        //                   child: SizedBox(
        //                     width: 50,
        //                     height: 50,
        //                     child: Image.asset('assets/images/ic-male.png'),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Padding(
        //             padding: EdgeInsets.only(bottom: 10),
        //           ),
        //           Container(
        //             height: 120,
        //             width: (MediaQuery.of(context).size.width - 60 - 10) / 2,
        //             decoration: BoxDecoration(
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: DefaultTheme.GREY_LIGHT.withOpacity(0.4),
        //                   spreadRadius: 3,
        //                   blurRadius: 7,
        //                   offset: Offset(0, 2), // changes position of shadow
        //                 ),
        //               ],
        //               color: DefaultTheme.WHITE,
        //               borderRadius: BorderRadius.circular(12),
        //             ),
        //             child: Column(
        //               children: <Widget>[
        //                 Container(
        //                   alignment: Alignment.centerLeft,
        //                   padding: EdgeInsets.only(left: 20, top: 10),
        //                   child: Text(
        //                     'Cân nặng',
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.w500,
        //                       fontSize: 15,
        //                     ),
        //                   ),
        //                 ),
        //                 Expanded(
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: [
        //                       Container(
        //                         margin: EdgeInsets.only(right: 0, top: 20),
        //                         child: Align(
        //                           alignment: Alignment.center,
        //                           child: Text(
        //                             '61',
        //                             style: TextStyle(
        //                               fontFamily: 'NewYork',
        //                               color: DefaultTheme.GREY_TEXT
        //                                   .withOpacity(0.5),
        //                               fontSize: 15,
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                       Container(
        //                         margin:
        //                             EdgeInsets.only(left: 5, right: 3, top: 8),
        //                         child: Align(
        //                           alignment: Alignment.center,
        //                           child: Text(
        //                             '62',
        //                             style: TextStyle(
        //                               fontFamily: 'NewYork',
        //                               color: DefaultTheme.GREY_TEXT,
        //                               fontSize: 18,
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                       Container(
        //                         margin: EdgeInsets.only(left: 5, right: 5),
        //                         width: 40,
        //                         height: 40,
        //                         decoration: BoxDecoration(
        //                           color: DefaultTheme.RED_CALENDAR
        //                               .withOpacity(0.8),
        //                           borderRadius: BorderRadius.circular(25),
        //                         ),
        //                         child: Center(
        //                           child: Text(
        //                             '63',
        //                             style: TextStyle(
        //                               fontFamily: 'NewYork',
        //                               color: DefaultTheme.WHITE,
        //                               fontSize: 20,
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                       Container(
        //                         margin:
        //                             EdgeInsets.only(left: 3, right: 5, top: 8),
        //                         child: Align(
        //                           alignment: Alignment.center,
        //                           child: Text(
        //                             '64',
        //                             style: TextStyle(
        //                               fontFamily: 'NewYork',
        //                               color: DefaultTheme.GREY_TEXT,
        //                               fontSize: 18,
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                       Container(
        //                         margin: EdgeInsets.only(left: 0, top: 20),
        //                         child: Align(
        //                           alignment: Alignment.center,
        //                           child: Text(
        //                             '65',
        //                             style: TextStyle(
        //                               fontFamily: 'NewYork',
        //                               color: DefaultTheme.GREY_TEXT
        //                                   .withOpacity(0.5),
        //                               fontSize: 15,
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: EdgeInsets.only(bottom: 10),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     Padding(
        //       padding: EdgeInsets.only(left: 10),
        //     ),
        //     Container(
        //       width: (MediaQuery.of(context).size.width - 60 - 10) / 2,
        //       height: 250,
        //       decoration: BoxDecoration(
        //         boxShadow: [
        //           BoxShadow(
        //             color: DefaultTheme.GREY_LIGHT.withOpacity(0.4),
        //             spreadRadius: 3,
        //             blurRadius: 7,
        //             offset: Offset(0, 2), // changes position of shadow
        //           ),
        //         ],
        //         color: DefaultTheme.WHITE,
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       child: Column(
        //         children: [
        //           Container(
        //             alignment: Alignment.centerLeft,
        //             padding: EdgeInsets.only(left: 20, top: 10),
        //             child: Text(
        //               'Chiều cao',
        //               style: TextStyle(
        //                 fontWeight: FontWeight.w500,
        //                 fontSize: 15,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
