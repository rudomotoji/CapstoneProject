import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter/cupertino.dart';

class NomalInfoView extends StatefulWidget {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController careerController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  List gender;
  String select, dateOfBirth;
  void Function(String) birthday;
  void Function(String) choiceGender;

  NomalInfoView({
    Key key,
    this.fullNameController,
    this.phoneController,
    this.emailController,
    this.addressController,
    this.careerController,
    this.weightController,
    this.heightController,
    this.gender,
    this.select,
    this.birthday,
    this.dateOfBirth,
    this.choiceGender,
  }) : super(key: key);

  @override
  _NomalInfoViewState createState() => _NomalInfoViewState();
}

class _NomalInfoViewState extends State<NomalInfoView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
              'Thông tin cá nhân',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          TextFieldHDr(
            style: TFStyle.BORDERED,
            label: 'Họ tên(*):',
            placeHolder: 'Nguyễn Văn A',
            inputType: TFInputType.TF_TEXT,
            controller: widget.fullNameController,
            keyboardAction: TextInputAction.next,
            onChange: (text) {},
          ),
          TextFieldHDr(
            style: TFStyle.BORDERED,
            label: 'SĐT(*):',
            placeHolder: '123456789',
            inputType: TFInputType.TF_PHONE,
            controller: widget.phoneController,
            keyboardAction: TextInputAction.next,
            onChange: (text) {},
          ),
          Row(
            children: [
              Text('Giới tính:'),
              Row(
                children: <Widget>[
                  addRadioButton(0, 'Nam'),
                  addRadioButton(1, 'Nữ'),
                  addRadioButton(2, 'Khác'),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: DefaultTheme.GREY_BUTTON),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                Text(
                  widget.dateOfBirth == null ? '' : widget.dateOfBirth,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Spacer(),
                ButtonHDr(
                  label: 'Chọn',
                  style: BtnStyle.BUTTON_FULL,
                  image: Image.asset('assets/images/ic-choose-date.png'),
                  width: 30,
                  height: 40,
                  labelColor: DefaultTheme.BLUE_DARK,
                  bgColor: DefaultTheme.TRANSPARENT,
                  onTap: () {
                    _showDatePickerStart();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                )
              ],
            ),
          ),
          // Row(
          //   children: [
          //     Text('Ngày sinh (*):'),
          //     FlatButton(
          //       child: Text(
          //         widget.birthday == null
          //             ? 'Chọn ngày sinh'
          //             : widget.birthday.toString(),
          //         style: TextStyle(color: Colors.black),
          //       ),
          //       onPressed: () async {
          //         DateTime newDateTime = await showRoundedDatePicker(
          //             context: context,
          //             initialDate: DateTime.now(),
          //             firstDate: DateTime(DateTime.now().year - 100),
          //             lastDate: DateTime.now(),
          //             borderRadius: 16,
          //             theme: ThemeData.dark());
          //         if (newDateTime != null) {
          //           setState(() => widget.birthday = newDateTime);
          //         }
          //       },
          //     ),
          //   ],
          // ),
          TextFieldHDr(
            style: TFStyle.BORDERED,
            label: 'Email:',
            placeHolder: 'abc@gmail.com',
            inputType: TFInputType.TF_EMAIL,
            controller: widget.emailController,
            keyboardAction: TextInputAction.next,
            onChange: (text) {},
          ),
          TextFieldHDr(
            style: TFStyle.BORDERED,
            label: 'Địa chỉ(*):',
            placeHolder: 'Hai Bà Trưng HN...',
            inputType: TFInputType.TF_TEXT,
            controller: widget.addressController,
            keyboardAction: TextInputAction.next,
            onChange: (text) {},
          ),
          TextFieldHDr(
            style: TFStyle.BORDERED,
            label: 'Nghề nghiệp:',
            placeHolder: 'Sinh viên',
            inputType: TFInputType.TF_TEXT,
            controller: widget.careerController,
            keyboardAction: TextInputAction.next,
            onChange: (text) {},
          ),
          TextFieldHDr(
            style: TFStyle.BORDERED,
            label: 'Chiều cao (*):',
            placeHolder: '175',
            inputType: TFInputType.TF_NUMBER,
            controller: widget.heightController,
            keyboardAction: TextInputAction.next,
            onChange: (text) {},
          ),
          TextFieldHDr(
            style: TFStyle.BORDERED,
            label: 'Cân nặng (*):',
            placeHolder: '59',
            inputType: TFInputType.TF_NUMBER,
            controller: widget.weightController,
            keyboardAction: TextInputAction.done,
            onChange: (text) {},
          ),
        ],
      ),
    );
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: widget.gender[btnValue],
          groupValue: widget.select,
          onChanged: (value) {
            setState(() {
              widget.select = value;
            });
            widget.choiceGender(value);
          },
        ),
        Text(title)
      ],
    );
  }

  void _showDatePickerStart() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: DefaultTheme.WHITE.withOpacity(0.6),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ngày sinh(*):',
                          style: TextStyle(
                            fontSize: 25,
                            color: DefaultTheme.BLACK,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime:
                              DateTime.now().add(Duration(days: 5)),
                          onDateTimeChanged: (dateTime) {
                            widget.birthday(dateTime.toString());
                            setState(() {
                              widget.dateOfBirth = dateTime.toString();
                            });
                          }),
                    ),
                    ButtonHDr(
                      style: BtnStyle.BUTTON_BLACK,
                      label: 'Chọn',
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
