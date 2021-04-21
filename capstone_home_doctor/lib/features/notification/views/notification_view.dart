import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/badge_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/notification/blocs/notification_list_bloc.dart';
import 'package:capstone_home_doctor/features/notification/events/notification_list_event.dart';
import 'package:capstone_home_doctor/features/notification/states/notification_list_state.dart';
import 'package:capstone_home_doctor/features/peripheral/views/connect_peripheral_view.dart';
import 'package:capstone_home_doctor/models/notification_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//
final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final DateValidator _dateValidator = DateValidator();
final ContractHelper _contractHelper = ContractHelper();

class NotificationPage extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  NotificationListBloc _notificationListBloc;
  //
  int _accountId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationListBloc = BlocProvider.of(context);
    _getAccountId();
  }

  Future _getAccountId() async {
    await _authenticateHelper.getAccountId().then((value) {
      _accountId = value;
    });
    if (_accountId != 0) {
      _notificationListBloc
          .add(NotificationListEventGet(accountId: _accountId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            HeaderWidget(
              title: 'Thông báo',
              isMainView: true,
              buttonHeaderType: ButtonHeaderType.AVATAR,
            ),
            // Padding(
            //   padding: EdgeInsets.only(bottom: 10),
            // ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _getAccountId,
                child: BlocBuilder<NotificationListBloc, NotificationListState>(
                    builder: (context, state) {
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
                  if (state is NotificationListStateSuccess) {
                    if (state.listNotification.isEmpty ||
                        state.listNotification == null) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/images/ic-noti.png'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 20),
                              ),
                              Text('Hiện tại bạn chưa có thông báo nào')
                            ],
                          )));
                    } else if (state.listNotification == null) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Text(
                                  'Kiểm tra lại đường truyền kết nối mạng')));
                    } else {
                      return ListView.builder(
                        itemCount: state.listNotification.length,
                        itemBuilder: (BuildContext context, int index) {
                          //
                          return Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                    left: 20, bottom: 15, top: 15),
                                child: Text(
                                  '${_dateValidator.parseDateToNotiView(state.listNotification[index].dateCreate)}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Divider(
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                height: 1,
                              ),
                              for (Notifications i in state
                                  .listNotification[index].notifications)
                                InkWell(
                                  onTap: () async {
                                    _notificationListBloc.add(
                                        NotificationUpdateStatusEvent(
                                            notiId: i.notificationId));
                                    _getAccountId();
                                    if (i.notificationType == 1 ||
                                        i.notificationType == 4 ||
                                        i.notificationType == 5 ||
                                        i.notificationType == 9 ||
                                        i.notificationType == 10) {
                                      //Navigate hợp đồng detail
                                      //
                                      if (i.contractId != null) {
                                        await _contractHelper
                                            .updateContractId(i.contractId);

                                        Navigator.of(context).pushNamed(
                                            RoutesHDr.DETAIL_CONTRACT_VIEW);
                                      }
                                    } else if (i.notificationType == 2) {
                                      //Navigate Screen overview

                                      //
                                      int currentIndex = 1;
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              RoutesHDr.MAIN_HOME,
                                              (Route<dynamic> route) => false,
                                              arguments: currentIndex);
                                    } else if (i.notificationType == 7) {
                                      //Navigate Lịch sinh hiệu
                                      //
                                      int currentIndex = 1;
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              RoutesHDr.MAIN_HOME,
                                              (Route<dynamic> route) => false,
                                              arguments: currentIndex);
                                    } else if (i.notificationType == 6) {
                                      //Navigate thuốc detail
                                      //
                                      Navigator.pushNamed(context,
                                          RoutesHDr.MEDICAL_HISTORY_DETAIL,
                                          arguments: i.medicalInstructionId);
                                    } else if (i.notificationType == 8) {
                                      //Navigate hẹn hẹn detail
                                      //
                                      int _indexPage = 1;
                                      Navigator.of(context).pushNamed(
                                          RoutesHDr.SCHEDULE,
                                          arguments: _indexPage);
                                    } else if (i.notificationType == 12) {
                                      //Navigate share medical instruction
                                      //

                                    } else if (i.notificationType == 11) {
                                      //Navigate connect device screen

                                      await peripheralHelper
                                          .getPeripheralId()
                                          .then((value) async {
                                        if (value != '') {
                                          Navigator.of(context).pushNamed(
                                              RoutesHDr
                                                  .INTRO_CONNECT_PERIPHERAL);
                                        } else {
                                          Navigator.of(context).pushNamed(
                                              RoutesHDr.PERIPHERAL_SERVICE);
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                        EdgeInsets.only(bottom: 10, top: 10),
                                    // margin: EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                        color: (i.status == false)
                                            ? DefaultTheme.GREY_VIEW
                                                .withOpacity(0.7)
                                            : DefaultTheme.WHITE
                                                .withOpacity(0.1)),

                                    child: Stack(
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            //
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                            ),
                                            SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: Image.asset((i
                                                              .notificationType ==
                                                          1 ||
                                                      i.notificationType == 4 ||
                                                      i.notificationType == 5 ||
                                                      i.notificationType == 9 ||
                                                      i.notificationType == 10)
                                                  ? 'assets/images/ic-contract.png'
                                                  : (i.notificationType == 2 ||
                                                          i.notificationType ==
                                                              7)
                                                      ? 'assets/images/ic-health-selected.png'
                                                      : (i.notificationType ==
                                                              6)
                                                          ? 'assets/images/ic-medicine.png'
                                                          : (i.notificationType ==
                                                                  8)
                                                              ? 'assets/images/ic-calendar.png'
                                                              : (i.notificationType ==
                                                                          3 ||
                                                                      i.notificationType ==
                                                                          12)
                                                                  ? 'assets/images/ic-medical-instruction.png'
                                                                  : (i.notificationType ==
                                                                          11)
                                                                      ? 'assets/images/ic-connect-p.png'
                                                                      : 'assets/images/ic-noti-selected.png'),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                //

                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      110,
                                                  child: Text(
                                                    '${i.title}',
                                                    style: TextStyle(
                                                        fontWeight: (i.status ==
                                                                true)
                                                            ? FontWeight.w500
                                                            : FontWeight.w600),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 2),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 3),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      110,
                                                  child: Text('${i.body}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              (i.status == true)
                                                                  ? FontWeight
                                                                      .w400
                                                                  : FontWeight
                                                                      .w600)),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 10,
                                          child: Text(
                                            '${_dateValidator.renderLastTimeNoti(i.timeAgo)}',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              Divider(
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                height: 1,
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child:
                              Text('Kiểm tra lại đường truyền kết nối mạng')));
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
