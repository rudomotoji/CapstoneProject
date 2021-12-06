import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/models/relative_dto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage4 extends StatefulWidget {
  List<RelativeRegisterDTO> listRelative;
  TextEditingController relativeNameController = TextEditingController();
  TextEditingController phoneRelativeController = TextEditingController();
  VoidCallback addRelative;
  void Function(int) deleteRelative;
  void Function(String) alertError;

  RegisterPage4({
    Key key,
    this.listRelative,
    this.relativeNameController,
    this.phoneRelativeController,
    this.addRelative,
    this.deleteRelative,
    this.alertError,
  }) : super(key: key);

  @override
  _RegisterPage4State createState() => _RegisterPage4State();
}

class _RegisterPage4State extends State<RegisterPage4> {
  TextEditingController _smsController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;
  ArrayValidator _validator = ArrayValidator();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      child: TextFieldHDr(
                        style: TFStyle.BORDERED,
                        label: 'Tên người thân:',
                        placeHolder: 'nguyen van a...',
                        inputType: TFInputType.TF_TEXT,
                        controller: widget.relativeNameController,
                        keyboardAction: TextInputAction.done,
                        onChange: (text) {},
                      ),
                    ),
                    Container(
                      width: 300,
                      child: TextFieldHDr(
                        style: TFStyle.BORDERED,
                        label: 'Số điện thoại:',
                        placeHolder: '0987654321',
                        inputType: TFInputType.TF_PHONE,
                        controller: widget.phoneRelativeController,
                        keyboardAction: TextInputAction.done,
                        onChange: (text) {},
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (_validator.phoneNumberValidator(
                          widget.phoneRelativeController.text) ==
                      null) {
                    String phoneNum =
                        widget.phoneRelativeController.text.substring(1);
                    setState(
                      () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                  child: Container(
                                    width: 300,
                                    height: 300,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: DefaultTheme.WHITE
                                            .withOpacity(0.8)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          height: 200,
                                          child: Image.asset(
                                              'assets/images/loading.gif'),
                                        ),
                                        Text(
                                          'Đang tải',
                                          style: TextStyle(
                                              color: DefaultTheme.GREY_TEXT,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              decoration: TextDecoration.none),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                    _verifyPhoneNumber('+84$phoneNum');
                  } else {
                    widget.alertError(_validator.phoneNumberValidator(
                        widget.phoneRelativeController.text));
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
                      'Thêm',
                      style: TextStyle(
                          color: DefaultTheme.WHITE,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.listRelative.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.listRelative[index].fullName),
                        Text(widget.listRelative[index].phoneNumber),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => widget.deleteRelative(index),
                    child: Text('Xóa'),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _verifyPhoneNumber(String phoneNum) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential).then((value) {
        if (value.user != null) {
          _smsController.text = '';
          Navigator.pop(context);
          widget.addRelative();
          Navigator.pop(context);
        }
      }).catchError((onError) {
        print('_verifyPhoneNumber: $onError');
      });
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      // widget.alertError('Vui lòng kiểm tra lại số điện thoại');
      // Navigator.pop(context);
      if (authException.code.contains('too-many-requests')) {
        Navigator.pop(context);
        widget.alertError('Số điện thoại đã gửi quá nhiều lần');
      } else {
        Navigator.pop(context);
        widget.alertError('Vui lòng kiểm tra lại số điện thoại');
      }
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      print('Please check your phone for the verification code.');
      _verificationId = verificationId;
      Navigator.pop(context);
      _showPopInputOTP();
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
      Navigator.pop(context);
      widget.alertError('Vui lòng kiểm tra lại số điện thoại');
      Navigator.pop(context);
    }
  }

  Future<void> _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      await _auth.signInWithCredential(credential).then((value) {
        if (value.user != null) {
          _smsController.text = '';
          widget.addRelative();
          Navigator.pop(context);
        } else {
          widget.alertError('Mã OTP không chính xác');
        }
      }).catchError((onError) {
        print('_signInWithPhoneNumber: $onError');
        widget.alertError('Mã OTP không chính xác');
      });
    } catch (e) {
      print('Failed to sign in: $e');
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
}
