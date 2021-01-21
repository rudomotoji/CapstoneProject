import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/numeral_ui.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/features/login/phone_auth.dart';
import 'package:flutter/material.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:provider/provider.dart';

enum ButtonHeaderType {
  NONE,
  AVATAR,
  NEW_MESSAGE,
  DETAIL,
  BACK_HOME,
}

class HeaderWidget extends StatefulWidget {
  BuildContext context;
  final String title;
  ButtonHeaderType buttonHeaderType;
  bool isMainView;
  final VoidCallback onTapButton;

  HeaderWidget({
    Key key,
    this.context,
    this.title,
    this.buttonHeaderType,
    this.isMainView,
    this.onTapButton,
  }) : super(key: key);

  @override
  _HeaderWidget createState() =>
      _HeaderWidget(title, buttonHeaderType, isMainView);
}

class _HeaderWidget extends State<HeaderWidget> {
  String _title;
  ButtonHeaderType _buttonHeaderType;
  bool _isMainView;

  @override
  _HeaderWidget(
    this._title,
    this._buttonHeaderType,
    this._isMainView,
  );

  @override
  Widget build(BuildContext context) {
    if (_buttonHeaderType == null) {
      _buttonHeaderType = ButtonHeaderType.NONE;
    }
    return Padding(
      padding: DefaultNumeralUI.HEADER_SIZE,
      child: Row(
        children: [
          if (!_isMainView)
            (InkWell(
              splashColor: DefaultTheme.TRANSPARENT,
              highlightColor: DefaultTheme.TRANSPARENT,
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/images/ic-pop.png',
                width: 30,
                height: 30,
              ),
            )),
          if (!_isMainView)
            (Padding(
              padding: EdgeInsets.only(left: 20),
            )),
          Text(
            '${_title}',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: DefaultTheme.BLACK,
            ),
          ),
          if (_buttonHeaderType == ButtonHeaderType.DETAIL)
            (Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  InkWell(
                    splashColor: DefaultTheme.TRANSPARENT,
                    highlightColor: DefaultTheme.TRANSPARENT,
                    onTap: widget.onTapButton,
                    child: Image.asset(
                      'assets/images/ic-detail.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            )),
          if (_buttonHeaderType == ButtonHeaderType.BACK_HOME)
            (Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  InkWell(
                    splashColor: DefaultTheme.TRANSPARENT,
                    highlightColor: DefaultTheme.TRANSPARENT,
                    onTap: _backToHome,
                    child: Image.asset(
                      'assets/images/ic-back-home.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            )),
          if (_buttonHeaderType == ButtonHeaderType.NEW_MESSAGE)
            (Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  InkWell(
                    splashColor: DefaultTheme.TRANSPARENT,
                    highlightColor: DefaultTheme.TRANSPARENT,
                    onTap: widget.onTapButton,
                    child: Image.asset(
                      'assets/images/ic-new-msg.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            )),
          if (_buttonHeaderType == ButtonHeaderType.AVATAR)
            (Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  InkWell(
                    splashColor: DefaultTheme.TRANSPARENT,
                    highlightColor: DefaultTheme.TRANSPARENT,
                    // onTap: () {
                    //   //for personal view nav
                    //   print('Press avatar');
                    // },
                    onTap: _onButtonShowModelSheet,
                    child: CircleAvatar(
                      radius: 16,
                      child: ClipOval(
                        child: Image.asset('assets/images/avatar-default.jpg'),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  _signOut() {
    Provider.of<PhoneAuthDataProvider>(context, listen: false).signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesHDr.LOG_IN, (Route<dynamic> route) => false);
  }

  void _backToHome() {
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesHDr.MAIN_HOME, (Route<dynamic> route) => false);
  }

  void _onButtonShowModelSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Divider(
                    color: DefaultTheme.GREY_TEXT,
                    height: 0.25,
                  ),
                  ButtonHDr(
                    style: BtnStyle.BUTTON_IN_LIST,
                    labelColor: DefaultTheme.RED_TEXT,
                    label: 'Đăng xuất',
                    onTap: () {
                      _signOut();
                    },
                  ),
                  Divider(
                    color: DefaultTheme.GREY_TEXT,
                    height: 0.25,
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
}
