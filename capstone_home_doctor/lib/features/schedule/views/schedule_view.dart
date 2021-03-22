import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/appointment_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/prescription_list_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/events/appointment_event.dart';
import 'package:capstone_home_doctor/features/schedule/events/prescription_list_event.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/prescription_repository.dart';
import 'package:capstone_home_doctor/features/schedule/states/appointment_state.dart';
import 'package:capstone_home_doctor/features/schedule/states/prescription_list_state.dart';
import 'package:capstone_home_doctor/models/appointment_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

class ScheduleView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScheduleView();
  }
}

class _ScheduleView extends State<ScheduleView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  //
  DateValidator _dateValidator = DateValidator();
  MedicalInstructionDTO _currentPrescription = MedicalInstructionDTO();
  //
  List<MedicalInstructionDTO> listPrescription = [];
  PrescriptionRepository prescriptionRepository =
      PrescriptionRepository(httpClient: http.Client());
  PrescriptionListBloc _prescriptionListBloc;
  //
  int _patientId = 0;
  DateTime curentDateNow = new DateFormat('dd/MM/yyyy')
      .parse(DateFormat('dd/MM/yyyy').format(DateTime.now()));

  //use for calendar
  Map<DateTime, List> _events = {};
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  AppointmentBloc _appointmentBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPatientId();
    _prescriptionListBloc = BlocProvider.of(context);
    _appointmentBloc = BlocProvider.of(context);

    _calendarController = CalendarController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _listPrescription.sort((a, b) => b.startDate.compareTo(a.startDate));
    // _currentPrescription = _listPrescription[0];
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
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
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 0),
                child: Divider(
                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                  height: 0.1,
                ),
              ),
              TabBar(
                  isScrollable: true,
                  //labelColor: Colors.black,
                  labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      foreground: Paint()..shader = _normalHealthColors),
                  indicatorPadding: EdgeInsets.only(left: 20),
                  unselectedLabelStyle:
                      TextStyle(color: DefaultTheme.BLACK.withOpacity(0.6)),
                  indicatorColor: Colors.white.withOpacity(0.0),
                  tabs: [
                    Tab(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 25,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Dùng thuốc',
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 25,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tái khám',
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 25,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Thời gian biểu',
                          ),
                        ),
                      ),
                    ),
                  ]),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Divider(
                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                  height: 0.1,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    _getMedicineSchedule(),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        _buildTableCalendar(),
                        const SizedBox(height: 8.0),
                        Expanded(child: _buildEventList(context)),
                      ],
                    ),
                    Container(
                      child: Text('3'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentStateLoading) {
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
        if (state is AppointmentStateFailure) {
          return Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text('Kiểm tra lại đường truyền kết nối mạng')));
        }
        if (state is AppointmentStateSuccess) {
          if (state.isCancel != null) {
            if (state.isCancel) {
              Navigator.pop(context);
            }
          }
          if (state.listAppointment.length > 0) {
            _getEvent(state.listAppointment);
          }
          return _buildCalendar();
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

  Widget _buildCalendar() {
    return TableCalendar(
      // locale: 'en-US',
      // locale: 'vi-VN',
      calendarController: _calendarController,
      initialCalendarFormat: CalendarFormat.month,
      // availableGestures: AvailableGestures.none,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: DefaultTheme.CHIP_BLUE,
        todayColor: DefaultTheme.BLUE_REFERENCE,
        markersColor: DefaultTheme.RED_CALENDAR,
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  void _getEvent(List<AppointmentDTO> listAppointment) {
    final _selectedDay = DateTime.now();

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
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  Widget _buildEventList(BuildContext context) {
    return _selectedEvents != null
        ? ListView(
            children: _selectedEvents.map((event) {
              DateTime timeEx = new DateFormat("yyyy-MM-ddThh:mm")
                  .parse(event.dateExamination);
              var dateAppointment =
                  new DateFormat('dd/MM/yyyy, hh:mm a').format(timeEx);
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Bạn có lịch tái khám:'),
                      Text('Với Bác sỹ Lê Huy'),
                      Text('Thời gian: ${dateAppointment}'),
                      Text('Ghi chú: ${event.note}'),
                      (event.status.contains('CANCEL'))
                          ? Text('Lý do hủy lịch: ${event.reasonCanceled}')
                          : Container(),
                      (event.status.contains('CANCEL'))
                          ? Container()
                          : _buttonCancel(event, context),
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        : Container();
  }

  Widget _buttonCancel(AppointmentDetailDTO dto, BuildContext contextButton) {
    DateTime timeEx = new DateFormat("yyyy-MM-dd").parse(dto.dateExamination);
    DateTime dateAppointment = new DateFormat('dd/MM/yyyy')
        .parse(DateFormat('dd/MM/yyyy').format(timeEx));

    if ((dateAppointment.millisecondsSinceEpoch -
            curentDateNow.millisecondsSinceEpoch) >
        (86400000 * 1)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: DefaultTheme.GREY_VIEW),
            child: FlatButton(
              color: DefaultTheme.TRANSPARENT,
              onPressed: () {
                _popupCancel(dto.appointmentId);
              },
              padding: null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset('assets/images/ic-contract.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                  Text(
                    'Hủy lịch tái khám',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      color: DefaultTheme.BLACK,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _popupCancel(int appointmentId) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: DefaultTheme.TRANSPARENT,
      builder: (context) {
        String reason = "";
        return StatefulBuilder(
          builder: (BuildContext context2, StateSetter setModalState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 600,
                    color: DefaultTheme.TRANSPARENT,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          color: DefaultTheme.TRANSPARENT,
                        ),
                        Container(
                          height: 580,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: DefaultTheme.WHITE,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 40, left: 0),
                                    child: Text(
                                      'Hủy lịch tái khám',
                                      style: TextStyle(
                                        color: DefaultTheme.BLACK,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    Text(''),
                                    Container(
                                      height: 100,
                                      child: TextFieldHDr(
                                        placeHolder:
                                            'Nhập tại đây lý do hủy lịch tái khám....',
                                        style: TFStyle.TEXT_AREA,
                                        keyboardAction: TextInputAction.done,
                                        onChange: (value) {
                                          reason = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ButtonHDr(
                                width: MediaQuery.of(context).size.width - 40,
                                style: BtnStyle.BUTTON_BLACK,
                                label: 'Gửi',
                                onTap: () async {
                                  //
                                  _appointmentBloc.add(AppointmentCancelEvent(
                                      appointmentId: appointmentId,
                                      reasonCancel: reason));
                                  Navigator.pop(context);
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 25),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
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
      },
    );
  }

  _getMedicineSchedule() {
    return BlocBuilder<PrescriptionListBloc, PrescriptionListState>(
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
            width: MediaQuery.of(context).size.width,
            child:
                Center(child: Text('Kiểm tra lại đường truyền kết nối mạng')));
      }
      if (state is PrescriptionListStateSuccess) {
        listPrescription = state.listPrescription;
        List<MedicalInstructionDTO> listPrescriptions = [];

        if (state.listPrescription != null) {
          listPrescription.sort((a, b) =>
              b.medicalInstructionId.compareTo(a.medicalInstructionId));
          listPrescription.sort((a, b) => b.medicationsRespone.dateFinished
              .compareTo(a.medicationsRespone.dateFinished));
        }
        if (listPrescription.isNotEmpty) {
          for (var element in listPrescription) {
            if (element.medicationsRespone.status.contains('ACTIVE')) {
              listPrescriptions.add(element);
            }
          }
          if (listPrescriptions.length > 0)
            _currentPrescription = listPrescriptions[0];
        }
        return (state.listPrescription == null ||
                state.listPrescription.isEmpty)
            ? Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text('Hiện chưa có lịch dùng thuốc'),
                ),
              )
            : ListView(
                padding: EdgeInsets.only(left: 20, right: 20),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        color: DefaultTheme.GREY_BUTTON,
                        borderRadius: BorderRadius.circular(10)),
                    child: ButtonHDr(
                      style: BtnStyle.BUTTON_IN_LIST,
                      label: 'Lịch sử các đơn thuốc',
                      image: Image.asset('assets/images/ic-medicine.png'),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RoutesHDr.HISTORY_PRESCRIPTION);
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 30, left: 0, right: 0, bottom: 20),
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

                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listPrescriptions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          child: _itemSchedule(listPrescriptions[index]),
                        );
                      }),

                  // _itemSchedule(_currentPrescription),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                ],
              );

        //

      }
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text('Không thể lấy dữ liệu'),
        ),
      );
    });
  }

  Widget _itemSchedule(MedicalInstructionDTO medicalInstructionDTO) {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 10),
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          color: DefaultTheme.GREY_VIEW,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) async {
      await setState(() {
        _patientId = value;
      });
    });
    _prescriptionListBloc
        .add(PrescriptionListEventsetPatientId(patientId: _patientId));
    _appointmentBloc.add(AppointmentGetListEvent(
        patientId: _patientId,
        date: '${curentDateNow.year}/${curentDateNow.month}'));
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
