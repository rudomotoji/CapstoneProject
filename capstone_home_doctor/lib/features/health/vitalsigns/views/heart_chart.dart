import 'dart:async';

import 'package:capstone_home_doctor/commons/constants/peripheral_services.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/peripheral/blocs/hr_bloc.dart';
import 'package:capstone_home_doctor/models/heart_rate_dto.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/subjects.dart';

class HeartChart extends StatefulWidget {
  @override
  _HeartChartState createState() => _HeartChartState();
}

final SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();

class _HeartChartState extends State<HeartChart> with WidgetsBindingObserver {
  final int defaultSpace = 50;
  final _vitalsignController = TextEditingController();
  var characteristicController =
      StreamController<BluetoothCharacteristic>.broadcast();
  int tmpHR = 0;
  String _labeltime = '';
  var deviceController = StreamController<BluetoothDevice>();
  var bpmController = BehaviorSubject<int>();
  BluetoothCharacteristic _bluetoothCharacteristic;
  HeartRateDTO heartRateDTO = HeartRateDTO();
  String _timeNow = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _labeltime = _getTimecurrent(new DateTime.now());
    const oneSec = const Duration(minutes: 1);
    new Timer.periodic(oneSec, (Timer t) {
      print(
          'DATE TIME NOW INTO HEART RATE: ${DateTime.now()} and VALUE HR is: ${tmpHR}');
      hrBloc.updateHR(tmpHR);
      _timeNow = DateTime.now().toString();
      heartRateDTO =
          HeartRateDTO(value: tmpHR, date: DateTime.now().toString());
      _sqfLiteHelper.insertHeartRate(heartRateDTO);
    });
  }

  void _calHeartRate(BluetoothCharacteristic bluetoothCharacteristic) async {
    //print('blueeee: $_bluetoothCharacteristic');
    //await bluetoothCharacteristic.descriptors[0].write([0xB1, 0x64]);
    await bluetoothCharacteristic.setNotifyValue(true);
    print(
        'bluetoothCharacteristic set notify ${bluetoothCharacteristic.isNotifying}');
    await bluetoothCharacteristic.value.listen((value) {
      if (value.isNotEmpty) {
        print('${value[1]}');
        tmpHR = value[1];
        hrBloc.hrSink.add(value[1]);
      } else {
        print('Empty bpm');
      }
    });
  }

  void _connectDevice(BluetoothDevice bluetoothDevice) async {
    deviceController.sink.add(bluetoothDevice);
    await bluetoothDevice.connect();

    List<BluetoothService> services = await bluetoothDevice.discoverServices();

    services.forEach((service) {
      if (service.uuid == PeripheralServices.SERVICE_HEART_RATE) {
        // Reads all characteristics
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          if (c.uuid == PeripheralCharacteristics.HEART_RATE_MEASUREMENT) {
            characteristicController.sink.add(c);
          } else {
            _bluetoothCharacteristic = c;
          }
          print('\n\n');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    Map<String, ScanResult> arguments =
        ModalRoute.of(context).settings.arguments;
    ScanResult peripheral = arguments['PERIPHERAL_CONNECTED'];
    BluetoothDevice device = peripheral.device;
    print('device connect is ${device.name}');
    _connectDevice(device);
    return Scaffold(
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
                    // InkWell(
                    //   onTap: () {
                    //     return showDialog(
                    //       context: context,
                    //       builder: (context) {
                    //         return Dialog(
                    //           child: Container(
                    //             height: 280.0,
                    //             width: 360.0,
                    //             color: Colors.white,
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: <Widget>[
                    //                 Container(
                    //                   margin: EdgeInsets.only(
                    //                       top: 16, left: 10, bottom: 10),
                    //                   child: Text(
                    //                     'Thêm dữ liệu',
                    //                     style: TextStyle(
                    //                         color: Colors.black, fontSize: 20),
                    //                   ),
                    //                 ),
                    //                 Divider(
                    //                   color: DefaultTheme.GREY_TOP_TAB_BAR,
                    //                   height: 0.25,
                    //                 ),
                    //                 TextFieldHDr(
                    //                   style: TFStyle.NO_BORDER,
                    //                   label: 'BPM',
                    //                   placeHolder: 'Nhập tại đây',
                    //                   inputType: TFInputType.TF_TEXT,
                    //                   // controller: _vitalsignController,
                    //                   keyboardAction: TextInputAction.done,
                    //                   label_text_width: 100,
                    //                 ),
                    //                 Divider(
                    //                   color: DefaultTheme.GREY_TOP_TAB_BAR,
                    //                   height: 0.25,
                    //                 ),
                    //                 Container(
                    //                   margin:
                    //                       EdgeInsets.only(top: 16, left: 10),
                    //                   child: Text(
                    //                     '$_labeltime',
                    //                     style: TextStyle(
                    //                         color: Colors.black, fontSize: 20),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   margin: EdgeInsets.only(
                    //                       top: 60, left: 10, right: 10),
                    //                   child: ButtonHDr(
                    //                     style: BtnStyle.BUTTON_BLACK,
                    //                     label: 'Xong',
                    //                     onTap: () async {},
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.only(top: 10, bottom: 10),
                    //     decoration: BoxDecoration(
                    //       color: DefaultTheme.GREY_VIEW,
                    //     ),
                    //     margin: EdgeInsets.only(top: 14),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "+",
                    //           textAlign: TextAlign.left,
                    //           style: TextStyle(
                    //             color: DefaultTheme.ORANGE_TEXT,
                    //             fontWeight: FontWeight.w400,
                    //             fontSize: 15,
                    //           ),
                    //         ),
                    //         Text(
                    //           "Thêm dữ liệu",
                    //           textAlign: TextAlign.left,
                    //           style: TextStyle(
                    //             color: DefaultTheme.ORANGE_TEXT,
                    //             fontWeight: FontWeight.w400,
                    //             fontSize: 15,
                    //           ),
                    //         ),
                    //         SizedBox(),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    StreamBuilder<BluetoothCharacteristic>(
                      stream: characteristicController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return InkWell(
                            onTap: () {
                              _calHeartRate(snapshot.data);
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: DefaultTheme.GREY_VIEW,
                              ),
                              margin: EdgeInsets.only(top: 14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "+",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: DefaultTheme.ORANGE_TEXT,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    "Đo nhịp tim",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: DefaultTheme.ORANGE_TEXT,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(),
                                ],
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                    (_timeNow == '')
                        ? Text('')
                        : Text('Được đồng bộ gần nhất lúc ${_timeNow}'),
                    __heartChart(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget __heartChart() {
    return Container(
      margin: EdgeInsets.only(left: 23, right: 22),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(
                    'Nhịp tim gần nhất',
                  ),
                  StreamBuilder<int>(
                    stream: hrBloc.hrStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          '${snapshot.data} BPM',
                          style: TextStyle(
                              fontSize: 20, color: DefaultTheme.ORANGE_TEXT),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ],
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Align(
            //         alignment: Alignment.topRight,
            //         child: Container(
            //           margin: EdgeInsets.only(right: 19),
            //           child: Text(
            //             "Khoảng nhịp tim",
            //             textAlign: TextAlign.right,
            //             style: TextStyle(
            //               color: Color.fromARGB(255, 137, 137, 137),
            //               fontWeight: FontWeight.w400,
            //               fontSize: 20,
            //             ),
            //           ),
            //         ),
            //       ),
            //       Align(
            //         alignment: Alignment.topRight,
            //         child: Container(
            //           width: 95,
            //           height: 41,
            //           margin: EdgeInsets.only(top: 6, right: 19),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.end,
            //             crossAxisAlignment: CrossAxisAlignment.stretch,
            //             children: [
            //               Align(
            //                 alignment: Alignment.topLeft,
            //                 child: Container(
            //                   child: Text(
            //                     "82",
            //                     textAlign: TextAlign.left,
            //                     style: TextStyle(
            //                       color: DefaultTheme.ORANGE_TEXT,
            //                       fontWeight: FontWeight.w400,
            //                       fontSize: 35,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               Align(
            //                 alignment: Alignment.topLeft,
            //                 child: Container(
            //                   margin: EdgeInsets.only(top: 14),
            //                   child: Text(
            //                     "BPM",
            //                     textAlign: TextAlign.right,
            //                     style: TextStyle(
            //                       color: Color.fromARGB(255, 137, 137, 137),
            //                       fontWeight: FontWeight.w400,
            //                       fontSize: 20,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Align(
            //         alignment: Alignment.topRight,
            //         child: Container(
            //           margin: EdgeInsets.only(top: 2, right: 19),
            //           child: Text(
            //             "Thứ 4, ngày 9, tháng 12, 2020 ",
            //             textAlign: TextAlign.right,
            //             style: TextStyle(
            //               color: Color.fromARGB(255, 137, 137, 137),
            //               fontWeight: FontWeight.w400,
            //               fontSize: 12,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 16),
              width: MediaQuery.of(context).size.width - 40,
              child: LineChart(
                sampleData2(),
                swapAnimationDuration: const Duration(milliseconds: 250),
              ),
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     color: DefaultTheme.ORANGE_TEXT,
          //     borderRadius: BorderRadius.all(Radius.circular(5)),
          //   ),
          //   margin: EdgeInsets.only(top: 16),
          //   padding: EdgeInsets.all(10),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       Container(
          //         width: 192,
          //         // height: 30,
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.end,
          //           crossAxisAlignment: CrossAxisAlignment.stretch,
          //           children: [
          //             Align(
          //               alignment: Alignment.topLeft,
          //               child: Container(
          //                 margin: EdgeInsets.only(left: 2),
          //                 child: Text(
          //                   "Lần đo gần nhất",
          //                   textAlign: TextAlign.center,
          //                   style: TextStyle(
          //                     color: DefaultTheme.WHITE,
          //                     fontWeight: FontWeight.w400,
          //                     fontSize: 16,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             Align(
          //               alignment: Alignment.topLeft,
          //               child: Text(
          //                 "12:57 pm, ngày 9 tháng 12 2020",
          //                 textAlign: TextAlign.left,
          //                 style: TextStyle(
          //                   color: DefaultTheme.WHITE,
          //                   fontWeight: FontWeight.w400,
          //                   fontSize: 12,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Spacer(),
          //       Container(
          //         margin: EdgeInsets.only(bottom: 5),
          //         child: Text(
          //           "125 bpm",
          //           textAlign: TextAlign.right,
          //           style: TextStyle(
          //             color: DefaultTheme.WHITE,
          //             fontWeight: FontWeight.w400,
          //             fontSize: 20,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

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
            fontSize: 10,
          ),
          // rotateAngle: -90,
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '00:00';
              case 6:
                return '06:00';
              case 12:
                return '12:00';
              case 18:
                return '18:00';
              case 24:
                return '24:00';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '';
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
          reservedSize: 12,
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
      maxX: 25,
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

  String _getTimecurrent(DateTime _time) {
    DateFormat _format = DateFormat('hh:mm a');
    String _formatted = _format.format(_time);
    return _formatted;
  }
}
