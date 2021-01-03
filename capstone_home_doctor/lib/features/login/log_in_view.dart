import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/models/user_dto.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> with WidgetsBindingObserver {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  UserDTO _userDTO = new UserDTO();

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
      // resizeToAvoidBottomPadding: false,
      backgroundColor: DefaultTheme.WHITE,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Đăng nhập',
              isAuthenticated: false,
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
                  TextFieldHDr2(
                    label: 'VN +84',
                    hintText: 'Số điện thoại',
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    buttonKeyboardAction: TextInputAction.next,
                    controller: _usernameController,
                    onChange: (text) {
                      setState(() {
                        _userDTO.phoneNo = text;
                        if (text.toString().isEmpty) {
                          _userDTO.phoneNo = null;
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
            if (_userDTO.phoneNo != null)
              (ButtonHDr(
                label: 'Tiếp theo',
                onTap: () {},
              )),
            Padding(padding: EdgeInsets.only(top: 10)),
            ButtonHDr(
              style: BtnStyle.BUTTON_GREY,
              label: 'Đăng kí tài khoản mới',
              onTap: () {
                print(_userDTO.phoneNo);
                Navigator.pushNamed(context, RoutesHDr.REGISTER);
              },
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
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
}
