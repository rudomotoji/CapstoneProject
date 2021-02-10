import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/models/medicine_scheduling_dto.dart';
import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Schedule();
  }
}

final List<MedicineSchedulingDTO> _listMedicine = [
  MedicineSchedulingDTO(
      name: 'Cefadroxil (Droxicef)',
      amount: '250mg',
      unit: 'viên',
      totalDay: 5,
      timePerDay: 2,
      howToUsing: 'Uống sau ăn',
      unitPerDay: 4),
  MedicineSchedulingDTO(
      name: 'Alpha chymotrypsin (Stratripsine)',
      amount: '4,2mg',
      unit: 'viên',
      totalDay: 5,
      timePerDay: 2,
      howToUsing: 'Uống sau ăn',
      unitPerDay: 4),
  MedicineSchedulingDTO(
      name: 'Metronidazol',
      amount: '250mg',
      unit: 'viên',
      totalDay: 5,
      timePerDay: 2,
      howToUsing: 'Uống sau ăn',
      unitPerDay: 4),
  MedicineSchedulingDTO(
      name: 'Paracetamol (Mypara)',
      amount: '500mg',
      unit: 'viên',
      totalDay: 5,
      timePerDay: null,
      howToUsing: 'Uống sủi bọt khi đau',
      unitPerDay: null),
  MedicineSchedulingDTO(
      name: 'Calci carbonat (CalciChew)',
      amount: '1.25g',
      unit: 'viên',
      totalDay: 5,
      timePerDay: 2,
      howToUsing: 'Uống sau ăn',
      unitPerDay: 2),
  MedicineSchedulingDTO(
      name: 'Vitamin C',
      amount: '100mg',
      unit: 'viên',
      totalDay: 5,
      timePerDay: 1,
      howToUsing: 'Uống sau ăn sáng',
      unitPerDay: 1),
];

