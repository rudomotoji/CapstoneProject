import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';

import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_checking_bloc.dart';

import 'package:capstone_home_doctor/features/contract/blocs/doctor_info_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/contract_checking_event.dart';
import 'package:capstone_home_doctor/features/contract/events/doctor_info_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/repositories/doctor_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/doctor_info_state.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

DoctorRepository doctorRepository = DoctorRepository(httpClient: http.Client());
final ContractHelper _contractHelper = ContractHelper();
final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final ArrayValidator _arrayValidator = ArrayValidator();

class DoctorInformation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DoctorInformation();
  }
}

class _DoctorInformation extends State<DoctorInformation>
    with WidgetsBindingObserver {
  //
  ContractRepository requestContractRepository =
      ContractRepository(httpClient: http.Client());
  CheckingContractBloc _checkingContractBloc;
  //
  int _idDoctor = 0;
  int _patientId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPatientId();
    _checkingContractBloc = BlocProvider.of(context);
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        _patientId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    String arguments = ModalRoute.of(context).settings.arguments;
    _idDoctor = int.tryParse(arguments);
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [DefaultTheme.GRADIENT_1, DefaultTheme.GRADIENT_2]),
      ),
      child: Scaffold(
        backgroundColor: DefaultTheme.BLACK.withOpacity(0.2),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //
              HeaderWidget(
                title: 'Thông tin bác sĩ ',
                isMainView: false,
                buttonHeaderType: ButtonHeaderType.BACK_HOME,
              ),
              Expanded(
                child: BlocProvider(
                  create: (context) => DoctorInfoBloc(
                      doctorAPI: doctorRepository)
                    ..add(DoctorInfoEventSetId(id: int.tryParse(arguments))),
                  child: _getDoctorInfo(),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.only(left: 20, bottom: 30, top: 30),
                child: ButtonHDr(
                  style: BtnStyle.BUTTON_BLACK,
                  label: 'Yêu cầu hợp đồng',
                  onTap: () {
                    _checkContractAvailable(arguments);

                    ///
                    ///
                    ///
                    // Navigator.of(context).pop();
                    // Navigator.pushNamed(context, RoutesHDr.CONTRACT_SHARE_VIEW,
                    //     arguments: arguments);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getDoctorInfo() {
    return BlocBuilder<DoctorInfoBloc, DoctorInfoState>(
        builder: (context, state) {
      if (state is DoctorInfoStateLoading) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: DefaultTheme.GREY_BUTTON),
          child: Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: Image.asset('assets/images/loading.gif'),
            ),
          ),
        );
      }
      if (state is DoctorInfoStateFailure) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: DefaultTheme.GREY_BUTTON),
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Text('Không tìm thấy bác sĩ',
                style: TextStyle(
                  color: DefaultTheme.GREY_TEXT,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
          ),
        );
      }
      if (state is DoctorInfoStateSuccess) {
        if (state.dto == null) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: DefaultTheme.GREY_BUTTON),
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              child: Text('Không tìm thấy bác sĩ',
                  style: TextStyle(
                    color: DefaultTheme.GREY_TEXT,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          );
        }

        return Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: DefaultTheme.GREY_BUTTON),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                  //avt
                  SizedBox(
                    child: CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: Image.asset('assets/images/avatar-default.jpg'),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            width: 50,
                            child: Text(
                              'Bác sĩ',
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
                            width: MediaQuery.of(context).size.width - (200),
                            child: Text(
                              '${state.dto.fullName}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            width: 50,
                            child: Text(
                              (state.dto.email != null) ? 'Email' : '',
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
                            width: MediaQuery.of(context).size.width - (200),
                            child: Text(
                              (state.dto.email != null)
                                  ? '${state.dto.email}'
                                  : '',
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
                    ],
                  ),

                  //
                ],
              ),

              //
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Divider(
                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                  height: 1,
                ),
              ),
              //
              InkWell(
                onTap: () async => await launch(
                    'tel://${_arrayValidator.parsePhoneToPhoneNo(state.dto.phone)}'),
                child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: DefaultTheme.SUCCESS_STATUS.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset('assets/images/ic-call.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Text('Gọi ngay')
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Divider(
                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                  height: 1,
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 120,
                    child: Text(
                      'Chuyên khoa',
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
                    width: MediaQuery.of(context).size.width - (80 + 120 + 10),
                    child: Text(
                      '${state.dto.specialization}',
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
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 120,
                    child: Text(
                      'Nơi làm việc',
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
                    width: MediaQuery.of(context).size.width - (80 + 120 + 10),
                    child: Text(
                      '${state.dto.workLocation}',
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
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 120,
                    child: Text(
                      'Đ/C phòng khám',
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
                    width: MediaQuery.of(context).size.width - (80 + 120 + 10),
                    child: Text(
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
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
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
                    width: MediaQuery.of(context).size.width - (80 + 120 + 10),
                    child: Text(
                      '${_arrayValidator.parsePhoneToView(state.dto.phone)}',
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
                padding: EdgeInsets.only(top: 10),
              ),
              //
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 120,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Kinh nghiệm',
                        style: TextStyle(
                          color: DefaultTheme.GREY_TEXT,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - (80 + 120 + 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${state.dto.experience} năm',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 120,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Thành tích',
                        style: TextStyle(
                          color: DefaultTheme.GREY_TEXT,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - (80 + 120 + 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${state.dto.details}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
      return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: DefaultTheme.GREY_BUTTON),
        child: Center(
          child: Text('Không tìm thấy bác sĩ'),
        ),
      );
    });
  }

  //
  _checkContractAvailable(String arg) {
    setState(() {
      //

      showDialog(
          barrierDismissible: false,
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
                      width: 250,
                      height: 160,
                      decoration: BoxDecoration(
                        color: DefaultTheme.WHITE.withOpacity(0.7),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 130,
                            // height: 100,
                            child: Image.asset('assets/images/loading.gif'),
                          ),
                          // Spacer(),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Đang kiểm tra',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: DefaultTheme.GREY_TEXT,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });

      ///
      if (_patientId != 0 && _idDoctor != 0) {
        //
        _checkingContractBloc.add(CheckingtContractEventSend(
            doctorId: _idDoctor, patientId: _patientId));

        Future.delayed(const Duration(seconds: 3), () {
          //
          _contractHelper.isAcceptable().then((value) {
            //
            if (value == true) {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, RoutesHDr.CONTRACT_SHARE_VIEW,
                  arguments: _idDoctor.toString());
            } else {
              //
              String msg = '';
              _contractHelper.getMsgCheckingContract().then((value) async {
                msg = value;
                if (msg.contains('đang có hợp đồng chờ') ||
                    msg.contains('chờ bạn chấp thuận') ||
                    msg.contains('Kiểm tra lại kết nối mạng')) {
                  Navigator.of(context).pop();
                  return showDialog(
                    barrierDismissible: false,
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
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                width: 250,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: DefaultTheme.WHITE.withOpacity(0.7),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.only(bottom: 10, top: 10),
                                      child: Text(
                                        'Gửi yêu cầu thất bại',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: DefaultTheme.BLACK,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$msg',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: DefaultTheme.GREY_TEXT,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Divider(
                                      height: 1,
                                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    ),
                                    ButtonHDr(
                                      height: 40,
                                      style: BtnStyle.BUTTON_TRANSPARENT,
                                      label: 'OK',
                                      labelColor: DefaultTheme.BLUE_TEXT,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  Navigator.of(context).pop();
                  return showDialog(
                    barrierDismissible: false,
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
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                width: 250,
                                height: 185,
                                decoration: BoxDecoration(
                                  color: DefaultTheme.WHITE.withOpacity(0.7),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.only(bottom: 10, top: 10),
                                      child: Text(
                                        'Lưu ý',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: DefaultTheme.BLACK,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$msg',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: DefaultTheme.GREY_TEXT,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Divider(
                                      height: 1,
                                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FlatButton(
                                          height: 40,
                                          minWidth: 250 / 2 - 10.5,
                                          child: Text('Đóng',
                                              style: TextStyle(
                                                  color:
                                                      DefaultTheme.BLUE_TEXT)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        Container(
                                          height: 40,
                                          width: 0.5,
                                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                                        ),
                                        FlatButton(
                                          height: 40,
                                          minWidth: 250 / 2 - 10.5,
                                          child: Text('Tiếp tục',
                                              style: TextStyle(
                                                  color:
                                                      DefaultTheme.BLUE_TEXT)),
                                          onPressed: () {
                                            //
                                            Navigator.of(context).pop();
                                            Navigator.pushNamed(context,
                                                RoutesHDr.CONTRACT_SHARE_VIEW,
                                                arguments: arg);
                                            //////
                                            //////
                                          },
                                        ),
                                      ],
                                    ),
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
              });
            }
          });
        });
      }
    });
  }
}
