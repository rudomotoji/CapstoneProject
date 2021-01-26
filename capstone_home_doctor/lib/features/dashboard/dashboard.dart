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
        Padding(
          padding: EdgeInsets.only(top: 20),
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
    ));
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
