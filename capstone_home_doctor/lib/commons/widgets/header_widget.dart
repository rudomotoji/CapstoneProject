import 'dart:async';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/numeral_ui.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/features/global/repositories/system_repository.dart';

import 'package:capstone_home_doctor/features/information/blocs/patient_bloc.dart';
import 'package:capstone_home_doctor/features/information/events/patient_event.dart';
import 'package:capstone_home_doctor/features/information/repositories/patient_repository.dart';
import 'package:capstone_home_doctor/features/information/states/patient_state.dart';
import 'package:capstone_home_doctor/features/login/blocs/token_device_bloc.dart';
import 'package:capstone_home_doctor/features/login/events/token_device_event.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repository.dart';
import 'package:capstone_home_doctor/features/peripheral/views/connect_peripheral_view.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/prescription_list_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/events/prescription_list_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/real_time_vt_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_repository.dart';
import 'package:capstone_home_doctor/models/patient_dto.dart';
import 'package:capstone_home_doctor/models/token_device_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:capstone_home_doctor/services/measure_helper.dart';
import 'package:capstone_home_doctor/services/medical_instruction_helper.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:capstone_home_doctor/services/notifications_bloc.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:capstone_home_doctor/services/reminder_helper.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:capstone_home_doctor/services/time_system_helper.dart';
import 'package:capstone_home_doctor/services/vital_sign_helper.dart';
import 'package:flutter/material.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

//helper to remove
final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final VitalSignHelper _vitalSignHelper = VitalSignHelper();
final PeripheralHelper _peripheralHelper = PeripheralHelper();
final PeripheralRepository _peripheralRepository = PeripheralRepository();
final ContractHelper _contractHelper = ContractHelper();
final MedicalInstructionHelper _medicalInstructionHelper =
    MedicalInstructionHelper();
final SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
final ReminderHelper _reminderHelper = ReminderHelper();
final VitalSignRepository _vitalSignRepository = VitalSignRepository();
final MeasureHelper _measureHelper = MeasureHelper();
final SystemRepository _systemRepository =
    SystemRepository(httpClient: http.Client());
final TimeSystemHelper _timeSystemHelper = TimeSystemHelper();
//
final ArrayValidator _arrayValidator = ArrayValidator();
//final RealTimeHeartRateBloc _realTimeHeartRateBloc = RealTimeHeartRateBloc();

enum ButtonHeaderType {
  NONE,
  AVATAR,
  NEW_MESSAGE,
  DETAIL,
  BACK_HOME,
  // HEART_RATE_MEASURE,
  CREATE_HEALTH_RECORD,
  HR_CREATE_SHARE,
}

class HeaderWidget extends StatefulWidget {
  BuildContext context;
  final String title;
  ButtonHeaderType buttonHeaderType;
  bool isMainView;
  final VoidCallback onTapButton;

  HeaderWidget({
    Key key,
    this.context,
    this.title,
    this.buttonHeaderType,
    this.isMainView,
    this.onTapButton,
  }) : super(key: key);

  @override
  _HeaderWidget createState() =>
      _HeaderWidget(title, buttonHeaderType, isMainView);
}

class _HeaderWidget extends State<HeaderWidget> {
  Stream<ReceiveNotification> _realTimeHeartRateStream;
  String _title;
  ButtonHeaderType _buttonHeaderType;
  bool _isMainView;
  PatientRepository patientRepository =
      PatientRepository(httpClient: http.Client());

  //patient Id
  int _patientId = 0;

  PatientBloc _patientBloc;
  PatientDTO _patientDTO = PatientDTO(fullName: 'User Full Name');
  PrescriptionListBloc _prescriptionListBloc;
  TokenDeviceBloc _tokenDeviceBloc;
  @override
  _HeaderWidget(
    this._title,
    this._buttonHeaderType,
    this._isMainView,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPatientId();
    _patientBloc = BlocProvider.of(context);
    _prescriptionListBloc = BlocProvider.of(context);
    _tokenDeviceBloc = BlocProvider.of(context);
    // _getTimeSystem();
  }

