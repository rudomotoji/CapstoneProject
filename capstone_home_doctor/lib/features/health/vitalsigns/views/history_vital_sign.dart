import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/models/history_vivtal_sign.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryVitalSign extends StatefulWidget {
  @override
  _HistoryVitalSignState createState() => _HistoryVitalSignState();
}

class _HistoryVitalSignState extends State<HistoryVitalSign> {
  List<HistoryVitalSignDTO> _lists = [
    HistoryVitalSignDTO(dateCreate: '19 tháng 3', data: [
      DataDTO(
        time: "12:00",
        status: "Cao bất thường",
        value: "92",
      ),
      DataDTO(
        time: "12:00",
        status: "Cao bất thường",
        value: "92",
      ),
      DataDTO(
        time: "12:00",
        status: "Cao bất thường",
        value: "92",
      ),
    ]),
    HistoryVitalSignDTO(dateCreate: '19 tháng 3', data: [
      DataDTO(
        time: "12:00",
        status: "Cao bất thường",
        value: "92",
      ),
      DataDTO(
        time: "12:00",
        status: "Cao bất thường",
        value: "92",
      ),
      DataDTO(
        time: "12:00",
        status: "Cao bất thường",
        value: "92",
      ),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          HeaderWidget(
            title: 'Lịch sử đo',
            isMainView: false,
            buttonHeaderType: ButtonHeaderType.BACK_HOME,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                _listHistory(),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _listHistory() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _lists.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 1, bottom: 5),
                  child: Text(
                    "19 tháng 3",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: DefaultTheme.BLACK,
                      fontFamily: "",
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _lists[index].data.length,
                itemBuilder: (BuildContext context, int indexItem) {
                  return _itemHistory();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _itemHistory() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: DefaultTheme.GREY_VIEW,
      ),
      width: MediaQuery.of(context).size.width - 40,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 11),
              child: Text(
                "12:00",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: DefaultTheme.BLACK,
                  fontFamily: "",
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Text(
                            "92",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: DefaultTheme.BLACK,
                              fontFamily: "",
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Text(
                          "BPM",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: DefaultTheme.BLACK,
                            fontFamily: "",
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Text(
                        "Cao bất thường",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: DefaultTheme.RED_TEXT,
                          fontFamily: "",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
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
