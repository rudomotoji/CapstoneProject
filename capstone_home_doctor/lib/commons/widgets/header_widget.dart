import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/numeral_ui.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';

import 'package:capstone_home_doctor/features/information/blocs/patient_bloc.dart';
import 'package:capstone_home_doctor/features/information/events/patient_event.dart';
import 'package:capstone_home_doctor/features/information/repositories/patient_repository.dart';
import 'package:capstone_home_doctor/features/information/states/patient_state.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repository.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/prescription_list_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/events/prescription_list_event.dart';
import 'package:capstone_home_doctor/models/patient_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:capstone_home_doctor/services/medical_instruction_helper.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
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

//
final ArrayValidator _arrayValidator = ArrayValidator();

enum ButtonHeaderType {
  NONE,
  AVATAR,
  NEW_MESSAGE,
  DETAIL,
  BACK_HOME,
  CREATE_HEALTH_RECORD,
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
  String _title;
  ButtonHeaderType _buttonHeaderType;
  bool _isMainView;
  PatientRepository patientRepository =
      PatientRepository(httpClient: http.Client());

  //patient Id
  int _patientId = 0;
  SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
  PatientBloc _patientBloc;
  PatientDTO _patientDTO = PatientDTO(fullName: 'User Full Name');
  PrescriptionListBloc _prescriptionListBloc;

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
  }

  @override
  Widget build(BuildContext context) {
    if (_buttonHeaderType == null) {
      _buttonHeaderType = ButtonHeaderType.NONE;
    }
    return Padding(
      padding: DefaultNumeralUI.HEADER_SIZE,
      child: Row(
        children: [
          if (!_isMainView)
            (InkWell(
              splashColor: DefaultTheme.TRANSPARENT,
              highlightColor: DefaultTheme.TRANSPARENT,
              onTap: () async {
                Future.delayed(const Duration(milliseconds: 100), () async {
                  if (_title.contains('Tạo hồ sơ sức khỏe'.trim())) {
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
          //
          if (_buttonHeaderType == ButtonHeaderType.CREATE_HEALTH_RECORD)
            (Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  InkWell(
                    splashColor: DefaultTheme.TRANSPARENT,
                    highlightColor: DefaultTheme.TRANSPARENT,
                    onTap: () async {
                      await _medicalInstructionHelper
                          .updateCreateHRFromDetail(true);
                      Navigator.of(context)
                          .pushNamed(RoutesHDr.CREATE_HEALTH_RECORD);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 15, right: 15, bottom: 5, top: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: DefaultTheme.GREY_VIEW,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: Image.asset('assets/images/ic-create.png'),
                          ),
                          Text(
                            'Hồ sơ mới',
                            style: TextStyle(
                                color: DefaultTheme.BLUE_DARK, fontSize: 16),
                          ),
                        ],
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
                  Padding(padding: EdgeInsets.only(left: 20)),
                  InkWell(
                    splashColor: DefaultTheme.TRANSPARENT,
                    highlightColor: DefaultTheme.TRANSPARENT,
                    onTap: _backToHome,
                    child: Image.asset(
                      'assets/images/ic-back-home.png',
                      width: 35,
                      height: 35,
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
                      width: 60,
                      height: 60,
                      child: Image.asset('assets/images/loading.gif'),
                    ),
                  ),
                );
              }
              if (state2 is PatientStateFailure) {
                return Container(
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: DefaultTheme.GREY_BUTTON),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 20, right: 20),
                    child: Text('Không thể tải thông tin cá nhân',
                        style: TextStyle(
                          color: DefaultTheme.GREY_TEXT,
                          fontSize: 12,
                        )),
                  ),
                );
              }
              if (state2 is PatientStateSuccess) {
                _patientDTO = state2.dto;
                if (state2.dto == null) {
                  return Container(
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: DefaultTheme.GREY_BUTTON),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      child: Text('Không thể tải thông tin cá nhân',
                          style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontSize: 12,
                          )),
                    ),
                  );
                }
              }
              return Container(
                padding: EdgeInsets.only(bottom: 5, top: 5, left: 15, right: 5),
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
                        child: Text('${_patientDTO.fullName}',
                            // (_patientDTO.fullName.split(' ').length >= 2)
                            //     ? '${_patientDTO.fullName.split(' ').first} ${_patientDTO.fullName.split(' ').last}'
                            //     : '${_patientDTO.fullName}',
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
    );
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
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
                                            .disconnectDevice(device);
                                      }
                                    });
                                  }
                                });
                                //

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
                                    await _contractHelper
                                        .updateAvailableDay('');
                                    await _medicalInstructionHelper
                                        .updateCheckToCreateOrList(false);
                                    await _medicalInstructionHelper
                                        .updateCreateHRFromDetail(false);
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
    await _medicalInstructionHelper.updateCheckToCreateOrList(false);
    await _medicalInstructionHelper.updateCreateHRFromDetail(false);
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesHDr.MAIN_HOME, (Route<dynamic> route) => false);
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
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushNamed(RoutesHDr.PERIPHERAL_SERVICE);
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
