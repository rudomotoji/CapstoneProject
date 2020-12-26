import 'package:capstone_home_doctor/commons/constants/theme.dart';
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
      resizeToAvoidBottomPadding: false,
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
              'lib/assets/images/logo-home-doctor.png',
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
                  TextFieldHomeDoctor(
                    // textfieldStyle: TextFieldStyleHDr.BORDERED,
                    label: 'Tên đăng nhập',
                    hintText: 'your_username',
                    buttonKeyboardAction: TextInputAction.next,
                    controller: _usernameController,
                    onChange: (text) {
                      _userDTO.id = text;
                    },
                  ),
                  Divider(
                    color: DefaultTheme.GREY_TEXT,
                    height: 0.25,
                  ),
                  TextFieldHomeDoctor(
                    isObsecure: true,
                    label: 'Mật khẩu',
                    hintText: '•••••••••',
                    controller: _passwordController,
                  ),
                  Divider(
                    color: DefaultTheme.GREY_TEXT,
                    height: 0.25,
                  ),
                  TextFieldHomeDoctor(),
                  ButtonHomeDoctor(
                    onTap: () {
                      print('sample');
                    },
                  ),
                ],
              ),
            ),
            ButtonHomeDoctor(
              text: 'Quên mật khẩu?',
              height: 2,
              width: 100,
              textColor: DefaultTheme.BLACK,
              buttonStyle: ButtonStyleHDr.BUTTON_TRANSPARENT,
              onTap: () {},
            ),
            ButtonHomeDoctor(
              text: 'Đăng nhập',
              onTap: () {},
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            ButtonHomeDoctor(
              buttonStyle: ButtonStyleHDr.BUTTON_GREY,
              text: 'Đăng kí',
              onTap: () {},
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
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
