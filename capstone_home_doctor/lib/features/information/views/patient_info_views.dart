import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/information/blocs/patient_bloc.dart';
import 'package:capstone_home_doctor/features/information/events/patient_event.dart';
import 'package:capstone_home_doctor/features/information/repositories/patient_repository.dart';
import 'package:capstone_home_doctor/features/information/states/patient_state.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

class PatientInformation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PatientInformation();
  }
}

class _PatientInformation extends State<PatientInformation>
    with WidgetsBindingObserver {
  String _relativeName = '';
  //
  PatientRepository patientRepository =
      PatientRepository(httpClient: http.Client());
  //
  DateValidator _dateValidator = DateValidator();
  //
  //patient Id
  int _patientId = 0;
  //
  PatientBloc _patientBloc;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _getPatientId();
    _patientBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) async {
      print('$value');
      await setState(() {
        _patientId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Thông tin tài khoản',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.NONE,
            ),
            Expanded(
              child: _getPatientInfo(),
            ),
          ],
        ),
      ),
    );
  }

  _getPatientInfo() {
    _patientBloc.add(PatientEventSetId(id: _patientId));
    return BlocBuilder<PatientBloc, PatientState>(builder: (context, state) {
      if (state is PatientStateLoading) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: DefaultTheme.TRANSPARENT),
          child: Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: Image.asset('assets/images/loading.gif'),
            ),
          ),
        );
      }
      if (state is PatientStateFailure) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: DefaultTheme.TRANSPARENT),
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Text('Không thể tải thông tin cá nhân',
                style: TextStyle(
                  color: DefaultTheme.TRANSPARENT,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
          ),
        );
      }
      if (state is PatientStateSuccess) {
        if (state.dto == null) {
          return Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: DefaultTheme.TRANSPARENT),
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              child: Text('Không thể tải thông tin cá nhân',
                  style: TextStyle(
                    color: DefaultTheme.GREY_TEXT,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          );
        }
        String _gender = '';
        if (state.dto.gender == 'Male') {
          _gender = 'Nam';
        } else {
          _gender = 'Nữ';
        }

        //
        return ListView(
          children: <Widget>[
            //avatar and fullname here
            Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  //avt
                  SizedBox(
                    child: CircleAvatar(
                      radius: 35,
                      child: ClipOval(
                        child: Image.asset('assets/images/avatar-default.jpg'),
                      ),
                    ),
                  ),
                  //fullname
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 5),
                    child: Text(
                      '${state.dto.fullName}',
                      style: TextStyle(
                        color: DefaultTheme.BLACK,
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Text(
                      '${state.dto.phoneNumber}',
                      style: TextStyle(
                        color: DefaultTheme.GREY_TEXT,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5 - 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            width: 1,
                          ),
                        ),
                        child: ButtonHDr(
                          label: 'Sửa thông tin',
                          labelColor: DefaultTheme.BLACK,
                          width: MediaQuery.of(context).size.width * 0.5 - 20,
                          bgColor: DefaultTheme.TRANSPARENT,
                          style: BtnStyle.BUTTON_TRANSPARENT,
                          onTap: () async {
                            //
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      //
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5 - 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            width: 1,
                          ),
                        ),
                        child: ButtonHDr(
                          label: 'Thêm người nhà',
                          labelColor: DefaultTheme.BLACK,
                          width: MediaQuery.of(context).size.width * 0.5 - 20,
                          bgColor: DefaultTheme.TRANSPARENT,
                          style: BtnStyle.BUTTON_TRANSPARENT,
                          onTap: () async {
                            //
                          },
                        ),
                      ),
                    ],
                  ),
                  //
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 5),
                    child: Divider(
                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                      height: 0.1,
                    ),
                  ),
                  //detail information
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20, top: 10),
                            child: Text(
                              'Thông tin cá nhân',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 120,
                              child: Text(
                                'Số điện thoại',
                                style: TextStyle(
                                  color: DefaultTheme.GREY_TEXT,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  (120 + 50),
                              child: Text(
                                '${state.dto.phoneNumber}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 120,
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  color: DefaultTheme.GREY_TEXT,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  (120 + 50),
                              child: Text(
                                '${state.dto.email}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 120,
                              child: Text(
                                'Giới tính',
                                style: TextStyle(
                                  color: DefaultTheme.GREY_TEXT,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  (120 + 50),
                              child: Text(
                                '${_gender}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 120,
                              child: Text(
                                'Ngày sinh',
                                style: TextStyle(
                                  color: DefaultTheme.GREY_TEXT,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  (120 + 50),
                              child: Text(
                                '${_dateValidator.parseToDateView(state.dto.dateOfBirth)}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 120,
                              child: Text(
                                'Nghề nghiệp',
                                style: TextStyle(
                                  color: DefaultTheme.GREY_TEXT,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  (120 + 50),
                              child: Text(
                                '${state.dto.career}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 120,
                              child: Text(
                                'ĐC thường trú',
                                style: TextStyle(
                                  color: DefaultTheme.GREY_TEXT,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  (120 + 50),
                              child: (state.dto.address == null)
                                  ? Text(
                                      'Chưa cập nhật',
                                      style: TextStyle(
                                        color: DefaultTheme.GREY_TEXT,
                                        fontSize: 15,
                                      ),
                                    )
                                  : Text(
                                      '${state.dto.address}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20, top: 30),
                            child: Text(
                              'Người nhà',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                          ),
                        ),
                        (state.dto.relatives.length == 0)
                            ? Container(
                                width: MediaQuery.of(context).size.width - 40,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: DefaultTheme.GREY_VIEW,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text(
                                    'Chưa có danh sách người nhà.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: DefaultTheme.GREY_TEXT),
                                  ),
                                ),
                              )
                            : Stack(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: state.dto.relatives.length,
                                      itemBuilder: (BuildContext buildContext,
                                          int index) {
                                        _relativeName =
                                            state.dto.relatives[index].fullName;
                                        return Container(
                                          height: 90,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: DefaultTheme.GREY_VIEW,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                              ),
                                              //
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                  ),
                                                  Container(
                                                    width: 120,
                                                    child: Text(
                                                      'Họ tên',
                                                      style: TextStyle(
                                                        color: DefaultTheme
                                                            .GREY_TEXT,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            (120 + 80),
                                                    child: Text(
                                                      '${state.dto.relatives[index].fullName}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                  ),
                                                  Container(
                                                    width: 120,
                                                    child: Text(
                                                      'Số điện thoại',
                                                      style: TextStyle(
                                                        color: DefaultTheme
                                                            .GREY_TEXT,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            (120 + 80),
                                                    child: Text(
                                                      '${state.dto.relatives[index].phoneNumber}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              //
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 20),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    width: 35,
                                    height: 35,
                                    top: 0,
                                    right: 0,
                                    child: ButtonHDr(
                                      style: BtnStyle.BUTTON_IMAGE,
                                      image: Image.asset(
                                          'assets/images/ic-remove.png'),
                                      onTap: () {
                                        _showDeletePopup();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                  //
                ],
              ),
            ),
            //component here
          ],
        );
      }
      return Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: DefaultTheme.TRANSPARENT),
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          child: Text('Không thể tải thông tin cá nhân',
              style: TextStyle(
                color: DefaultTheme.GREY_TEXT,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
        ),
      );
    });
  }

  _showDeletePopup() {
    showModalBottomSheet(
        isScrollControlled: false,
        context: this.context,
        backgroundColor: Colors.white.withOpacity(0),
        builder: (context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width - 20,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: DefaultTheme.WHITE.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: <Widget>[
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    'Xoá ${_relativeName} khỏi danh sách người nhà?',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: DefaultTheme.GREY_TEXT),
                                  ),
                                ),
                                Spacer(),
                                Divider(
                                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                                  height: 0.5,
                                ),
                                ButtonHDr(
                                  label: 'Xoá',
                                  height: 60,
                                  labelColor: DefaultTheme.RED_TEXT,
                                  style: BtnStyle.BUTTON_IN_LIST,
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: DefaultTheme.WHITE.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ButtonHDr(
                              label: 'Huỷ',
                              labelColor: DefaultTheme.BLUE_TEXT,
                              style: BtnStyle.BUTTON_IN_LIST,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                    ),
                  ],
                ),
              ));
        });
  }
}
