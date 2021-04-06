import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/activity/blocs/activity_bloc.dart';
import 'package:capstone_home_doctor/features/activity/blocs/doctor_list_bloc.dart';
import 'package:capstone_home_doctor/features/activity/event/activity_event.dart';
import 'package:capstone_home_doctor/features/activity/event/doctor_list_event.dart';
import 'package:capstone_home_doctor/features/activity/state/activity_state.dart';
import 'package:capstone_home_doctor/features/activity/state/doctor_info_state.dart';
import 'package:capstone_home_doctor/features/notification/blocs/notification_list_bloc.dart';
import 'package:capstone_home_doctor/features/notification/events/notification_list_event.dart';
import 'package:capstone_home_doctor/features/notification/states/notification_list_state.dart';
import 'package:capstone_home_doctor/models/doctor_list_dto.dart';
import 'package:capstone_home_doctor/models/time_activity_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/doctor_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final DateValidator _dateValidator = DateValidator();
final DoctorHelper _doctorHelper = DoctorHelper();

class ActivityTimeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ActivityTimeView();
  }
}

class _ActivityTimeView extends State<ActivityTimeView>
    with WidgetsBindingObserver {
  int _accountId = 0;
  int _doctorAccountId = 0;
  String dateTimeChosen = '';
  ActivityBloc _activityBloc;
  NotificationListBloc _notificationListBloc;
  bool kickViewOn = false;
  bool isItemLeft = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _activityBloc = BlocProvider.of(context);
    _notificationListBloc = BlocProvider.of(context);
    _getAccountId();
  }

  //
  _getAccountId() async {
    await _authenticateHelper.getAccountId().then((value) async {
      _accountId = value;
      if (_accountId != 0) {
        //
        await _doctorHelper.getDoctorId().then((dAId) {
          if (dAId != null) {
            _doctorAccountId = dAId;
            print('Doctor account id: $dAId');
            _activityBloc.add(ActivityGetTimeEvent(
                patientAccountId: _accountId, doctorAccountId: dAId));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeaderWidget(
              title: 'Hoạt động',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            //
            (kickViewOn == false)
                ? Padding(
                    padding: EdgeInsets.only(
                        top: 5, left: 20, bottom: 15, right: 20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        _showFilterForm();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: DefaultTheme.BLUE_DARK.withOpacity(0.3)),
                        child: Row(
                          children: [
                            Spacer(),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Image.asset('assets/images/ic-filter.png'),
                            ),
                            Text(
                              'Bộ lọc',
                              style: TextStyle(
                                  color: DefaultTheme.BLUE_DARK,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ))
                : Padding(
                    padding: EdgeInsets.only(
                        top: 5, left: 20, bottom: 15, right: 20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() {
                          kickViewOn = false;
                        });
                      },
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: DefaultTheme.BLUE_DARK.withOpacity(0.3)),
                        child: Row(
                          children: [
                            Spacer(),
                            Text(
                              'Ngày ${dateTimeChosen.split('-')[2]} tháng ${dateTimeChosen.split('-')[1]},${dateTimeChosen.split('-')[0]}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: DefaultTheme.BLUE_DARK,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Image.asset('assets/images/ic-close.png'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                            ),
                          ],
                        ),
                      ),
                    )),

            Expanded(
              child: ListView(
                children: <Widget>[
                  (kickViewOn)
                      ? BlocBuilder<NotificationListBloc,
                          NotificationListState>(builder: (context, state) {
                          //
                          if (state is NotificationListStateLoading) {
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
                          if (state is NotificationListStateFailure) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: Text(
                                        'Kiểm tra lại đường truyền kết nối mạng')));
                          }
                          if (state is TimeLineStateSuccess) {
                            if (state.dto == null) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                      child: Text(
                                          'Kiểm tra lại đường truyền kết nối mạng')));
                            } else {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.dto.notifications.length,
                                itemBuilder: (BuildContext context, int index) {
                                  //

                                  return Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          margin: (state
                                                          .dto
                                                          .notifications[index]
                                                          .notificationType ==
                                                      1 ||
                                                  state.dto.notifications[index]
                                                          .notificationType ==
                                                      2 ||
                                                  state.dto.notifications[index]
                                                          .notificationType ==
                                                      3 ||
                                                  state.dto.notifications[index]
                                                          .notificationType ==
                                                      9 ||
                                                  state.dto.notifications[index]
                                                          .notificationType ==
                                                      10 ||
                                                  state.dto.notifications[index]
                                                          .notificationType ==
                                                      14 ||
                                                  state.dto.notifications[index]
                                                          .notificationType ==
                                                      15 ||
                                                  state.dto.notifications[index]
                                                          .notificationType ==
                                                      16 ||
                                                  state.dto.notifications[index]
                                                          .notificationType ==
                                                      17)
                                              ? EdgeInsets.only(
                                                  left: 50, right: 10)
                                              : EdgeInsets.only(
                                                  left: 10, right: 50),
                                          padding: EdgeInsets.only(
                                              bottom: 10,
                                              left: 10,
                                              top: 10,
                                              right: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: DefaultTheme
                                                    .GREY_TOP_TAB_BAR),
                                            color: DefaultTheme.GREY_VIEW,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: ((state
                                                            .dto
                                                            .notifications[
                                                                index]
                                                            .notificationType ==
                                                        1 ||
                                                    state
                                                            .dto
                                                            .notifications[
                                                                index]
                                                            .notificationType ==
                                                        2 ||
                                                    state
                                                            .dto
                                                            .notifications[
                                                                index]
                                                            .notificationType ==
                                                        3 ||
                                                    state
                                                            .dto
                                                            .notifications[
                                                                index]
                                                            .notificationType ==
                                                        9 ||
                                                    state
                                                            .dto
                                                            .notifications[
                                                                index]
                                                            .notificationType ==
                                                        10 ||
                                                    state
                                                            .dto
                                                            .notifications[
                                                                index]
                                                            .notificationType ==
                                                        14 ||
                                                    state
                                                            .dto
                                                            .notifications[
                                                                index]
                                                            .notificationType ==
                                                        15 ||
                                                    state
                                                            .dto
                                                            .notifications[
                                                                index]
                                                            .notificationType ==
                                                        16 ||
                                                    state
                                                            .dto
                                                            .notifications[
                                                                index]
                                                            .notificationType ==
                                                        17))
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${state.dto.notifications[index].title}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                textAlign: (state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            1 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            2 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            3 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            9 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            10 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            14 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            15 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            16 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            17)
                                                    ? TextAlign.right
                                                    : TextAlign.left,
                                              ),
                                              Text(
                                                '${state.dto.notifications[index].body}',
                                                textAlign: (state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            1 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            2 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            3 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            9 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            10 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            14 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            15 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            16 ||
                                                        state
                                                                .dto
                                                                .notifications[
                                                                    index]
                                                                .notificationType ==
                                                            17)
                                                    ? TextAlign.right
                                                    : TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          }
                          return Container();
                        })
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterForm() {
    String month = 'Tháng: ';
    bool isDayOn = false;
    String day = 'Ngày: ';
    List<int> valueDays = [];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
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
                      color: DefaultTheme.WHITE.withOpacity(0.6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                        ),
                        Expanded(
                          child: Container(
                            child:
                                //
                                BlocBuilder<ActivityBloc, ActivityState>(
                                    builder: (context, state) {
                              if (state is ActivityStateLoading) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                        'assets/images/loading.gif'),
                                  ),
                                );
                              }
                              if (state is ActivityStateFailure) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text('Lỗi'),
                                );
                              }
                              if (state is ActivityStateSuccess) {
                                if (state.list == null) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text('Lỗi'),
                                  );
                                } else {
                                  return Column(
                                    children: <Widget>[
                                      Text(
                                          'Chọn thời gian cụ thể để xem hoạt động của bạn và bác sĩ.'),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                      ),
                                      Divider(
                                        color: DefaultTheme.GREY_TEXT,
                                        height: 0.25,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 30, right: 30),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: DropdownButton<TimeActDTO>(
                                          items: state.list
                                              .map((TimeActDTO value) {
                                            return new DropdownMenuItem<
                                                TimeActDTO>(
                                              value: value,
                                              child: new Text(value.month),
                                            );
                                          }).toList(),
                                          hint: Text(
                                            '${month}',
                                            style: TextStyle(
                                              color: DefaultTheme.BLUE_DARK,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          underline: Container(
                                            width: 0,
                                          ),
                                          isExpanded: true,
                                          onChanged: (_) {
                                            setModalState(() {
                                              month = 'Tháng: ${_.month}';
                                              day = 'Ngày: ';
                                              isDayOn = true;
                                              valueDays = _.days;
                                            });
                                          },
                                        ),
                                      ),
                                      //
                                      Divider(
                                        color: DefaultTheme.GREY_TEXT,
                                        height: 0.25,
                                      ),
                                      (isDayOn)
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  left: 30, right: 30),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: DropdownButton<int>(
                                                items:
                                                    valueDays.map((int aDay) {
                                                  return new DropdownMenuItem<
                                                      int>(
                                                    value: aDay,
                                                    child: new Text('$aDay'),
                                                  );
                                                }).toList(),
                                                hint: Text(
                                                  '${day}',
                                                  style: TextStyle(
                                                    color:
                                                        DefaultTheme.BLUE_DARK,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                underline: Container(
                                                  width: 0,
                                                ),
                                                isExpanded: true,
                                                onChanged: (_) {
                                                  setModalState(() {
                                                    day = 'Ngày: ${_}';
                                                  });
                                                },
                                              ),
                                            )
                                          : Container(),
                                      // : Container(),
                                      (isDayOn)
                                          ? Divider(
                                              color: DefaultTheme.GREY_TEXT,
                                              height: 0.25,
                                            )
                                          : Container(),
                                    ],
                                  );
                                }
                              }
                              return Container();
                            }),
                          ),
                        ),
                        ButtonHDr(
                          style: BtnStyle.BUTTON_BLACK,
                          label: 'Xong',
                          onTap: () {
                            //
                            if (month.split(': ')[1] != '' &&
                                day.split(': ')[1] != '') {
                              //
                              String yearData =
                                  month.split(': ')[1].trim().split('/')[1];
                              String monthData =
                                  month.split(': ')[1].trim().split('/')[0];
                              String dayData = day.split(': ')[1].trim();
                              print(
                                  'before add event: patient acc id:${_accountId} - doctor acc id: ${_doctorAccountId}');
                              print('$yearData-$monthData-$dayData');

                              setState(() {
                                kickViewOn = true;
                                dateTimeChosen =
                                    '$yearData-$monthData-$dayData';
                              });
                              if (dateTimeChosen != '') {
                                _notificationListBloc.add(TimeLineGetEvent(
                                    patientAccountId: _accountId,
                                    doctorAccountId: _doctorAccountId,
                                    dateTime: dateTimeChosen));
                              }
                              Navigator.of(context).pop();
                            } else {
                              //
                              Navigator.of(context).pop();
                            }

                            //
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
        });
      },
    );
  }
}
