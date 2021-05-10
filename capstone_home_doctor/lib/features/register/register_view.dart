import 'dart:async';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/slide_dot.dart';
import 'package:capstone_home_doctor/features/register/nomal_info_view.dart';
import 'package:capstone_home_doctor/features/register/register_form_1.dart';
import 'package:capstone_home_doctor/features/register/register_form_3.dart';
import 'package:capstone_home_doctor/features/register/register_form_4.dart';
import 'package:capstone_home_doctor/features/register/repositories/register_repository.dart';
import 'package:capstone_home_doctor/models/patient_dto.dart';
import 'package:capstone_home_doctor/models/relative_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State<Register> with WidgetsBindingObserver {
  //page0
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  //page1
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _careerController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  List gender = ["Nam", "Nữ"];
  String selectGender = 'Nam';
  String birthday;
  bool verified = false;

  //page 2
  TextEditingController familyController = TextEditingController();
  TextEditingController patientController = TextEditingController();

  //page 3
  List<RelativeRegisterDTO> listRelative = [];
  final relativeNameController = TextEditingController();
  final phoneRelativeController = TextEditingController();

  int _currentPage = 0;
  bool flagEnd = false;
  final PageController _pageController = PageController(initialPage: 0);
  final slideList = [
    RegisterPage1(),
    NomalInfoView(),
    RegisterPage3(),
    RegisterPage4(),
  ];
  ArrayValidator _validator = ArrayValidator();

  RegisterRepository _registerRepository =
      RegisterRepository(httpClient: http.Client());

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _pageController.dispose();
  }

  onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              title: 'Đăng ký',
              isMainView: false,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    PageView.builder(
                      physics: new NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: onPageChanged,
                      itemCount: slideList.length,
                      itemBuilder: (ctx, i) {
                        if (i == 1) {
                          return NomalInfoView(
                            fullNameController: _fullNameController,
                            phoneController: _phoneController,
                            emailController: _emailController,
                            addressController: _addressController,
                            careerController: _careerController,
                            weightController: _weightController,
                            heightController: _heightController,
                            gender: gender,
                            select: selectGender,
                            birthday: setBirthday,
                            dateOfBirth: birthday,
                            choiceGender: setGender,
                            setVerify: setVerify,
                            verified: verified,
                            alertError: alertError,
                          );
                        } else if (i == 0) {
                          return RegisterPage1(
                            usernameController: usernameController,
                            passwordController: passwordController,
                            passwordConfirmController:
                                passwordConfirmController,
                          );
                        } else if (i == 2) {
                          return RegisterPage3(
                            familyController: familyController,
                            patientController: patientController,
                          );
                        } else if (i == 3) {
                          return RegisterPage4(
                              listRelative: listRelative,
                              relativeNameController: relativeNameController,
                              phoneRelativeController: phoneRelativeController,
                              alertError: alertError,
                              addRelative: () {
                                RelativeRegisterDTO dto = RelativeRegisterDTO(
                                  fullName: relativeNameController.text,
                                  phoneNumber: phoneRelativeController.text,
                                );
                                setState(() {
                                  listRelative.add(dto);
                                });
                                relativeNameController.text = '';
                                phoneRelativeController.text = '';
                              },
                              deleteRelative: deleteRelative);
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                //  alignment: AlignmentDirectional.topStart,
                children: <Widget>[
                  for (int i = 0; i < slideList.length; i++)
                    if (i == _currentPage) SlideDots(true) else SlideDots(false)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            //
            (_currentPage == 0)
                ? Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Thông tin tài khoản',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                  )
                : (_currentPage == 1)
                    ? Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Thông tin cá nhân',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                          ),
                        ),
                      )
                    : (_currentPage == 2)
                        ? Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Tiền sử bệnh án',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Thêm người thân',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                            ),
                          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  // style: BtnStyle.BUTTON_BLACK,
                  // label: 'Trở lại',
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 20),
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: DefaultTheme.GREY_TEXT, width: 0.5),
                        color: DefaultTheme.WHITE,
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset('assets/images/ic-foward.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                        ),
                        Text('Trở lại'),
                      ],
                    ),
                  ),
                  onTap: () async {
                    if (_currentPage > 0) {
                      _currentPage = _currentPage - 1;
                    } else {
                      _currentPage = 0;
                      Navigator.of(context).pop();
                    }

                    _pageController.animateToPage(
                      _currentPage,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: DefaultTheme.GREY_TEXT, width: 0.5),
                        color: DefaultTheme.WHITE,
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      children: [
                        (_currentPage == slideList.length - 1)
                            ? Spacer()
                            : Container(),
                        Text((_currentPage == slideList.length - 1)
                            ? 'Tạo'
                            : 'Tiếp tục'),
                        (_currentPage == slideList.length - 1)
                            ? Spacer()
                            : Padding(
                                padding: EdgeInsets.only(left: 15),
                              ),
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset('assets/images/ic-move-next.png'),
                        ),
                        (_currentPage == slideList.length - 1)
                            ? Padding(
                                padding: EdgeInsets.only(right: 10),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  // child: Container(
                  //   child: Text((_currentPage == slideList.length - 1)
                  //       ? 'Tạo'
                  //       : 'Tiếp tục'),
                  // ),
                  // style: BtnStyle.BUTTON_BLACK,
                  // label: ,
                  onTap: () async {
                    //turn off keyboard
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus &&
                        currentFocus.focusedChild != null) {
                      currentFocus.focusedChild.unfocus();
                    }
                    //
                    bool checkError = false;
                    if (_currentPage == 0) {
                      if (usernameController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          passwordConfirmController.text.isEmpty) {
                        alertError(
                            'Vui lòng nhập đầy đủ các thông tin yêu cầu');
                      } else if (validateUsernamePassword(
                              usernameController.text, 'tên đăng nhập') !=
                          null) {
                        alertError(validateUsernamePassword(
                            usernameController.text, 'tên đăng nhập'));
                      } else if (validateUsernamePassword(
                              passwordController.text, 'mật khẩu') !=
                          null) {
                        alertError(validateUsernamePassword(
                            passwordController.text, 'mật khẩu'));
                      } else if (passwordController.text !=
                          passwordConfirmController.text) {
                        alertError('2 mật khẩu chưa trùng khớp');
                      } else {
                        checkError = true;
                      }
                    }
                    if (_currentPage == 1) {
                      if (_fullNameController.text == '' ||
                          _phoneController.text == '' ||
                          _addressController.text == '' ||
                          _heightController.text == '' ||
                          _weightController.text == '' ||
                          birthday == null) {
                        alertError('Vui lòng điền đầy đủ thông tin bắt buộc');
                      } else if (!verified) {
                        alertError('Vui lòng xác thực số điện thoại');
                      } else if (_validator
                              .phoneNumberValidator(_phoneController.text) !=
                          null) {
                        alertError(_validator
                            .phoneNumberValidator(_phoneController.text));
                      } else if (_emailController.text != '' &&
                          !_validator.validateEmail(_emailController.text)) {
                        alertError('Vui lòng nhập đúng địa chỉ email');
                      } else {
                        checkError = true;
                      }
                    }
                    if (_currentPage == 2 || _currentPage == 3) {
                      checkError = true;
                    }

                    if (checkError) {
                      if (_currentPage < slideList.length - 1) {
                        _currentPage = _currentPage + 1;
                      } else {
                        PatientHealthRecordDTO patientHealthRecordDTO =
                            PatientHealthRecordDTO(
                          height: int.parse(_heightController.text) ?? 0,
                          weight: int.parse(_weightController.text) ?? 0,
                          personalMedicalHistory: patientController.text,
                          familyMedicalHistory: familyController.text,
                          relativesRegister: listRelative,
                        );
                        String dateOfBirthDay = DateFormat('yyyy-MM-dd')
                            .format(DateFormat('yyyy-MM-dd').parse(birthday));

                        PatientDTO patientDTO = PatientDTO(
                          fullName: _fullNameController.text,
                          phoneNumber: _phoneController.text,
                          email: _emailController.text,
                          address: _addressController.text,
                          dateOfBirth: dateOfBirthDay,
                          gender: selectGender,
                          career: _careerController.text,
                          patientHealthRecord: patientHealthRecordDTO,
                        );

                        FormRegisterDTO formRegisterDTO = FormRegisterDTO(
                          username: usernameController.text,
                          password: passwordController.text,
                          patientInformation: patientDTO,
                        );

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
                                      filter: ImageFilter.blur(
                                          sigmaX: 25, sigmaY: 25),
                                      child: Container(
                                        width: 300,
                                        height: 300,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                              'Đang tạo',
                                              style: TextStyle(
                                                  color: DefaultTheme.GREY_TEXT,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  decoration:
                                                      TextDecoration.none),
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

                        _registerRepository
                            .registerAccPatient(formRegisterDTO)
                            .then(
                          (value) {
                            Navigator.pop(context);
                            if (value) {
                              // showDialog(
                              //   barrierDismissible: false,
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return Center(
                              //       child: ClipRRect(
                              //         borderRadius: BorderRadius.all(
                              //             Radius.circular(5)),
                              //         child: BackdropFilter(
                              //           filter: ImageFilter.blur(
                              //               sigmaX: 25, sigmaY: 25),
                              //           child: Container(
                              //             width: 200,
                              //             height: 200,
                              //             decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(10),
                              //                 color: DefaultTheme.WHITE
                              //                     .withOpacity(0.8)),
                              //             child: Column(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.center,
                              //               children: [
                              //                 SizedBox(
                              //                   width: 100,
                              //                   height: 100,
                              //                   child: Image.asset(
                              //                       'assets/images/ic-checked.png'),
                              //                 ),
                              //                 Text(
                              //                   'Tạo thành công',
                              //                   style: TextStyle(
                              //                       color: DefaultTheme
                              //                           .GREY_TEXT,
                              //                       fontSize: 15,
                              //                       fontWeight:
                              //                           FontWeight.w400,
                              //                       decoration:
                              //                           TextDecoration.none),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // );

                              // Future.delayed(const Duration(seconds: 2), () {
                              // Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              // });
                            } else {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 25, sigmaY: 25),
                                        child: Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: DefaultTheme.WHITE
                                                  .withOpacity(0.8)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Image.asset(
                                                    'assets/images/ic-failed.png'),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Không thể tạo tài khoản, vui kiểm tra lại',
                                                  style: TextStyle(
                                                      color: DefaultTheme
                                                          .GREY_TEXT,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      decoration:
                                                          TextDecoration.none),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                              Future.delayed(const Duration(seconds: 2), () {
                                Navigator.of(context).pop();
                              });
                            }
                          },
                        );
                      }

                      _pageController.animateToPage(
                        _currentPage,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
          ],
        ),
      ),
    );
  }

  setBirthday(String date) {
    setState(() {
      birthday = date;
    });
  }

  setGender(String select) {
    setState(() {
      selectGender = select;
    });
  }

  setVerify(bool res) {
    setState(() {
      verified = res;
    });
  }

  deleteRelative(int index) {
    setState(() {
      listRelative.removeAt(index);
    });
  }

  String validateUsernamePassword(String value, String type) {
    Pattern pattern = r'\w{5}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Vui lòng nhập $type ít nhất 5 ký tự';
    else
      return null;
  }

  alertError(String title) {
    setState(() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: DefaultTheme.TRANSPARENT,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    width: 250,
                    height: 200,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: DefaultTheme.WHITE.withOpacity(0.8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset('assets/images/ic-failed.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '$title',
                            style: TextStyle(
                                color: DefaultTheme.BLACK,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    });
  }
}

class FormRegisterDTO {
  String username;
  String password;
  PatientDTO patientInformation;
  FormRegisterDTO({this.username, this.password, this.patientInformation});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    if (this.patientInformation != null) {
      data['patientInformation'] = this.patientInformation.toJsonRegister();
    }
    return data;
  }
}
