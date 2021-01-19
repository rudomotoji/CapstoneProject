import 'package:capstone_home_doctor/commons/constants/numeral_ui.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:flutter/material.dart';

enum ButtonHeaderType {
  NONE,
  AVATAR,
  NEW_MESSAGE,
  DETAIL,
}

class HeaderWidget extends StatelessWidget {
  final String title;
  ButtonHeaderType buttonHeaderType;
  bool isMainView;

  HeaderWidget({this.title, this.buttonHeaderType, this.isMainView});

  @override
  Widget build(BuildContext context) {
    if (buttonHeaderType == null) {
      buttonHeaderType = ButtonHeaderType.NONE;
    }
    return Padding(
      padding: DefaultNumeralUI.HEADER_SIZE,
      child: Row(
        children: [
          if (!isMainView)
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
          if (!isMainView)
            (Padding(
              padding: EdgeInsets.only(left: 20),
            )),
          Text(
            '${title}',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: DefaultTheme.BLACK,
            ),
          ),
          if (buttonHeaderType == ButtonHeaderType.DETAIL)
            (Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  InkWell(
                    splashColor: DefaultTheme.TRANSPARENT,
                    highlightColor: DefaultTheme.TRANSPARENT,
                    onTap: () {
                      //for notification navtigator
                      print('Press Detail Button');
                    },
                    child: Image.asset(
                      'assets/images/ic-detail.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            )),
          if (buttonHeaderType == ButtonHeaderType.NEW_MESSAGE)
            (Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  InkWell(
                    splashColor: DefaultTheme.TRANSPARENT,
                    highlightColor: DefaultTheme.TRANSPARENT,
                    onTap: () {
                      //for notification navtigator
                      print('Press New Msg Button');
                    },
                    child: Image.asset(
                      'assets/images/ic-new-msg.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            )),
          if (buttonHeaderType == ButtonHeaderType.AVATAR)
            (Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  InkWell(
                    splashColor: DefaultTheme.TRANSPARENT,
                    highlightColor: DefaultTheme.TRANSPARENT,
                    onTap: () {
                      //for personal view nav
                      print('Press avatar');
                    },
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
}
