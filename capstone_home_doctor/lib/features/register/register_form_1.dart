import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';

class RegisterPage1 extends StatefulWidget {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  RegisterPage1(
      {Key key,
      this.usernameController,
      this.passwordController,
      this.passwordConfirmController})
      : super(key: key);

  @override
  _RegisterPage1State createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: DefaultTheme.GREY_VIEW),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
              'Thông tin tài khoản',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10, top: 10),
            decoration: BoxDecoration(
              color: DefaultTheme.GREY_VIEW,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                // Divider(
                //   height: 1,
                //   color: DefaultTheme.GREY_TOP_TAB_BAR,
                // ),
                TextFieldHDr(
                  style: TFStyle.NO_BORDER,
                  label: 'Tên đăng nhập*:',
                  placeHolder: 'username123',
                  label_text_width: 180,
                  inputType: TFInputType.TF_TEXT,
                  controller: widget.usernameController,
                  keyboardAction: TextInputAction.next,
                  onChange: (text) {},
                ),
                Divider(
                  height: 1,
                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                ),
                TextFieldHDr(
                  style: TFStyle.NO_BORDER,
                  label: 'Mật khẩu*:',
                  label_text_width: 180,
                  placeHolder: '••••••',
                  inputType: TFInputType.TF_PASSWORD,
                  controller: widget.passwordController,
                  keyboardAction: TextInputAction.next,
                  onChange: (text) {},
                ),
                Divider(
                  height: 1,
                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                ),
                TextFieldHDr(
                  style: TFStyle.NO_BORDER,
                  label: 'Xác nhận mật khẩu*:',
                  label_text_width: 180,
                  placeHolder: '••••••',
                  inputType: TFInputType.TF_PASSWORD,
                  controller: widget.passwordConfirmController,
                  keyboardAction: TextInputAction.done,
                  onChange: (text) {},
                ),

                // Divider(
                //   height: 1,
                //   color: DefaultTheme.GREY_TOP_TAB_BAR,
                // ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
            decoration: BoxDecoration(
              color: DefaultTheme.GREY_VIEW,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('Các thông tin có dấu * là bắt buộc.'),
          ),
        ],
      ),
    );
  }
}
