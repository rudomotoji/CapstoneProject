import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';

class RegisterPage3 extends StatefulWidget {
  TextEditingController familyController = TextEditingController();
  TextEditingController patientController = TextEditingController();

  RegisterPage3({
    Key key,
    this.familyController,
    this.patientController,
  }) : super(key: key);

  @override
  _RegisterPage3State createState() => _RegisterPage3State();
}

class _RegisterPage3State extends State<RegisterPage3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          // Container(
          //   margin: EdgeInsets.only(bottom: 20),
          //   child: Text(
          //     'Tiền sử bệnh án',
          //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          //   ),
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 10, top: 20),
                  child: Text(
                    'Tiền sử bệnh án của gia đình',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: DefaultTheme.BLACK_BUTTON,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
              ),
              TextFieldHDr(
                style: TFStyle.TEXT_AREA,
                placeHolder:
                    'Mô tả thông tin bệnh lý liên quan của các thành viên trong gia đình (nếu có).',
                maxLength: 5,
                inputType: TFInputType.TF_TEXT,
                controller: widget.familyController,
                keyboardAction: TextInputAction.done,
                onChange: (text) {},
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 10, top: 20),
                  child: Text(
                    'Tiền sử bệnh án của gia đình',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: DefaultTheme.BLACK_BUTTON,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
              ),
              TextFieldHDr(
                style: TFStyle.TEXT_AREA,
                placeHolder: '',
                maxLength: 5,
                inputType: TFInputType.TF_TEXT,
                controller: widget.patientController,
                keyboardAction: TextInputAction.done,
                onChange: (text) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
