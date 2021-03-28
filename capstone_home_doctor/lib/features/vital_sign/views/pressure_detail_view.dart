import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PressureDetailView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PressureDetailView();
  }
}

class _PressureDetailView extends State<PressureDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: ListView(padding: const EdgeInsets.all(24), children: <Widget>[
      //   _lineChartBloodPressure(),
      // ]),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //
          ],
        ),
      ),
    );
  }

  // Widget _lineChartBloodPressure() {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  //     color: Colors.white,
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 16.0),
  //       child: BarChart(
  //         BarChartData(
  //           alignment: BarChartAlignment.start,
  //           barTouchData: BarTouchData(
  //             enabled: false,
  //           ),
  //           titlesData: FlTitlesData(
  //             show: true,
  //             bottomTitles: SideTitles(
  //               showTitles: true,
  //               getTextStyles: (value) =>
  //                   const TextStyle(color: Color(0xff939393), fontSize: 10),
  //               margin: 5,
  //             ),
  //             leftTitles: SideTitles(
  //               showTitles: true,
  //               getTextStyles: (value) => const TextStyle(
  //                   color: Color(
  //                     0xff939393,
  //                   ),
  //                   fontSize: 10),
  //               margin: 0,
  //               getTitles: (double value) {
  //                 if (value % 10 == 0) return '${value.floor()}';
  //               },
  //             ),
  //           ),
  //           borderData: FlBorderData(
  //             show: false,
  //           ),
  //           barGroups: getData(),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // List<BarChartGroupData> getData() {
  //   return [
  //     BarChartGroupData(
  //       x: 0,
  //       barRods: [
  //         BarChartRodData(
  //           y: 100,
  //           rodStackItems: [
  //             BarChartRodStackItem(0, 50, DefaultTheme.WHITE),
  //             BarChartRodStackItem(50, 100, DefaultTheme.RED_CALENDAR),
  //           ],
  //         ),
  //         BarChartRodData(
  //           y: 100,
  //           rodStackItems: [
  //             BarChartRodStackItem(0, 10, DefaultTheme.WHITE),
  //             BarChartRodStackItem(10, 30, DefaultTheme.RED_CALENDAR),
  //             BarChartRodStackItem(30, 100, DefaultTheme.WHITE),
  //           ],
  //         ),
  //       ],
  //     ),
  //   ];
  // }

}
