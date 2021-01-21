import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:barcode_scan/barcode_scan.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  var location;

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Row(
    //     children: [
    //       FlatButton(
    //         child: Text('get location'),
    //         onPressed: () {
    //           _determinePosition();
    //         },
    //       ),
    //       location != null
    //           ? Text(location.latitude.toString() +
    //               ' - ' +
    //               location.longitude.toString())
    //           : Text(''),
    //     ],
    //   ),
    // );
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
        InkWell(
          onTap: () async {
            //
            String codeScanner = await BarcodeScanner.scan();
            if (codeScanner != null) {
              _onButtonShowModelSheet(codeScanner);
            }
          },
          child: Container(
            padding: EdgeInsets.only(left: 20),
            width: MediaQuery.of(context).size.width - 40,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xffEEEFF3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/ic-scan-qr.png',
                    width: 35,
                    height: 35,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width - 40 - 150,
                      child: Text(
                        'Quét hợp đồng',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15, top: 3),
                      width: MediaQuery.of(context).size.width - 40 - 150,
                      child: Text(
                        'Quét mã QR Code để kết nối với bác sĩ',
                        style: TextStyle(color: Color(0xFF888888)),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/ic-navigator.png',
                    width: 20,
                    height: 20,
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  void _onButtonShowModelSheet(String codeScanned) {
    showModalBottomSheet(
        isScrollControlled: false,
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ButtonHDr(
                    style: BtnStyle.BUTTON_BLACK,
                    label: 'Đồng ý ghép nối',
                    onTap: () {
                      Navigator.pushNamed(context, RoutesHDr.CONFIRM_CONTRACT,
                          arguments: codeScanned);
                    },
                  ),
                  ButtonHDr(
                    style: BtnStyle.BUTTON_GREY,
                    label: 'Huỷ ghép nối',
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context,
                          RoutesHDr.MAIN_HOME, (Route<dynamic> route) => false);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 100),
                  )
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
