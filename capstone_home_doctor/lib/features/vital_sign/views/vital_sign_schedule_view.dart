import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class VitalSignScheduleView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VitalSignScheduleView();
  }
}

class _VitalSignScheduleView extends State<VitalSignScheduleView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future refresh() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeaderWidget(
              title: 'Lịch sinh hiệu',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refresh,
                child: ListView(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text('Bác sĩ: Nguyễn Lê Huy'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                          'Xếp lịch đo sinh hiệu từ ngày 1-1-2001 đến ngày 1-1-2021'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text('Chẩn đoán bệnh lý: Một con vịt abcd'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text('Mô tả: Đây là một mô tả'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color: DefaultTheme.GREY_VIEW,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Text('Nhịp tim'),
                          Text('Thời gian đo: Mỗi 10phút'),
                          Text('(Nhịp tim có thiết bị đeo hỗ trợ)'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
