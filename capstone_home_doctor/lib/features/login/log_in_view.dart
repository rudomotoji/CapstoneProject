import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/login/phone_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'logout.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> with WidgetsBindingObserver {
  final _phoneController = TextEditingController();

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-verify-phone");

  // UserDTO _userDTO = new UserDTO();
  String _phoneNo;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // resizeToAvoidBottomPadding: false,
      backgroundColor: DefaultTheme.WHITE,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Đăng nhập',
              isMainView: true,
            ),
            Padding(padding: const EdgeInsets.only(top: 30)),
            Image.asset(
              'assets/images/logo-home-doctor.png',
              width: 80,
              height: 80,
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 50)),
                  Divider(
                    color: DefaultTheme.GREY_TEXT,
                    height: 0.25,
                  ),
                  TextFieldHDr(
                    style: TFStyle.NO_BORDER,
                    label: 'Số điện thoại',
                    placeHolder: '090 999 9999',
                    maxLength: 11,
                    inputType: TFInputType.TF_PHONE,
                    controller: Provider.of<PhoneAuthDataProvider>(context,
                            listen: false)
                        .phoneNumberController,
                    keyboardAction: TextInputAction.next,
                    onChange: (text) {
                      setState(() {
                        _phoneNo = text;
                        if (text.toString().isEmpty) {
                          _phoneNo = null;
                        }
                      });
                    },
                  ),
                  Divider(
                    color: DefaultTheme.GREY_TEXT,
                    height: 0.25,
                  ),
                ],
              ),
            ),
            if (_phoneNo != null)
              (ButtonHDr(
                style: BtnStyle.BUTTON_GREY,
                label: 'Tiếp theo',
                onTap: () {
                  // Navigator.pushReplacementNamed(context, RoutesHDr.MAIN_HOME);
                  startPhoneAuth();
                  // Navigator.pushNamed(context, RoutesHDr.CONFIRM_LOG_IN,
                  //     arguments: {'PHONE_NUMBER': _phoneNo});
                },
              )),
            Padding(padding: EdgeInsets.only(top: 20)),
            Text(
              'Powered by HomeDoctor',
              style: TextStyle(
                color: DefaultTheme.GREY_TEXT,
                fontSize: 12,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
          ],
        ),
      ),
    );
  }

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
      duration: Duration(seconds: 2),
    );
//    if (mounted) Scaffold.of(context).showSnackBar(snackBar);
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  startPhoneAuth() async {
    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);

    phoneAuthDataProvider.loading = true;
    bool validPhone = await phoneAuthDataProvider.instantiate(
        dialCode: '+84',
        onCodeSent: () {
          Navigator.pushNamed(context, RoutesHDr.CONFIRM_LOG_IN);
        },
        onFailed: () {
          _showSnackBar(phoneAuthDataProvider.message);
        },
        onError: () {
          _showSnackBar(phoneAuthDataProvider.message);
        });
    if (!validPhone) {
      print(Provider.of<PhoneAuthDataProvider>(context, listen: false)
          .phoneNumberController
          .text);
      phoneAuthDataProvider.loading = false;
      _showSnackBar("Oops! Number seems invaild");
      return;
    }
  }
}