class _Schedule extends State<Schedule> with WidgetsBindingObserver {
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
                title: 'Lịch',
                isMainView: false,
                buttonHeaderType: ButtonHeaderType.BACK_HOME,
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 10),
                child: Divider(
                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                  height: 0.1,
                ),
              ),
              TabBar(
                  isScrollable: true,
                  //labelColor: Colors.black,
                  labelStyle: TextStyle(
                      fontSize: 28,
                      foreground: Paint()..shader = _normalHealthColors),
                  indicatorPadding: EdgeInsets.only(left: 20),
                  unselectedLabelStyle:
                      TextStyle(color: DefaultTheme.BLACK.withOpacity(0.6)),
                  indicatorColor: Colors.white.withOpacity(0.0),
                  tabs: [
                    Tab(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 40,
                        child: Text(
                          'Dùng thuốc',
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 40,
                        child: Text(
                          'Tái khám',
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 40,
                        child: Text(
                          'Thời gian biểu',
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
                    _getMedicineSchedule(context),
                    Container(
                      child: Text('2'),
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
}

_getMedicineSchedule(BuildContext context) {
  return ListView(padding: EdgeInsets.only(left: 20, right: 20), children: <
      Widget>[
    Container(
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
                width: 160,
                child: Text(
                  'Bác sĩ:',
                  style: TextStyle(
                      color: DefaultTheme.GREY_TEXT,
                      fontSize: 15,
                      fontFamily: 'NewYork'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Container(
                width: MediaQuery.of(context).size.width - (40 + 120 + 20 + 30),
                child: Text(
                  'Nguyễn Lê Huy',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                      color: Colors.black, fontSize: 15, fontFamily: 'NewYork'),
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
                width: 160,
                child: Text(
                  'Kê đơn thuốc ngày:',
                  style: TextStyle(
                      color: DefaultTheme.GREY_TEXT,
                      fontSize: 15,
                      fontFamily: 'NewYork'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Container(
                width: MediaQuery.of(context).size.width - (40 + 120 + 20 + 30),
                child: Text(
                  '04 tháng 02, 2021',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                      color: Colors.black, fontSize: 15, fontFamily: 'NewYork'),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
          ),
          //bltm
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Divider(
              color: DefaultTheme.GREY_TEXT,
              height: 0.1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                width: 100,
                child: Text(
                  'Bệnh lý tim mạch:',
                  style: TextStyle(
                      color: DefaultTheme.GREY_TEXT,
                      fontSize: 15,
                      fontFamily: 'NewYork'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Container(
                width: MediaQuery.of(context).size.width - (130 + 20 + 10 + 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (BuildContext buildContext, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            child: Text(
                              'EX-${index + 1}',
                              style: TextStyle(
                                  color: DefaultTheme.BLACK,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'NewYork'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width -
                                (130 + 20 + 10 + 20 + 60),
                            child: Text(
                              'Bệnh tim do tăng huyết áp',
                              style: TextStyle(
                                  color: DefaultTheme.BLACK,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NewYork'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          //ghi chu
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
                width: 100,
                child: Text(
                  'Ghi chú của Bác sĩ:',
                  style: TextStyle(
                      color: DefaultTheme.GREY_TEXT,
                      fontSize: 15,
                      fontFamily: 'NewYork'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Container(
                width: MediaQuery.of(context).size.width - (80 + 20 + 20 + 30),
                child: Text(
                  'Đây là một ghi chú mẫu abis udhaisdhoiashd ioauhsdi oh',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                      color: Colors.black, fontSize: 15, fontFamily: 'NewYork'),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
          ),

          //đơn thuốc
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Đơn thuốc',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: 'NewYork'),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _listMedicine.length,
            itemBuilder: (BuildContext buildContext, int index) {
              return Container(
                color: DefaultTheme.WHITE,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //start list
                    if (index == 0)
                      (Padding(
                        padding: EdgeInsets.only(top: 10),
                      )),
                    //components
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Text(
                            '${_listMedicine[index].name} ${_listMedicine[index].amount}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text('ĐV: ${_listMedicine[index].unit}',
                            style: TextStyle(
                                fontSize: 16, color: DefaultTheme.GREY_TEXT)),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                        ),
                        Container(
                          width: 80,
                          child: Text(
                            'Dùng trong',
                            style: TextStyle(
                                fontSize: 15, color: DefaultTheme.GREY_TEXT),
                          ),
                        ),
                        Spacer(),
                        Text('${_listMedicine[index].totalDay} ngày',
                            style: TextStyle(
                                color: DefaultTheme.BLACK_BUTTON,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        Padding(
                          padding: EdgeInsets.only(right: 30),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    (_listMedicine[index].timePerDay != null)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                              ),
                              Container(
                                width: 80,
                                child: Text(
                                  'Mỗi ngày',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: DefaultTheme.GREY_TEXT),
                                ),
                              ),
                              Spacer(),
                              Text('${_listMedicine[index].timePerDay} lần',
                                  style: TextStyle(
                                      color: DefaultTheme.BLACK_BUTTON,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                              Padding(
                                padding: EdgeInsets.only(right: 30),
                              )
                            ],
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    (_listMedicine[index].unitPerDay != null)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                              ),
                              Container(
                                width: 80,
                                child: Text(
                                  'Mỗi lần',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: DefaultTheme.GREY_TEXT),
                                ),
                              ),
                              Spacer(),
                              Text(
                                  '${_listMedicine[index].unitPerDay} ${_listMedicine[index].unit}',
                                  style: TextStyle(
                                      color: DefaultTheme.BLACK_BUTTON,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                              Padding(
                                padding: EdgeInsets.only(right: 30),
                              )
                            ],
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
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
                                fontSize: 15, color: DefaultTheme.GREY_TEXT),
                          ),
                        ),
                        Spacer(),
                        Text('${_listMedicine[index].howToUsing}',
                            style: TextStyle(
                                color: DefaultTheme.BLACK_BUTTON,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        Padding(
                          padding: EdgeInsets.only(right: 30),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    //end of list
                    if (index == _listMedicine.length - 1)
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                    if (index != _listMedicine.length - 1)
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        child: Divider(
                          color: DefaultTheme.GREY_TEXT,
                          height: 0.1,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ),
    Padding(
      padding: EdgeInsets.only(bottom: 20),
    ),
    Container(
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          color: DefaultTheme.GREY_BUTTON,
          borderRadius: BorderRadius.circular(10)),
      child: ButtonHDr(
        style: BtnStyle.BUTTON_IN_LIST,
        label: 'Xem lịch sử đơn thuốc',
        image: Image.asset('assets/images/ic-medicine.png'),
        onTap: () {
          Navigator.of(context).pushNamed(RoutesHDr.HISTORY_PRESCRIPTION);
        },
      ),
    ),
    Padding(
      padding: EdgeInsets.only(bottom: 20),
    )
  ]);
}

final Shader _normalHealthColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_1,
    DefaultTheme.GRADIENT_2,
  ],
).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 90.0));
