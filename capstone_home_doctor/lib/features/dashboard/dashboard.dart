import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/artboard_button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/login/blocs/token_device_bloc.dart';
import 'package:capstone_home_doctor/features/login/events/token_device_event.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/appointment_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/prescription_list_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/events/appointment_event.dart';
import 'package:capstone_home_doctor/features/schedule/events/prescription_list_event.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/prescription_repository.dart';
import 'package:capstone_home_doctor/features/schedule/states/appointment_state.dart';
import 'package:capstone_home_doctor/features/schedule/states/prescription_list_state.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_sign_state.dart';
import 'package:capstone_home_doctor/models/appointment_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:capstone_home_doctor/models/token_device_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:capstone_home_doctor/services/mobile_device_helper.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:capstone_home_doctor/services/notifications_bloc.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:capstone_home_doctor/services/vital_sign_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

//
final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final MobileDeviceHelper _mobileDeviceHelper = MobileDeviceHelper();
final VitalSignHelper vitalSignHelper = VitalSignHelper();
final ContractHelper contractHelper = ContractHelper();

//
final Shader _normalHealthColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_1,
    DefaultTheme.GRADIENT_2,
  ],
).createShader(new Rect.fromLTWH(10.0, 1.0, 100.0, 90.0));

final Shader _caledarColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_3,
    DefaultTheme.GRADIENT_4,
    DefaultTheme.GRADIENT_5,
  ],
).createShader(new Rect.fromLTWH(50, 1.0, 255.0, 255.0));

class DashboardPage extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> with WidgetsBindingObserver {
  var _index = 0;
  var location;
  var _idDoctorController = TextEditingController();
  String _idDoctor = '';
  DateValidator _dateValidator = DateValidator();

  bool checkPeopleStatusLocal = false;

  int _patientId = 0;
  String _tokenDevice = '';
  int _accountId = 0;

  int _heartRateValue = 0;

  TokenDeviceDTO _tokenDeviceDTO = TokenDeviceDTO();
  AppointmentDTO _appointmentDTO;
  //
  PrescriptionRepository prescriptionRepository =
      PrescriptionRepository(httpClient: http.Client());

  PrescriptionListBloc _prescriptionListBloc;
  AppointmentBloc _appointmentBloc;
  TokenDeviceBloc _tokenDeviceBloc;
  VitalSignBloc _vitalSignBloc;
  VitalSignDangerousBloc _vitalSignDangerousBloc;

  //
  String vitalType = 'HEART_RATE';
  String vitalBPType = 'PRESSURE';
  VitalSignDTO lastMeasurement = VitalSignDTO();

  //
  List<VitalSignDTO> listVitalSignDangerous = [];

  SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
  DateTime curentDateNow = new DateFormat('yyyy-MM-dd')
      .parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  // List<MedicationSchedules> listSchedule = [];
  List<AppointmentDTO> listAppointment = [];
  List<MedicalInstructionDTO> listPrescription = [];
  List<AppointmentDTO> _listAppointment = [];

  Stream<ReceiveNotification> _notificationsStream;

  bool dangerKickedOn = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _getPatientId();
    _appointmentBloc = BlocProvider.of(context);
    _prescriptionListBloc = BlocProvider.of(context);
    _tokenDeviceBloc = BlocProvider.of(context);
    _vitalSignBloc = BlocProvider.of(context);
    _vitalSignDangerousBloc = BlocProvider.of(context);

    if (_patientId != 0) {
      _vitalSignBloc
          .add(VitalSignEventGetList(type: vitalType, patientId: _patientId));
      _vitalSignDangerousBloc.add(VitalSignGetListdangerous(
          min: 0, max: 100, patientId: _patientId, valueType: vitalType));
    }
    _updateAvailableContract();
    _updateTokenDevice();
    // _getHeartRateValue();

    selectNotificationSubject.stream.listen((String payload) async {
      await _getPatientId();
    });

