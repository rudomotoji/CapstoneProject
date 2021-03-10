import 'package:capstone_home_doctor/commons/widgets/badge_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/notification/blocs/notification_list_bloc.dart';
import 'package:capstone_home_doctor/features/notification/events/notification_list_event.dart';
import 'package:capstone_home_doctor/features/notification/states/notification_list_state.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//
final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

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

  _getAccountId() async {
    await _authenticateHelper.getAccountId().then((value) {
      setState(() {
        _accountId = value;
      });
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
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Expanded(
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
                          child:
                              Text('Kiểm tra lại đường truyền kết nối mạng')));
                }
                if (state is NotificationListStateSuccess) {
                  return ListView.builder(
                      itemCount: state.listNotification.length,
                      itemBuilder: (BuildContext buildContext, int index) {
                        //
                        return BadgeWidget(
                          title: '${state.listNotification[index].title}',
                          description: '${state.listNotification[index].body}',
                          contractId: state.listNotification[index].contractId,
                          medInsId: state
                              .listNotification[index].medicalInstructionId,
                          date: state.listNotification[index].dateCreate,
                          isRead: state.listNotification[index].status,
                        );
                      });
                }
                return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text('Kiểm tra lại đường truyền kết nối mạng')));
              }),
            ),
          ],
        ),
      ),
    );
  }
}
