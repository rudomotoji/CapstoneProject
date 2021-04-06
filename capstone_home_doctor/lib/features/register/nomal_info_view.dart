import 'dart:convert';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                width: verified
                    ? (MediaQuery.of(context).size.width - 100)
                    : (MediaQuery.of(context).size.width - 160),
                child: TextFieldHDr(
                  style: TFStyle.BORDERED,
                  label: 'SĐT(*):',
                  placeHolder: '123456789',
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
                      width: 20,
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
                            _showPopInputOTP();
                          } else {
                            widget.alertError(_validator.phoneNumberValidator(
                                widget.phoneController.text));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 120, 75),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          height: 48,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Center(
                            child: Text(
                              'Xác thực ngay',
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
                  style: TextStyle(color: Colors.black),
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
          widget.alertError('Mã OTP không chính xác');
          widget.setVerify(false);
        }
      }).catchError((onError) {
        print('_signInWithPhoneNumber: $onError');
        widget.alertError('Mã OTP không chính xác');
        widget.setVerify(false);
      });
    } catch (e) {
      print('Failed to sign in: $e');
      widget.setVerify(false);
    }
  }

  void _showPopInputOTP() {
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
}
