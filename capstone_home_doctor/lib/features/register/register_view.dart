import 'dart:async';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/slide_dot.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/information/views/patient_info_views.dart';
import 'package:capstone_home_doctor/features/register/nomal_info_view.dart';
import 'package:capstone_home_doctor/features/register/register_form_1.dart';
import 'package:capstone_home_doctor/features/register/register_form_3.dart';
import 'package:capstone_home_doctor/features/register/register_form_4.dart';
import 'package:capstone_home_doctor/features/register/repositories/register_repository.dart';
import 'package:capstone_home_doctor/models/patient_dto.dart';
import 'package:capstone_home_doctor/models/relative_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
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
  List gender = ["Nam", "Nữ", "Khác"];
  String selectGender = 'Nam';
  String birthday;

  //page 2
  TextEditingController familyController = TextEditingController();
  TextEditingController patientController = TextEditingController();

  //page 3
  List<RelativeDTO> listRelative = [];
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
            Padding(padding: EdgeInsets.only(top: 20)),
            Expanded(
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
                        );
                      } else if (i == 0) {
                        return RegisterPage1(
                          usernameController: usernameController,
                          passwordController: passwordController,
                          passwordConfirmController: passwordConfirmController,
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
                          addRelative: () {
                            RelativeDTO dto = RelativeDTO(
                              fullName: relativeNameController.text,
                              phoneNumber: phoneRelativeController.text,
                            );
                            setState(() {
                              listRelative.add(dto);
                            });
                            relativeNameController.text = '';
                            phoneRelativeController.text = '';
                          },
                        );
                      }
                    },
                  ),
                  Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 35),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            for (int i = 0; i < slideList.length; i++)
                              if (i == _currentPage)
                                SlideDots(true)
                              else
                                SlideDots(false)
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: ButtonHDr(
                    style: BtnStyle.BUTTON_BLACK,
                    label: 'Trở lại',
                    onTap: () async {
                      if (_currentPage > 0) {
                        _currentPage = _currentPage - 1;
                      } else {
                        _currentPage = 0;
                      }

                      print('_currentPage: $_currentPage');

                      _pageController.animateToPage(
                        _currentPage,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: ButtonHDr(
                    style: BtnStyle.BUTTON_BLACK,
                    label: (_currentPage == slideList.length - 1)
                        ? 'Tạo'
                        : 'Tiếp tục',
                    onTap: () async {
                      if (_currentPage < slideList.length - 1) {
                        _currentPage = _currentPage + 1;
                      } else {
                        PatientHealthRecordDTO patientHealthRecordDTO =
                            PatientHealthRecordDTO(
                          height: int.parse(_heightController.text) ?? 0,
                          weight: int.parse(_weightController.text) ?? 0,
                          personalMedicalHistory: patientController.text,
                          familyMedicalHistory: familyController.text,
                          relatives: listRelative,
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
                                              'Đang tạo...',
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
                              showDialog(
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
                                                    'assets/images/ic-checked.png'),
                                              ),
                                              Text(
                                                'Tạo thành công',
                                                style: TextStyle(
                                                    color:
                                                        DefaultTheme.GREY_TEXT,
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
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              });
                            } else {
                              showDialog(
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
                                              Text(
                                                'Không thể tạo tài khoản, vui kiểm tra lại',
                                                style: TextStyle(
                                                    color:
                                                        DefaultTheme.GREY_TEXT,
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
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.of(context).pop();
                              });
                            }
                          },
                        );
                      }

                      print('_currentPage: $_currentPage');

                      _pageController.animateToPage(
                        _currentPage,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  setBirthday(date) {
    setState(() {
      birthday = date;
    });
  }

  setGender(select) {
    setState(() {
      selectGender = select;
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
      data['patientInformation'] = this.patientInformation.toJson();
    }
    return data;
  }
}