  // _getTimeSystem() async {
  //   await _systemRepository.getTimeSystem().then((value) async {
  //     /////
  //     await _timeSystemHelper.setTimeSystem(value);
  //   });
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_buttonHeaderType == null) {
      _buttonHeaderType = ButtonHeaderType.NONE;
    }
    return Container(
      height: 80,
      child: Padding(
        padding: DefaultNumeralUI.HEADER_SIZE,
        child: Row(
          children: [
            if (!_isMainView)
              (InkWell(
                splashColor: DefaultTheme.TRANSPARENT,
                highlightColor: DefaultTheme.TRANSPARENT,
                onTap: () async {
                  Future.delayed(const Duration(milliseconds: 100), () async {
                    if (_title == '') {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        RoutesHDr.MAIN_HOME,
                        (Route<dynamic> route) => false,
                      );
                    } else if (_title.contains('Hợp đồng'.trim())) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        RoutesHDr.MAIN_HOME,
                        (Route<dynamic> route) => false,
                      );
                    } else if (_title.contains('Tạo hồ sơ sức khỏe'.trim())) {
                      await _medicalInstructionHelper
                          .getCreateHRFromDetail()
                          .then((check) async {
                        if (check) {
                          await _medicalInstructionHelper
                              .updateCreateHRFromDetail(false);

                          ///
                          await _medicalInstructionHelper
                              .updateCheckToCreateOrList(false);
                          int currentIndex = 2;
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              RoutesHDr.MAIN_HOME,
                              (Route<dynamic> route) => false,
                              arguments: currentIndex);
                        } else {
                          Navigator.of(context).pop();
                        }
                      });
                    } else if (_title.contains('Chi tiết hồ sơ')) {
                      _medicalInstructionHelper
                          .getCheckToCreateOrList()
                          .then((check) async {
                        //
                        if (check) {
                          ///CODE HERE FOR NAVIGATE
                          ///
                          int currentIndex = 2;
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              RoutesHDr.MAIN_HOME,
                              (Route<dynamic> route) => false,
                              arguments: currentIndex);
                          await _medicalInstructionHelper
                              .updateCreateHRFromDetail(false);

                          ///
                          await _medicalInstructionHelper
                              .updateCheckToCreateOrList(false);
                        } else {
                          Navigator.pop(context);
                          await _medicalInstructionHelper
                              .updateCheckToCreateOrList(false);
                          await _medicalInstructionHelper
                              .updateCreateHRFromDetail(false);
                        }
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  });
                },
                child: Image.asset(
                  'assets/images/ic-pop.png',
                  width: 30,
                  height: 30,
                ),
              )),
            if (!_isMainView)
              (Padding(
                padding: EdgeInsets.only(left: 20),
              )),
            Text(
              '${_title}',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: DefaultTheme.BLACK,
              ),
            ),
            // if (_buttonHeaderType == ButtonHeaderType.HEART_RATE_MEASURE)
            //   (Expanded(
            //     flex: 2,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Padding(padding: EdgeInsets.only(left: 20)),
            //         Container(
            //           padding: EdgeInsets.only(
            //               left: 10, right: 10, bottom: 5, top: 5),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(20),
            //             color: DefaultTheme.RED_CALENDAR.withOpacity(0.2),
            //             // border: Border.all(
            //             //     color: DefaultTheme.GREY_TOP_TAB_BAR, width: 0.5),
            //           ),
            //           child: InkWell(
            //               splashColor: DefaultTheme.TRANSPARENT,
            //               highlightColor: DefaultTheme.TRANSPARENT,
            //               onTap: _onMeasuring,
            //               child: Row(
            //                 children: [
            //                   Image.asset(
            //                     'assets/images/ic-heart-dangerous.gif',
            //                     width: 30,
            //                     height: 30,
            //                   ),
            //                   Container(
            //                     child: Text('Đo'),
            //                   ),
            //                 ],
            //               )),
            //         ),
            //       ],
            //     ),
            //   )),

            if (_buttonHeaderType == ButtonHeaderType.HR_CREATE_SHARE)
              (Expanded(
                flex: 2,
                child: Row(
                  children: [
                    //
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesHDr.MEDICAL_SHARE);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: DefaultTheme.GREY_TOP_TAB_BAR, width: 1),
                          color: DefaultTheme.WHITE,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Image.asset(
                          'assets/images/ic-share.png',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    InkWell(
                      onTap: () async {
                        await _medicalInstructionHelper
                            .updateCreateHRFromDetail(false);
                        Navigator.of(context)
                            .pushNamed(RoutesHDr.CREATE_HEALTH_RECORD);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: DefaultTheme.GREY_TOP_TAB_BAR, width: 1),
                          color: DefaultTheme.WHITE,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Image.asset(
                          'assets/images/ic-create-dark.png',
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            //
            if (_buttonHeaderType == ButtonHeaderType.CREATE_HEALTH_RECORD)
              (Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        await _medicalInstructionHelper
                            .updateCreateHRFromDetail(true);
                        Navigator.of(context)
                            .pushNamed(RoutesHDr.CREATE_HEALTH_RECORD);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: DefaultTheme.GREY_TOP_TAB_BAR, width: 1),
                          color: DefaultTheme.WHITE,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Image.asset(
                          'assets/images/ic-create-dark.png',
                        ),
                      ),
                    ),
                  ],
                ),
              )),

            //
            if (_buttonHeaderType == ButtonHeaderType.DETAIL)
              (Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20)),
                    InkWell(
                      splashColor: DefaultTheme.TRANSPARENT,
                      highlightColor: DefaultTheme.TRANSPARENT,
                      onTap: widget.onTapButton,
                      child: Image.asset(
                        'assets/images/ic-detail.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
              )),
            if (_buttonHeaderType == ButtonHeaderType.BACK_HOME)
              (Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 15)),
                    InkWell(
                      splashColor: DefaultTheme.TRANSPARENT,
                      highlightColor: DefaultTheme.TRANSPARENT,
                      onTap: _backToHome,
                      child: Image.asset(
                        'assets/images/ic-back-home.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
              )),
            if (_buttonHeaderType == ButtonHeaderType.NEW_MESSAGE)
              (Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20)),
                    InkWell(
                      splashColor: DefaultTheme.TRANSPARENT,
                      highlightColor: DefaultTheme.TRANSPARENT,
                      onTap: widget.onTapButton,
                      child: Image.asset(
                        'assets/images/ic-new-msg.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
              )),
            if (_buttonHeaderType == ButtonHeaderType.AVATAR) (Spacer()),
            if (_buttonHeaderType == ButtonHeaderType.AVATAR)
              (BlocBuilder<PatientBloc, PatientState>(
                  builder: (context2, state2) {
                if (state2 is PatientStateLoading) {
                  return Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: DefaultTheme.GREY_BUTTON),
                    child: Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset('assets/images/loading.gif'),
                      ),
                    ),
                  );
                }
                if (state2 is PatientStateFailure) {
                  return Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: DefaultTheme.GREY_BUTTON),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      child: Center(
                        child: Text('',
                            style: TextStyle(
                              color: DefaultTheme.GREY_TEXT,
                              fontSize: 12,
                            )),
                      ),
                    ),
                  );
                }
                if (state2 is PatientStateSuccess) {
                  _patientDTO = state2.dto;
                  if (state2.dto == null) {
                    return Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: DefaultTheme.GREY_BUTTON),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 20),
                        child: Center(
                          child: Text('User Fullname',
                              style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 12,
                              )),
                        ),
                      ),
                    );
                  }
                }
                return Container(
                  padding:
                      EdgeInsets.only(bottom: 5, top: 5, left: 15, right: 5),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      color: DefaultTheme.WHITE,
                      // border: Border.all(
                      //     color: DefaultTheme.GREY_TOP_TAB_BAR, width: 0.5),
                      borderRadius: BorderRadius.circular(50)),
                  child: InkWell(
                    splashColor: DefaultTheme.TRANSPARENT,
                    highlightColor: DefaultTheme.TRANSPARENT,
                    onTap: _onButtonShowModelSheet,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              //'${_patientDTO.fullName}',
                              (_patientDTO.fullName.split(' ').length >= 2)
                                  ? '${_patientDTO.fullName.split(' ').first} ${_patientDTO.fullName.split(' ').last}'
                                  : '${_patientDTO.fullName}',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        CircleAvatar(
                          radius: 16,
                          child: ClipOval(
                            child:
                                Image.asset('assets/images/avatar-default.jpg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }))
          ],
        ),
      ),
    );
  }

  _kickHRCOn() async {
    await _peripheralHelper.getPeripheralId().then((id) async {
      if (id != '') {
        await _vitalSignRepository.kickHRCOn(id);
      }
    });
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        if (!mounted) return;
        _patientId = value;
        if (_patientId != 0) {
          _patientBloc.add(PatientEventSetId(id: _patientId));
        }
      });
    });
  }

  _signOut() async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                width: 250,
                height: 180,
                decoration: BoxDecoration(
                  color: DefaultTheme.WHITE.withOpacity(0.7),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 5, top: 10),
                      child: Text(
                        'Lưu ý',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: DefaultTheme.BLACK,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Đăng xuất tài khoản đồng nghĩa bạn sẽ mất kết nối với thiết bị đeo tay.\nBạn vẫn muốn đăng xuất?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: DefaultTheme.GREY_TEXT,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Divider(
                      height: 1,
                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          height: 40,
                          minWidth: 250 / 2 - 10.5,
                          child: Text('Đóng',
                              style: TextStyle(color: DefaultTheme.BLUE_TEXT)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Container(
                          height: 40,
                          width: 0.5,
                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                        ),
                        FlatButton(
                          height: 40,
                          minWidth: 250 / 2 - 10.5,
                          child: Text('Đăng xuất',
                              style: TextStyle(color: DefaultTheme.RED_TEXT)),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            //

                            await _sqfLiteHelper
                                .cleanDatabase()
                                .then((valueDelete) async {
                              if (valueDelete) {
                                _prescriptionListBloc
                                    .add(PrescriptionListEventInitial());
                                //
                                //disconnect
                                await _peripheralHelper
                                    .getPeripheralId()
                                    .then((peripheralId) async {
                                  //
                                  if (peripheralId != '' ||
                                      peripheralId != 'NOTHING') {
                                    //
                                    await _peripheralRepository
                                        .findScanResultById(peripheralId)
                                        .then((device) async {
                                      //
                                      if (device != null) {
                                        await _peripheralRepository
                                            .disconnectDevice(peripheralId);
                                      }
                                    });
                                  }
                                });
                                await _authenticateHelper
                                    .getAccountId()
                                    .then((accountId) async {
                                  TokenDeviceDTO _tokenDeviceDTO =
                                      TokenDeviceDTO(
                                          accountId: accountId,
                                          tokenDevice: '');
                                  _tokenDeviceBloc.add(TokenDeviceEventUpdate(
                                      dto: _tokenDeviceDTO));
                                });
                                //
                                await _vitalSignHelper
                                    .updatePeopleStatus('')
                                    .then((isOk) {
                                  if (isOk) {
                                    ReceiveNotification notiData =
                                        ReceiveNotification(
                                            id: 0,
                                            title: "reload heart rate",
                                            body: "",
                                            payload: "");
                                    HeartRefreshBloc.instance
                                        .newNotification(notiData);
                                  }
                                });
                                await _measureHelper.updateMeasureOn(false);
                                _vitalSignHelper.updateWarning(false, '');
                                //
                                //SAVE TIME START
                                await _measureHelper.updateTimeStartM('');
                                //
                                //SAVE DURATION TIME
                                await _measureHelper.updateDurationM(0);

                                //
                                await _measureHelper.updateCountingM(0);
                                //UPDATE TIME AND VALUE LIST HR INTO INITIAL
                                await _measureHelper.updateListTime('');
                                await _measureHelper.updateListValueHr('');
                                await _sqfLiteHelper
                                    .deleteVitalSignSchedule()
                                    .then((isDeleted) async {
                                  //
                                  //
                                  if (isDeleted) {
                                    //remove all shared preference
                                    await _authenticateHelper.updateAuth(
                                        false, null, null);
                                    await _peripheralHelper
                                        .updatePeripheralChecking(false, '');
                                    await _vitalSignHelper
                                        .updateCountDownDangerous(0);
                                    await _vitalSignHelper
                                        .updateCountInBackground(0);
                                    await _vitalSignHelper.updateCountingHR(0);
                                    await _vitalSignHelper.updateHeartValue(0);
                                    await _vitalSignHelper
                                        .updateCheckToNormal(false);
                                    await _vitalSignHelper
                                        .updateCountToNormal(0);
                                    await _vitalSignHelper
                                        .updateSendSMSTurnOffStatus(false);
                                    await _contractHelper
                                        .updateAvailableDay('');
                                    await _medicalInstructionHelper
                                        .updateCheckToCreateOrList(false);
                                    await _medicalInstructionHelper
                                        .updateCreateHRFromDetail(false);
                                    await _reminderHelper
                                        .updateValueBluetooth(false);
                                    //
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        RoutesHDr.LOG_IN,
                                        (Route<dynamic> route) => false);
                                    //
                                  }
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    //
  }

  _backToHome() async {
    // NotificationsSelectBloc.instance.newNotification('');
    await _medicalInstructionHelper.updateCheckToCreateOrList(false);
    await _medicalInstructionHelper.updateCreateHRFromDetail(false);
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesHDr.MAIN_HOME, (Route<dynamic> route) => false);
  }

  _onMeasuring() async {
    //String heartRateData = 'Đang đo';
    await realtimeHeartRateBloc.realtimeHrSink.add(0);
    bool isMeasureOff = false;
    List<int> listHeartRate = [];
    // List<int> listValueMeasure = [];
    // listValueMeasure.clear();
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
                    width: 250,
                    height: 160,
                    decoration: BoxDecoration(
                      color: DefaultTheme.WHITE.withOpacity(0.7),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 130,
                          // height: 100,
                          child: Image.asset('assets/images/loading.gif'),
                        ),
                        // Spacer(),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Đang kích hoạt',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: DefaultTheme.GREY_TEXT,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
    await _kickHRCOn();
    _peripheralHelper.getPeripheralId().then((peripheralId) {
      if (peripheralId == '' || peripheralId == null) {
        Navigator.of(context).pop();
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
                      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                      width: 250,
                      height: 150,
                      decoration: BoxDecoration(
                        color: DefaultTheme.WHITE.withOpacity(0.7),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 10, top: 10),
                            child: Text(
                              'Không thể đo',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: DefaultTheme.BLACK,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Vui lòng kết nối với thiết bị đeo.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: DefaultTheme.GREY_TEXT,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Divider(
                            height: 1,
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                          ),
                          ButtonHDr(
                            height: 40,
                            style: BtnStyle.BUTTON_TRANSPARENT,
                            label: 'OK',
                            labelColor: DefaultTheme.BLUE_TEXT,
                            onTap: () {
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
      } else {
        Navigator.of(context).pop();
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: DefaultTheme.TRANSPARENT,
          builder: (context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              Future.delayed(Duration(seconds: 30), () {
                setModalState(() {
                  if (!mounted) return;
                  isMeasureOff = true;
                });
              });
              // if (isMeasureOff == false) {
              //   _realTimeHeartRateStream =
              //       HeartRealTimeBloc.instance.notificationsStream;
              //   _realTimeHeartRateStream.listen((_) {
              //     if (_.title.contains('realtime heart rate')) {
              //       //
              //       setModalState(() {
              //         if (mounted == true) {
              //           heartRateData = _.body;
              //           listValueMeasure.add(int.tryParse(_.body));
              //         } else {
              //           return;
              //         }
              //       });
              //     }
              //   });
              // }

              // _timerHR = new Timer.periodic(
              //     const Duration(seconds: 30),
              //     (_) => setModalState(() {
              //           //
              //           if (!mounted) return;
              //           if (mounted == true) {
              //             isMeasureOff = true;
              //             listValueMeasure.sort((a, b) => a.compareTo(b));
              //             heartRateData =
              //                 'Nhịp tim khoảng ${listValueMeasure.first}-${listValueMeasure.last}';
              //             super.dispose();
              //             _timerHR.cancel();
              //             return;
              //           }
              //         }));
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
                            //////
                            ///
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Padding(
                                    //   padding: EdgeInsets.only(top: 20),
                                    // ),
                                    (isMeasureOff)
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // Spacer(),
                                              Container(
                                                width: 120,
                                                height: 60,
                                                // decoration: BoxDecoration(
                                                //   color: DefaultTheme.BLUE_TEXT
                                                //       .withOpacity(0.4),
                                                //   borderRadius:
                                                //       BorderRadius.circular(30),
                                                // ),
                                                child: InkWell(
                                                  onTap: () async {
                                                    setModalState(() {
                                                      if (!mounted) return;
                                                      isMeasureOff = false;
                                                      listHeartRate.clear();
                                                    });
                                                    realtimeHeartRateBloc
                                                        .realtimeHrSink
                                                        .add(0);
                                                    await _kickHRCOn();
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 15,
                                                        height: 15,
                                                        child: Image.asset(
                                                            'assets/images/ic-reload-blue.png'),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                      ),
                                                      Container(
                                                        child: Center(
                                                          child: Text(
                                                            'Đo lại',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15,
                                                                color: DefaultTheme
                                                                    .BLUE_TEXT),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                width: 80,
                                                height: 60,
                                                // decoration: BoxDecoration(
                                                //   color: DefaultTheme.BLUE_TEXT
                                                //       .withOpacity(0.4),
                                                //   borderRadius:
                                                //       BorderRadius.circular(30),
                                                // ),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        child: Center(
                                                          child: Text(
                                                            'Xong',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15,
                                                                color: DefaultTheme
                                                                    .BLUE_TEXT),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    (isMeasureOff)
                                        ? Divider(
                                            color:
                                                DefaultTheme.GREY_TOP_TAB_BAR,
                                            height: 1,
                                          )
                                        : Container(),
                                    Spacer(),
                                    (isMeasureOff)
                                        ? Container(
                                            child: (listHeartRate.length == 1)
                                                ? Container(
                                                    child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: 30,
                                                        height: 30,
                                                        child: Image.asset(
                                                            'assets/images/ic-heart-rate.png'),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10),
                                                      ),
                                                      Text(
                                                        'Không thể đo nhịp tim, xin vui lòng thử lại.',
                                                        style: TextStyle(
                                                          color: DefaultTheme
                                                              .GREY_TEXT,
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    height: 120,
                                                    padding: EdgeInsets.only(
                                                        left: 20, right: 20),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment
                                                              .topRight,
                                                          end: Alignment
                                                              .bottomLeft,
                                                          colors: [
                                                            DefaultTheme
                                                                .SUCCESS_STATUS,
                                                            DefaultTheme
                                                                .GRADIENT_2
                                                          ]),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            'Nhịp tim trong khoảng',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  DefaultTheme
                                                                      .WHITE,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            (listHeartRate[1] ==
                                                                    listHeartRate
                                                                        .last)
                                                                ? '${listHeartRate[1]} bpm'
                                                                : '${listHeartRate[1]} - ${listHeartRate.last} bpm',
                                                            style: TextStyle(
                                                                fontSize: 30,
                                                                color:
                                                                    DefaultTheme
                                                                        .WHITE,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            (listHeartRate
                                                                        .last >
                                                                    125)
                                                                ? 'Hệ thống nhận thấy nhịp tim của bạn trên mức an toàn.'
                                                                : 'Nhịp tim của bạn trong khoảng an toàn. Hệ thống không nhận thấy dấu hiệu bất thường.',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  DefaultTheme
                                                                      .WHITE,
                                                            ),
                                                          ),
                                                        ),
                                                        ///////this is comment avoid back old version.
                                                        ////commenttttttttttttttt
                                                      ],
                                                    ),
                                                  ),
                                          )
                                        : Container(
                                            width: 300,
                                            height: 300,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: DefaultTheme
                                                      .GREY_TOP_TAB_BAR
                                                      .withOpacity(1),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: Offset(0,
                                                      1), // changes position of shadow
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(500),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    DefaultTheme.GRADIENT_1,
                                                    DefaultTheme.GRADIENT_2
                                                  ]),
                                            ),
                                            child: Container(
                                              width: 250,
                                              height: 250,
                                              decoration: BoxDecoration(
                                                color: DefaultTheme.WHITE,
                                                borderRadius:
                                                    BorderRadius.circular(500),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  (isMeasureOff)
                                                      ? Container()
                                                      : Image.asset(
                                                          'assets/images/ic-mesuring.gif',
                                                          width: 100,
                                                          height: 100,
                                                        ),
                                                  StreamBuilder<int>(
                                                      stream:
                                                          realtimeHeartRateBloc
                                                              .realtimeHrStream,
                                                      builder:
                                                          (context, snapshot) {
                                                        // if (snapshot.hasData == null) {
                                                        //   return Container(
                                                        //       child: Text('Đang đo'));
                                                        // } else
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Container(
                                                              child: Text(
                                                                  'Đang đo'));
                                                        }
                                                        print(
                                                            'snap shot connection state ${snapshot.connectionState}');
                                                        if (snapshot.hasData) {
                                                          listHeartRate.add(
                                                              snapshot.data);
                                                          listHeartRate.sort((a,
                                                                  b) =>
                                                              a.compareTo(b));
                                                          return Column(
                                                            children: [
                                                              (snapshot.data ==
                                                                      0)
                                                                  ? Padding(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              20),
                                                                    )
                                                                  : Container(),
                                                              (snapshot.data ==
                                                                      0)
                                                                  ? Text(
                                                                      'Đang đo',
                                                                      style:
                                                                          TextStyle(
                                                                        color: DefaultTheme
                                                                            .BLACK,
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      '${snapshot.data}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: DefaultTheme
                                                                            .BLACK,
                                                                        fontSize:
                                                                            35,
                                                                      ),
                                                                    ),
                                                              Text(
                                                                (snapshot.data ==
                                                                        0)
                                                                    ? ''
                                                                    : 'bpm',
                                                                style:
                                                                    TextStyle(
                                                                  color: DefaultTheme
                                                                      .GREY_TEXT,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Container(
                                                              child: Text(
                                                                  'Error Loading'));
                                                        }
                                                        print(
                                                            'snap shot connection state after if else ${snapshot.connectionState}');
                                                        return Container();
                                                      }),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 10),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
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
          },
        );
      }
    });
  }

  void _onButtonShowModelSheet() {
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
                      //avt here
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 50, right: 20),
                            child: CircleAvatar(
                              radius: 30,
                              child: ClipOval(
                                child: Image.asset(
                                    'assets/images/avatar-default.jpg'),
                              ),
                            ),
                          ),
                          Expanded(
                            child:
                                //Patient Information
                                BlocProvider(
                                    create: (context4) => PatientBloc(
                                        patientRepository: patientRepository)
                                      ..add(PatientEventSetId(id: _patientId)),
                                    child:
                                        BlocBuilder<PatientBloc, PatientState>(
                                            builder: (context, state) {
                                      if (state is PatientStateLoading) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: DefaultTheme.GREY_BUTTON),
                                          child: Center(
                                            child: SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: Image.asset(
                                                  'assets/images/loading.gif'),
                                            ),
                                          ),
                                        );
                                      }
                                      if (state is PatientStateFailure) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 10,
                                              top: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: DefaultTheme.GREY_BUTTON),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                left: 20,
                                                right: 20),
                                            child: Text(
                                                'Không thể tải thông tin cá nhân',
                                                style: TextStyle(
                                                  color: DefaultTheme.GREY_TEXT,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                          ),
                                        );
                                      }
                                      if (state is PatientStateSuccess) {
                                        if (state.dto == null) {
                                          return Container(
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 10,
                                                top: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color:
                                                    DefaultTheme.GREY_BUTTON),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 20,
                                                  right: 20),
                                              child: Text(
                                                  'Không thể tải thông tin cá nhân',
                                                  style: TextStyle(
                                                    color:
                                                        DefaultTheme.GREY_TEXT,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ),
                                          );
                                        }
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(left: 5),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  150,
                                              child: Text(
                                                '${state.dto.fullName}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: DefaultTheme.BLACK,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 5, top: 3),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  150,
                                              child: Text(
                                                '${_arrayValidator.parsePhoneToView(state.dto.phoneNumber)}',
                                                style: TextStyle(
                                                  color: DefaultTheme.GREY_TEXT,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return Container(
                                        margin: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 10,
                                            top: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: DefaultTheme.GREY_BUTTON),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 20,
                                              right: 20),
                                          child: Text(
                                              'Không thể tải thông tin cá nhân',
                                              style: TextStyle(
                                                color: DefaultTheme.GREY_TEXT,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ),
                                      );
                                    })),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 25),
                      ),
                      //
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 0.1,
                      ),
                      ButtonHDr(
                        style: BtnStyle.BUTTON_IN_LIST,
                        labelColor: DefaultTheme.BLACK,
                        height: 70,
                        label: 'Thông tin tài khoản',
                        image: Image.asset(
                            'assets/images/ic-information-list.png'),
                        imgHeight: 25,
                        isLabelLeft: false,
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushNamed(RoutesHDr.PATIENT_INFORMATION);
                        },
                      ),
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 0.1,
                      ),
                      ButtonHDr(
                        style: BtnStyle.BUTTON_IN_LIST,
                        labelColor: DefaultTheme.BLACK,
                        height: 70,
                        isLabelLeft: false,
                        label: 'Thiết bị đeo',
                        image: Image.asset('assets/images/ic-device-list.png'),
                        imgHeight: 25,
                        onTap: () async {
                          Navigator.of(context).pop();
                          await peripheralHelper
                              .getPeripheralId()
                              .then((peripheralId) {
                            //
                            Navigator.of(context)
                                .pushNamed(RoutesHDr.INTRO_CONNECT_PERIPHERAL);
                            if (peripheralId == '') {
                            } else {
                              Navigator.of(context)
                                  .pushNamed(RoutesHDr.PERIPHERAL_SERVICE);
                            }
                          });
                        },
                      ),
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 0.1,
                      ),
                      ButtonHDr(
                        style: BtnStyle.BUTTON_IN_LIST,
                        labelColor: DefaultTheme.BLACK,
                        height: 70,
                        label: 'Hợp đồng',
                        image:
                            Image.asset('assets/images/ic-contract-list.png'),
                        imgHeight: 25,
                        isLabelLeft: false,
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(
                              context, RoutesHDr.MANAGE_CONTRACT);
                        },
                      ),
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 0.1,
                      ),
                      // ButtonHDr(
                      //   style: BtnStyle.BUTTON_IN_LIST,
                      //   labelColor: DefaultTheme.BLUE_TEXT,
                      //   label: 'Gói dịch vụ',
                      //   isLabelLeft: true,
                      //   onTap: () {},
                      // ),
                      // Divider(
                      //   color: DefaultTheme.GREY_TEXT,
                      //   height: 0.1,
                      // ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            // Divider(
                            //   color: DefaultTheme.GREY_TOP_TAB_BAR,
                            //   height: 0.1,
                            // ),
                            // ButtonHDr(
                            //   style: BtnStyle.BUTTON_IN_LIST,
                            //   labelColor: DefaultTheme.BLACK_BUTTON,
                            //   height: 70,
                            //   label: 'Đóng cửa sổ',
                            //   onTap: () {
                            //     Navigator.of(context).pop();
                            //   },
                            // ),
                            Divider(
                              color: DefaultTheme.GREY_TOP_TAB_BAR,
                              height: 0.1,
                            ),
                            ButtonHDr(
                              style: BtnStyle.BUTTON_IN_LIST,
                              labelColor: DefaultTheme.RED_CALENDAR,
                              height: 70,
                              label: 'Đăng xuất',
                              onTap: () {
                                Navigator.of(context).pop();
                                _signOut();
                              },
                            ),
                            Divider(
                              color: DefaultTheme.GREY_TOP_TAB_BAR,
                              height: 0.1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 30),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
      },
    );
  }
}

