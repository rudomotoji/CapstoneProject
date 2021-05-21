import 'dart:async';
import 'dart:ui';

import 'package:capstone_home_doctor/features/advertisement/repositories/advertisement_repository.dart';
import 'package:capstone_home_doctor/features/background/repositories/background_repository.dart';
import 'package:capstone_home_doctor/models/advertisement_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_detail_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_push_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_schedule_dto.dart';
import 'package:capstone_home_doctor/services/time_system_helper.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/artboard_button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/silver_floating_header.dart';
import 'package:capstone_home_doctor/commons/widgets/silver_pin_box_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/payment_bloc.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/views/webview_payment.dart';
import 'package:capstone_home_doctor/features/global/repositories/system_repository.dart';
import 'package:capstone_home_doctor/features/information/blocs/patient_bloc.dart';
import 'package:capstone_home_doctor/features/information/events/patient_event.dart';
import 'package:capstone_home_doctor/features/information/states/patient_state.dart';
import 'package:capstone_home_doctor/features/login/blocs/token_device_bloc.dart';
import 'package:capstone_home_doctor/features/login/events/token_device_event.dart';
import 'package:capstone_home_doctor/features/payment/repositories/payment_repository.dart';
import 'package:capstone_home_doctor/features/peripheral/views/connect_peripheral_view.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/appointment_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/prescription_list_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/events/appointment_event.dart';
import 'package:capstone_home_doctor/features/schedule/events/prescription_list_event.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/appointment_repository.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/prescription_repository.dart';
import 'package:capstone_home_doctor/features/schedule/states/appointment_state.dart';
import 'package:capstone_home_doctor/features/schedule/states/prescription_list_state.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/blood_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/real_time_vt_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/blocs/vital_sign_bloc.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/blood_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/events/vital_sign_event.dart';
import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_repository.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/blood_state.dart';
import 'package:capstone_home_doctor/features/vital_sign/states/vital_sign_state.dart';
import 'package:capstone_home_doctor/models/appointment_dto.dart';
import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/models/patient_dto.dart';
import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:capstone_home_doctor/models/token_device_dto.dart';
import 'package:capstone_home_doctor/models/vital_sign_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:capstone_home_doctor/services/measure_helper.dart';
import 'package:capstone_home_doctor/services/mobile_device_helper.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:capstone_home_doctor/services/notifications_bloc.dart';
import 'package:capstone_home_doctor/services/reminder_helper.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:capstone_home_doctor/services/vital_sign_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:url_launcher/url_launcher.dart';

//////////////
///
///
///
///
///COMMENT COMMENT COMMETNOKJAOISJ AISHFKASGFKJ ABSJHBASF
//
final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final MobileDeviceHelper _mobileDeviceHelper = MobileDeviceHelper();
final VitalSignHelper vitalSignHelper = VitalSignHelper();
final ContractHelper contractHelper = ContractHelper();
final ReminderHelper _reminderHelper = ReminderHelper();
final ArrayValidator _arrayValidator = ArrayValidator();
final MeasureHelper _measureHelper = MeasureHelper();
DateValidator _dateValidator = DateValidator();
List<ContractListDTO> _listExecuting = [];
final VitalSignRepository _vitalSignRepository = VitalSignRepository();
final BackgroundRepository _backgroundRepository =
    BackgroundRepository(httpClient: http.Client());
final VitalSignServerRepository _vitalSignServerRepository =
    VitalSignServerRepository(httpClient: http.Client());
final TimeSystemHelper _timeSystemHelper = TimeSystemHelper();
final AdvertisementRepository _advertisementRepository =
    AdvertisementRepository(httpClient: http.Client());
//
List<int> listTimeMeasure = [3, 5, 10, 15, 30];
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

