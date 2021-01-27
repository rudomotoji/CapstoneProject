import 'package:capstone_home_doctor/commons/constants/terminology.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/artboard_button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VitalSignTab extends StatefulWidget {
  @override
  _VitalSignTabState createState() => _VitalSignTabState();
}

class _VitalSignTabState extends State<VitalSignTab> {
  final PeripheralHelper peripheralHelper = PeripheralHelper();
  //
  Widget _thisView = Container();
  Future<void> _launchURL;

  @override
  void initState() {
    super.initState();
    peripheralHelper.isPeripheralConnected().then((value) {
      setState(() {
        print('Value of peripheral connect: ${value}');
        if (value) {
          _thisView = _ConnectedtDevice();
        } else {
          _thisView = _NotConnectDevice();
        }
      });
    });
  }

  //launch URL
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  //megazine
  Widget _VitalSignMegazine() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tìm hiểu thêm về sinh hiệu',
              style: TextStyle(
                color: DefaultTheme.BLACK,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: DefaultTheme.GREY_BUTTON),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text(
                    Terminology.VITAL_SIGN,
                    style: TextStyle(
                      wordSpacing: 0.2,
                      color: DefaultTheme.BLACK_BUTTON,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: InkWell(
                        child: Text(
                          'Theo Vinmec, xem tiếp',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: DefaultTheme.BLUE_REFERENCE,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () => setState(() {
                          _launchURL =
                              _launchInBrowser(Terminology.VITAL_SIGN_URL);
                        }),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
      ],
    );
  }

  //If peripheral is not connect
  Widget _NotConnectDevice() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Text(
                    'Gợi ý',
                    style: TextStyle(
                      color: DefaultTheme.BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Hiện tại chưa có thiết bị kết nối',
                    style: TextStyle(
                      color: DefaultTheme.GREY_TEXT,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              )),
        ),
        ButtonArtBoard(
          title: 'Kết nối thiết bị',
          description: 'Dữ liệu được đồng bộ qua thiết bị đeo',
          imageAsset: 'assets/images/ic-connect-p.png',
          onTap: () {
            Navigator.pushNamed(context, RoutesHDr.INTRO_CONNECT_PERIPHERAL);
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Danh mục',
              style: TextStyle(
                color: DefaultTheme.BLACK,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: DefaultTheme.GREY_BUTTON),
            child: Column(
              children: <Widget>[
                ButtonHDr(
                  style: BtnStyle.BUTTON_IN_LIST,
                  label: 'Nhịp tim',
                  image: Image.asset('assets/images/ic-heart-rate.png'),
                  onTap: () {
                    // startPhoneAuth();
                  },
                ),
                ButtonHDr(
                  style: BtnStyle.BUTTON_IN_LIST,
                  label: 'Huyết áp',
                  image: Image.asset('assets/images/ic-blood-pressure.png'),
                  onTap: () {
                    // startPhoneAuth();
                  },
                ),
                ButtonHDr(
                  style: BtnStyle.BUTTON_IN_LIST,
                  label: 'Oxy trong máu',
                  image: Image.asset('assets/images/ic-spo2.png'),
                  onTap: () {
                    // startPhoneAuth();
                  },
                ),
                ButtonHDr(
                  style: BtnStyle.BUTTON_IN_LIST,
                  label: 'Tần số hô hấp',
                  image: Image.asset('assets/images/ic-oxy.png'),
                  onTap: () {
                    // startPhoneAuth();
                  },
                ),
                ButtonHDr(
                  style: BtnStyle.BUTTON_IN_LIST,
                  label: 'Nhiệt độ cơ thể',
                  image: Image.asset('assets/images/ic-tempurature.png'),
                  onTap: () {
                    // startPhoneAuth();
                  },
                ),
              ],
            ),
          ),
        ),
        _VitalSignMegazine(),
      ],
    );
  }

  //If peripheral is connected
  Widget _ConnectedtDevice() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Trong thiết bị đeo',
              style: TextStyle(
                color: DefaultTheme.BLACK,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Khác',
              style: TextStyle(
                color: DefaultTheme.BLACK,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        _VitalSignMegazine(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _thisView;
  }
}
