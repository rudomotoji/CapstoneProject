import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/features/home/home.dart';
import 'package:flutter/material.dart';

class OverviewTab extends StatefulWidget {
  @override
  _OverviewTabState createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 60,
          height: 150,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: DefaultTheme.GREY_LIGHT.withOpacity(0.4),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
            color: DefaultTheme.WHITE,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  'BMI',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  //
                  Container(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    height: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: DefaultTheme.BLUE_REFERENCE
                                    .withOpacity(0.8),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Thiếu cân'),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: DefaultTheme.GRADIENT_1.withOpacity(0.8),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Bình thường'),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color:
                                    DefaultTheme.RED_CALENDAR.withOpacity(0.8),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Thừa cân'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    height: 110,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 2,
                            decoration: BoxDecoration(
                              color: DefaultTheme.GRADIENT_1.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          Text(
                            '21.5',
                            style: TextStyle(
                                color: DefaultTheme.BLACK,
                                fontSize: 30,
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          Text(
                            'kg/m2',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        //
        Padding(
          padding: EdgeInsets.only(bottom: 10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 25),
            ),
            Container(
              width: (MediaQuery.of(context).size.width - 60) / 2,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 120,
                    width: (MediaQuery.of(context).size.width - 60 - 10) / 2,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: DefaultTheme.GREY_LIGHT.withOpacity(0.4),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                      color: DefaultTheme.WHITE,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                'Giới tính',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              alignment: Alignment.bottomRight,
                              padding: EdgeInsets.only(right: 20, top: 10),
                              child: Text(
                                'Nam',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/images/ic-male.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Container(
                    height: 120,
                    width: (MediaQuery.of(context).size.width - 60 - 10) / 2,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: DefaultTheme.GREY_LIGHT.withOpacity(0.4),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                      color: DefaultTheme.WHITE,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Text(
                            'Cân nặng',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 0, top: 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '61',
                                    style: TextStyle(
                                      fontFamily: 'NewYork',
                                      color: DefaultTheme.GREY_TEXT
                                          .withOpacity(0.5),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(left: 5, right: 3, top: 8),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '62',
                                    style: TextStyle(
                                      fontFamily: 'NewYork',
                                      color: DefaultTheme.GREY_TEXT,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: DefaultTheme.RED_CALENDAR
                                      .withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    '63',
                                    style: TextStyle(
                                      fontFamily: 'NewYork',
                                      color: DefaultTheme.WHITE,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(left: 3, right: 5, top: 8),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '64',
                                    style: TextStyle(
                                      fontFamily: 'NewYork',
                                      color: DefaultTheme.GREY_TEXT,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 0, top: 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '65',
                                    style: TextStyle(
                                      fontFamily: 'NewYork',
                                      color: DefaultTheme.GREY_TEXT
                                          .withOpacity(0.5),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Container(
              width: (MediaQuery.of(context).size.width - 60 - 10) / 2,
              height: 250,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: DefaultTheme.GREY_LIGHT.withOpacity(0.4),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
                color: DefaultTheme.WHITE,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      'Chiều cao',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