    _notificationsStream = NotificationsBloc.instance.notificationsStream;
    _notificationsStream.listen((notification) {
      print('Notification: $notification');
      _getPatientId();
    });
    _getPeopleStatus();
  }

  _getPeopleStatus() async {
    const oneSec = const Duration(seconds: 60);

    Timer.periodic(oneSec, (Timer t) async {
      await vitalSignHelper.getPeopleStatus().then((value) async {
        print('EVERY 1 MINUTES. CHECK STATUS PEOPLE LOCAL');
        print('people status is ${value}');
        if (value == 'DANGER') {
          _getPeopleStatus();
          setState(() {
            checkPeopleStatusLocal = true;
          });
        } else {
          //
          setState(() {
            checkPeopleStatusLocal = false;
          });
        }
      });
    });
  }

  _changeDangerView() {
    const oneSec = const Duration(milliseconds: 500);
    Timer.periodic(oneSec, (Timer t) {
      //

      if (!mounted) return;
      setState(() {
        dangerKickedOn = !dangerKickedOn;
      });
    });
    //
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // _getHeartRateValue() {
  //   vitalSignHelper.getHeartRateValue().then((value) {
  //     setState(() {
  //       _heartRateValue = value;
  //     });
  //   });
  // }

  _updateTokenDevice() async {
    await _mobileDeviceHelper.getTokenDevice().then((value) {
      //
      setState(() {
        _tokenDevice = value;
      });
    });
    await _authenticateHelper.getAccountId().then((value) {
      setState(() {
        _accountId = value;
      });
    });

    if (_accountId != '' && _tokenDevice != '') {
      //do update token device here

      _tokenDeviceDTO =
          TokenDeviceDTO(accountId: _accountId, tokenDevice: _tokenDevice);
      if (_tokenDeviceDTO != null) {
        _tokenDeviceBloc.add(TokenDeviceEventUpdate(dto: _tokenDeviceDTO));
      }
    }
  }

  _updateAvailableContract() async {
    await contractHelper.updateAvailableDay('');
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        _patientId = value;
      });
    });
    await _authenticateHelper.getAccountId().then((value) {
      setState(() {
        _accountId = value;
      });
    });
    if (_patientId != 0) {
      DateTime curentDateNow = new DateTime.now();
      _vitalSignBloc
          .add(VitalSignEventGetList(type: vitalType, patientId: _patientId));
      _prescriptionListBloc
          .add(PrescriptionListEventsetPatientId(patientId: _patientId));
      _appointmentBloc.add(AppointmentGetListEvent(
          patientId: _accountId,
          date: '${curentDateNow.year}/${curentDateNow.month}'));
    }
    // await _authenticateHelper.getAccountId().then((value) {
    //   print('ACCOUNT ID ${value}');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        HeaderWidget(
          title: 'Trang chủ',
          isMainView: true,
          buttonHeaderType: ButtonHeaderType.AVATAR,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              '${_dateValidator.getDateTimeView()}',
              style: TextStyle(color: DefaultTheme.GREY_TEXT, fontSize: 15),
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: ListView(
              padding: EdgeInsets.only(left: 20, right: 20),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/images/ic-calendar.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Text(
                      'Lịch',
                      style: TextStyle(
                        color: DefaultTheme.BLACK,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    ButtonHDr(
                      style: BtnStyle.BUTTON_TRANSPARENT,
                      label: 'Chi tiết',
                      labelColor: DefaultTheme.BLACK_BUTTON.withOpacity(0.8),
                      isUnderline: true,
                      width: 40,
                      onTap: () {
                        Navigator.of(context).pushNamed(RoutesHDr.SCHEDULE);
                      },
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 280,
                  child: OverflowBox(
                      // alignment: Alignment.centerRight,
                      minWidth: MediaQuery.of(context).size.width,
                      maxWidth: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: _sizeBoxCard(),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                        height: 25,
                        child:
                            Image.asset('assets/images/ic-health-selected.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Text(
                        'Trạng thái',
                        style: TextStyle(
                          color: DefaultTheme.BLACK,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),

                _showStatusOverview(),
                //
                _showLastHeartRateMeasure(),

                // Padding(
                //   padding: EdgeInsets.only(bottom: 20),
                // ),
                // _showLastBloodPressureMeasure(),
                // //
                _showSuggestionDashboard(),

                //_showLastMeasurement(),
                Padding(
                  padding: EdgeInsets.only(bottom: 50),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  _showLastHeartRateMeasure() {
    return BlocBuilder<VitalSignBloc, VitalSignState>(
        builder: (context, state) {
      if (state is VitalSignStateLoading) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: SizedBox(
            width: 80,
            height: 80,
            child: Image.asset('assets/images/loading.gif'),
          ),
        );
      }
      if (state is VitalSignStateFailure) {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: Center(
              child: Text('Không thể tải'),
            ));
      }
      if (state is VitalSignStateGetListSuccess) {
        if (null == state.list) {
          return Container();
        } else {
          lastMeasurement = state.list.last;
        }
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Lần đo gần đây',
              style: TextStyle(
                color: DefaultTheme.BLACK,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
          ),
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.of(context).pushNamed(RoutesHDr.HEART);
                      },
                      focusColor: DefaultTheme.TRANSPARENT,
                      hoverColor: DefaultTheme.TRANSPARENT,
                      highlightColor: DefaultTheme.TRANSPARENT,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        height: 80,
                        decoration: BoxDecoration(
                            color: DefaultTheme.GREY_VIEW,
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            //

                            SizedBox(
                              width: 30,
                              height: 30,
                              child: Image.asset(
                                  'assets/images/ic-heart-rate.png'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                            ),
                            Container(
                              height: 30,
                              margin: EdgeInsets.only(bottom: 5),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                (lastMeasurement.value1 != null &&
                                        lastMeasurement.value1 != 0)
                                    ? '${lastMeasurement.value1}'
                                    : (lastMeasurement.value1 == 0)
                                        ? '--'
                                        : '--',
                                style: TextStyle(
                                  color: DefaultTheme.ORANGE_TEXT,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                            ),
                            Container(
                              height: 30,
                              margin: EdgeInsets.only(bottom: 5),
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                'BPM',
                                style: TextStyle(
                                  color: DefaultTheme.GREY_TEXT,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                //
                                (lastMeasurement.dateTime != null)
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          child: Text(
                                            '${lastMeasurement.dateTime.split(' ')[1].split('.')[0].split(':')[0]}:${lastMeasurement.dateTime.split(' ')[1].split('.')[0].split(':')[1]}',
                                            textAlign: TextAlign.right,
                                          ),
                                        ))
                                    : Container(),
                                (lastMeasurement.value1 == null)
                                    ? Container()
                                    : (lastMeasurement.value1 == 0)
                                        ? Text('-',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color:
                                                    DefaultTheme.RED_CALENDAR,
                                                fontWeight: FontWeight.w500))
                                        : (lastMeasurement.value1 < 55 &&
                                                lastMeasurement.value1 > 0)
                                            ? Text('Thấp',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: DefaultTheme
                                                        .RED_CALENDAR,
                                                    fontWeight:
                                                        FontWeight.w500))
                                            : (lastMeasurement.value1 >= 55 &&
                                                    lastMeasurement.value1 <
                                                        120)
                                                ? Text('Bình thường',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        color: DefaultTheme
                                                            .SUCCESS_STATUS,
                                                        fontWeight:
                                                            FontWeight.w500))
                                                : (lastMeasurement.value1 >=
                                                        120)
                                                    ? Text('Cao',
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            color: DefaultTheme
                                                                .CHIP_BLUE,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))
                                                    : (lastMeasurement.value1 >
                                                            150)
                                                        ? Text('Cao bất thường',
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                                color:
                                                                    DefaultTheme
                                                                        .RED_TEXT,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))
                                                        : Container()
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  Image.asset('assets/images/ic-navigator.png'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                          ],
                        ),
                      )),
                ),
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: Container(
                    width: 80,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: DefaultTheme.ORANGE_TEXT),
                    child: Center(
                      child: Text('Nhịp tim',
                          style: TextStyle(color: DefaultTheme.WHITE)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  _showLastBloodPressureMeasure() {
    return BlocBuilder<VitalSignBloc, VitalSignState>(
        builder: (context, state) {
      if (state is VitalSignStateLoading) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: SizedBox(
            width: 80,
            height: 80,
            child: Image.asset('assets/images/loading.gif'),
          ),
        );
      }
      if (state is VitalSignStateFailure) {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: Center(
              child: Text('Không thể tải'),
            ));
      }
      if (state is VitalSignStateGetListSuccess) {
        if (state.list != null || state.list != []) {
          lastMeasurement = state.list.last;
        } else {
          return Container();
        }
      }
      return (null != lastMeasurement)
          ? Container(
              height: 90,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.of(context).pushNamed(RoutesHDr.HEART);
                        },
                        focusColor: DefaultTheme.TRANSPARENT,
                        hoverColor: DefaultTheme.TRANSPARENT,
                        highlightColor: DefaultTheme.TRANSPARENT,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          height: 80,
                          decoration: BoxDecoration(
                              color: DefaultTheme.GREY_VIEW,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              //

                              SizedBox(
                                width: 30,
                                height: 30,
                                child: Image.asset(
                                    'assets/images/ic-blood-pressure.png'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '110',
                                      style: TextStyle(
                                        color: DefaultTheme.RED_CALENDAR,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Tâm thu',
                                      style: TextStyle(
                                        color: DefaultTheme.GREY_TEXT,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '83',
                                      style: TextStyle(
                                        color: DefaultTheme.RED_CALENDAR,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Tâm trương',
                                      style: TextStyle(
                                        color: DefaultTheme.GREY_TEXT,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              //
                              Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  //
                                  (lastMeasurement.dateTime != null)
                                      ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            child: Text(
                                              '${lastMeasurement.dateTime.split(' ')[1].split('.')[0].split(':')[0]}:${lastMeasurement.dateTime.split(' ')[1].split('.')[0].split(':')[1]}',
                                              textAlign: TextAlign.right,
                                            ),
                                          ))
                                      : Container(),
                                  (lastMeasurement.value1 == null)
                                      ? Container()
                                      : (lastMeasurement.value1 < 55)
                                          ? Text('Thấp',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color:
                                                      DefaultTheme.RED_CALENDAR,
                                                  fontWeight: FontWeight.w500))
                                          : (lastMeasurement.value1 >= 55 &&
                                                  lastMeasurement.value1 < 120)
                                              ? Text('Bình thường',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: DefaultTheme
                                                          .SUCCESS_STATUS,
                                                      fontWeight:
                                                          FontWeight.w500))
                                              : (lastMeasurement.value1 >= 120)
                                                  ? Text('Cao',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          color: DefaultTheme
                                                              .CHIP_BLUE,
                                                          fontWeight:
                                                              FontWeight.w500))
                                                  : (lastMeasurement.value1 >
                                                          150)
                                                      ? Text('Cao bất thường',
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              color:
                                                                  DefaultTheme
                                                                      .RED_TEXT,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))
                                                      : Container()
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                              ),
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                    'assets/images/ic-navigator.png'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                              ),
                            ],
                          ),
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 20,
                    child: Container(
                      width: 80,
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: DefaultTheme.RED_CALENDAR),
                      child: Center(
                        child: Text('Huyết áp',
                            style: TextStyle(color: DefaultTheme.WHITE)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container();
    });
  }

  //
  rowMedicalSchedule(String nameMedical, String time, String timeLoop) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 15,
            height: 15,
            margin: EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: DefaultTheme.GREY_TEXT,
            ),
            child: Container(),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              nameMedical,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: DefaultTheme.GREY_TEXT,
                fontFamily: "",
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Text(
              time,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: DefaultTheme.GREY_TEXT,
                fontFamily: "",
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            timeLoop,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: DefaultTheme.GREY_TEXT,
              fontFamily: "",
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  _showLastMeasurement() {}

  _showSuggestionDashboard() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Gợi ý',
              style: TextStyle(
                color: DefaultTheme.BLACK,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        ButtonArtBoard(
          title: 'Yêu cầu hợp đồng',
          description: 'Quét QR hoặc nhập ID kết nối với bác sĩ',
          imageAsset: 'assets/images/ic-contract.png',
          onTap: () async {
            _chooseStepContract();
          },
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
        ButtonArtBoard(
          title: 'Kết nối thiết bị',
          description: 'Dữ liệu được đồng bộ qua thiết bị đeo',
          imageAsset: 'assets/images/ic-connect-p.png',
          onTap: () {
            Navigator.pushNamed(context, RoutesHDr.INTRO_CONNECT_PERIPHERAL);
          },
        ),
      ],
    );
  }

  _showStatusOverview() {
    //change color and text color if else status patient and call it
    return (checkPeopleStatusLocal)
        ? ClipRRect(
            child: Stack(
              children: [
                Center(
                  child: AnimatedContainer(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: (dangerKickedOn)
                              ? [
                                  DefaultTheme.GRADIENT_3,
                                  DefaultTheme.GRADIENT_3,
                                  DefaultTheme.GRADIENT_4,
                                  DefaultTheme.GRADIENT_5,
                                ]
                              : [
                                  DefaultTheme.GRADIENT_5,
                                  DefaultTheme.GRADIENT_5,
                                  DefaultTheme.GRADIENT_5,
                                  DefaultTheme.GRADIENT_5,
                                ]),
                    ),
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOutBack,
                    // child: Text('Sinh hiệu bất thường'),
                  ),
                ),
                Positioned(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //
                        Padding(
                          padding: EdgeInsets.only(
                            top: 15,
                          ),
                        ),
                        Text(
                          'Sinh hiệu bất thường',
                          style: TextStyle(
                            color: DefaultTheme.WHITE,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 5,
                          ),
                        ),
                        Divider(
                          color: DefaultTheme.GREY_VIEW,
                          height: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Text(
                          'Hệ thống ghi nhận nhịp tim của bạn bất thường.',
                          style: TextStyle(
                            color: DefaultTheme.WHITE,
                          ),
                        ),
                        // BlocBuilder<VitalSignDangerousBloc, VitalSignState>(
                        //     builder: (context, state) {
                        //   if (state is VitalSignStateLoading) {
                        //     return Container(
                        //       width: MediaQuery.of(context).size.width,
                        //       height: 80,
                        //       child: SizedBox(
                        //         width: 80,
                        //         height: 80,
                        //         child: Image.asset('assets/images/loading.gif'),
                        //       ),
                        //     );
                        //   }
                        //   if (state is VitalSignStateFailure) {
                        //     return Container(
                        //         width: MediaQuery.of(context).size.width,
                        //         height: 80,
                        //         child: Center(
                        //           child: Text('Không thể tải'),
                        //         ));
                        //   }
                        //   if (state is VitalSignGetListDangerousSuccess) {
                        //     if (null == state.list) {
                        //       return Container();
                        //     } else {
                        //       // lastMeasurement = state.list.last;
                        //       listVitalSignDangerous = state.list;
                        //     }
                        //   }
                        //   return Container(
                        //       child: Column(
                        //     children: <Widget>[
                        //       //
                        //       Text(
                        //         'Hệ thống ghi nhận nhịp tim của bạn bất thường.',
                        //         style: TextStyle(
                        //           color: DefaultTheme.WHITE,
                        //         ),
                        //       ),
                        //       (listVitalSignDangerous != null)
                        //           ? Text('${listVitalSignDangerous.length}')
                        //           : Container(),
                        //     ],
                        //   ));
                        // }),
                      ],
                    ),
                  ),
                ),
                //
              ],
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: DefaultTheme.GREY_VIEW,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //
                Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                ),
                Text(
                  'Sinh hiệu bình thường',
                  style: TextStyle(
                    color: DefaultTheme.BLACK,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                ),
                Divider(
                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                  height: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Text(
                  'Hiện tại không có dấu hiệu bất thường về sinh hiệu của bạn.',
                  style: TextStyle(
                    color: DefaultTheme.BLACK,
                  ),
                ),
              ],
            ),
          );
  }

  void _showPopUpIDDoctor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: DefaultTheme.WHITE.withOpacity(0.6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/images/ic-id.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        Text(
                          'Bác sĩ',
                          style: TextStyle(
                            fontSize: 30,
                            decoration: TextDecoration.none,
                            color: DefaultTheme.BLACK,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 20),
                            child: Text(
                              'Mã định danh giúp bệnh nhân dễ dàng ghép nối với bác sĩ thông qua hợp đồng',
                              style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.none,
                                color: DefaultTheme.GREY_TEXT,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TEXT,
                            height: 0.25,
                          ),
                          Flexible(
                            child: TextFieldHDr(
                              style: TFStyle.NO_BORDER,
                              label: 'ID:',
                              controller: _idDoctorController,
                              keyboardAction: TextInputAction.done,
                              onChange: (text) {
                                setState(() {
                                  _idDoctor = text;
                                });
                              },
                            ),
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TEXT,
                            height: 0.25,
                          ),
                        ],
                      ),
                    ),
                    ButtonHDr(
                      style: BtnStyle.BUTTON_BLACK,
                      label: 'Tiếp theo',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(
                            context, RoutesHDr.DOCTOR_INFORMATION,
                            arguments: _idDoctor);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _chooseStepContract() {
    showModalBottomSheet(
        isScrollControlled: false,
        context: this.context,
        backgroundColor: Colors.white.withOpacity(0),
        builder: (context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(33.33),
                        // borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(33.33),
                        //     topRight: Radius.circular(33.33)),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // Padding(
                          //   padding: EdgeInsets.only(
                          //       top: MediaQuery.of(context).size.height * 0.05),
                          // ),
                          Spacer(),
                          Image.asset(
                            'assets/images/ic-contract.png',
                            height: MediaQuery.of(context).size.height * 0.20,
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(60, 20, 60, 0),
                            child: Text(
                              'Quét Mã QR hoặc nhập ID của bác sĩ để yêu cầu tạo hợp đồng',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ),
                          Spacer(),
                          ButtonHDr(
                            isUnderline: false,
                            style: BtnStyle.BUTTON_BLACK,
                            label: 'Quét Mã QR',
                            onTap: () async {
                              String codeScanner = await BarcodeScanner.scan();
                              if (codeScanner != null) {
                                Navigator.of(context).pop();
                                Navigator.pushNamed(
                                    context, RoutesHDr.DOCTOR_INFORMATION,
                                    arguments: codeScanner);
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          ButtonHDr(
                            isUnderline: false,
                            style: BtnStyle.BUTTON_GREY,
                            label: 'Nhập ID Bác sĩ',
                            onTap: () {
                              Navigator.of(context).pop();
                              _showPopUpIDDoctor();
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                    ),
                  ],
                ),
              ));
        });
  }

  Widget _medicalScheduleNotNull(List<MedicationSchedules> listSchedule) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 20),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lịch dùng thuốc',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                    color: DefaultTheme.RED_CALENDAR,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
          child: Text(
            'Tổng quan lịch sử dụng thuốc đang hiện hành, bấm chi tiết để xem thêm thông tin.',
            style: TextStyle(color: DefaultTheme.GREY_TEXT, fontSize: 13),
          ),
        ),
        Divider(
          height: 0.1,
          color: DefaultTheme.GREY_TOP_TAB_BAR,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: listSchedule.length,
              itemBuilder: (BuildContext buildContext, int index) {
                return Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${listSchedule[index].medicationName} (${listSchedule[index].content})',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 3),
                        ),
                        Text(
                          'Cách dùng: ${listSchedule[index].useTime}',
                          style: TextStyle(
                              color: DefaultTheme.BLACK, fontSize: 12),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (listSchedule[index].morning == 0)
                                ? Container(
                                    width: 0,
                                    height: 0,
                                  )
                                : Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: DefaultTheme.WHITE,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Sáng',
                                          style: TextStyle(
                                            color: DefaultTheme.RED_CALENDAR,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '${listSchedule[index].morning}',
                                          style: TextStyle(
                                            color: DefaultTheme.BLACK,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '${listSchedule[index].unit}',
                                          style: TextStyle(
                                            color: DefaultTheme.GREY_TEXT,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            //noon
                            (listSchedule[index].noon == 0)
                                ? Container(
                                    width: 0,
                                    height: 0,
                                  )
                                : Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: DefaultTheme.WHITE,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Trưa',
                                          style: TextStyle(
                                            color: DefaultTheme.RED_CALENDAR,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '${listSchedule[index].noon}',
                                          style: TextStyle(
                                            color: DefaultTheme.BLACK,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '${listSchedule[index].unit}',
                                          style: TextStyle(
                                            color: DefaultTheme.GREY_TEXT,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            //afternoon
                            (listSchedule[index].afterNoon == 0)
                                ? Container(
                                    width: 0,
                                    height: 0,
                                  )
                                : Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: DefaultTheme.WHITE,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Chiều',
                                          style: TextStyle(
                                            color: DefaultTheme.RED_CALENDAR,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '${listSchedule[index].afterNoon}',
                                          style: TextStyle(
                                            color: DefaultTheme.BLACK,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '${listSchedule[index].unit}',
                                          style: TextStyle(
                                            color: DefaultTheme.GREY_TEXT,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            //night
                            (listSchedule[index].night == 0)
                                ? Container(
                                    width: 0,
                                    height: 0,
                                  )
                                : Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: DefaultTheme.WHITE,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Tối',
                                          style: TextStyle(
                                            color: DefaultTheme.RED_CALENDAR,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '${listSchedule[index].night}',
                                          style: TextStyle(
                                            color: DefaultTheme.BLACK,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '${listSchedule[index].unit}',
                                          style: TextStyle(
                                            color: DefaultTheme.GREY_TEXT,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                            //
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10, top: 10),
                          child: Divider(
                            height: 3,
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                          ),
                        ),
                      ]),
                );
              }),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
      ],
    );
  }

  Widget _appointmentNotNull() {
    List _listDetail = _appointmentDTO.appointments.map((e) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bác sĩ: ${e.fullNameDoctor}'),
          Text(
              'Thời gian: ${_dateValidator.convertDateCreate(e.dateExamination, 'dd/MM/yyyy, hh:mm a', 'yyyy-MM-ddThh:mm')}'),
          Text('Ghi chú: ${e.note}'),
          // Container(height: 20),
        ],
      );
    }).toList();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Lịch tái khám',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: DefaultTheme.RED_CALENDAR,
              ),
            ),
          ),
        ),
        Divider(
          height: 0.1,
          color: DefaultTheme.GREY_TOP_TAB_BAR,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                Text(
                  'Bạn có ${_appointmentDTO.appointments.length} lịch khám trong hôm nay:',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _appointmentDTO.appointments.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: _listDetail[index],
                      margin: EdgeInsets.only(left: 16, top: 16),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sizeBoxCard() {
    return BlocBuilder<PrescriptionListBloc, PrescriptionListState>(
      builder: (context, contextPrescription) {
        if (contextPrescription is PrescriptionListStateLoading) {
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
        if (contextPrescription is PrescriptionListStateFailure) {
          getLocalStorage();
          return _getCalendar();
        }
        if (contextPrescription is PrescriptionListStateSuccess) {
          listPrescription = contextPrescription.listPrescription;
          if (contextPrescription.listPrescription != null) {
            listPrescription.sort((a, b) =>
                b.medicalInstructionId.compareTo(a.medicalInstructionId));
            listPrescription.sort((a, b) => b.medicationsRespone.dateFinished
                .compareTo(a.medicationsRespone.dateFinished));
          }
          if (contextPrescription.listPrescription.length > 0) {
            handlingMEdicalResponse();
          } else {
            getLocalStorage();
          }
          return _getCalendar();
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text('Không thể lấy dữ liệu'),
          ),
        );
      },
    );
  }

  Widget _getCalendar() {
    return SizedBox(
      height: 280,
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
        itemCount: listPrescription.length,
        controller: PageController(viewportFraction: 0.9),
        onPageChanged: (int index) => setState(() => _index = index),
        itemBuilder: (_, i) {
          return Transform.scale(
            scale: i == _index ? 1 : 0.9,
            alignment: Alignment.centerLeft,
            child: Card(
              elevation: 0,
              shadowColor: DefaultTheme.GREY_TEXT,
              color: DefaultTheme.GREY_VIEW,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: _medicalScheduleNotNull(
                  listPrescription[i].medicationsRespone.medicationSchedules),
            ),
          );
        },
      ),
    );
  }

  Widget _getAppointment() {
    return Container(
      child: (_appointmentDTO == null)
          ? Center(
              child: Text('Hôm nay không có lịch tái khám'),
            )
          : _appointmentNotNull(),
    );
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    var position = await Geolocator.getCurrentPosition();
    setState(() {
      location = position;
    });
  }

  handlingMEdicalResponse() async {
    List<MedicalInstructionDTO> _listPrescription = [];

    await _sqfLiteHelper.cleanDatabase();
    for (var schedule in listPrescription) {
      MedicalInstructionDTO _prescription = MedicalInstructionDTO();
      if (schedule.medicationsRespone.dateFinished != null) {
        DateTime tempDate2 = new DateFormat("yyyy-MM-dd")
            .parse(schedule.medicationsRespone.dateFinished);
        if (tempDate2.millisecondsSinceEpoch >=
                curentDateNow.millisecondsSinceEpoch &&
            schedule.medicationsRespone.status.contains('ACTIVE')) {
          schedule.medicationsRespone.medicalResponseID =
              schedule.medicalInstructionId;
          await _sqfLiteHelper
              .insertMedicalResponse(schedule.medicationsRespone);
          _prescription = schedule;
          _listPrescription.add(_prescription);

          for (var item in schedule.medicationsRespone.medicationSchedules) {
            item.medicalResponseID = schedule.medicalInstructionId;
            await _sqfLiteHelper.insertMedicalSchedule(item);
          }
        }
      }
    }

    setState(() {
      listPrescription = _listPrescription;
    });
  }

  getLocalStorage() async {
    List<PrescriptionDTO> data = await _sqfLiteHelper.getMedicationsRespone();
    List<MedicalInstructionDTO> _listPrescription = [];
    for (var itemPrescription in data) {
      MedicalInstructionDTO _prescription = MedicalInstructionDTO();
      DateTime dateFinished =
          new DateFormat("yyyy-MM-dd").parse(itemPrescription.dateFinished);
      //nếu ngày kết thúc lớn hơn ngày hiện tại thì lấy lịch uống thuốc
      if (dateFinished.millisecondsSinceEpoch >=
          curentDateNow.millisecondsSinceEpoch) {
        List<MedicationSchedules> listMedical = await _sqfLiteHelper
            .getAllByMedicalResponseID(itemPrescription.medicalResponseID);
        itemPrescription.medicationSchedules = listMedical;
        _prescription.medicationsRespone = itemPrescription;
        _listPrescription.add(_prescription);
      } else {
        // nếu ngày kết thúc nhỏ hơn ngày hiện tại thì xóa data trong local
        await _sqfLiteHelper
            .deleteMedicalScheduleByID(itemPrescription.medicalResponseID);
        await _sqfLiteHelper
            .deleteMedicalResponseByID(itemPrescription.medicalResponseID);
      }
    }

    setState(() {
      listPrescription = _listPrescription;
    });
  }

  Future<void> _pullRefresh() async {
    _getPatientId();
  }
}
