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
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
              'Thông tin tài khoản',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          TextFieldHDr(
            style: TFStyle.BORDERED,
            label: 'Tên đăng nhập(*):',
            placeHolder: 'abc123',
            inputType: TFInputType.TF_TEXT,
            controller: widget.usernameController,
            keyboardAction: TextInputAction.done,
            onChange: (text) {},
          ),
          TextFieldHDr(
            style: TFStyle.BORDERED,
            label: 'Mật khẩu(*):',
            placeHolder: '',
            inputType: TFInputType.TF_PASSWORD,
            controller: widget.passwordController,
            keyboardAction: TextInputAction.done,
            onChange: (text) {},
          ),
          TextFieldHDr(
            style: TFStyle.BORDERED,
            label: 'Nhập lại mật khẩu(*):',
            placeHolder: '',
            inputType: TFInputType.TF_PASSWORD,
            controller: widget.passwordConfirmController,
            keyboardAction: TextInputAction.done,
            onChange: (text) {},
          ),
        ],
      ),
    );
  }
}
