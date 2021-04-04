import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool verified = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;
  TextEditingController _smsController = TextEditingController();

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
            keyboardAction: TextInputAction.done,
            onChange: (text) {},
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width - 150,
                child: TextFieldHDr(
                  style: TFStyle.BORDERED,
                  label: 'SĐT(*):',
                  placeHolder: '123456789',
                  inputType: TFInputType.TF_PHONE,
                  controller: widget.phoneController,
                  keyboardAction: TextInputAction.done,
                  onChange: (text) {},
                ),
              ),
              (verified)
                  ? Container(
                      child: Text(
                        'Đã xác thực',
                        style: TextStyle(color: DefaultTheme.BLUE_TEXT),
                      ),
                    )
                  : Container(
                      child: InkWell(
                        onTap: () async {
                          // await FirebaseAuth.instance.verifyPhoneNumber(
                          //   phoneNumber: '+84773770198',
                          //   verificationCompleted:
                          //       (PhoneAuthCredential credential) {
                          //     print('verificationCompleted');
                          //     setState(() {
                          //       verified = true;
                          //     });
                          //   },
                          //   verificationFailed: (FirebaseAuthException e) {
                          //     print('FirebaseAuthException: $e');
                          //   },
                          //   codeSent: (String verificationId, int resendToken) {
                          //     print(
                          //         'codeSent: verificationId($verificationId), resendToken($resendToken)');
                          //   },
                          //   codeAutoRetrievalTimeout: (String verificationId) {
                          //     print(
                          //         'codeAutoRetrievalTimeout: $verificationId');
                          //   },
                          // );
                          _verifyPhoneNumber();
                          _showPopUpIDDoctor();
                        },
                        child: Text(
                          'Xác thực ngay',
                          style: TextStyle(color: DefaultTheme.RED_TEXT),
                        ),
                      ),
                    ),
            ],
          ),
          Row(
            children: [
              Text('Giới tính(*):'),
              Row(
                children: <Widget>[
                  addRadioButton(0, 'Nam'),
                  addRadioButton(1, 'Nữ'),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text('Ngày sinh (*):'),
              FlatButton(
                child: Text(
                  widget.dateOfBirth == null
                      ? 'Chọn ngày sinh'
                      : DateFormat('dd/MM/yyyy').format(DateFormat('yyyy-MM-dd')
                          .parse(widget.dateOfBirth.toString())),
                  // : widget.birthday.toString(),
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  DateTime newDateTime = await showRoundedDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 100),
                      lastDate: DateTime.now(),
                      borderRadius: 16,
                      theme: ThemeData.dark());
                  if (newDateTime != null) {
                    // setState(() => widget.birthday = newDateTime);
                    // widget.dateOfBirth = newDateTime.toString();
                    widget.birthday(newDateTime.toString());
                  }
                },
              ),
            ],
          ),
          TextFieldHDr(
            style: TFStyle.BORDERED,
            label: 'Email:',
            placeHolder: 'abc@gmail.com',
            inputType: TFInputType.TF_EMAIL,
            controller: widget.emailController,
            keyboardAction: TextInputAction.done,
            onChange: (text) {},
          ),
          TextFieldHDr(
            style: TFStyle.BORDERED,
            label: 'Địa chỉ(*):',
            placeHolder: 'Hai Bà Trưng HN...',
            inputType: TFInputType.TF_TEXT,
            controller: widget.addressController,
            keyboardAction: TextInputAction.done,
            onChange: (text) {},
          ),
          TextFieldHDr(
            style: TFStyle.BORDERED,
            label: 'Nghề nghiệp:',
            placeHolder: 'Sinh viên',
            inputType: TFInputType.TF_TEXT,
            controller: widget.careerController,
            keyboardAction: TextInputAction.done,
            onChange: (text) {},
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width - 100,
                child: TextFieldHDr(
                  style: TFStyle.BORDERED,
                  label: 'Chiều cao (*):',
                  placeHolder: '175',
                  inputType: TFInputType.TF_NUMBER,
                  controller: widget.heightController,
                  keyboardAction: TextInputAction.done,
                  onChange: (text) {},
                ),
              ),
              Text('cm'),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width - 100,
                child: TextFieldHDr(
                  style: TFStyle.BORDERED,
                  label: 'Cân nặng (*):',
                  placeHolder: '59',
                  inputType: TFInputType.TF_NUMBER,
                  controller: widget.weightController,
                  keyboardAction: TextInputAction.done,
                  onChange: (text) {},
                ),
              ),
              Text('kg'),
            ],
          ),
        ],
      ),
    );
  }

  // Code of how to verify phone number
  Future<void> _verifyPhoneNumber() async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential).then((value) {
        if (value.user != null) {
          setState(() {
            verified = true;
          });
          Navigator.pop(context);
        } else {
          print("Error");
        }
      }).catchError((onError) {
        print('_verifyPhoneNumber: $onError');
      });
      print(
          'Phone number automatically verified and user signed in: $phoneAuthCredential');
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      print('Please check your phone for the verification code.');
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: widget.phoneController.text,
          timeout: const Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      print('Failed to Verify Phone Number: $e');
    }
  }

  // Code of how to sign in with phone.
  Future<void> _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      UserCredential result =
          await _auth.signInWithCredential(credential).then((value) {
        if (value.user != null) {
          setState(() {
            verified = true;
          });
          Navigator.pop(context);
        } else {
          print("Error");
        }
      }).catchError((onError) {
        print('_signInWithPhoneNumber: $onError');
      });
    } catch (e) {
      print('Failed to sign in: $e');
    }
  }

  void _showPopUpIDDoctor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  color: DefaultTheme.WHITE.withOpacity(0.6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        Text(
                          'OTP',
                          style: TextStyle(
                            fontSize: 30,
                            decoration: TextDecoration.none,
                            color: DefaultTheme.BLACK,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 20),
                            child: Text(
                              'Mã xác thực đã được gửi về số điện thoại của bạn',
                              style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.none,
                                color: DefaultTheme.GREY_TEXT,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TEXT,
                            height: 0.25,
                          ),
                          Flexible(
                            child: TextFieldHDr(
                              style: TFStyle.NO_BORDER,
                              label: 'Mã:',
                              controller: _smsController,
                              keyboardAction: TextInputAction.done,
                              onChange: (text) {},
                            ),
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TEXT,
                            height: 0.25,
                          ),
                        ],
                      ),
                    ),
                    ButtonHDr(
                      style: BtnStyle.BUTTON_BLACK,
                      label: 'Xác thực',
                      onTap: () {
                        _signInWithPhoneNumber();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
      barrierDismissible: false,
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