class _DashboardState extends State<DashboardPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  var _index = 0;
  var location;
  var _idDoctorController = TextEditingController();
  String _idDoctor = '';
  List<ContractListDTO> listContract = [];
  bool checkPeopleStatusLocal = false;

  List<AdvertisementDTO> listAd = [];
  //measure kicked on
  bool isMeasureOn = false;
  String timeChosen = '';

  //peripheral
  bool _isConnectedWithPeripheral = false;
  String _peripheralId = '';

  int _patientId = 0;
  String _tokenDevice = '';
  int _accountId = 0;

  int _heartRateValue = 0;

  TokenDeviceDTO _tokenDeviceDTO = TokenDeviceDTO();
  AppointmentDTO _appointmentDTO;
  //
  PrescriptionRepository prescriptionRepository =
      PrescriptionRepository(httpClient: http.Client());
  ContractRepository contractRepository =
      ContractRepository(httpClient: http.Client());
  PaymentRepository paymentRepository =
      PaymentRepository(httpClient: http.Client());

  PrescriptionListBloc _prescriptionListBloc;
  AppointmentBloc _appointmentBloc;
  TokenDeviceBloc _tokenDeviceBloc;
  VitalSignBloc _vitalSignBloc;
  VitalSignBloodBloc _vitalSignBloodBloc;

  SystemRepository _systemRepository =
      SystemRepository(httpClient: http.Client());

  //
  String vitalType = 'HEART_RATE';
  String vitalBPType = 'PRESSURE';
  VitalSignDTO lastMeasurement = VitalSignDTO();
  List<VitalSignDTO> listHeartRate = [];
  VitalSignDTO lastMeasurementBlood = VitalSignDTO();
  //
  //
  bool isBluetoothConnection = false;
  bool isContractApproved = false;
  bool isMeasureDone = false;
  String timeStartM = '';
  int durationM = 0;
  int countDurationM = 0;
  List<String> listTimeM = [];
  String listTimeString = '';
  String listValueM = '';
  int minL = 0;
  int maxL = 0;

  //
  List<VitalSignDTO> listVitalSignDangerous = [];

  SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
  DateTime curentDateNow = new DateFormat('yyyy-MM-dd')
      .parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  // List<MedicationSchedules> listSchedule = [];
  List<AppointmentDTO> listAppointment = [];
  List<AppointmentDTO> listAppointmentCurrentSortedDate = [];
  List<AppointmentDetailDTO> listAppointmentDetailSortedDate = [];
  List<MedicalInstructionDTO> listPrescription = [];
  List<AppointmentDTO> _listAppointment = [];

  Stream<ReceiveNotification> _notificationsStream;
  Stream<ReceiveNotification> _refreshHeartRateStream;
  Stream<ReceiveNotification> _measureStream;

  bool dangerKickedOn = false;

  //
  final _controller = ScrollController();

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;

  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;

  _refreshBottomSheet(StateSetter setModalState) {
    if (!mounted) return;
    setModalState(() {
      timeStartM = timeStartM;
      durationM = durationM;
      listValueM = listValueM;
      listTimeM = listTimeM;
      isMeasureOn = isMeasureOn;
      isMeasureDone = isMeasureDone;
      countDurationM = countDurationM;
    });
  }

  _getListAd() async {
    await _advertisementRepository.getListAd().then((list) {
      if (!mounted) return;
      setState(() {
        listAd = list;
      });
    });
  }

  _getsOffline() async {
    await _sqfLiteHelper.getVitalSignScheduleOffline().then((sOffline) async {
      if (sOffline.isNotEmpty && sOffline != null) {
        //
        var heartRateSchedule =
            sOffline.where((item) => item.vitalSignType == 'Nhịp tim').first;
        setState(() {
          minL = heartRateSchedule.numberMin;
          maxL = heartRateSchedule.numberMax;
        });
      } else {
        await _backgroundRepository
            .getSafeScopeHeartRate()
            .then((safeScopeHR) async {
          print(
              'safe scope hr: ${safeScopeHR.minSafeHeartRate} - ${safeScopeHR.maxSafeHeartRate}');
          setState(() {
            minL = safeScopeHR.minSafeHeartRate;
            maxL = safeScopeHR.maxSafeHeartRate;
          });
        });
      }
    });
  }

  _getMeasureCounting() async {
    await _measureHelper.getTimeStartM().then((tStart) {
      if (!mounted) return;
      setState(() {
        timeStartM = tStart;
      });
    });
    await _measureHelper.getDurationM().then((dM) {
      if (!mounted) return;
      setState(() {
        durationM = dM;
      });
    });
    await _measureHelper.getListValueHr().then((listV) {
      if (!mounted) return;
      setState(() {
        listValueM = listV;
      });
    });
    await _measureHelper.getListTime().then((listT) {
      if (!mounted) return;

      listTimeM.clear();
      setState(() {
        listTimeString = listT;
        if (listT != '' || listT != null) {
          for (int i = 0; i < listT.split(',').length; i++) {
            listTimeM.add('"' + '${listT.split(',')[i]}' + '"');
          }
          if (listTimeM.last == '""') {
            listTimeM.removeLast();
          }
        }
      });
    });
    await _measureHelper.isMeasureOn().then((value) async {
      //
      if (!mounted) return;
      setState(() {
        //
        isMeasureOn = value;
      });
      //
      if (value) {
        await _measureHelper.getCountingM().then((countM) async {
          //
          if (!mounted) return;
          setState(() {
            countDurationM = countM;
          });

          await _measureHelper.getDurationM().then((durationM) async {
            if (countM < durationM) {
              if (!mounted) return;
              setState(() {
                isMeasureDone = false;
              });
            } else {
              if (!mounted) return;
              setState(() {
                isMeasureDone = true;
              });
            }
          });
        });
      }
      //
    });
    //
    //
  }

  _getTimeSystem() async {
    await _systemRepository.getTimeSystem().then((value) async {
      /////
      // await _timeSystemHelper.setTimeSystem(value);
      if (!mounted) return;
      setState(() {
        curentDateNow = new DateFormat('yyyy-MM-dd').parse(
            DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(value.split('"')[1].split('"')[0])));
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _getListAd();
    _getTimeSystem();
    _getPatientId();
    _getMeasureCounting();
    _getsOffline();
    _appointmentBloc = BlocProvider.of(context);
    _prescriptionListBloc = BlocProvider.of(context);
    _tokenDeviceBloc = BlocProvider.of(context);
    _vitalSignBloc = BlocProvider.of(context);
    _vitalSignBloodBloc = BlocProvider.of(context);
    _getBluetoothConnection();
    if (_patientId != 0) {
      _vitalSignBloc
          .add(VitalSignEventGetList(type: vitalType, patientId: _patientId));
      _vitalSignBloodBloc
          .add(BloodPressureEventGet(patientId: _patientId, type: vitalBPType));
    }
    _updateAvailableContract();
    _updateTokenDevice();
    _getPeripheralInfo();

    _notificationsStream = NotificationsBloc.instance.notificationsStream;
    _notificationsStream.listen((notification) {
      _pullRefresh();
      _getTimeSystem();
      print(
          '--------NOTI BODY ${notification.body} - noti id: ${notification.id} -  - noti: ${notification.payload}');
    });
    _measureStream = MeasureBloc.instance.notificationsStream;
    _measureStream.listen((rf) {
      if (rf.title.contains('measure hr')) {
        _getMeasureCounting();
      }
    });

    //
    _refreshHeartRateStream = HeartRefreshBloc.instance.notificationsStream;
    _refreshHeartRateStream.listen((refresh) {
      if (refresh.title.contains('reload heart rate')) {
        if (_patientId != 0) {
          _vitalSignBloc.add(
              VitalSignEventGetList(type: vitalType, patientId: _patientId));
          _getPeopleStatus();
        }
      }
    });

    _getPeopleStatus();
  }

  _getBluetoothConnection() async {
    await _reminderHelper.isBluetoothConnection().then((value) {
      if (!mounted) return;
      setState(() {
        if (value) {
          isBluetoothConnection = true;
        } else {
          isBluetoothConnection = false;
        }
      });
    });
  }

  _getPeripheralInfo() async {
    await peripheralHelper.getPeripheralId().then((peripheralId) async {
      if (!mounted) return;
      if (peripheralId != '') {
        setState(() {
          _isConnectedWithPeripheral = true;
        });
        _peripheralId = peripheralId;
      } else {
        setState(() {
          _isConnectedWithPeripheral = false;
        });
      }
    });
  }

  _getPeopleStatus() async {
    await vitalSignHelper.getPeopleStatus().then((value) async {
      if (!mounted) return;
      setState(() {
        if (value == 'DANGER') {
          checkPeopleStatusLocal = true;
        } else {
          checkPeopleStatusLocal = false;
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    //  _animationController.dispose();
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
      if (!mounted) return;
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
    // await _systemRepository.getTimeSystem().then((value) {
    // if (!mounted) return;
    //   if (value != null && value != '' && value.isNotEmpty) {
    //     String nowSystem = value.toString().trim().replaceAll('"', '');
    //     // curentDateNow = DateFormat('yyyy-MM-dd').parse(nowSystem);
    //     // print('curentDateNow: ${curentDateNow}');
    //     //
    //   }
    // });
    // });

    await _authenticateHelper.getPatientId().then((value) {
      _patientId = value;
    });
    await _authenticateHelper.getAccountId().then((value) {
      _accountId = value;
    });
    if (_patientId != 0) {
      // DateTime curentDateNow = new DateTime.now();
      _vitalSignBloodBloc
          .add(BloodPressureEventGet(patientId: _patientId, type: vitalBPType));
      _vitalSignBloc
          .add(VitalSignEventGetList(type: vitalType, patientId: _patientId));
      _prescriptionListBloc
          .add(PrescriptionListEventsetPatientId(patientId: _patientId));
      _appointmentBloc.add(AppointmentGetListEvent(
          patientId: _accountId,
          date: '${curentDateNow.year}/${curentDateNow.month}'));

      await prescriptionRepository
          .getListPrecription(_patientId)
          .then((value) async {
        List<MedicalInstructionDTO> _listPrescription = [];
        if (value != null) {
          value.sort((a, b) =>
              b.medicalInstructionId.compareTo(a.medicalInstructionId));
          value.sort((a, b) => a.medicationsRespone.dateStarted
              .compareTo(b.medicationsRespone.dateStarted));

          for (var schedule in value) {
            MedicalInstructionDTO _prescription = MedicalInstructionDTO();
            if (schedule.medicationsRespone.dateFinished != null) {
              // DateTime tempDate2 = new DateFormat("yyyy-MM-dd")
              //     .parse(schedule.medicationsRespone.dateFinished);
              //
              DateTime dateFinished = new DateFormat('dd/MM/yyyy').parse(
                  _dateValidator.convertDateCreate(
                      schedule.medicationsRespone.dateFinished,
                      'dd/MM/yyyy',
                      'yyyy-MM-dd'));
              DateTime dateStarted = new DateFormat('dd/MM/yyyy').parse(
                  _dateValidator.convertDateCreate(
                      schedule.medicationsRespone.dateStarted,
                      'dd/MM/yyyy',
                      'yyyy-MM-dd'));
              if (dateFinished.millisecondsSinceEpoch >=
                      curentDateNow.millisecondsSinceEpoch &&
                  dateStarted.millisecondsSinceEpoch <=
                      curentDateNow.millisecondsSinceEpoch &&
                  schedule.medicationsRespone.status.contains('ACTIVE')) {
                schedule.medicationsRespone.medicalResponseID =
                    schedule.medicalInstructionId;
                _prescription = schedule;
                _listPrescription.add(_prescription);
              }
            }
          }
          listPrescription = _listPrescription;
        }
        await handlingMEdicalResponse();
      });
      await contractRepository.getListContract(_patientId).then((value) async {
        //
        listContract = value;
        //listContract=  listContract.where((item) => item.status=='APPROVED');
        if (!mounted) return;
        setState(() {
          _listExecuting =
              listContract.where((item) => item.status == 'ACTIVE').toList();
        });
        //
        for (ContractListDTO contract in listContract) {
          if (contract.status == 'APPROVED') {
            if (!mounted) return;
            setState(() {
              isContractApproved = true;
            });
            break;
          } else {
            isContractApproved = false;
          }
        }
      });
    }
    // await _authenticateHelper.getAccountId().then((value) {
    //   print('ACCOUNT ID ${value}');
    // });
    // //////this is comment for real
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (_) {
            // _snapAppbar();
            return false;
          },
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _controller,
            slivers: [
              SliverAppBar(
                brightness: Brightness.light,
                pinned: true,
                collapsedHeight: minHeight + 10,
                floating: false,
                // stretch: true,
                flexibleSpace: Stack(
                  children: [
                    Header(
                      maxHeight: maxHeight + 10,
                      minHeight: minHeight + 10,
                    ),
                  ],
                ),
                expandedHeight:
                    maxHeight - MediaQuery.of(context).padding.top + 10,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildComponentDashboard();
                  },
                  childCount: 1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComponentDashboard() {
    //  final int percent = (_animationController.value * 100.0).round();
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Container(
          //   width: (isDJOn) ? 200 : 300,
          //   color: DefaultTheme.RED_CALENDAR,
          //   height: 50,

          // ),
          // Text('$percent%'),
          (checkPeopleStatusLocal) ? _showVitalSignSummary() : Container(),
          _showAppointmentNoti(),
          ((listPrescription != null && listPrescription.isNotEmpty) ||
                  !_isConnectedWithPeripheral ||
                  isContractApproved)
              ? _buildReminder()
              : Container(),
          _showMedicineSchedule(),

          //  _buildVitalSign(),
          //
          //
          //
          (checkPeopleStatusLocal && !_isConnectedWithPeripheral)
              ? Container()
              : (!checkPeopleStatusLocal && _isConnectedWithPeripheral)
                  ? _showVitalSignSummary()
                  : Container(),
          _showLastHeartRateMeasure(),
          _showLastBloodPressureMeasure(),
          _buildShorcut(),
          Padding(
            padding: EdgeInsets.only(bottom: 50),
          ),
        ]);
  }

  Widget _showMedicineSchedule() {
    return Container();
  }

  Widget _buildReminder() {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(left: 20, bottom: 10),
            margin: EdgeInsets.only(top: 20),
            child: Text(
              'Nhắc nhở',
              style: TextStyle(
                  color: DefaultTheme.BLACK,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        (listPrescription != null && listPrescription.isNotEmpty)
            ? Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                padding:
                    EdgeInsets.only(left: 10, right: 20, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  color: DefaultTheme.GREY_VIEW,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/images/ic-medicine.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                    ),
                    Text('Bạn có lịch dùng thuốc',
                        style: TextStyle(color: DefaultTheme.BLACK))
                  ],
                ),
              )
            : Container(),
        //
        (isContractApproved)
            ? Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                padding:
                    EdgeInsets.only(left: 10, right: 20, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  color: DefaultTheme.GREY_VIEW,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/images/ic-contract.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                    ),
                    Text('Bạn có hợp đồng cần xác nhận',
                        style: TextStyle(color: DefaultTheme.BLACK))
                  ],
                ),
              )
            : Container(),

        //
        StreamBuilder<BluetoothState>(
            stream: FlutterBlue.instance.state,
            initialData: BluetoothState.unknown,
            builder: (c, snapshot) {
              final state = snapshot.data;
              if (state == BluetoothState.on) {
                return Container();
              }
              return Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                padding:
                    EdgeInsets.only(left: 10, right: 20, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  color: DefaultTheme.GREY_VIEW,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/images/ic-bluetooth.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                    ),
                    Text('Kết nối bluetooth đã tắt',
                        style: TextStyle(color: DefaultTheme.BLACK))
                  ],
                ),
              );
            }),
        (_isConnectedWithPeripheral)
            ? Container()
            : Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                padding:
                    EdgeInsets.only(left: 10, right: 20, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  color: DefaultTheme.GREY_VIEW,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/images/ic-connect-p.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                    ),
                    Text('Bạn cần nối thiết bị đeo',
                        style: TextStyle(color: DefaultTheme.BLACK))
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildShorcut() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(left: 20, bottom: 10),
            margin: EdgeInsets.only(top: 20),
            child: Text(
              'Phím tắt',
              style: TextStyle(
                  color: DefaultTheme.BLACK,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        //

        Divider(color: DefaultTheme.GREY_TOP_TAB_BAR, height: 1),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RoutesHDr.SCHEDULE);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.19,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/ic-calendar.png',
                          width: 30, height: 30),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.19,
                        child: Text(
                          'Lịch',
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _chooseStepContract();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.21,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/ic-contract.png',
                          width: 30, height: 30),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: Text(
                          'Tạo hợp đồng',
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RoutesHDr.CREATE_HEALTH_RECORD);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/ic-create-hr.png',
                          width: 30, height: 30),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Text(
                          'Tạo Hồ sơ',
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await peripheralHelper.getPeripheralId().then((peripheralId) {
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
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/ic-connect-p.png',
                          width: 30, height: 30),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Text(
                          'Thiết bị đeo',
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (_isConnectedWithPeripheral) {
                    _chooseMeasure();
                  } else {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return Material(
                          color: DefaultTheme.TRANSPARENT,
                          child: Center(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 10, right: 10),
                                  width: 250,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: DefaultTheme.WHITE.withOpacity(0.7),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            bottom: 10, top: 10),
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
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Vui lòng kết nối với thiết bị đeo.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              decoration: TextDecoration.none,
                                              color: DefaultTheme.BLACK,
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
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/ic-measure.png',
                          width: 30, height: 30),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Text(
                          'Đo nhịp tim',
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(color: DefaultTheme.GREY_TOP_TAB_BAR, height: 1),
//         CarouselSlider(
//           options: CarouselOptions(
//             height: 180,
//             autoPlay: true,
//             viewportFraction: 0.6,
//             aspectRatio: 2.0,
//             autoPlayInterval: Duration(seconds: 5),
//             enlargeCenterPage: false,
//             autoPlayCurve: Curves.easeIn,
//           ),
//           items: listAd.map((i) {
//             return Builder(
//               builder: (BuildContext context) {
//                 return Container(
//                     padding: EdgeInsets.only(left: 10, right: 10),
//                     margin: EdgeInsets.only(left: 10),
//                     width: 280,
//                     height: 180,
//                     // margin: EdgeInsets.symmetric(horizontal: 2.0),
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage('${i.adImage}'),
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(top: 40),
//                         ),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             '${i.title}',
//                             style: TextStyle(
//                                 fontSize: 16.0,
//                                 color: DefaultTheme.WHITE,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                         Text(
//                           '${i.description}',
//                           style: TextStyle(
//                               fontSize: 12, color: DefaultTheme.WHITE),
//                         ),
//                       ],
//                     ));
//               },
//             );
//           }).toList(),
//         ),
// //
      ],
    );
  }

  Widget _buildCard(int index) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Text("Item $index"),
      ),
    );
  }

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset =
          _controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(() => _controller.animateTo(snapOffset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }

  _showVitalSignSummary() {
    return (checkPeopleStatusLocal)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (checkPeopleStatusLocal)
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        'Sinh hiệu',
                        style: TextStyle(
                          color: DefaultTheme.BLACK,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 0),
                padding:
                    EdgeInsets.only(left: 20, bottom: 10, top: 10, right: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg-danger.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    //
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: DefaultTheme.WHITE.withOpacity(0.2),
                      ),
                      width: MediaQuery.of(context).size.width - 20,
                      child: Center(
                        child: Text(
                          'Sinh hiệu bất thường'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            color: DefaultTheme.WHITE,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                    // Container(
                    //   padding: EdgeInsets.only(bottom: 5),
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     'Ghi chú của bác sĩ: ',
                    //     style: TextStyle(
                    //       color: DefaultTheme.WHITE,
                    //       fontSize: 15,
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   height: 100,
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5),
                    //     color: DefaultTheme.WHITE.withOpacity(0.9),
                    //   ),
                    // ),
                  ],
                ),
              ),
              (_listExecuting.length == 0)
                  ? Container()
                  : Container(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 15),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _listExecuting.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async => await launch(
                                'tel://${_arrayValidator.parsePhoneToPhoneNo(_listExecuting[index].phoneNumberDoctor)}'),
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              margin: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                //
                                border: Border.all(
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    width: 0.75),
                                color: DefaultTheme.WHITE,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                        'assets/images/ic-call.png'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                  ),
                                  Text(
                                    'Gọi bác sĩ ${_listExecuting[index].fullNameDoctor}',
                                    style: TextStyle(
                                      color: DefaultTheme.SUCCESS_STATUS,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (checkPeopleStatusLocal)
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        'Sinh hiệu',
                        style: TextStyle(
                          color: DefaultTheme.BLACK,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 0),
                padding:
                    EdgeInsets.only(left: 20, bottom: 10, top: 10, right: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg-normal.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: DefaultTheme.WHITE.withOpacity(0.2),
                            ),
                            width: MediaQuery.of(context).size.width - 20,
                            child: Center(
                              child: Text(
                                'Sinh hiệu ổn định',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: DefaultTheme.WHITE,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                          ),
                          Container(
                            child: Text(
                              'Hệ thống không nhận thấy dấu hiệu bất thường.',
                              style: TextStyle(
                                color: DefaultTheme.WHITE,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  _showAppointmentNoti() {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, stateAppointment) {
      if (stateAppointment is AppointmentStateLoading) {
        return Container(
            // width: MediaQuery.of(context).size.width,
            // height: 50,
            // child: SizedBox(
            //   width: MediaQuery.of(context).size.width,
            //   height: 50,
            //   child: Image.asset('assets/images/loading.gif'),
            // ),
            );
      }
      if (stateAppointment is AppointmentStateFailure) {
        return Container(
            width: MediaQuery.of(context).size.width,
            child:
                Center(child: Text('Kiểm tra lại đường truyền kết nối mạng')));
      }
      if (stateAppointment is AppointmentStateSuccess) {
        listAppointment = stateAppointment.listAppointment;
        listAppointmentCurrentSortedDate.clear();
        listAppointmentDetailSortedDate.clear();
        if (stateAppointment.listAppointment != null &&
            stateAppointment.listAppointment.isNotEmpty) {
          // print('current: $curentDateNow');
          for (AppointmentDTO dto in stateAppointment.listAppointment) {
            if (_dateValidator
                    .parseStringToDateApnt(dto.dateExamination)
                    .isAfter(curentDateNow) ||
                _dateValidator
                    .parseStringToDateApnt(dto.dateExamination)
                    .isAtSameMomentAs(curentDateNow)) {
              if (_dateValidator
                  .parseStringToDateApnt(dto.dateExamination)
                  .isBefore(curentDateNow.add(Duration(days: 7)))) {
                //
                dto.appointments.removeWhere((item) =>
                    item.status == 'FINISHED' || item.status == 'CANCEL');
                listAppointmentCurrentSortedDate.add(dto);
                listAppointmentDetailSortedDate.addAll(dto.appointments);
              }
            }
            //

          }
        }
      }
      return (listAppointmentCurrentSortedDate == null ||
              listAppointmentCurrentSortedDate.isEmpty ||
              listAppointmentDetailSortedDate.length == 0)
          ? Container()
          : Container(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, bottom: 0),
                  margin: EdgeInsets.only(top: 20, bottom: 0),
                  child: Row(children: [
                    Text(
                      'Sự kiện tiếp theo',
                      //  \n${curentDateNow}',
                      style: TextStyle(
                          color: DefaultTheme.BLACK,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        // color: DefaultTheme.RED_CALENDAR,
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              DefaultTheme.BLUE_TEXT.withOpacity(0.5),
                              DefaultTheme.BLUE_TEXT,
                            ]),
                      ),
                      child: Center(
                        child: Text(
                          '${listAppointmentDetailSortedDate.length}',
                          style: TextStyle(
                              fontSize: 12, color: DefaultTheme.WHITE),
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    primary: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listAppointmentCurrentSortedDate.length,
                    itemBuilder: (BuildContext context, int index) {
                      return (listAppointmentCurrentSortedDate[index]
                                  .appointments
                                  .isEmpty ||
                              listAppointmentCurrentSortedDate[index]
                                      .appointments ==
                                  null)
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  //color: DefaultTheme.GREY_VIEW,
                                  // border: Border(
                                  //   left: BorderSide(
                                  //       width: 2.0, color: DefaultTheme.RED_CALENDAR),
                                  // ),
                                  ),
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 5),
                              padding: EdgeInsets.only(bottom: 10, top: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  Container(
                                    // width: 60,
                                    // height: 60,
                                    child: Center(
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  DefaultTheme.GREY_TOP_TAB_BAR,
                                              width: 0.75),
                                          color: DefaultTheme.WHITE,
                                          borderRadius:
                                              BorderRadius.circular(13),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${listAppointmentCurrentSortedDate[index].dateExamination.split('/')[0]}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color:
                                                      DefaultTheme.BLUE_TEXT),
                                            ),
                                            Text(
                                              'Th ${listAppointmentCurrentSortedDate[index].dateExamination.split('/')[1]}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: DefaultTheme.BLACK),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      for (AppointmentDetailDTO detail
                                          in listAppointmentCurrentSortedDate[
                                                  index]
                                              .appointments)
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 5, top: 5),
                                          padding: EdgeInsets.only(left: 5),
                                          decoration: BoxDecoration(
                                              border: Border(
                                            left: BorderSide(
                                                width: 3.0,
                                                color: _genderColor(
                                                    detail.status)),
                                          )),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              (40 + 20 + 50 + 2 + 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Bác sĩ ${detail.fullNameDoctor} lên lịch khám cho bạn.'),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 3,
                                                ),
                                              ),
                                              Text(
                                                'Thời gian: ${detail.dateExamination.split('T')[1].split(':')[0]}:${detail.dateExamination.split('T')[1].split(':')[1]}',
                                                style: TextStyle(
                                                  color: DefaultTheme.GREY_TEXT,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 3,
                                                ),
                                                child: Divider(
                                                  height: 2,
                                                  color: DefaultTheme
                                                      .GREY_TOP_TAB_BAR,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
                ),
              ],
            ));
    });
  }

  _showLastHeartRateMeasure() {
    return BlocBuilder<VitalSignBloc, VitalSignState>(
        builder: (context, state) {
      if (state is VitalSignDangerStateFailure) {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: Center(
              child: Text('Không thể tải'),
            ));
      }
      if (state is VitalSignStateGetListSuccess) {
        if (null == state.list || state.list.isEmpty) {
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
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Text(
              'Lần đo gần đây',
              style: TextStyle(
                color: DefaultTheme.BLACK,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
          ),
          Container(
            height: 90,
            margin: EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  child: InkWell(
                      // borderRadius: BorderRadius.circular(12),
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
                          // borderRadius: BorderRadius.circular(12),
                        ),
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
                                  fontFamily: 'NewYork',
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
                                'bpm',
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
    return BlocBuilder<VitalSignBloodBloc, BloodState>(
        builder: (context, state) {
      if (state is BloodPressureStateFailure) {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: Center(
              child: Text('Không thể tải'),
            ));
      }
      if (state is BloodPressureStateGetListSuccess) {
        if (state.list == null || state.list.isEmpty) {
          return Container();
        } else {
          lastMeasurementBlood = state.list.last;
          return (lastMeasurementBlood != null)
              ? Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 90,
                        child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(RoutesHDr.PRESSURE_CHART_VIEW);
                            },
                            focusColor: DefaultTheme.TRANSPARENT,
                            hoverColor: DefaultTheme.TRANSPARENT,
                            highlightColor: DefaultTheme.TRANSPARENT,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 10,
                              ),
                              padding: EdgeInsets.only(left: 20, right: 20),
                              height: 80,
                              decoration: BoxDecoration(
                                color: DefaultTheme.GREY_VIEW,
                                //borderRadius: BorderRadius.circular(12),
                              ),
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
                                          '${lastMeasurementBlood.value1}',
                                          style: TextStyle(
                                            color: DefaultTheme.RED_CALENDAR,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'NewYork',
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
                                          '${lastMeasurementBlood.value2}',
                                          style: TextStyle(
                                            color: DefaultTheme.RED_CALENDAR,
                                            fontFamily: 'NewYork',
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
                                  Container(
                                    height: 30,
                                    child: Text(
                                      'mmHg',
                                      style: TextStyle(
                                        color: DefaultTheme.GREY_TEXT,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  //
                                  Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      //
                                      (lastMeasurementBlood.dateTime != null)
                                          ? Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                child: Text(
                                                  '${lastMeasurementBlood.dateTime.split(' ')[1].split('.')[0].split(':')[0]}:${lastMeasurementBlood.dateTime.split(' ')[1].split('.')[0].split(':')[1]}',
                                                  textAlign: TextAlign.right,
                                                ),
                                              ))
                                          : Container(),
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
                        left: 40,
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
        }
      }

      return Container();
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

  void _chooseMeasure() {
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
                            'assets/images/ic-measure.png',
                            height: MediaQuery.of(context).size.height * 0.20,
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(60, 20, 60, 0),
                            child: Text(
                              'Kiểm tra và theo dõi nhịp tim của bạn',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ),
                          Spacer(),
                          // ButtonHDr(
                          //   isUnderline: false,
                          //   style: BtnStyle.BUTTON_BLACK,
                          //   label: 'Đo ngay',
                          //   onTap: () async {
                          //     Navigator.of(context).pop();
                          //     _onMeasuring();
                          //   },
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.only(top: 10),
                          // ),
                          ButtonHDr(
                            isUnderline: false,
                            style: BtnStyle.BUTTON_BLACK,
                            label: 'Đo',
                            onTap: () async {
                              Navigator.of(context).pop();
                              await _getMeasureCounting();
                              _showMeasureDuration();
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

  void _showPopUpIDDoctor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width - 20,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: DefaultTheme.WHITE.withOpacity(0.8),
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

  Widget _medicalScheduleNotNull(
      List<MedicationSchedules> listSchedule, String place) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, right: 20, bottom: 5, top: 10),
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
              (place != null) ? Text('(${place})') : Text(''),
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
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: 100,
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
            'Lịch khám',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: DefaultTheme.RED_CALENDAR,
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
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
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
        ],
      ),
    );
  }

  getAppointment() {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, stateAppointment) {
        if (stateAppointment is AppointmentStateLoading) {
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
        if (stateAppointment is AppointmentStateFailure) {
          return Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text('Kiểm tra lại đường truyền kết nối mạng')));
        }
        if (stateAppointment is AppointmentStateSuccess) {
          listAppointment = stateAppointment.listAppointment;
          if (stateAppointment.listAppointment != null) {
            DateTime curentNow = new DateFormat('dd/MM/yyyy')
                .parse(DateFormat('yyyy-MM-dd').format(curentDateNow));
            for (var appointment in stateAppointment.listAppointment) {
              DateTime dateAppointment = new DateFormat("dd/MM/yyyy")
                  .parse(appointment.dateExamination);
              if (dateAppointment.millisecondsSinceEpoch ==
                  curentNow.millisecondsSinceEpoch) {
                _appointmentDTO = appointment;
              }
              // _appointmentDTO = appointment;
            }
          }
          return Container(
            child: (_appointmentDTO == null)
                ? Container(
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
                          'Lịch khám',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: DefaultTheme.RED_CALENDAR,
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
                          'Hiện tại bạn không có lịch khám nào',
                          style: TextStyle(
                            color: DefaultTheme.BLACK,
                          ),
                        ),
                      ],
                    ),
                  )
                : _appointmentNotNull(),
          );
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
          return _getMedicationSchedule();
        }
        if (contextPrescription is PrescriptionListStateSuccess) {
          // listPrescription = contextPrescription.listPrescription;

          List<MedicalInstructionDTO> _listPrescription = [];
          if (contextPrescription.listPrescription != null) {
            listPrescription.sort((a, b) =>
                b.medicalInstructionId.compareTo(a.medicalInstructionId));
            listPrescription.sort((a, b) => a.medicationsRespone.dateStarted
                .compareTo(b.medicationsRespone.dateStarted));

            for (var schedule in contextPrescription.listPrescription) {
              MedicalInstructionDTO _prescription = MedicalInstructionDTO();
              if (schedule.medicationsRespone.dateFinished != null) {
                DateTime tempDate2 = new DateFormat("yyyy-MM-dd")
                    .parse(schedule.medicationsRespone.dateFinished);
                if (tempDate2.millisecondsSinceEpoch >=
                        curentDateNow.millisecondsSinceEpoch &&
                    schedule.medicationsRespone.status.contains('ACTIVE')) {
                  schedule.medicationsRespone.medicalResponseID =
                      schedule.medicalInstructionId;
                  _prescription = schedule;
                  _listPrescription.add(_prescription);
                }
              }
            }
            listPrescription = _listPrescription;
          }
          if (contextPrescription.listPrescription.length > 0) {
            handlingMEdicalResponse();
          } else {
            getLocalStorage();
          }
          return _getMedicationSchedule();
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

  Widget _getMedicationSchedule() {
    return (listPrescription.length > 0)
        ? SizedBox(
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
                        listPrescription[i]
                            .medicationsRespone
                            .medicationSchedules,
                        listPrescription[i].placeHealthRecord),
                  ),
                );
              },
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
                  'Lịch dùng thuốc',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: DefaultTheme.RED_CALENDAR,
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
                  'Hiện tại bạn chưa có lịch uống thuốc nào từ bác sĩ.',
                  style: TextStyle(
                    color: DefaultTheme.BLACK,
                  ),
                ),
              ],
            ),
          );
    // if (listPrescription.length > 0) {
    //   return SizedBox(
    //     height: 280,
    //     width: MediaQuery.of(context).size.width,
    //     child: PageView.builder(
    //       itemCount: listPrescription.length,
    //       controller: PageController(viewportFraction: 0.9),
    //       onPageChanged: (int index) => setState(() => _index = index),
    //       itemBuilder: (_, i) {
    //         return Transform.scale(
    //           scale: i == _index ? 1 : 0.9,
    //           alignment: Alignment.centerLeft,
    //           child: Card(
    //             elevation: 0,
    //             shadowColor: DefaultTheme.GREY_TEXT,
    //             color: DefaultTheme.GREY_VIEW,
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10)),
    //             child: _medicalScheduleNotNull(
    //                 listPrescription[i].medicationsRespone.medicationSchedules),
    //           ),
    //         );
    //       },
    //     ),
    //   );
    // } else {
    //   return Container(
    //     width: MediaQuery.of(context).size.width,
    //     height: 100,
    //     padding: EdgeInsets.only(left: 20, right: 20),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(12),
    //       color: DefaultTheme.GREY_VIEW,
    //     ),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         //
    //         Padding(
    //           padding: EdgeInsets.only(
    //             top: 15,
    //           ),
    //         ),
    //         Text(
    //           'Lịch dùng thuốc',
    //           style: TextStyle(
    //             fontWeight: FontWeight.w400,
    //             fontSize: 18,
    //             color: DefaultTheme.RED_CALENDAR,
    //           ),
    //         ),
    //         Padding(
    //           padding: EdgeInsets.only(
    //             top: 5,
    //           ),
    //         ),
    //         Divider(
    //           color: DefaultTheme.GREY_TOP_TAB_BAR,
    //           height: 1,
    //         ),
    //         Padding(
    //           padding: EdgeInsets.only(bottom: 10),
    //         ),
    //         Text(
    //           'Hiện tại bạn chưa có lịch uống thuốc nào từ bác sĩ.',
    //           style: TextStyle(
    //             color: DefaultTheme.BLACK,
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }
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
    peripheralHelper.getPeripheralId().then((peripheralId) {
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
              }).catchError((e) {
                return;
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
    await _sqfLiteHelper.cleanDatabase();
    for (var schedule in listPrescription) {
      if (schedule.medicationsRespone.dateFinished != null) {
        DateTime dateFinished = new DateFormat('dd/MM/yyyy').parse(
            _dateValidator.convertDateCreate(
                schedule.medicationsRespone.dateFinished,
                'dd/MM/yyyy',
                'yyyy-MM-dd'));
        DateTime dateStarted = new DateFormat('dd/MM/yyyy').parse(
            _dateValidator.convertDateCreate(
                schedule.medicationsRespone.dateStarted,
                'dd/MM/yyyy',
                'yyyy-MM-dd'));
        if (dateFinished.millisecondsSinceEpoch >=
                curentDateNow.millisecondsSinceEpoch &&
            dateStarted.millisecondsSinceEpoch <=
                curentDateNow.millisecondsSinceEpoch &&
            schedule.medicationsRespone.status.contains('ACTIVE')) {
          schedule.medicationsRespone.medicalResponseID =
              schedule.medicalInstructionId;
          await _sqfLiteHelper
              .insertMedicalResponse(schedule.medicationsRespone);

          for (var item in schedule.medicationsRespone.medicationSchedules) {
            item.medicalResponseID = schedule.medicalInstructionId;
            await _sqfLiteHelper.insertMedicalSchedule(item);
          }
        }
      }
    }

    // getLocalStorage();
  }

  _kickHRCOn() async {
    await peripheralHelper.getPeripheralId().then((id) async {
      if (id != '') {
        await _vitalSignRepository.kickHRCOn(id);
      }
    });
  }

  getLocalStorage() async {
    List<PrescriptionDTO> data = await _sqfLiteHelper.getMedicationsRespone();
    print('getLocalStorage: ${data.length}');
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

    // setState(() {
    //   listPrescription = _listPrescription;
    // });
  }

  Future<void> _pullRefresh() async {
    _getPatientId();
  }

  DateTime dateNow;
  _getDateTimeNow() {
    setState(() {
      dateNow = DateTime.now();
    });
  }

//show measure duration
  _showMeasureDuration() {
    ////////
    ///DO HERE
    timeChosen = '';
    _getDateTimeNow();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            _measureStream = MeasureBloc.instance.notificationsStream;
            _measureStream.listen((rf) {
              if (rf.title.contains('measure hr')) {
                // _getMeasureCounting();
                _refreshBottomSheet(setModalState);
              }
            });
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.95,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05),
                    color: DefaultTheme.TRANSPARENT,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.9,
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
                                  EdgeInsets.only(top: 30, left: 20, right: 20),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                            'assets/images/ic-measure.png'),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15),
                                      ),
                                      Text(
                                        'Đo nhịp tim',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Spacer(),
                                      (isMeasureOn)
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  bottom: 10,
                                                  top: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: (isMeasureDone)
                                                      ? DefaultTheme.BLUE_TEXT
                                                          .withOpacity(0.7)
                                                      : DefaultTheme
                                                          .RED_CALENDAR
                                                          .withOpacity(0.7)),
                                              child: Center(
                                                child: Text(
                                                  (isMeasureDone &&
                                                          countDurationM > 0)
                                                      ? 'Đo hoàn tất'
                                                      : (!isMeasureDone &&
                                                              countDurationM ==
                                                                  0)
                                                          ? 'Đang đo'
                                                          : (!isMeasureDone &&
                                                                  countDurationM >
                                                                      0)
                                                              ? 'Đang đo ${countDurationM} phút'
                                                              : '',
                                                  style: TextStyle(
                                                      color:
                                                          DefaultTheme.WHITE),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  )),
                            ),
                            (isMeasureOn)
                                ? Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                        _getMeasureInformation(),
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(top: 20)),
                                        Divider(
                                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                                          height: 0.25,
                                        ),
                                        Container(
                                          height: 50,
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 140,
                                                child: Text(
                                                  'Ngày',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 140,
                                                child: Text(
                                                  'Bắt đầu từ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Text(
                                                  '${_dateValidator.getHourAndMinute(dateNow.toString())}'),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                                          height: 0.25,
                                        ),
                                        Container(
                                          height: 50,
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 140,
                                                child: Text(
                                                  'Trong vòng',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              //
                                              Container(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    180,
                                                child: DropdownButton<int>(
                                                  items: listTimeMeasure
                                                      .map((int value) {
                                                    return new DropdownMenuItem<
                                                        int>(
                                                      value: value,
                                                      child: new Text(
                                                        '${value} phút',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    );
                                                  }).toList(),
                                                  hint: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 0),
                                                    child: Text(
                                                      '$timeChosen',
                                                      style: TextStyle(
                                                          color: DefaultTheme
                                                              .BLACK,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  underline: Container(
                                                    width: 0,
                                                  ),
                                                  isExpanded: true,
                                                  onChanged: (_) {
                                                    print('$_');
                                                    setModalState(() {
                                                      timeChosen =
                                                          _.toString() +
                                                              ' phút';
                                                    });
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                                          height: 0.25,
                                        ),
                                        Spacer(),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 45,
                                          child: ButtonHDr(
                                            style: BtnStyle.BUTTON_BLACK,
                                            label: 'Bắt đầu đo',
                                            onTap: () async {
                                              setState(() {
                                                if (!mounted) return;
                                                isMeasureOn = true;
                                              });
                                              setModalState(() {
                                                if (!mounted) return;
                                                isMeasureOn = true;
                                              });
                                              await _measureHelper
                                                  .updateMeasureOn(true);
                                              //
                                              //SAVE TIME START
                                              await _measureHelper
                                                  .updateTimeStartM(
                                                      _dateValidator
                                                          .getHourAndMinute(
                                                              dateNow
                                                                  .toString()));
                                              //
                                              //SAVE DURATION TIME
                                              await _measureHelper
                                                  .updateDurationM(int.tryParse(
                                                      timeChosen
                                                          .split(' ')[0]));
                                              //
                                              // Navigator.of(context).pop();
                                              await _getMeasureCounting();

                                              ///
                                              ///

                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Material(
                                                    color: DefaultTheme
                                                        .TRANSPARENT,
                                                    child: Center(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                        child: BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 25,
                                                                  sigmaY: 25),
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    top: 10,
                                                                    right: 10),
                                                            width: 250,
                                                            height: 150,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: DefaultTheme
                                                                  .WHITE
                                                                  .withOpacity(
                                                                      0.7),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10,
                                                                          top:
                                                                              10),
                                                                  child: Text(
                                                                    'Bắt đầu đo nhịp tim',
                                                                    style:
                                                                        TextStyle(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .none,
                                                                      color: DefaultTheme
                                                                          .BLACK,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      'Hệ thống sẽ ghi nhận nhịp tim của bạn trong khoảng thời gian này',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        decoration:
                                                                            TextDecoration.none,
                                                                        color: DefaultTheme
                                                                            .GREY_TEXT,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            13,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Divider(
                                                                  height: 1,
                                                                  color: DefaultTheme
                                                                      .GREY_TOP_TAB_BAR,
                                                                ),
                                                                ButtonHDr(
                                                                  height: 40,
                                                                  style: BtnStyle
                                                                      .BUTTON_TRANSPARENT,
                                                                  label:
                                                                      'Đồng ý',
                                                                  labelColor:
                                                                      DefaultTheme
                                                                          .BLUE_TEXT,
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
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
                                            },
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 30)),
                                      ],
                                    ),
                                  ),
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
        });
  }

  _getMeasureInformation() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                Column(
                  children: [
                    Text(
                      'Thời gian bắt đầu đo',
                      style: TextStyle(fontSize: 15),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                width: 0.75),
                            borderRadius: BorderRadius.circular(8),
                            color: DefaultTheme.WHITE,
                          ),
                          child: Center(
                              child: Text(
                            '${timeStartM.split(':')[0]}:${timeStartM.split(':')[1]}',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(wordSpacing: 2.0, letterSpacing: 2),
                          )),
                        ),
                      ],
                    )
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Text(
                      'Đo trong khoảng',
                      style: TextStyle(fontSize: 15),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 25,
                          child: Text(
                            '$durationM',
                            style: TextStyle(
                                fontSize: 20, color: DefaultTheme.RED_CALENDAR),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(bottom: 2),
                          height: 25,
                          child: Text(
                            'phút',
                            style: TextStyle(fontSize: 16),
                            // textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          _heartRateChartToday(listTimeM, listValueM),
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: (isMeasureDone)
                ? Column(
                    children: [
                      Row(
                        children: [
                          //
                          InkWell(
                            onTap: () async {
                              VitalSignPushDTO vitalSignPush = VitalSignPushDTO(
                                patientId: _patientId,
                                vitalSignTypeId: 1,
                                timeStartValue: listTimeString,
                                numberStartValue: listValueM,
                              );
                              await _vitalSignServerRepository
                                  .pushVitalSign(vitalSignPush)
                                  .then((isSuccess) async {
                                if (isSuccess) {
                                  print('SUCCESSFUL PUSH DATA HEART RATE');
                                }
                              });
                              /////
                              ///
                              setState(() {
                                if (!mounted) return;
                                isMeasureOn = false;
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
                              //
                              ///
                              ///
                              Navigator.of(context).pop();
                              //
                            },
                            child: Container(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    25,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: DefaultTheme.BLACK_BUTTON,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text('Lưu',
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: DefaultTheme.WHITE)),
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                if (!mounted) return;
                                isMeasureOn = false;
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
                              //
                              Navigator.of(context).pop();
                            },
                            child: Container(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    25,
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                                        width: 0.5),
                                    color: DefaultTheme.WHITE,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text('Huỷ kết quả',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: DefaultTheme.RED_CALENDAR)),
                                )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    width: 0.5),
                                color: DefaultTheme.WHITE,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text('Đóng',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: DefaultTheme.BLACK)),
                            )),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            if (!mounted) return;
                            isMeasureOn = false;
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
                          //
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            width: (MediaQuery.of(context).size.width / 2) - 25,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    width: 0.5),
                                color: DefaultTheme.WHITE,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text('Huỷ đo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: DefaultTheme.RED_CALENDAR)),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            width: (MediaQuery.of(context).size.width / 2) - 25,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    width: 0.5),
                                color: DefaultTheme.WHITE,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text('Đóng',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: DefaultTheme.BLACK)),
                            )),
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
          )
        ],
      ),
    );
  }

  Widget _heartRateChartToday(List<String> listXAxis, String listYAxis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10),
        ),
        Divider(
          color: DefaultTheme.GREY_TOP_TAB_BAR,
          height: 0.5,
        ),
        (listXAxis != null && listYAxis != null)
            ? new Container(
                width: MediaQuery.of(context).size.width,
                color: DefaultTheme.WHITE,
                height: 400,
                child: Column(
                  children: [
                    Container(
                      child:
                          // ListView(
                          //   shrinkWrap: true,
                          //   scrollDirection: Axis.horizontal,
                          //   children: <Widget>[
                          //
                          new Echarts(
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
                                        data: ${listXAxis},
                                        show: true,
                                        nameTextStyle: {
                                          align: "center",
                                          color: "#F5233C",
                                          fontSize: 10
                                        }
                                    },
                                    yAxis: {
                                       max:150,
        min:0,
                                      name: 'BPM',
                                      nameTextStyle: {
                                      verticalAlign: "middle",
                                      color: "#F5233C"
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
                                         top: 20,
                                         
            right: 20,
            pieces: [{
                gt: 0,
                lte:   ${minL},
                color: '#F5233C'
            }, {
                gt:  ${minL},
                lte:  ${maxL},
                color: '#636AA7'
            }, {
                gt:  ${maxL},
                lte: 150,
                color: '#F5233C'
            }],
                                      },
                                      series: [{
                                        name: 'Nhịp tim',
                                        data: [${listYAxis}],
                                        type: 'line',
                                            markLine: {
                silent: true,
                lineStyle: {
                    color: '#303030',
                     type: 'solid',
                  
                },
   
                data: [
                 
                    {
                    yAxis: ${maxL},
                   
                }, {
                    yAxis: ${minL},
                }]
            }
                                      },]
                                    }
                                  ''',
                      ),
                      width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.only(right: 20),
                      height: 380,
                    ),
                    Text('Biểu đồ nhịp tim'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: DefaultTheme.BLUE_REFERENCE,
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
          padding: EdgeInsets.only(bottom: 15),
        ),

        // Container(
        //   width: MediaQuery.of(context).size.width - 40,
        //   height: 45,
        //   child: ButtonHDr(
        //     style: BtnStyle.BUTTON_BLACK,
        //     label: 'Hiển thị thêm dữ liệu đo',
        //     onTap: () {
        //       Navigator.pushNamed(context, RoutesHDr.VITALSIGN_HISTORY);
        //     },
        //   ),
        // ),
        // Padding(
        //   padding: EdgeInsets.only(bottom: 20),
        // ),
      ],
    );
  }

  Color _genderColor(String s) {
    Color color;
    if (s == 'FINISHED') {
      color = DefaultTheme.BLUE_DARK;
    } else if (s == 'ACTIVE') {
      color = DefaultTheme.SUCCESS_STATUS;
    } else if (s == 'CANCEL') {
      color = DefaultTheme.BLACK_BUTTON;
    }
    return color;
  }
}
