import 'dart:convert';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

final DateValidator _dateValidator = DateValidator();
final ArrayValidator _arrayValidator = ArrayValidator();

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
  bool verified = false;

  void Function(String) birthday;
  void Function(String) choiceGender;
  void Function(String) alertError;
  void Function(bool) setVerify;

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
    this.setVerify,
    this.verified,
    this.alertError,
  }) : super(key: key);

  @override
  _NomalInfoViewState createState() => _NomalInfoViewState();
}

class _NomalInfoViewState extends State<NomalInfoView> {
  bool verified = false;
  String _verificationId;
  int ageRequest = 18;
  ArrayValidator _validator = ArrayValidator();

  TextEditingController _smsController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      verified = widget.verified;
    });
    getDataFromJSONFile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getDataFromJSONFile() async {
    final String response = await rootBundle.loadString('assets/global.json');

    if (response.contains('ageReq')) {
      final data = await json.decode(response);
      setState(() {
        ageRequest = data['ageReq'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, top: 20),
      decoration: BoxDecoration(
        color: DefaultTheme.GREY_VIEW,
        borderRadius: BorderRadius.circular(10),
      ),
      // margin: EdgeInsets.only(top: 20),
      child: ListView(
        children: [
          TextFieldHDr(
            style: TFStyle.NO_BORDER,
            label: 'Họ tên*:',
            label_text_width: 120,
            placeHolder: 'Nguyễn Văn A',
            inputType: TFInputType.TF_TEXT,
            controller: widget.fullNameController,
            keyboardAction: TextInputAction.next,
            onChange: (text) {},
          ),
          Divider(
            height: 1,
            color: DefaultTheme.GREY_TOP_TAB_BAR,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                width: 115,
                child: Text('Giới tính*:',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  addRadioButton(0, 'Nam'),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                  addRadioButton(1, 'Nữ'),
                ],
              ),
            ],
          ),
          Divider(
            height: 1,
            color: DefaultTheme.GREY_TOP_TAB_BAR,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                width: 115,
                child: Text('Ngày sinh*:',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ),
              FlatButton(
                child: Text(
                  widget.dateOfBirth == null
                      ? 'Chọn ngày sinh'
                      : _dateValidator.parseToDateView4(DateFormat('dd/MM/yyyy')
                          .format(DateFormat('yyyy-MM-dd')
                              .parse(widget.dateOfBirth.toString()))),
                  style: TextStyle(
                      fontSize: 15,
                      color: (widget.dateOfBirth == null)
                          ? DefaultTheme.SUCCESS_STATUS
                          : DefaultTheme.BLACK),
                ),
                onPressed: () async {
                  DateTime newDateTime = await showRoundedDatePicker(
                      context: context,
                      initialDate: DateTime(DateTime.now().year - ageRequest),
                      firstDate: DateTime(DateTime.now().year - 100),
                      lastDate: DateTime(DateTime.now().year - ageRequest),
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
          Divider(
            height: 1,
            color: DefaultTheme.GREY_TOP_TAB_BAR,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width - 100,
                child: TextFieldHDr(
                  style: TFStyle.NO_BORDER,
                  label_text_width: 120,
                  label: 'Chiều cao*:',
                  placeHolder: '--',
                  inputType: TFInputType.TF_NUMBER,
                  controller: widget.heightController,
                  keyboardAction: TextInputAction.next,
                  onChange: (text) {},
                ),
              ),
              Text('cm', style: TextStyle(color: DefaultTheme.GREY_TEXT)),
            ],
          ),
          Divider(
            height: 1,
            color: DefaultTheme.GREY_TOP_TAB_BAR,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width - 100,
                child: TextFieldHDr(
                  style: TFStyle.NO_BORDER,
                  label_text_width: 120,
                  label: 'Cân nặng*:',
                  placeHolder: '--',
                  inputType: TFInputType.TF_NUMBER,
                  controller: widget.weightController,
                  keyboardAction: TextInputAction.next,
                  onChange: (text) {},
                ),
              ),
              Text('kg', style: TextStyle(color: DefaultTheme.GREY_TEXT)),
            ],
          ),

          Divider(
            height: 1,
            color: DefaultTheme.GREY_TOP_TAB_BAR,
          ),
          TextFieldHDr(
            style: TFStyle.NO_BORDER,
            label: 'Email:',
            label_text_width: 120,
            placeHolder: 'UserEmail123@gmail.com',
            inputType: TFInputType.TF_EMAIL,
            controller: widget.emailController,
            keyboardAction: TextInputAction.next,
            onChange: (text) {},
          ),
          Divider(
            height: 1,
            color: DefaultTheme.GREY_TOP_TAB_BAR,
          ),
          TextFieldHDr(
            style: TFStyle.NO_BORDER,
            label: 'Địa chỉ*:',
            label_text_width: 120,
            placeHolder: 'Địa chỉ thường trú',
            inputType: TFInputType.TF_TEXT,
            controller: widget.addressController,
            keyboardAction: TextInputAction.next,
            onChange: (text) {},
          ),
          Divider(
            height: 1,
            color: DefaultTheme.GREY_TOP_TAB_BAR,
          ),
          TextFieldHDr(
            style: TFStyle.NO_BORDER,
            label: 'Nghề nghiệp:',
            label_text_width: 120,
            placeHolder: 'Công việc hiện tại',
            inputType: TFInputType.TF_TEXT,
            controller: widget.careerController,
            keyboardAction: TextInputAction.next,
            onChange: (text) {},
          ),
          Divider(
            height: 1,
            color: DefaultTheme.GREY_TOP_TAB_BAR,
          ),

          //
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                width: verified
                    ? (MediaQuery.of(context).size.width - 100)
                    : (MediaQuery.of(context).size.width - 160),
                child: TextFieldHDr(
                  style: TFStyle.NO_BORDER,
                  label: 'Số điện thoại*:',
                  placeHolder: '090 123 6789',
                  label_text_width: 120,
                  inputType: TFInputType.TF_PHONE,
                  controller: widget.phoneController,
                  keyboardAction: TextInputAction.done,
                  onChange: (text) {
                    widget.setVerify(false);
                    setState(() {
                      verified = false;
                    });
                  },
                ),
              ),
              (verified)
                  ? Container(
                      height: 20,
                      margin: EdgeInsets.only(right: 20),
                      child: Image.asset(
                        'assets/images/ic-checked.png',
                      ),
                    )
                  : Container(
                      child: InkWell(
                        onTap: () async {
                          if (_validator.phoneNumberValidator(
                                  widget.phoneController.text) ==
                              null) {
                            String phoneNum =
                                widget.phoneController.text.substring(1);

                            _verifyPhoneNumber('+84$phoneNum');
                            _showPopInputOTP('+84$phoneNum');
                          } else {
                            widget.alertError(_validator.phoneNumberValidator(
                                widget.phoneController.text));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: DefaultTheme.SUCCESS_STATUS,
                            // borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          height: 48,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Center(
                            child: Text(
                              'Xác thực',
                              style: TextStyle(
                                  color: DefaultTheme.WHITE,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          Divider(
            height: 1,
            color: DefaultTheme.GREY_TOP_TAB_BAR,
          ),
          // Padding(
          //   padding: EdgeInsets.only(bottom: 20),
          // ),
          (verified)
              ? Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  decoration: BoxDecoration(color: DefaultTheme.SUCCESS_STATUS),
                  child: Text(
                    'Số điện thoại đã được xác thực',
                    style: TextStyle(
                      fontSize: 15,
                      color: DefaultTheme.WHITE,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  // Code of how to verify phone number
  Future<void> _verifyPhoneNumber(String phoneNum) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential).then((value) {
        if (value.user != null) {
          setState(() {
            verified = true;
          });
          _smsController.text = '';
          widget.setVerify(true);
          Navigator.pop(context);
        } else {
          print("Error");
          widget.setVerify(false);
        }
      }).catchError((onError) {
        print('_verifyPhoneNumber: $onError');
        widget.setVerify(false);
      });
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      // widget.alertError('Vui lòng kiểm tra lại số điện thoại');
      // Navigator.pop(context);
      if (authException.code.contains('too-many-requests')) {
        widget.alertError('Số điện thoại đã gửi quá nhiều lần');
      } else {
        widget.alertError('Vui lòng kiểm tra lại số điện thoại');
      }

      // Navigator.pop(context);
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
          phoneNumber: phoneNum,
          timeout: const Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      print('Failed to Verify Phone Number: $e');

      widget.alertError('Vui lòng kiểm tra lại số điện thoại');
      Navigator.pop(context);
    }
  }

  // Code of how to sign in with phone.
  Future<void> _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      await _auth.signInWithCredential(credential).then((value) {
        if (value.user != null) {
          setState(() {
            verified = true;
          });
          _smsController.text = '';
          widget.setVerify(true);
          Navigator.pop(context);
        } else {
          // print('-----go into WRONG');
          widget.alertError('Mã OTP không chính xác');
          widget.setVerify(false);
        }
      }).catchError((onError) {
        print('_signInWithPhoneNumber: $onError');
        // print(
        //     '-----go into catch: ${_smsController.text} -- ${_verificationId}');
        widget.alertError('Mã OTP không chính xác');
        widget.setVerify(false);
      });
    } catch (e) {
      print('Failed to sign in: $e');
      widget.setVerify(false);
    }
  }

  void _showPopInputOTP(String pNum) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: DefaultTheme.WHITE.withOpacity(0.9),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 50,
                            child: Image.asset('assets/images/ic-otp.png'),
                          ),
                          Text(
                            'Xác thực số điện thoại',
                            style: TextStyle(
                              fontSize: 22,
                              decoration: TextDecoration.none,
                              color: DefaultTheme.BLACK,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 30),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      style: TextStyle(
                                          color: DefaultTheme.BLACK,
                                          fontSize: 15),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                'Vui lòng nhập OTP đã được gửi đến số điện thoại '),
                                        TextSpan(
                                            text:
                                                '${_arrayValidator.parsePhoneToView2(pNum)}',
                                            style: TextStyle(
                                                color:
                                                    DefaultTheme.SUCCESS_STATUS,
                                                fontWeight: FontWeight.w500)),
                                        TextSpan(text: ' để xác thực.'),
                                      ]),
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
                                label: 'OTP:',
                                placeHolder: 'Nhập mã ở đây',
                                label_text_width: 60,
                                controller: _smsController,
                                inputType: TFInputType.TF_NUMBER,
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
                        style: BtnStyle.BUTTON_FULL,
                        bgColor: DefaultTheme.SUCCESS_STATUS,
                        label: 'Xác thực',
                        onTap: () {
                          _signInWithPhoneNumber();
                        },
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: 15),
                      // )
                    ],
                  ),
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
          activeColor: DefaultTheme.SUCCESS_STATUS,
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
}
