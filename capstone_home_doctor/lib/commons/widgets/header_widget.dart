import 'package:capstone_home_doctor/commons/constants/numeral.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final bool isAuthenticated;
  final bool isMainView;

  //status: not Done yet.

  //rerange header case.

  HeaderWidget({this.title, this.isAuthenticated, this.isMainView});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: DefaultNumeral.DEFAULT_HEADER_SIZE,
      child: Row(
        children: [
          if (!isMainView)
            (InkWell(
              splashColor: DefaultTheme.TRANSPARENT,
              highlightColor: DefaultTheme.TRANSPARENT,
              onTap: () {
                //pop
                //Navigator.pop(context);
                print('Do pop');
              },
              child: Image.asset(
                'lib/assets/images/ic-pop.png',
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
          if (isAuthenticated)
            (Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    splashColor: DefaultTheme.TRANSPARENT,
                    highlightColor: DefaultTheme.TRANSPARENT,
                    onTap: () {
                      //for notification navtigator
                      print('Press Notification');
                    },
                    child: Image.asset(
                      'lib/assets/images/ic-notification.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
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
                        child:
                            Image.asset('lib/assets/images/avatar-default.jpg'),
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
