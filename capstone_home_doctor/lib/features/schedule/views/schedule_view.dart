import 'dart:convert';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/global/repositories/system_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/appnt_detail_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/appointment_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/prescription_list_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/events/appnt_event.dart';
import 'package:capstone_home_doctor/features/schedule/events/appointment_event.dart';
import 'package:capstone_home_doctor/features/schedule/events/prescription_list_event.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/appointment_repository.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/prescription_repository.dart';
import 'package:capstone_home_doctor/features/schedule/states/appnt_state.dart';
import 'package:capstone_home_doctor/features/schedule/states/appointment_state.dart';
import 'package:capstone_home_doctor/features/schedule/states/prescription_list_state.dart';
import 'package:capstone_home_doctor/models/appointment_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/services/appointment_helper.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:capstone_home_doctor/services/notifications_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
MedicalInstructionRepository _medicalInstructionRepository =
    MedicalInstructionRepository(httpClient: http.Client());

class ScheduleView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScheduleView();
  }
}

class _ScheduleView extends State<ScheduleView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int _listIndex = 0;
  //
  DateValidator _dateValidator = DateValidator();
  // MedicalInstructionDTO _currentPrescription = MedicalInstructionDTO();
  //
  List<MedicalInstructionDTO> listPrescription = [];
  PrescriptionRepository prescriptionRepository =
      PrescriptionRepository(httpClient: http.Client());
  PrescriptionListBloc _prescriptionListBloc;
  AppointDetailmentBloc _appointDetailmentBloc;
  //
  //
  int arguments = 0;
  int _currentIndex = 0;
  int count = 0;
  int dateChangeAppointment = 1;
  //
  int _accountId = 0;
  int _patientId = 0;
  DateTime curentDateNow = new DateFormat('dd/MM/yyyy')
      .parse(DateFormat('dd/MM/yyyy').format(DateTime.now()));
  var datechoice;
  var timechoice;
  final AppointmentHelper _appointmentHelper = AppointmentHelper();

  SystemRepository _systemRepository =
      SystemRepository(httpClient: http.Client());
  AppointmentRepository _appointmentRepository =
      AppointmentRepository(httpClient: http.Client());

  //use for calendar
  Map<DateTime, List> _events = {};
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  AppointmentBloc _appointmentBloc;

  Stream<ReceiveNotification> _notificationsStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _prescriptionListBloc = BlocProvider.of(context);
    _appointmentBloc = BlocProvider.of(context);
    _appointDetailmentBloc = BlocProvider.of(context);
    _calendarController = CalendarController();
    getDataFromJSONFile();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _getPatientId();
    // _getTimeSystem();
    _notificationsStream = NotificationsBloc.instance.notificationsStream;
    _notificationsStream.listen((notification) {
      _getPatientId();
      // var navigate = jsonDecode(notification.payload);
      // var notificationType = navigate['notiTypeId'];
      // if (int.parse(notificationType) == 8 ||
      //     int.parse(notificationType) == 13 ||
      //     int.parse(notificationType) == 23) {
      //   _getPatientId();
      // }
    });

    _animationController.forward();
  }

  // _getTimeSystem() async {
  //   await _systemRepository.getTimeSystem().then((value) async {
  //     /////
  //     // await _timeSystemHelper.setTimeSystem(value);
  //     if (!mounted) return;
  //     setState(() {
  //       curentDateNow = new DateFormat('yyyy-MM-dd').parse(
  //           DateFormat('yyyy-MM-dd')
  //               .format(DateTime.parse(value.split('"')[1].split('"')[0])));
  //     });
  //   });
  // }

  Future<void> getDataFromJSONFile() async {
    final String response = await rootBundle.loadString('assets/global.json');

    if (response.contains('suggestions')) {
      final data = await json.decode(response);
      dateChangeAppointment = data['dateChangeAppointment'];
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    _calendarController.dispose();
    NotificationsSelectBloc.instance.newNotification('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      setState(() {
        arguments = ModalRoute.of(context).settings.arguments;
        if (arguments != null) {
          _currentIndex = arguments;
        } else {}
      });
      count++;
    } else {
      arguments = null;
    }
    // _listPrescription.sort((a, b) => b.startDate.compareTo(a.startDate));
    // _currentPrescription = _listPrescription[0];
    return DefaultTabController(
      length: 2,
      initialIndex: _currentIndex,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              HeaderWidget(
                title: 'Lịch',
                isMainView: false,
                buttonHeaderType: ButtonHeaderType.BACK_HOME,
              ),
              _buildTab(),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              Expanded(
                child: (_listIndex == 0)
                    ? _getMedicineSchedule()
                    : Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          // _buildTableCalendar(),
                          _buildCalendar(),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                          ),
                          Container(
                            height: 5,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/bg-calendar.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                          ),
                          Expanded(child: _buildEventList(context)),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTab() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Padding(
          //   padding: EdgeInsets.only(left: 20),
          // ),
          InkWell(
            onTap: () {
              setState(() {
                _listIndex = 0;
              });
            },
            child: Container(
              padding: EdgeInsets.only(left: 0, right: 5, top: 8, bottom: 8),
              height: 40,
              decoration: (_listIndex == 0)
                  ? BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 2.0,
                            color:
                                DefaultTheme.BLUE_REFERENCE.withOpacity(0.8)),
                      ),
                      // color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.8),
                      // borderRadius: BorderRadius.circular(30),
                    )
                  : BoxDecoration(),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/images/ic-medicine.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Text('Lịch dùng thuốc',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: (_listIndex == 0)
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: DefaultTheme.BLACK,
                            fontSize: (_listIndex == 0) ? 16 : 14)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _listIndex = 1;
              });
            },
            child: Container(
              padding: EdgeInsets.only(left: 0, right: 5, top: 8, bottom: 8),
              height: 40,
              decoration: (_listIndex == 1)
                  ? BoxDecoration(
                      border: Border(
                      bottom: BorderSide(
                          width: 2.0,
                          color: DefaultTheme.BLUE_REFERENCE.withOpacity(0.8)),
                    ))
                  : BoxDecoration(),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/images/ic-appointment.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Text('Lịch khám',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: (_listIndex == 1)
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: DefaultTheme.BLACK,
                            fontSize: (_listIndex == 1) ? 16 : 14)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // // Simple TableCalendar configuration (using Styles)
  // Widget _buildTableCalendar() {
  //   return BlocBuilder<AppointmentBloc, AppointmentState>(
  //     builder: (context, state) {
  //       if (state is AppointmentStateLoading) {
  //         return Container(
  //           width: 200,
  //           height: 200,
  //           child: SizedBox(
  //             width: 100,
  //             height: 100,
  //             child: Image.asset('assets/images/loading.gif'),
  //           ),
  //         );
  //       }
  //       if (state is AppointmentStateFailure) {
  //         return Container(
  //             width: MediaQuery.of(context).size.width,
  //             child: Center(
  //                 child: Text('Kiểm tra lại đường truyền kết nối mạng')));
  //       }
  //       if (state is AppointmentStateSuccess) {
  //         // if (state.isCancel != null) {
  //         //   if (state.isCancel) {
  //         //     Navigator.pop(context);
  //         //   }
  //         // }
  //         if (state.listAppointment.isNotEmpty &&
  //             state.listAppointment != null) {
  //           _events = {};
  //           _getEvent(state.listAppointment);
  //           return Container();
  //           // return _buildCalendar();
  //         }
  //       }
  //       return Container(
  //         width: MediaQuery.of(context).size.width,
  //         child: Center(
  //           child: Text('Không thể lấy dữ liệu'),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildCalendar() {
    return TableCalendar(
      // locale: 'en-US',
      locale: 'vi-VN',
      calendarController: _calendarController,
      initialCalendarFormat: CalendarFormat.month,
      // availableGestures: AvailableGestures.none,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: DefaultTheme.GREY_TEXT.withOpacity(0.6)),
      ),
      calendarStyle: CalendarStyle(
        ///
        markersMaxAmount: 1,
        ////
        weekendStyle: TextStyle(color: DefaultTheme.GREY_TEXT.withOpacity(0.6)),
        selectedColor: DefaultTheme.BLUE_TEXT,
        todayColor: DefaultTheme.BLUE_TEXT.withOpacity(0.6),
        markersColor: DefaultTheme.GREY_TOP_TAB_BAR,
        eventDayStyle: TextStyle(color: DefaultTheme.BLUE_TEXT),
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-calendar.png'),
            fit: BoxFit.cover,
          ),
        ),
        headerPadding: EdgeInsets.only(top: 10, bottom: 10),
        headerMargin: EdgeInsets.only(bottom: 10, top: 20),
        titleTextStyle: TextStyle(
          color: DefaultTheme.WHITE,
          fontSize: 18,
        ),
      ),
      formatAnimation: FormatAnimation.slide,
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      //builders: Calendar
    );
  }

  void _getEvent(List<AppointmentDTO> listAppointment) {
    // final _selectedDay = DateTime.now();
    final _selectedDay = curentDateNow;

    for (var item in listAppointment) {
      DateTime dateAppointment =
          new DateFormat("dd/MM/yyyy").parse(item.dateExamination);

      if (dateAppointment.millisecondsSinceEpoch ==
          curentDateNow.millisecondsSinceEpoch) {
        _events = {
          ..._events,
          _selectedDay: item.appointments,
        };
      } else {
        if (dateAppointment.millisecondsSinceEpoch >
            curentDateNow.millisecondsSinceEpoch) {
          _events = {
            ..._events,
            _selectedDay.subtract(Duration(
                milliseconds: curentDateNow.millisecondsSinceEpoch -
                    dateAppointment.millisecondsSinceEpoch)): item.appointments,
          };
        } else {
          _events = {
            ..._events,
            _selectedDay.add(Duration(
                milliseconds: dateAppointment.millisecondsSinceEpoch -
                    curentDateNow.millisecondsSinceEpoch)): item.appointments,
          };
        }
      }
    }
    setState(() {
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    // _selectedEvents = _events[_selectedDay] ?? [];
  }

  Widget _buildEventList(BuildContext context) {
    return _selectedEvents != null
        ? ListView(
            children: _selectedEvents.map((event) {
              print('appointment ID now: ${event.appointmentId}');
              DateTime timeEx = new DateFormat("yyyy-MM-ddThh:mm")
                  .parse(event.dateExamination);
              var dateAppointment =
                  new DateFormat('dd/MM/yyyy, hh:mm a').format(timeEx);
              return InkWell(
                onTap: () {
                  print('tapped');
                  _appointDetailmentBloc.add(AppointmentGetDetailEvent(
                      appointmentId: event.appointmentId));
                  _showDetailAppointment();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          width: 5.0, color: _genderColor(event.status)),
                    ),
                    color: DefaultTheme.GREY_VIEW,
                    //border: Border.all(width: 0.8),
                    // borderRadius: BorderRadius.circular(6),
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          'Bác sĩ ${event.fullNameDoctor} lên lịch khám cho bạn'),
                      Text('Thời gian: ${dateAppointment}'),

                      // (event.status.contains('CANCEL'))
                      //     ? Text('Lý do hủy lịch: ${event.reasonCanceled}')
                      //     : Container(),
                      // (event.status.contains('CANCEL'))
                      //     ? Container()
                      //     : _buttonChangeDate(event, context),
                      //
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        : Container();
  }

  _showDetailAppointment() {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Stack(
                children: <Widget>[
                  //
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05),
                    color: DefaultTheme.TRANSPARENT,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        color: DefaultTheme.GREY_VIEW,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: MediaQuery.of(context).size.width,
                              child: BlocBuilder<AppointDetailmentBloc,
                                      AppointmentDetailState>(
                                  builder: (context, state) {
                                if (state is AppointmentDetailStateLoading) {
                                  return Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 200,
                                        child: Image.asset(
                                            'assets/images/loading.gif'),
                                      ),
                                    ),
                                  );
                                }
                                if (state is AppointmentDetailStateFailure) {}
                                if (state is AppointmentDetailStateSuccess) {
                                  if (state.dto != null) {
                                    return ListView(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: Image.asset(
                                                  'assets/images/ic-appointment.png'),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                            ),
                                            Container(
                                              // padding:
                                              //     EdgeInsets.only(bottom: 3),
                                              alignment: Alignment.bottomCenter,
                                              height: 30,
                                              child: Text(
                                                'Chi tiết cuộc hẹn',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              margin: EdgeInsets.only(top: 3),
                                              padding: EdgeInsets.only(
                                                  bottom: 10,
                                                  top: 10,
                                                  left: 20,
                                                  right: 20),
                                              decoration: BoxDecoration(
                                                color: _genderColor(
                                                    state.dto.status),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${_genderStatus(state.dto.status)}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color:
                                                          DefaultTheme.WHITE),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                        ),
                                        Divider(
                                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                                          height: 1,
                                        ),
                                        Container(
                                          height: 40,
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              //
                                              Container(
                                                width: 120,
                                                alignment: Alignment.centerLeft,
                                                height: 40,
                                                child: Text('Bác sĩ',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    160,
                                                alignment: Alignment.centerLeft,
                                                height: 40,
                                                child: Text(
                                                    '${state.dto.fullNameDoctor}',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                                          height: 1,
                                        ),
                                        Container(
                                          height: 40,
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              //
                                              Container(
                                                width: 120,
                                                alignment: Alignment.centerLeft,
                                                height: 40,
                                                child: Text('Bệnh nhân',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    160,
                                                alignment: Alignment.centerLeft,
                                                height: 40,
                                                child: Text(
                                                    '${state.dto.fullNamePatient}',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                                          height: 1,
                                        ),
                                        Container(
                                          height: 40,
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              //
                                              Container(
                                                width: 120,
                                                alignment: Alignment.centerLeft,
                                                height: 40,
                                                child: Text('Thời gian',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    160,
                                                alignment: Alignment.centerLeft,
                                                height: 40,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 35,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            DefaultTheme.WHITE,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: DefaultTheme
                                                                .GREY_TOP_TAB_BAR,
                                                            width: 0.5),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                            '${state.dto.dateExamination.split('T')[1].split(':')[0]}'),
                                                      ),
                                                    ),
                                                    Text(' : '),
                                                    Container(
                                                      width: 35,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            DefaultTheme.WHITE,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: DefaultTheme
                                                                .GREY_TOP_TAB_BAR,
                                                            width: 0.5),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                            '${state.dto.dateExamination.split('T')[1].split(':')[1]}'),
                                                      ),
                                                    ),
                                                    Container(
                                                      // width: MediaQuery.of(context)
                                                      //         .size
                                                      //         .width -
                                                      //     160,
                                                      padding: EdgeInsets.only(
                                                          left: 5),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 40,
                                                      child: Text(
                                                          ' ngày ${_dateValidator.parseToDateView(state.dto.dateExamination)}',
                                                          style: TextStyle(
                                                              fontSize: 16)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                                          height: 1,
                                        ),
                                        Container(
                                          height: 200,
                                          padding: EdgeInsets.only(top: 10),
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //
                                              Container(
                                                width: 120,
                                                alignment: Alignment.topLeft,
                                                height: 200,
                                                child: Text('Chẩn đoán',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    160,
                                                alignment: Alignment.topLeft,
                                                height: 200,
                                                child: Text('${state.dto.note}',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                                          height: 1,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                        ),
                                        (state.dto.medicalInstructions
                                                    .isEmpty ||
                                                state.dto.medicalInstructions ==
                                                    null)
                                            ? Container()
                                            : Container(
                                                height: 40,
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    //
                                                    Container(
                                                      width: 120,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 40,
                                                      child: Text('Đính kèm ',
                                                          style: TextStyle(
                                                              fontSize: 16)),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              160,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 40,
                                                      child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          // shrinkWrap: true,
                                                          // physics:
                                                          //     NeverScrollableScrollPhysics(),
                                                          itemCount: state
                                                              .dto
                                                              .medicalInstructions
                                                              .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      contex,
                                                                  int index) {
                                                            return Container(
                                                              height: 50,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  _showDetailVitalSign(state
                                                                      .dto
                                                                      .medicalInstructions[
                                                                          index]
                                                                      .medicalInstructionId);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                  height: 50,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: DefaultTheme
                                                                        .WHITE,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                  ),
                                                                  child: Center(
                                                                    child: Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20,
                                                                          child:
                                                                              Image.asset('assets/images/ic-medicine.png'),
                                                                        ),
                                                                        Text(
                                                                            '${state.dto.medicalInstructions[index].medicalInstructionType}'),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 30),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: DefaultTheme
                                                        .GREY_TOP_TAB_BAR,
                                                    width: 0.5),
                                                color: DefaultTheme.WHITE,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Đóng',
                                                  textAlign: TextAlign.center,
                                                ),
                                              )),
                                        ),
                                      ],
                                    );
                                  } else {}
                                }
                                return Container();
                              }),
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
          });
        });
  }

  String _genderStatus(String s) {
    String status = '';
    if (s == 'FINISHED') {
      status = 'Đã kết thúc';
    } else if (s == 'ACTIVE') {
      status = 'Đang hiện hành';
    } else if (s == 'CANCEL') {
      status = 'Đã huỷ';
    }
    return status;
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

  void _showDetailVitalSign(int medicalInstructionId) {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 250,
                    height: 150,
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
                            'Đang tải',
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
            );
          });
    });

    _medicalInstructionRepository
        .getMedicalInstructionById(medicalInstructionId)
        .then((value) {
      Navigator.pop(context);
      if (value != null) {
        if (value.medicationsRespone != null) {
          Navigator.pushNamed(context, RoutesHDr.MEDICAL_HISTORY_DETAIL,
              arguments: value.medicalInstructionId);
        } else {
          var dateStarted = _dateValidator.convertDateCreate(
              value.vitalSignScheduleRespone.timeStared,
              'dd/MM/yyyy',
              "yyyy-MM-dd");
          var dateFinished = _dateValidator.convertDateCreate(
              value.vitalSignScheduleRespone.timeCanceled,
              'dd/MM/yyyy',
              "yyyy-MM-dd");

          setState(() {
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
                        height: MediaQuery.of(context).size.height * 0.4,
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
                                Text(
                                  '${value.medicalInstructionType}',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Divider(
                                    color: DefaultTheme.GREY_TEXT,
                                    height: 0.25,
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 5)),
                                  Text(
                                    'Người đặt: ${value.placeHealthRecord}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.none,
                                      color: DefaultTheme.GREY_TEXT,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 10)),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: value.vitalSignScheduleRespone
                                          .vitalSigns.length,
                                      itemBuilder: (context, index) {
                                        var item = value
                                            .vitalSignScheduleRespone
                                            .vitalSigns[index];
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Divider(
                                              color: DefaultTheme.GREY_TEXT,
                                              height: 0.25,
                                            ),
                                            Text(
                                              '${value.vitalSignScheduleRespone.vitalSigns[0].vitalSignType}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                decoration: TextDecoration.none,
                                                color: DefaultTheme.GREY_TEXT,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Chỉ số an toàn:',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    decoration:
                                                        TextDecoration.none,
                                                    color:
                                                        DefaultTheme.GREY_TEXT,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  '${value.vitalSignScheduleRespone.vitalSigns[0].numberMin} - ${value.vitalSignScheduleRespone.vitalSigns[0].numberMax}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    decoration:
                                                        TextDecoration.none,
                                                    color:
                                                        DefaultTheme.GREY_TEXT,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'Ngày bắt đầu: ${dateStarted}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                decoration: TextDecoration.none,
                                                color: DefaultTheme.GREY_TEXT,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              'Ngày bắt đầu: ${dateFinished}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                decoration: TextDecoration.none,
                                                color: DefaultTheme.GREY_TEXT,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                    ),
                                  ),
                                  ButtonHDr(
                                    style: BtnStyle.BUTTON_BLACK,
                                    label: 'Chi tiết',
                                    onTap: () {
                                      Map<String, dynamic> arguments = {
                                        'healthRecordId': 0,
                                        'medicalInstructionId':
                                            medicalInstructionId,
                                        "timeStared": value
                                            .vitalSignScheduleRespone
                                            .timeStared,
                                        "timeCanceled": value
                                            .vitalSignScheduleRespone
                                            .timeCanceled,
                                      };
                                      Navigator.pushNamed(context,
                                          RoutesHDr.VITAL_SIGN_CHART_DETAIL,
                                          arguments: arguments);
                                    },
                                  ),
                                ],
                              ),
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
          });
        }
      }
    });
  }

  // Widget _buttonChangeDate(
  //     AppointmentDetailDTO dto, BuildContext contextButton) {
  //   DateTime timeEx = new DateFormat("yyyy-MM-dd").parse(dto.dateExamination);
  //   DateTime dateAppointment = new DateFormat('dd/MM/yyyy')
  //       .parse(DateFormat('dd/MM/yyyy').format(timeEx));

  //   if ((dateAppointment.millisecondsSinceEpoch -
  //               curentDateNow.millisecondsSinceEpoch) ==
  //           (86400000 * dateChangeAppointment) &&
  //       dto.status.contains('ACTIVE')) {
  //     return Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Container(
  //           margin: EdgeInsets.only(top: 20),
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(12),
  //               color: DefaultTheme.GREY_VIEW),
  //           child: FlatButton(
  //             color: DefaultTheme.TRANSPARENT,
  //             onPressed: () {
  //               _popupChangeDate(dto.appointmentId, dto.contractId);
  //             },
  //             padding: null,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: <Widget>[
  //                 SizedBox(
  //                   width: 20,
  //                   height: 20,
  //                   child: Image.asset('assets/images/ic-contract.png'),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.only(left: 20),
  //                 ),
  //                 Text(
  //                   'Đổi ngày',
  //                   textAlign: TextAlign.left,
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: DefaultTheme.BLACK,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
  //   } else {
  //     return Container();
  //   }
  // }

  // Widget _popupChangeDate(int appointmentId, int contractID) {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     backgroundColor: DefaultTheme.TRANSPARENT,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context2, StateSetter setModalState) {
  //           return BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
  //             child: Stack(
  //               children: <Widget>[
  //                 Container(
  //                   height: 600,
  //                   color: DefaultTheme.TRANSPARENT,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       Container(
  //                         height: 20,
  //                         color: DefaultTheme.TRANSPARENT,
  //                       ),
  //                       Container(
  //                         height: 580,
  //                         padding: EdgeInsets.only(left: 20, right: 20),
  //                         decoration: BoxDecoration(
  //                           color: DefaultTheme.WHITE,
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: <Widget>[
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 Padding(
  //                                   padding: EdgeInsets.only(top: 40, left: 0),
  //                                   child: Text(
  //                                     'Đổi lịch tái khám',
  //                                     style: TextStyle(
  //                                       color: DefaultTheme.BLACK,
  //                                       fontSize: 18,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Padding(
  //                               padding: EdgeInsets.only(top: 10, bottom: 10),
  //                               child: Column(
  //                                 children: [
  //                                   Row(
  //                                     children: [
  //                                       Text(
  //                                         'Ngày tái khám:',
  //                                         style: TextStyle(
  //                                           color: DefaultTheme.BLACK,
  //                                           fontSize: 18,
  //                                         ),
  //                                       ),
  //                                       FlatButton(
  //                                         child: Text(
  //                                           datechoice == null
  //                                               ? 'Chọn ngày tái khám'
  //                                               : DateFormat('dd/MM/yyyy')
  //                                                   .format(DateTime.parse(
  //                                                       datechoice)),
  //                                           style: TextStyle(
  //                                             color: DefaultTheme.BLACK,
  //                                             fontSize: 18,
  //                                           ),
  //                                         ),
  //                                         onPressed: () async {
  //                                           DateTime newDateTime =
  //                                               await showRoundedDatePicker(
  //                                                   context: context,
  //                                                   initialDate: curentDateNow,
  //                                                   firstDate: DateTime(
  //                                                       curentDateNow.year - 1),
  //                                                   lastDate: DateTime(
  //                                                       curentDateNow.year + 1),
  //                                                   borderRadius: 16,
  //                                                   theme: ThemeData.dark());
  //                                           if (newDateTime != null) {
  //                                             setModalState(() {
  //                                               datechoice =
  //                                                   newDateTime.toString();
  //                                             });
  //                                           }
  //                                         },
  //                                       ),
  //                                     ],
  //                                   ),
  //                                   Row(
  //                                     children: [
  //                                       Text(
  //                                         'Giờ tái khám:',
  //                                         style: TextStyle(
  //                                           color: DefaultTheme.BLACK,
  //                                           fontSize: 18,
  //                                         ),
  //                                       ),
  //                                       FlatButton(
  //                                         child: Text(
  //                                           timechoice == null
  //                                               ? 'Chọn giờ tái khám'
  //                                               : timechoice,
  //                                           style: TextStyle(
  //                                             color: DefaultTheme.BLACK,
  //                                             fontSize: 18,
  //                                           ),
  //                                         ),
  //                                         onPressed: () async {
  //                                           final timePicked =
  //                                               await showRoundedTimePicker(
  //                                             context: context,
  //                                             initialTime: TimeOfDay.now(),
  //                                             theme: ThemeData.dark(),
  //                                           );
  //                                           if (timePicked != null) {
  //                                             setModalState(() {
  //                                               var hour = timePicked.hour < 10
  //                                                   ? '0${timePicked.hour}'
  //                                                   : '${timePicked.hour}';
  //                                               var minutes = timePicked
  //                                                           .minute <
  //                                                       10
  //                                                   ? '0${timePicked.minute}'
  //                                                   : '${timePicked.minute}';
  //                                               timechoice = '$hour:$minutes';
  //                                             });
  //                                           }
  //                                         },
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             ButtonHDr(
  //                               width: MediaQuery.of(context).size.width - 40,
  //                               style: BtnStyle.BUTTON_BLACK,
  //                               label: 'Gửi',
  //                               onTap: () async {
  //                                 setState(() {
  //                                   showDialog(
  //                                     barrierDismissible: false,
  //                                     context: context,
  //                                     builder: (BuildContext context) {
  //                                       return Center(
  //                                         child: ClipRRect(
  //                                           borderRadius: BorderRadius.all(
  //                                               Radius.circular(5)),
  //                                           child: BackdropFilter(
  //                                             filter: ImageFilter.blur(
  //                                                 sigmaX: 25, sigmaY: 25),
  //                                             child: Container(
  //                                               width: 300,
  //                                               height: 300,
  //                                               decoration: BoxDecoration(
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           10),
  //                                                   color: DefaultTheme.WHITE
  //                                                       .withOpacity(0.8)),
  //                                               child: Column(
  //                                                 mainAxisAlignment:
  //                                                     MainAxisAlignment.center,
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment.center,
  //                                                 children: [
  //                                                   SizedBox(
  //                                                     width: 200,
  //                                                     height: 200,
  //                                                     child: Image.asset(
  //                                                         'assets/images/loading.gif'),
  //                                                   ),
  //                                                   Text(
  //                                                     'Đang gửi yêu cầu...',
  //                                                     style: TextStyle(
  //                                                         color: DefaultTheme
  //                                                             .GREY_TEXT,
  //                                                         fontSize: 15,
  //                                                         fontWeight:
  //                                                             FontWeight.w400,
  //                                                         decoration:
  //                                                             TextDecoration
  //                                                                 .none),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       );
  //                                     },
  //                                   );
  //                                 });
  //                                 if (datechoice == null ||
  //                                     timechoice == null) {
  //                                   Future.delayed(Duration(seconds: 2), () {
  //                                     Navigator.of(context).pop();
  //                                     _showDialogFailed(
  //                                         'Vui lòng chọn đủ ngày và giờ khám');
  //                                   });
  //                                 } else {
  //                                   String dateAppointment =
  //                                       DateFormat('yyyy-MM-dd').format(
  //                                               DateTime.parse(datechoice)) +
  //                                           'T${timechoice}:00';
  //                                   _appointmentBloc.add(
  //                                       AppointmentChangeDateEvent(
  //                                           appointmentID: appointmentId,
  //                                           contractID: contractID,
  //                                           dateAppointment: dateAppointment));
  //                                   Future.delayed(
  //                                     const Duration(seconds: 3),
  //                                     () {
  //                                       _appointmentHelper
  //                                           .getAppointmentChangeDate()
  //                                           .then(
  //                                         (value) {
  //                                           Navigator.of(context).pop();
  //                                           if (value) {
  //                                             // _showDialogSuccess();
  //                                           } else {
  //                                             _showDialogFailed(
  //                                                 'Không thể gửi yêu cầu');
  //                                           }
  //                                         },
  //                                       );
  //                                     },
  //                                   );
  //                                 }
  //                               },
  //                             ),
  //                             Padding(
  //                               padding: EdgeInsets.only(bottom: 25),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Positioned(
  //                   top: 0,
  //                   left: MediaQuery.of(context).size.width * 0.3,
  //                   height: 5,
  //                   child: Container(
  //                     padding: EdgeInsets.only(
  //                         left: MediaQuery.of(context).size.width * 0.3),
  //                     width: MediaQuery.of(context).size.width * 0.4,
  //                     height: 15,
  //                     decoration: BoxDecoration(
  //                         color: DefaultTheme.WHITE.withOpacity(0.8),
  //                         borderRadius: BorderRadius.circular(50)),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // _showDialogSuccess() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.all(Radius.circular(5)),
  //           child: BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
  //             child: Container(
  //               width: 200,
  //               height: 200,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: DefaultTheme.WHITE.withOpacity(0.8)),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   SizedBox(
  //                     width: 100,
  //                     height: 100,
  //                     child: Image.asset('assets/images/ic-checked.png'),
  //                   ),
  //                   Text(
  //                     'Gửi yêu cầu thành công',
  //                     style: TextStyle(
  //                         color: DefaultTheme.GREY_TEXT,
  //                         fontSize: 15,
  //                         fontWeight: FontWeight.w400,
  //                         decoration: TextDecoration.none),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //   Future.delayed(const Duration(seconds: 2), () {
  //     Navigator.of(context).pop();
  //     Navigator.of(context).pop();
  //     _getPatientId();
  //   });
  // }

  // _showDialogFailed(String title) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.all(Radius.circular(5)),
  //           child: BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
  //             child: Container(
  //               width: 200,
  //               height: 200,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: DefaultTheme.WHITE.withOpacity(0.8)),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   SizedBox(
  //                     width: 100,
  //                     height: 100,
  //                     child: Image.asset('assets/images/ic-failed.png'),
  //                   ),
  //                   Align(
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       '$title',
  //                       style: TextStyle(
  //                           color: DefaultTheme.GREY_TEXT,
  //                           fontSize: 15,
  //                           fontWeight: FontWeight.w400,
  //                           decoration: TextDecoration.none),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //   Future.delayed(const Duration(seconds: 2), () {
  //     Navigator.of(context).pop();
  //   });
  // }

  _getMedicineSchedule() {
    return ListView(
      children: <Widget>[
        // Padding(
        //   padding: EdgeInsets.only(bottom: 20),
        // ),
        // Stack(
        //   children: [
        //     Container(
        //       width: MediaQuery.of(context).size.width,
        //       //   height: 300,
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: AssetImage('assets/images/bg-medicine.png'),
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //     ),
        //     Positioned(
        //         top: 0,
        //         child:
        //             ],
        // ),
        Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(RoutesHDr.HISTORY_PRESCRIPTION);
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                decoration: BoxDecoration(
                  // color: DefaultTheme.GREY_VIEW,
                  border:
                      Border.all(color: DefaultTheme.BLACK_BUTTON, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 50,
                child: Center(
                  child: Text(
                    'Danh sách đơn thuốc',
                    style: TextStyle(
                        fontSize: 16,
                        color: DefaultTheme.BLACK_BUTTON,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: BlocBuilder<PrescriptionListBloc, PrescriptionListState>(
                  builder: (context, state) {
                if (state is PrescriptionListStateLoading) {
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
                if (state is PrescriptionListStateFailure) {
                  return Container(
                    height: 200,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: BoxDecoration(
                      color: DefaultTheme.WHITE.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset('assets/images/ic-medicine.png'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                          ),
                          Text('Không có lịch dùng thuốc trong hôm nay'),
                        ],
                      ),
                    ),
                  );
                }
                if (state is PrescriptionListStateSuccess) {
                  List<MedicalInstructionDTO> listPrescriptions = [];

                  if (state.listPrescription != null) {
                    listPrescription = state.listPrescription;
                    listPrescription.sort((a, b) => b.medicalInstructionId
                        .compareTo(a.medicalInstructionId));
                    listPrescription.sort((a, b) => b
                        .medicationsRespone.dateFinished
                        .compareTo(a.medicationsRespone.dateFinished));
                  }
                  if (listPrescription.isNotEmpty) {
                    for (var element in listPrescription) {
                      DateTime dateFinished = new DateFormat('dd/MM/yyyy')
                          .parse(_dateValidator.convertDateCreate(
                              element.medicationsRespone.dateFinished,
                              'dd/MM/yyyy',
                              'yyyy-MM-dd'));
                      DateTime dateStarted = new DateFormat('dd/MM/yyyy').parse(
                          _dateValidator.convertDateCreate(
                              element.medicationsRespone.dateStarted,
                              'dd/MM/yyyy',
                              'yyyy-MM-dd'));
                      if (element.medicationsRespone.status
                              .contains('ACTIVE') &&
                          dateFinished.millisecondsSinceEpoch >=
                              curentDateNow.millisecondsSinceEpoch &&
                          dateStarted.millisecondsSinceEpoch <=
                              curentDateNow.millisecondsSinceEpoch) {
                        listPrescriptions.add(element);
                      }
                    }
                    // if (listPrescriptions.length > 0)
                    //   _currentPrescription = listPrescriptions[0];
                  }
                  return RefreshIndicator(
                    onRefresh: _getPatientId,
                    child: (state.listPrescription == null ||
                            state.listPrescription.isEmpty)
                        ? Container(
                            height: 200,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            decoration: BoxDecoration(
                              color: DefaultTheme.WHITE.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                        'assets/images/ic-medicine.png'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                  ),
                                  Text(
                                      'Không có lịch dùng thuốc trong hôm nay'),
                                ],
                              ),
                            ),
                          )
                        : (listPrescriptions.length <= 0)
                            ? Container(
                                height: 200,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                decoration: BoxDecoration(
                                  color: DefaultTheme.WHITE.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                            'assets/images/ic-medicine.png'),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                      ),
                                      Text(
                                          'Không có lịch dùng thuốc trong hôm nay'),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 30,
                                        left: 20,
                                        right: 0,
                                        bottom: 20),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Đơn thuốc hiện hành',
                                        style: TextStyle(
                                          color: DefaultTheme.BLACK,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                  //
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: listPrescriptions.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: _buildPrescription(
                                              listPrescriptions[index]),
                                        );
                                      }),

                                  // _itemSchedule(_currentPrescription),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                  ),
                                ],
                              ),
                  );
                }
                return Container(
                  height: 200,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  decoration: BoxDecoration(
                    color: DefaultTheme.WHITE.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset('assets/images/ic-medicine.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Text('Không có lịch dùng thuốc trong hôm nay'),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrescription(MedicalInstructionDTO medicalInstructionDTO) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
        color: DefaultTheme.GREY_VIEW,
        // borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: 60,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.only(
          //       topRight: Radius.circular(20),
          //       topLeft: Radius.circular(10),
          //     ),
          //     color: DefaultTheme.WHITE,
          //     border: Border(
          //       top: BorderSide(width: 2.0, color: DefaultTheme.RED_CALENDAR),
          //     ),
          //   ),
          //   child: Row(),
          // ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                width: 140,
                child: Text(
                  'Bác sĩ:',
                  style: TextStyle(
                    color: DefaultTheme.GREY_TEXT,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Container(
                width: MediaQuery.of(context).size.width - (40 + 120 + 20 + 30),
                child: Text(
                  '${medicalInstructionDTO.placeHealthRecord}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Divider(
              color: DefaultTheme.GREY_TEXT,
              height: 0.1,
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                width: 140,
                child: Text(
                  'Kê đơn ngày:',
                  style: TextStyle(
                    color: DefaultTheme.GREY_TEXT,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Container(
                width: MediaQuery.of(context).size.width - (40 + 120 + 20 + 30),
                child: Text(
                  '${_dateValidator.parseToDateView(medicalInstructionDTO.medicationsRespone.dateStarted)}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                width: 140,
                child: Text(
                  'Đến ngày:',
                  style: TextStyle(
                    color: DefaultTheme.GREY_TEXT,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Container(
                width: MediaQuery.of(context).size.width - (40 + 120 + 20 + 30),
                child: Text(
                  '${_dateValidator.parseToDateView(medicalInstructionDTO.medicationsRespone.dateFinished)}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
          ),
          //diagnose
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Divider(
              color: DefaultTheme.GREY_TEXT,
              height: 0.1,
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                width: 140,
                child: Text(
                  'Triệu chứng:',
                  style: TextStyle(
                    color: DefaultTheme.GREY_TEXT,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Container(
                width: MediaQuery.of(context).size.width - (40 + 120 + 20 + 30),
                child: Text(
                  '${medicalInstructionDTO.diagnose}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
          ),
          //dsach thuốc
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Danh sách thuốc',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    fontFamily: 'NewYork'),
              ),
            ),
          ),
          (medicalInstructionDTO
                      .medicationsRespone.medicationSchedules.length !=
                  0)
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: medicalInstructionDTO
                      .medicationsRespone.medicationSchedules.length,
                  itemBuilder: (BuildContext buildContext, int index) {
                    return Container(
                      color: DefaultTheme.GREY_VIEW,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //start list
                          if (index == 0)
                            (Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Divider(
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                height: 1,
                              ),
                            )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 5),
                                height: 16,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Text(
                                  '${medicalInstructionDTO.medicationsRespone.medicationSchedules[index].medicationName} (${medicalInstructionDTO.medicationsRespone.medicationSchedules[index].content})',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 16,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                      'Đơn vị: ${medicalInstructionDTO.medicationsRespone.medicationSchedules[index].unit}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                          color: DefaultTheme.GREY_TEXT)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                              ),
                              Container(
                                width: 90,
                                child: Text(
                                  'Cách dùng',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: DefaultTheme.GREY_TEXT),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: MediaQuery.of(context).size.width -
                                    90 -
                                    40 -
                                    60,
                                child: Text(
                                  '${medicalInstructionDTO.medicationsRespone.medicationSchedules[index].useTime}',
                                  textAlign: TextAlign.right,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: DefaultTheme.BLACK_BUTTON,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 30),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                          ),
                          (medicalInstructionDTO.medicationsRespone
                                      .medicationSchedules[index].morning ==
                                  0)
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 30),
                                      ),
                                      Container(
                                        width: 90,
                                        child: Text(
                                          'Buổi sáng',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: DefaultTheme.GREY_TEXT),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                90 -
                                                40 -
                                                60,
                                        child: Text(
                                          '${medicalInstructionDTO.medicationsRespone.medicationSchedules[index].morning} ${medicalInstructionDTO.medicationsRespone.medicationSchedules[index].unit}',
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: DefaultTheme.BLACK_BUTTON,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 30),
                                      )
                                    ],
                                  ),
                                ),
                          (medicalInstructionDTO.medicationsRespone
                                      .medicationSchedules[index].noon ==
                                  0)
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 30),
                                      ),
                                      Container(
                                        width: 90,
                                        child: Text(
                                          'Buổi trưa',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: DefaultTheme.GREY_TEXT),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                90 -
                                                40 -
                                                60,
                                        child: Text(
                                          '${medicalInstructionDTO.medicationsRespone.medicationSchedules[index].noon} ${medicalInstructionDTO.medicationsRespone.medicationSchedules[index].unit}',
                                          maxLines: 5,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: DefaultTheme.BLACK_BUTTON,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 30),
                                      )
                                    ],
                                  ),
                                ),
                          (medicalInstructionDTO.medicationsRespone
                                      .medicationSchedules[index].afterNoon ==
                                  0)
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 30),
                                      ),
                                      Container(
                                        width: 90,
                                        child: Text(
                                          'Buổi chiều',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: DefaultTheme.GREY_TEXT),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                90 -
                                                40 -
                                                60,
                                        child: Text(
                                          '${medicalInstructionDTO.medicationsRespone.medicationSchedules[index].afterNoon} ${medicalInstructionDTO.medicationsRespone.medicationSchedules[index].unit}',
                                          maxLines: 5,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: DefaultTheme.BLACK_BUTTON,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 30),
                                      )
                                    ],
                                  ),
                                ),
                          (medicalInstructionDTO.medicationsRespone
                                      .medicationSchedules[index].night ==
                                  0)
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 30),
                                      ),
                                      Container(
                                        width: 90,
                                        child: Text(
                                          'Buổi tối',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: DefaultTheme.GREY_TEXT),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                90 -
                                                40 -
                                                60,
                                        child: Text(
                                          '${medicalInstructionDTO.medicationsRespone.medicationSchedules[index].night} ${medicalInstructionDTO.medicationsRespone.medicationSchedules[index].unit}',
                                          maxLines: 5,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: DefaultTheme.BLACK_BUTTON,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 30),
                                      )
                                    ],
                                  ),
                                ),

                          //divider
                          if (index !=
                              medicalInstructionDTO.medicationsRespone
                                      .medicationSchedules.length -
                                  1)
                            (Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Divider(
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                height: 1,
                              ),
                            )),
                          if (index ==
                              medicalInstructionDTO.medicationsRespone
                                      .medicationSchedules.length -
                                  1)
                            (Padding(
                              padding: EdgeInsets.only(top: 20),
                            )),
                        ],
                      ),
                    );
                  })
              : Container(),
          //
        ],
      ),
    );
  }

  Future<void> _getPatientId() async {
    // await _systemRepository.getTimeSystem().then((value) {
    //   if (value != null && value != '' && value.isNotEmpty) {
    //     String nowSystem = _dateValidator.convertDateCreate(
    //         value.toString().trim().replaceAll('"', ''),
    //         'dd/MM/yyyy',
    //         'yyyy-MM-dd');

    //     setState(() {
    //       curentDateNow = DateFormat('dd/MM/yyyy').parse(nowSystem);
    //     });
    //   }
    // });
    //
    setState(() {
      curentDateNow = new DateFormat('dd/MM/yyyy')
          .parse(DateFormat('dd/MM/yyyy').format(DateTime.now()));
    });

    await _authenticateHelper.getPatientId().then((value) async {
      await setState(() {
        _patientId = value;
      });
    });
    await _authenticateHelper.getAccountId().then((value) async {
      await setState(() {
        _accountId = value;
        // _patientId = value;
      });
    });
    _prescriptionListBloc
        .add(PrescriptionListEventsetPatientId(patientId: _patientId));
    _appointmentBloc.add(AppointmentGetListEvent(
        patientId: _accountId,
        date: '${curentDateNow.year}/${curentDateNow.month}'));

    _appointmentRepository.getAppointment(_accountId, '').then((value) {
      _getEvent(value);
    });
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    // print('CALLBACK: _onVisibleDaysChanged');
    // print('$first - $last - $format');
    // _appointmentBloc.add(AppointmentGetListEvent(
    //     patientId: _patientId, date: '${first.year}/${first.month}'));
  }
}

final Shader _normalHealthColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_1,
    DefaultTheme.GRADIENT_2,
  ],
).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 90.0));
