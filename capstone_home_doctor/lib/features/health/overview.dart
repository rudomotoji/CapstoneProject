import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/features/home/home.dart';
import 'package:capstone_home_doctor/features/information/blocs/patient_bloc.dart';
import 'package:capstone_home_doctor/features/information/events/patient_event.dart';
import 'package:capstone_home_doctor/features/information/states/patient_state.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_schedule_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_schedule_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_schedule_state.dart';
import 'package:capstone_home_doctor/models/vital_sign_schedule_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:capstone_home_doctor/services/notifications_bloc.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  PatientBloc _patientBloc;
  int _patientId = 0;
  var uuid = Uuid();

  Stream<ReceiveNotification> _notificationsStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPatientId();
    _vitalScheduleBloc = BlocProvider.of(context);
    _patientBloc = BlocProvider.of(context);
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
        _patientBloc.add(PatientEventSetId(id: _patientId));
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
        _buildBMI(),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
        _buildVitalSignSchedule(),
      ],
    );
  }

  _buildVitalSignSchedule() {
    return Container(
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
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/bg-vital-sign.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width - 40,
                      height: 250,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.only(left: 20),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                        ),
                        Text(
                          'Bác sĩ đã đặt cho bạn các thông số sinh hiệu',
                          style: TextStyle(
                            color: DefaultTheme.WHITE,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Bắt đầu từ ngày: ${_dateValidator.parseToDateView(state.dto.dateStarted)}',
                          style: TextStyle(
                            color: DefaultTheme.GREY_VIEW,
                            fontSize: 14,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                        ),
                        _buildVitalSign(state.dto.vitalSigns),
                      ],
                    ),
                  ),
                ),
              ],
            );

            // Container(
            //   margin: EdgeInsets.only(left: 20, right: 20),
            //   padding:
            //       EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //     color: DefaultTheme.GREY_VIEW,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       //
            //       Container(
            //         width: MediaQuery.of(context).size.width,
            //         child: Text('Bác sĩ đã đặt các chỉ số đo sinh hiệu',
            //             style: TextStyle(
            //               color: DefaultTheme.BLACK,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 16,
            //             )),
            //       ),
            //       Container(
            //         width: MediaQuery.of(context).size.width,
            //         child: (state.dto.dateStarted != null)
            //             ? Text(
            //                 'Bắt đầu từ ngày ${_dateValidator.parseToDateView(state.dto.dateStarted)}',
            //                 style: TextStyle(color: DefaultTheme.GREY_TEXT))
            //             : Container(),
            //       ),
            //       Padding(
            //         padding: EdgeInsets.only(bottom: 20),
            //       ),
            //       ListView.builder(
            //         shrinkWrap: true,
            //         physics: NeverScrollableScrollPhysics(),
            //         itemCount: state.dto.vitalSigns.length,
            //         itemBuilder: (BuildContext context, int index) {
            //           return Container(
            //             child: Column(
            //               children: [
            //                 Row(
            //                   children: [
            //                     SizedBox(
            //                       height: 20,
            //                       width: 20,
            //                       child: (state.dto.vitalSigns[index]
            //                                   .vitalSignType ==
            //                               'Nhịp tim')
            //                           ? Image.asset(
            //                               'assets/images/ic-heart-rate.png')
            //                           : (state.dto.vitalSigns[index]
            //                                       .vitalSignType ==
            //                                   'Huyết áp')
            //                               ? Image.asset(
            //                                   'assets/images/ic-blood-pressure.png')
            //                               : Image.asset(
            //                                   'assets/images/ic-health-selected.png'),
            //                     ),
            //                     Padding(
            //                       padding: EdgeInsets.only(left: 10),
            //                     ),
            //                     Text(
            //                       '${state.dto.vitalSigns[index].vitalSignType}',
            //                       style: TextStyle(
            //                           color: DefaultTheme.RED_CALENDAR,
            //                           fontSize: 16),
            //                     ),
            //                   ],
            //                 ),
            //                 Padding(
            //                   padding: EdgeInsets.only(bottom: 5),
            //                 ),
            //                 (state.dto.vitalSigns[index].vitalSignType ==
            //                         'Nhịp tim')
            //                     ? Text(
            //                         'Nhịp tim của bạn an toàn trong khoảng ${state.dto.vitalSigns[index].numberMin} - ${state.dto.vitalSigns[index].numberMax}')
            //                     : (state.dto.vitalSigns[index].vitalSignType ==
            //                             'Huyết áp')
            //                         ? Text(
            //                             'Huyết áp  được đo bắt đầu vào ${state.dto.vitalSigns[index].timeStart} giờ mỗi ngày.')
            //                         : Text(''),
            //               ],
            //             ),
            //           );
            //         },
            //       ),
            //     ],
            //   ),
            // );

          }
        }
        return Container();
      }),
    );
  }

  _getListTimeToSchedule(String timeStart, int minuteAgain) {
    //
    String timeStartString = timeStart.split('T')[1];
  }

  _buildVitalSign(List<VitalSigns> list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              _getIconVitalSign(list[index].vitalSignType),
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              _buildVitalSignDescription(list[index]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVitalSignDescription(VitalSigns dto) {
    if (dto.vitalSignType.trim().toLowerCase().contains('nhịp tim')) {
      return Container(
        height: 40,
        width: MediaQuery.of(context).size.width - 130,
        decoration: BoxDecoration(
          color: DefaultTheme.WHITE.withOpacity(0.9),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: RichText(
            text: TextSpan(
                style: TextStyle(color: DefaultTheme.BLACK),
                children: <TextSpan>[
                  //
                  TextSpan(text: 'Khoảng nhịp tim an toàn: '),
                  TextSpan(
                      text: '${dto.numberMin} - ${dto.numberMax}',
                      style: TextStyle(color: DefaultTheme.RED_CALENDAR)),
                  TextSpan(text: ' bpm'),
                ]),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _getIconVitalSign(String vitalType) {
    if (vitalType.trim().toLowerCase().contains('nhịp tim')) {
      return Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: DefaultTheme.WHITE.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Image.asset(
          'assets/images/ic-heart-rate.png',
        ),
      );
    } else if (vitalType.trim().toLowerCase().contains('huyết áp')) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: DefaultTheme.WHITE.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.all(10),
        child: Image.asset(
          'assets/images/ic-blood-pressure.png',
        ),
      );
    } else {
      return Container();
    }
  }

  _buildBMI() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          if (state is PatientStateLoading) {}
          if (state is PatientStateFailure) {}
          if (state is PatientStateSuccess) {
            if (state.dto == null) {
              return Container();
            } else {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/bg_bmi.png',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width - 40,
                        height: 250,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 80,
                            child: Row(
                              children: [
                                Text(
                                  'BMI',
                                  style: TextStyle(
                                    color: DefaultTheme.WHITE,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '${state.dto.fullName}',
                                  style: TextStyle(
                                    color: DefaultTheme.WHITE,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                    ),
                                    Text('Chiều cao: ${state.dto.height} cm',
                                        style: TextStyle(
                                            color: DefaultTheme.WHITE,
                                            fontSize: 17)),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                    ),
                                    Text('Cân nặng: ${state.dto.weight} kg',
                                        style: TextStyle(
                                            color: DefaultTheme.WHITE,
                                            fontSize: 17)),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.only(top: 20, left: 20),
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: DefaultTheme.WHITE,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'BMI',
                                        style: TextStyle(
                                            color: DefaultTheme.GREY_TEXT,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 3),
                                      ),
                                      Text(
                                        '${_genderBMI(state.dto.height, state.dto.weight)}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'NewYork',
                                            color: DefaultTheme.BLUE_REFERENCE,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 3),
                                      ),
                                      Text('kg/m\u00B2'),
                                    ],
                                  )),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                          ),
                          Container(
                            child: Text(
                              'Trạng thái: ',
                              style: TextStyle(
                                  color: DefaultTheme.WHITE,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                          ),
                          Container(
                              padding: EdgeInsets.only(bottom: 10, top: 10),
                              width: MediaQuery.of(context).size.width - 80,
                              decoration: BoxDecoration(
                                color: DefaultTheme.BLUE_REFERENCE
                                    .withOpacity(0.7),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  '${_genderBMIStatus(state.dto.height, state.dto.weight)}',
                                  style: TextStyle(
                                      color: DefaultTheme.WHITE, fontSize: 16),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }
          return Container();
        },
      ),
    );
  }

  _genderBMIStatus(int height, int weight) {
    String result = '';
    if (height == null || weight == null || height == 0 || weight == 0) {
      result = 'Không xác định';
    } else {
      double heightToMeter = height / 100;
      double bmi = (weight / (heightToMeter * heightToMeter));
      if (bmi < 18.5) {
        result = 'Cân nặng thấp (gầy)';
      } else if (bmi >= 18.5 && bmi < 23) {
        result = 'Bình thường';
      } else if (bmi >= 23 && bmi < 23.9) {
        result = 'Thừa cân';
      } else if (bmi >= 23.9 && bmi < 25) {
        result = 'Tiền béo phì';
      } else if (bmi >= 25 && bmi < 30) {
        result = 'Béo phì độ I';
      } else if (bmi >= 30 && bmi < 40) {
        result = 'Béo phì độ II';
      } else if (bmi >= 40) {
        result = 'Béo phì độ III';
      } else {
        result = 'Không xác định';
      }
    }
    return result;
  }

  _genderBMI(int height, int weight) {
    double heightToMeter = height / 100;
    double result = (weight / (heightToMeter * heightToMeter));
    return result.floorToDouble();
  }
}
