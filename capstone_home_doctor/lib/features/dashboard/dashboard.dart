import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/artboard_button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:barcode_scan/barcode_scan.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> with WidgetsBindingObserver {
  var _index = 0;
  var location;
  var _idDoctorController = TextEditingController();
  String _idDoctor = '';

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        HeaderWidget(
          title: 'Trang chủ',
          isMainView: true,
          buttonHeaderType: ButtonHeaderType.AVATAR,
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(left: 20, right: 20),
            children: <Widget>[
              _showSuggestionDashboard(),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Trạng thái',
                      style: TextStyle(
                        color: DefaultTheme.BLACK,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    ButtonHDr(
                      style: BtnStyle.BUTTON_TRANSPARENT,
                      label: 'Xem tổng quan',
                      labelColor: DefaultTheme.BLUE_REFERENCE,
                      width: 40,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              _showStatusOverview(),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Lịch',
                      style: TextStyle(
                        color: DefaultTheme.BLACK,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    ButtonHDr(
                      style: BtnStyle.BUTTON_TRANSPARENT,
                      label: 'Chi tiết',
                      labelColor: DefaultTheme.BLUE_REFERENCE,
                      width: 40,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              _showCalendarOverview(),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Lần đo gần đây',
                  style: TextStyle(
                    color: DefaultTheme.BLACK,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              //_showLastMeasurement(),
            ],
          ),
        ),

        //   Align(
        //     alignment: Alignment.topCenter,
        //     child: Container(
        //       margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.stretch,
        //         children: [
        //           Container(
        //             height: 23,
        //             child: Row(
        //               crossAxisAlignment: CrossAxisAlignment.stretch,
        //               children: [
        //                 Align(
        //                   alignment: Alignment.topLeft,
        //                   child: Text(
        //                     "Trạng thái cá nhân",
        //                     textAlign: TextAlign.left,
        //                     style: TextStyle(
        //                       color: DefaultTheme.GREY_TEXT,
        //                       fontFamily: "",
        //                       fontWeight: FontWeight.w400,
        //                       fontSize: 20,
        //                     ),
        //                   ),
        //                 ),
        //                 Spacer(),
        //                 InkWell(
        //                   onTap: () {},
        //                   child: Align(
        //                     alignment: Alignment.topLeft,
        //                     child: Container(
        //                       margin: EdgeInsets.only(top: 1),
        //                       child: Text(
        //                         "Xem tổng quan",
        //                         textAlign: TextAlign.right,
        //                         style: TextStyle(
        //                           color: DefaultTheme.GREY_TEXT,
        //                           fontFamily: "",
        //                           fontWeight: FontWeight.w400,
        //                           fontSize: 15,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Align(
        //             alignment: Alignment.topLeft,
        //             child: Container(
        //               margin: EdgeInsets.only(top: 1),
        //               child: Text(
        //                 "Some description here",
        //                 textAlign: TextAlign.left,
        //                 style: TextStyle(
        //                   color: DefaultTheme.GREY_TEXT,
        //                   fontFamily: "",
        //                   fontWeight: FontWeight.w400,
        //                   fontSize: 15,
        //                 ),
        //               ),
        //             ),
        //           ),
        //           Align(
        //             alignment: Alignment.topLeft,
        //             child: Text(
        //               "Không có dấu hiệu/Nhịp tim bất thường….",
        //               textAlign: TextAlign.left,
        //               style: TextStyle(
        //                 color: DefaultTheme.GREY_TEXT,
        //                 fontFamily: "",
        //                 fontWeight: FontWeight.w400,
        //                 fontSize: 15,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        //   Align(
        //     alignment: Alignment.topCenter,
        //     child: Container(
        //       margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.stretch,
        //         children: [
        //           Container(
        //             height: 23,
        //             margin: EdgeInsets.only(left: 1, right: 2),
        //             child: Row(
        //               crossAxisAlignment: CrossAxisAlignment.stretch,
        //               children: [
        //                 Align(
        //                   alignment: Alignment.topLeft,
        //                   child: Text(
        //                     "Lịch theo chu kì",
        //                     textAlign: TextAlign.left,
        //                     style: TextStyle(
        //                       color: DefaultTheme.GREY_TEXT,
        //                       fontFamily: "",
        //                       fontWeight: FontWeight.w400,
        //                       fontSize: 20,
        //                     ),
        //                   ),
        //                 ),
        //                 Spacer(),
        //                 Align(
        //                   alignment: Alignment.topLeft,
        //                   child: Container(
        //                     margin: EdgeInsets.only(top: 5),
        //                     child: Text(
        //                       "Xem lịch",
        //                       textAlign: TextAlign.right,
        //                       style: TextStyle(
        //                         color: DefaultTheme.GREY_TEXT,
        //                         fontFamily: "",
        //                         fontWeight: FontWeight.w400,
        //                         fontSize: 15,
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Align(
        //             alignment: Alignment.topCenter,
        //             child: Container(
        //               padding: EdgeInsets.all(16),
        //               margin: EdgeInsets.only(top: 8),
        //               decoration: BoxDecoration(
        //                 color: DefaultTheme.GREY_VIEW,
        //                 borderRadius: BorderRadius.all(Radius.circular(5)),
        //               ),
        //               child: Column(
        //                 children: [
        //                   rowMedicalSchedule('thuốc số 1', '12:00', 'Mỗi ngày'),
        //                   rowMedicalSchedule('thuốc số 2', '12:00', 'Mỗi ngày'),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        //   Align(
        //     alignment: Alignment.topLeft,
        //     child: Container(
        //       margin: EdgeInsets.fromLTRB(20, 23, 20, 0),
        //       child: Column(
        //         children: [
        //           Align(
        //             alignment: Alignment.topLeft,
        //             child: Text(
        //               "Lần đo cuối",
        //               textAlign: TextAlign.left,
        //               style: TextStyle(
        //                 color: DefaultTheme.GREY_TEXT,
        //                 fontFamily: "",
        //                 fontWeight: FontWeight.w400,
        //                 fontSize: 20,
        //               ),
        //             ),
        //           ),
        //           rowMonitor(),
        //           rowMonitor(),
        //         ],
        //       ),
        //     ),
        //   ),
      ],
    ));
  }

  rowMonitor() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: DefaultTheme.GREY_VIEW,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 20,
            margin: EdgeInsets.only(left: 9, top: 6, right: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: DefaultTheme.GREY_TEXT,
                    ),
                    child: Container(),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 13, top: 1),
                    child: Text(
                      "Huyết áp",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: DefaultTheme.GREY_TEXT,
                        fontFamily: "",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 1),
                    child: Text(
                      "12:30",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: DefaultTheme.GREY_TEXT,
                        fontFamily: "",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: 42, top: 1),
              child: Text(
                "120/81 mmHg",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: DefaultTheme.GREY_TEXT,
                  fontFamily: "",
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: 42),
              child: Text(
                "Chi tiết",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: DefaultTheme.GREY_TEXT,
                  fontFamily: "",
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  rowMedicalSchedule(String nameMedical, String time, String timeLoop) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 15,
            height: 15,
            margin: EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: DefaultTheme.GREY_TEXT,
            ),
            child: Container(),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              nameMedical,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: DefaultTheme.GREY_TEXT,
                fontFamily: "",
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Text(
              time,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: DefaultTheme.GREY_TEXT,
                fontFamily: "",
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            timeLoop,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: DefaultTheme.GREY_TEXT,
              fontFamily: "",
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  final Shader _normalHealthColors = LinearGradient(
    colors: <Color>[
      DefaultTheme.GRADIENT_1,
      DefaultTheme.GRADIENT_2,
    ],
  ).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 90.0));

  _showLastMeasurement() {}

  _showSuggestionDashboard() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Gợi ý',
              style: TextStyle(
                color: DefaultTheme.BLACK,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        ButtonArtBoard(
          title: 'Yêu cầu hợp đồng',
          description: 'Quét QR hoặc nhập ID kết nối với bác sĩ',
          imageAsset: 'assets/images/ic-contract.png',
          onTap: () async {
            _chooseStepContract();
          },
        ),
      ],
    );
  }

  _showCalendarOverview() {
    return Center(
      child: SizedBox(
        height: 200,
        child: PageView.builder(
          itemCount: 2,
          controller: PageController(viewportFraction: 0.95),
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              scale: i == _index ? 1 : 0.9,
              child: Card(
                elevation: 0,
                color: DefaultTheme.GREY_VIEW,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: (i == 0)
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 10, top: 20),
                            child: Text(
                              'Lịch tái khám',
                              style: TextStyle(
                                  color: DefaultTheme.RED_CALENDAR,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ),
                          Divider(
                            height: 0.25,
                            color: DefaultTheme.GREY_TEXT,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Hiện không có lịch tái khám',
                              style: TextStyle(color: DefaultTheme.GREY_TEXT),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 10, top: 20),
                            child: Text(
                              'Lịch dùng thuốc',
                              style: TextStyle(
                                  color: DefaultTheme.RED_CALENDAR,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ),
                          Divider(
                            height: 0.25,
                            color: DefaultTheme.GREY_TEXT,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Hiện không có lịch dùng thuốc',
                              style: TextStyle(color: DefaultTheme.GREY_TEXT),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  _showStatusOverview() {
    //change color and text color if else status patient and call it
    return SizedBox(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: DefaultTheme.GREY_BUTTON,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: SizedBox(
                width: 25,
                height: 25,
                child: Image.asset('assets/images/ic-health-selected.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Sinh hiệu bình thường',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    foreground: Paint()..shader = _normalHealthColors),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopUpConfirmPrivacy(String codeScanned) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height - 300,
                decoration: BoxDecoration(
                  color: DefaultTheme.WHITE.withOpacity(0.6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Xác nhận quyền riêng tư',
                          style: TextStyle(
                            fontSize: 25,
                            decoration: TextDecoration.none,
                            color: DefaultTheme.BLACK,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Đây là một số mô tả về quyền riêng tư khi xác nhận ghép nối hợp đồng. Bác sĩ truy cập các thông tin, về các điều kiện của gói dịch vụ.',
                              style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.none,
                                color: DefaultTheme.GREY_TEXT,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ButtonHDr(
                      style: BtnStyle.BUTTON_BLACK,
                      label: 'Đồng ý',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, RoutesHDr.CONFIRM_CONTRACT,
                            arguments: codeScanned);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    ButtonHDr(
                      style: BtnStyle.BUTTON_GREY,
                      label: 'Huỷ ghép nối',
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPopUpIDDoctor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                      padding: EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Nhập ID Bác Sĩ',
                          style: TextStyle(
                            fontSize: 25,
                            decoration: TextDecoration.none,
                            color: DefaultTheme.BLACK,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'ID Bác sĩ là một mã định danh giúp bệnh nhân dễ dàng ghép nối với bác sĩ thông qua hợp đồng',
                              style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.none,
                                color: DefaultTheme.GREY_TEXT,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TEXT,
                            height: 0.25,
                          ),
                          Flexible(
                            child: TextFieldHDr(
                              style: TFStyle.NO_BORDER,
                              label: 'ID:',
                              controller: _idDoctorController,
                              keyboardAction: TextInputAction.done,
                              onChange: (text) {
                                setState(() {
                                  _idDoctor = text;
                                });
                              },
                            ),
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TEXT,
                            height: 0.25,
                          ),
                        ],
                      ),
                    ),
                    ButtonHDr(
                      style: BtnStyle.BUTTON_BLACK,
                      label: 'Tiếp theo',
                      onTap: () {
                        Navigator.of(context).pop();
                        _showPopUpConfirmPrivacy(_idDoctor);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _chooseStepContract() {
    showModalBottomSheet(
        isScrollControlled: false,
        context: this.context,
        backgroundColor: Colors.white.withOpacity(0),
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              constraints: BoxConstraints(minWidth: 0, maxWidth: 500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(33.33),
                // borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(33.33),
                //     topRight: Radius.circular(33.33)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //       top: MediaQuery.of(context).size.height * 0.05),
                  // ),
                  Spacer(),
                  Image.asset(
                    'assets/images/ic-contract.png',
                    height: MediaQuery.of(context).size.height * 0.20,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(70, 20, 70, 0),
                    child: Text(
                      'Quét Mã QR hoặc nhập ID của bác sĩ để yêu cầu tạo hợp đồng',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
                  Spacer(),
                  ButtonHDr(
                    style: BtnStyle.BUTTON_BLACK,
                    label: 'Quét Mã QR',
                    onTap: () async {
                      String codeScanner = await BarcodeScanner.scan();
                      if (codeScanner != null) {
                        Navigator.of(context).pop();
                        _showPopUpConfirmPrivacy(codeScanner);
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  ButtonHDr(
                    style: BtnStyle.BUTTON_GREY,
                    label: 'Nhập ID Bác sĩ',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showPopUpIDDoctor();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    var position = await Geolocator.getCurrentPosition();
    setState(() {
      location = position;
    });
  }
}
