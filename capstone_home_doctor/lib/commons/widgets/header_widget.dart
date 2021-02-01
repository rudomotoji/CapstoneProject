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
                      width: 40,
                      height: 40,
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
                      width: 40,
                      height: 40,
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
                      width: 40,
                      height: 40,
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
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                color: DefaultTheme.GREY_VIEW,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //avt here
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CircleAvatar(
                          radius: 30,
                          child: ClipOval(
                            child:
                                Image.asset('assets/images/avatar-default.jpg'),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            width: MediaQuery.of(context).size.width - 150,
                            child: Text(
                              'Nguyễn Văn A',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: DefaultTheme.BLACK,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5, top: 3),
                            width: MediaQuery.of(context).size.width - 150,
                            child: Text(
                              '090 999 9999',
                              style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 25),
                  ),
                  //
                  Divider(
                    color: DefaultTheme.GREY_TEXT,
                    height: 0.1,
                  ),
                  ButtonHDr(
                    style: BtnStyle.BUTTON_IN_LIST,
                    labelColor: DefaultTheme.BLUE_TEXT,
                    label: 'Thông tin tài khoản',
                    isLabelLeft: true,
                    onTap: () {},
                  ),
                  Divider(
                    color: DefaultTheme.GREY_TEXT,
                    height: 0.1,
                  ),
                  ButtonHDr(
                    style: BtnStyle.BUTTON_IN_LIST,
                    labelColor: DefaultTheme.BLUE_TEXT,
                    label: 'Thiết bị đeo',
                    isLabelLeft: true,
                    onTap: () {},
                  ),
                  Divider(
                    color: DefaultTheme.GREY_TEXT,
                    height: 0.1,
                  ),
                  ButtonHDr(
                    style: BtnStyle.BUTTON_IN_LIST,
                    labelColor: DefaultTheme.BLUE_TEXT,
                    label: 'Hợp đồng',
                    isLabelLeft: true,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, RoutesHDr.MANAGE_CONTRACT);
                    },
                  ),
                  Divider(
                    color: DefaultTheme.GREY_TEXT,
                    height: 0.1,
                  ),
                  ButtonHDr(
                    style: BtnStyle.BUTTON_IN_LIST,
                    labelColor: DefaultTheme.BLUE_TEXT,
                    label: 'Gói dịch vụ',
                    isLabelLeft: true,
                    onTap: () {},
                  ),
                  Divider(
                    color: DefaultTheme.GREY_TEXT,
                    height: 0.1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Divider(
                          color: DefaultTheme.GREY_TEXT,
                          height: 0.1,
                        ),
                        ButtonHDr(
                          style: BtnStyle.BUTTON_IN_LIST,
                          labelColor: DefaultTheme.RED_TEXT,
                          label: 'Đóng cửa sổ',
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Divider(
                          color: DefaultTheme.GREY_TEXT,
                          height: 0.1,
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
                          height: 0.1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
