import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';

class HeartChart extends StatefulWidget {
  @override
  _HeartChartState createState() => _HeartChartState();
}

class _HeartChartState extends State<HeartChart> {
  final int defaultSpace = 50;

  @override
  Widget build(BuildContext context) {
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
                title: 'Nhịp tim',
                isMainView: false,
                buttonHeaderType: ButtonHeaderType.BACK_HOME,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: ListView(
                    children: <Widget>[
                      __heartChart(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget __heartChart() {
    return Container(
      margin: EdgeInsets.only(left: 23, right: 22),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(right: 19),
              child: Text(
                "Khoảng nhịp tim",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color.fromARGB(255, 137, 137, 137),
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 95,
              height: 41,
              margin: EdgeInsets.only(top: 6, right: 19),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Text(
                        "82",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: DefaultTheme.ORANGE_TEXT,
                          fontWeight: FontWeight.w400,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 14),
                      child: Text(
                        "BPM",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color.fromARGB(255, 137, 137, 137),
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(top: 2, right: 19),
              child: Text(
                "Thứ 4, ngày 9, tháng 12, 2020 ",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color.fromARGB(255, 137, 137, 137),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 16),
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: LineChart(
                sampleData2(),
                swapAnimationDuration: const Duration(milliseconds: 250),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: DefaultTheme.ORANGE_TEXT,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 192,
                  // height: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 2),
                          child: Text(
                            "Lần đo gần nhất",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: DefaultTheme.WHITE,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "12:57 pm, ngày 9 tháng 12 2020",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: DefaultTheme.WHITE,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(
                    "125 bpm",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: DefaultTheme.WHITE,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.only(left: 3, top: 10, bottom: 7),
                child: InkWell(
                  child: Text(
                    "Hiển thị thêm dữ liệu đo về tim",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: DefaultTheme.ORANGE_TEXT,
                      fontFamily: "",
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, RoutesHDr.VITALSIGN_HISTORY);
                  },
                )),
          ),
        ],
      ),
    );
  }

  LineChartData sampleData2() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: false,
        drawVerticalLine: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 8,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          // rotateAngle: -90,
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 7:
                return '7';
              case 14:
                return '14';
              case 21:
                return '21';
              case 28:
                return '28';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 1:
                return '50';
              case 2:
                return '100';
              case 3:
                return '150';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(
            color: Color(0xff4e4965),
            width: 1,
          ),
        ),
      ),
      minX: 0,
      maxX: 30,
      maxY: 5,
      minY: 0,
      lineBarsData: linesBarData2(),
    );
  }

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(0, 75 / defaultSpace),
          FlSpot(3, 90 / defaultSpace),
          FlSpot(4, 110 / defaultSpace),
          FlSpot(5, 60 / defaultSpace),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0xFFFF784B),
        ],
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true), //dấu Dot tại mỗi giá trị
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
  }

  Future<void> _pullRefresh() async {}
}