class Header extends StatefulWidget {
  BuildContext context;
  final double maxHeight;
  final double minHeight;

  Header({Key key, this.context, this.maxHeight, this.minHeight})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Header(maxHeight, minHeight);
  }
}

class _Header extends State<Header> {
  double _maxHeight;
  double _minHeight;
  PatientBloc patientBloc;
  PatientDTO _patientDTO = PatientDTO(fullName: 'User Full Name');
  final DateValidator _dateValidator = DateValidator();
  int _patientId = 0;
  PatientRepository patientRepository =
      PatientRepository(httpClient: http.Client());
  PrescriptionListBloc _prescriptionListBloc;
  TokenDeviceBloc _tokenDeviceBloc;
  String _timeSystem = '';
  @override
  _Header(this._maxHeight, this._minHeight);

  @override
  void initState() {
    patientBloc = BlocProvider.of(context);
    _prescriptionListBloc = BlocProvider.of(context);
    _tokenDeviceBloc = BlocProvider.of(context);
    _getPatientId();
    _getTimeSystem();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //
  _getTimeSystem() async {
    await _systemRepository.getTimeSystem().then((value) async {
      await _timeSystemHelper.setTimeSystem(value);
      if (!mounted) return;
      _timeSystem = value;
    });
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        if (!mounted) dispose();
        _patientId = value;
        if (_patientId != 0) {
          patientBloc.add(PatientEventSetId(id: _patientId));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expandRatio = _calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expandRatio);

        return Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(),
            _buildGradient(animation),
            _buildTitle(animation),
          ],
        );
      },
    );
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio =
        (constraints.maxHeight - _minHeight) / (_maxHeight - _minHeight);
    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.0) expandRatio = 0.0;
    return expandRatio;
  }

  Align _buildTitle(Animation<double> animation) {
    return Align(
      alignment: AlignmentTween(
              begin: Alignment.bottomCenter, end: Alignment.bottomLeft)
          .evaluate(animation),
      child: Container(
        margin: EdgeInsets.only(bottom: 10, left: 20, top: 20, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Trang chủ',
                      style: TextStyle(
                        fontSize: Tween<double>(begin: 20, end: 30)
                            .evaluate(animation),
                        color: DefaultTheme.WHITE,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    // width: MediaQuery.of(context).size.width / 2,
                    // padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${_dateValidator.getDateTimeView2(_timeSystem)}',
                      style: TextStyle(
                          color: DefaultTheme.WHITE,
                          fontSize: Tween<double>(begin: 10, end: 13)
                              .evaluate(animation)),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            (BlocBuilder<PatientBloc, PatientState>(
                builder: (context2, state2) {
              if (state2 is PatientStateLoading) {
                return Container(
                  height: 40,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: DefaultTheme.GREY_BUTTON),
                  child: Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.asset('assets/images/loading.gif'),
                    ),
                  ),
                );
              }
              if (state2 is PatientStateFailure) {
                return Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: DefaultTheme.GREY_BUTTON),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 20, right: 20),
                    child: Center(
                      child: Text('User Fullname',
                          style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontSize: 12,
                          )),
                    ),
                  ),
                );
              }
              if (state2 is PatientStateSuccess) {
                _patientDTO = state2.dto;
                if (state2.dto == null) {
                  return Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: DefaultTheme.GREY_BUTTON),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      child: Center(
                        child: Text('User Fullname',
                            style: TextStyle(
                              color: DefaultTheme.GREY_TEXT,
                              fontSize: 12,
                            )),
                      ),
                    ),
                  );
                }
              }
              return InkWell(
                onTap: () {
                  _onButtonShowModelSheet();
                },
                child: Container(
                  height: 40,
                  padding:
                      EdgeInsets.only(bottom: 5, top: 5, left: 15, right: 5),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      color: DefaultTheme.WHITE,
                      // border: Border.all(
                      //     color: DefaultTheme.GREY_TOP_TAB_BAR, width: 0.5),
                      borderRadius: BorderRadius.circular(50)),
                  child: InkWell(
                    splashColor: DefaultTheme.TRANSPARENT,
                    highlightColor: DefaultTheme.TRANSPARENT,
                    // onTap: _onButtonShowModelSheet,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              // '${_patientDTO.fullName}',
                              (_patientDTO.fullName.split(' ').length >= 2)
                                  ? '${_patientDTO.fullName.split(' ').first} ${_patientDTO.fullName.split(' ').last}'
                                  : '${_patientDTO.fullName}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              )),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        CircleAvatar(
                          radius: 16,
                          child: ClipOval(
                            child:
                                Image.asset('assets/images/avatar-default.jpg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }))
          ],
        ),
      ),
    );
  }

  Container _buildGradient(Animation<double> animation) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            ColorTween(
                    begin: DefaultTheme.BLACK.withOpacity(0.8),
                    end: DefaultTheme.BLACK.withOpacity(0.3))
                .evaluate(animation)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      color: DefaultTheme.BLACK.withOpacity(0.8),
      child: Image.asset(
        'assets/images/bg-home.png',
        fit: BoxFit.cover,
        color: DefaultTheme.BLACK.withOpacity(0.3),
        colorBlendMode: BlendMode.darken,
      ),
    );
  }

  void _onButtonShowModelSheet() {
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
                      //avt here
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 50, right: 20),
                            child: CircleAvatar(
                              radius: 30,
                              child: ClipOval(
                                child: Image.asset(
                                    'assets/images/avatar-default.jpg'),
                              ),
                            ),
                          ),
                          Expanded(
                            child:
                                //Patient Information
                                BlocProvider(
                                    create: (context4) => PatientBloc(
                                        patientRepository: patientRepository)
                                      ..add(PatientEventSetId(id: _patientId)),
                                    child:
                                        BlocBuilder<PatientBloc, PatientState>(
                                            builder: (context, state) {
                                      if (state is PatientStateLoading) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: DefaultTheme.GREY_BUTTON),
                                          child: Center(
                                            child: SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: Image.asset(
                                                  'assets/images/loading.gif'),
                                            ),
                                          ),
                                        );
                                      }
                                      if (state is PatientStateFailure) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 10,
                                              top: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: DefaultTheme.GREY_BUTTON),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                left: 20,
                                                right: 20),
                                            child: Text(
                                                'Không thể tải thông tin cá nhân',
                                                style: TextStyle(
                                                  color: DefaultTheme.GREY_TEXT,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                          ),
                                        );
                                      }
                                      if (state is PatientStateSuccess) {
                                        if (state.dto == null) {
                                          return Container(
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 10,
                                                top: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color:
                                                    DefaultTheme.GREY_BUTTON),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 20,
                                                  right: 20),
                                              child: Text(
                                                  'Không thể tải thông tin cá nhân',
                                                  style: TextStyle(
                                                    color:
                                                        DefaultTheme.GREY_TEXT,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ),
                                          );
                                        }
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(left: 5),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  150,
                                              child: Text(
                                                '${state.dto.fullName}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: DefaultTheme.BLACK,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 5, top: 3),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  150,
                                              child: Text(
                                                '${_arrayValidator.parsePhoneToView(state.dto.phoneNumber)}',
                                                style: TextStyle(
                                                  color: DefaultTheme.GREY_TEXT,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return Container(
                                        margin: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 10,
                                            top: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: DefaultTheme.GREY_BUTTON),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 20,
                                              right: 20),
                                          child: Text(
                                              'Không thể tải thông tin cá nhân',
                                              style: TextStyle(
                                                color: DefaultTheme.GREY_TEXT,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ),
                                      );
                                    })),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 25),
                      ),
                      //
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 0.1,
                      ),
                      ButtonHDr(
                        style: BtnStyle.BUTTON_IN_LIST,
                        labelColor: DefaultTheme.BLACK,
                        height: 70,
                        label: 'Thông tin tài khoản',
                        image: Image.asset(
                            'assets/images/ic-information-list.png'),
                        imgHeight: 25,
                        isLabelLeft: false,
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushNamed(RoutesHDr.PATIENT_INFORMATION);
                        },
                      ),
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 0.1,
                      ),
                      ButtonHDr(
                        style: BtnStyle.BUTTON_IN_LIST,
                        labelColor: DefaultTheme.BLACK,
                        height: 70,
                        isLabelLeft: false,
                        label: 'Thiết bị đeo',
                        image: Image.asset('assets/images/ic-device-list.png'),
                        imgHeight: 25,
                        onTap: () async {
                          Navigator.of(context).pop();
                          await peripheralHelper
                              .getPeripheralId()
                              .then((peripheralId) {
                            //
                            Navigator.of(context)
                                .pushNamed(RoutesHDr.INTRO_CONNECT_PERIPHERAL);
                            if (peripheralId == '') {
                            } else {
                              Navigator.of(context)
                                  .pushNamed(RoutesHDr.PERIPHERAL_SERVICE);
                            }
                          });
                        },
                      ),
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 0.1,
                      ),
                      ButtonHDr(
                        style: BtnStyle.BUTTON_IN_LIST,
                        labelColor: DefaultTheme.BLACK,
                        height: 70,
                        label: 'Hợp đồng',
                        image:
                            Image.asset('assets/images/ic-contract-list.png'),
                        imgHeight: 25,
                        isLabelLeft: false,
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(
                              context, RoutesHDr.MANAGE_CONTRACT);
                        },
                      ),
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 0.1,
                      ),
                      // ButtonHDr(
                      //   style: BtnStyle.BUTTON_IN_LIST,
                      //   labelColor: DefaultTheme.BLUE_TEXT,
                      //   label: 'Gói dịch vụ',
                      //   isLabelLeft: true,
                      //   onTap: () {},
                      // ),
                      // Divider(
                      //   color: DefaultTheme.GREY_TEXT,
                      //   height: 0.1,
                      // ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            // Divider(
                            //   color: DefaultTheme.GREY_TOP_TAB_BAR,
                            //   height: 0.1,
                            // ),
                            // ButtonHDr(
                            //   style: BtnStyle.BUTTON_IN_LIST,
                            //   labelColor: DefaultTheme.BLACK_BUTTON,
                            //   height: 70,
                            //   label: 'Đóng cửa sổ',
                            //   onTap: () {
                            //     Navigator.of(context).pop();
                            //   },
                            // ),
                            Divider(
                              color: DefaultTheme.GREY_TOP_TAB_BAR,
                              height: 0.1,
                            ),
                            ButtonHDr(
                              style: BtnStyle.BUTTON_IN_LIST,
                              labelColor: DefaultTheme.RED_CALENDAR,
                              height: 70,
                              label: 'Đăng xuất',
                              onTap: () {
                                Navigator.of(context).pop();
                                _signOut();
                              },
                            ),
                            Divider(
                              color: DefaultTheme.GREY_TOP_TAB_BAR,
                              height: 0.1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 30),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
      },
    );
  }

  _signOut() async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                width: 250,
                height: 180,
                decoration: BoxDecoration(
                  color: DefaultTheme.WHITE.withOpacity(0.7),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 5, top: 10),
                      child: Text(
                        'Lưu ý',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: DefaultTheme.BLACK,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Đăng xuất tài khoản đồng nghĩa bạn sẽ mất kết nối với thiết bị đeo tay.\nBạn vẫn muốn đăng xuất?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: DefaultTheme.GREY_TEXT,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Divider(
                      height: 1,
                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          height: 40,
                          minWidth: 250 / 2 - 10.5,
                          child: Text('Đóng',
                              style: TextStyle(color: DefaultTheme.BLUE_TEXT)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Container(
                          height: 40,
                          width: 0.5,
                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                        ),
                        FlatButton(
                          height: 40,
                          minWidth: 250 / 2 - 10.5,
                          child: Text('Đăng xuất',
                              style: TextStyle(color: DefaultTheme.RED_TEXT)),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            //

                            await _sqfLiteHelper
                                .cleanDatabase()
                                .then((valueDelete) async {
                              if (valueDelete) {
                                _prescriptionListBloc
                                    .add(PrescriptionListEventInitial());
                                //
                                //disconnect
                                await _peripheralHelper
                                    .getPeripheralId()
                                    .then((peripheralId) async {
                                  //
                                  if (peripheralId != '' ||
                                      peripheralId != 'NOTHING') {
                                    //
                                    await _peripheralRepository
                                        .findScanResultById(peripheralId)
                                        .then((device) async {
                                      //
                                      if (device != null) {
                                        await _peripheralRepository
                                            .disconnectDevice(peripheralId);
                                      }
                                    });
                                  }
                                });
                                //
                                await _vitalSignHelper
                                    .updatePeopleStatus('')
                                    .then((isOk) {
                                  if (isOk) {
                                    ReceiveNotification notiData =
                                        ReceiveNotification(
                                            id: 0,
                                            title: "reload heart rate",
                                            body: "",
                                            payload: "");
                                    HeartRefreshBloc.instance
                                        .newNotification(notiData);
                                  }
                                });
                                await _authenticateHelper
                                    .getAccountId()
                                    .then((accountId) async {
                                  TokenDeviceDTO _tokenDeviceDTO =
                                      TokenDeviceDTO(
                                          accountId: accountId,
                                          tokenDevice: '');
                                  _tokenDeviceBloc.add(TokenDeviceEventUpdate(
                                      dto: _tokenDeviceDTO));
                                  print('udpate token becomes null successful');
                                });
                                await _measureHelper.updateMeasureOn(false);
                                //
                                //SAVE TIME START
                                await _measureHelper.updateTimeStartM('');
                                //
                                //SAVE DURATION TIME
                                await _measureHelper.updateDurationM(0);

                                //
                                await _measureHelper.updateCountingM(0);
                                //UPDATE TIME AND VALUE LIST HR INTO INITIAL
                                await _measureHelper.updateListTime('');
                                await _measureHelper.updateListValueHr('');
                                await _sqfLiteHelper
                                    .deleteVitalSignSchedule()
                                    .then((isDeleted) async {
                                  //
                                  //
                                  if (isDeleted) {
                                    //remove all shared preference
                                    await _authenticateHelper.updateAuth(
                                        false, null, null);
                                    _vitalSignHelper.updateWarning(false, '');
                                    await _peripheralHelper
                                        .updatePeripheralChecking(false, '');
                                    await _vitalSignHelper
                                        .updateCountDownDangerous(0);
                                    await _vitalSignHelper
                                        .updateCountInBackground(0);
                                    await _vitalSignHelper.updateCountingHR(0);
                                    await _vitalSignHelper.updateHeartValue(0);
                                    await _vitalSignHelper
                                        .updateCheckToNormal(false);
                                    await _vitalSignHelper
                                        .updateCountToNormal(0);
                                    await _vitalSignHelper
                                        .updateSendSMSTurnOffStatus(false);
                                    await _contractHelper
                                        .updateAvailableDay('');
                                    await _medicalInstructionHelper
                                        .updateCheckToCreateOrList(false);
                                    await _medicalInstructionHelper
                                        .updateCreateHRFromDetail(false);
                                    await _reminderHelper
                                        .updateValueBluetooth(false);
                                    //
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        RoutesHDr.LOG_IN,
                                        (Route<dynamic> route) => false);
                                    //
                                  }
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    //
  }
}
