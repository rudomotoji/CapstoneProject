import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_request_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/doctor_info_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/contract_request_event.dart';
import 'package:capstone_home_doctor/features/contract/events/doctor_info_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/repositories/doctor_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/doctor_info_state.dart';
import 'package:capstone_home_doctor/features/information/blocs/patient_bloc.dart';
import 'package:capstone_home_doctor/features/information/events/patient_event.dart';
import 'package:capstone_home_doctor/features/information/repositories/patient_repository.dart';
import 'package:capstone_home_doctor/features/information/states/patient_state.dart';
import 'package:capstone_home_doctor/models/doctor_dto.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

//
final DateValidator _dateValidator = DateValidator();
final ContractHelper _contractHelper = ContractHelper();

class ContractDraftView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContractDraftView();
  }
}

final Shader _normalHealthColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_1,
    DefaultTheme.GRADIENT_2,
  ],
).createShader(new Rect.fromLTWH(10.0, 1.0, 100.0, 90.0));

class _ContractDraftView extends State<ContractDraftView>
    with WidgetsBindingObserver {
  //

  ContractRepository requestContractRepository =
      ContractRepository(httpClient: http.Client());
  RequestContractBloc _requestContractBloc;
  DoctorDTO doctorDTO = DoctorDTO();
  bool _isAccept = false;
  bool _isAccept2 = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _requestContractBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  _updateAcceptState() {
    setState(() {
      _isAccept = !_isAccept;
    });
  }

  _updateAcceptState2() {
    setState(() {
      _isAccept2 = !_isAccept2;
    });
  }

//
  DoctorRepository doctorRepository =
      DoctorRepository(httpClient: http.Client());
  PatientRepository patientRepository =
      PatientRepository(httpClient: http.Client());
  //
  String _currentDate = DateTime.now().toString().split(' ')[0];
  // String _dateInWeek = DateFormat('EEEE').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    Map<String, Object> arguments = ModalRoute.of(context).settings.arguments;
    RequestContractDTO _requestContract = arguments['REQUEST_OBJ'];
    String note = arguments['NOTE'];
    String dateStart = arguments['DATE_START'];
    print(
        'PATIENT ID ${_requestContract.patientId} AND DOCTOR ID ${_requestContract.doctorId}');
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Yêu cầu hợp đồng',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Expanded(
              child: ListView(children: <Widget>[
                //
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: DefaultTheme.GREY_VIEW),
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  width: MediaQuery.of(context).size.width - 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 0, right: 0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'CỘNG HOÀ XÃ HỘI CHỦ NGHĨA VIỆT NAM',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 30),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Độc lập - Tự do - Hạnh phúc',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'HỢP ĐỒNG KHÁM CHỮA BỆNH',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            Text(
                              '- Căn cứ Bộ luật Dân sự ngày 14 tháng 6 năm 2005;',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: DefaultTheme.BLACK,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                            ),
                            Text(
                              '- Căn cứ Luật khám bệnh, chữa bệnh ngày 23 tháng 11 năm 2009;',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: DefaultTheme.BLACK,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                            ),
                            Text(
                              '- Căn cứ Nghị định số 87/2011/NĐ-CP ngày 27 tháng 9 năm 2011 của Chính phủ quy định chi tiết và hướng dẫn thi hành một số điều của Luật khám bệnh, chữa bệnh;',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: DefaultTheme.BLACK,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                            ),
                            Text(
                              'Hôm nay ngày ${_dateValidator.parseToDateView2(_currentDate)}.\nChúng tôi gồm có:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: DefaultTheme.BLACK,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _getPatientInfo(_requestContract.patientId),

                      ///
                      ///
                      BlocProvider(
                        create: (context) =>
                            DoctorInfoBloc(doctorAPI: doctorRepository)
                              ..add(DoctorInfoEventSetId(
                                  id: _requestContract.doctorId)),
                        child: _getDoctorInfo(),
                      ),

                      ///

                      ///
                      ///
                      ///
                      ///
                      ///
                      ///
                      ///

                      //
                      //

                      //
                      Padding(
                        padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                        child: Text(
                            'Sau khi thỏa thuận, Hai bên thống nhất ký kết hợp đồng khám, chữa bệnh theo các điều khoản cụ thể như sau:',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'NewYork')),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, bottom: 10, top: 20),
                        child: Text(
                          'Điều 1: Thời hạn và nhiệm vụ hợp đồng',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: Text(
                          'Thời hạn hợp đồng kể từ ngày ${_dateValidator.parseToDateView2(_currentDate)}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 30),
                        child: Text(
                          'Điều 2: Chế độ thăm khám và theo dõi',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 30),
                        child: Text(
                          'Điều 3: Trách nhiệm của hai bên',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => _updateAcceptState(),
                        borderRadius: BorderRadius.circular(40),
                        child: _isAccept
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset('assets/images/ic-dot.png'),
                              )
                            : SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                    'assets/images/ic-dot-unselect.png'),
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Text(
                        'Tôi đồng ý với tất cả các điều khoản.',
                        style: TextStyle(
                          color: DefaultTheme.GREY_TEXT,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => _updateAcceptState2(),
                        borderRadius: BorderRadius.circular(40),
                        child: _isAccept2
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset('assets/images/ic-dot.png'),
                              )
                            : SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                    'assets/images/ic-dot-unselect.png'),
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 70,
                        child: Text(
                          'Tôi xác nhận tất cả các thông tin chia sẻ là sự thật và hoàn toàn chịu trách nhiệm trước pháp luật.',
                          style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                //
              ]),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 30),
              child: Column(
                children: <Widget>[
                  //
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 3, right: 3),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3, right: 3),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3, right: 3),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: DefaultTheme.GREY_TOP_TAB_BAR,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      'Xác nhận bản nháp hợp đồng',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      'Bước 3',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: DefaultTheme.GREY_TEXT),
                    ),
                  ),
                  //
                  (_isAccept == false || _isAccept2 == false)
                      ? Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          height: 50,
                          decoration: BoxDecoration(
                              color: DefaultTheme.GREY_BUTTON,
                              borderRadius: BorderRadius.circular(10)),
                          child: Align(
                            alignment: Alignment.center,
                            heightFactor: 50,
                            child: Text('Gửi yêu cầu',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16)),
                          ),
                        )
                      : new Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: ButtonHDr(
                              label: 'Gửi yêu cầu',
                              style: BtnStyle.BUTTON_BLACK,
                              onTap: () {
                                if (_isAccept) {
                                  if (_requestContract.doctorId != 0 ||
                                      _requestContract.doctorId != null) {
                                    if (_requestContract.patientId != null ||
                                        _requestContract.patientId != 0) {
                                      _requestContract.dateStarted = dateStart;
                                      _requestContract.note = note;
                                      _sendRequestContract(_requestContract);
                                    }
                                  } else {
                                    return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 25, sigmaY: 25),
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      top: 10,
                                                      right: 10),
                                                  width: 250,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    color: DefaultTheme.WHITE
                                                        .withOpacity(0.7),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10,
                                                                top: 10),
                                                        child: Text(
                                                          'Gửi yêu cầu thất bại',
                                                          style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            color: DefaultTheme
                                                                .BLACK,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                right: 20),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'Kiểm tra lại kết nối mạng',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                              color: DefaultTheme
                                                                  .GREY_TEXT,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Divider(
                                                        height: 1,
                                                        color: DefaultTheme
                                                            .GREY_TOP_TAB_BAR,
                                                      ),
                                                      ButtonHDr(
                                                        height: 40,
                                                        style: BtnStyle
                                                            .BUTTON_TRANSPARENT,
                                                        label: 'OK',
                                                        labelColor: DefaultTheme
                                                            .BLUE_TEXT,
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                }
                              }),
                        ),
                  //
                ],
              ),
            ),
          ],
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
              width: 30,
              height: 30,
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
        doctorDTO = state.dto;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //
            Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
              child: Text(
                'Bên B: ${state.dto.fullName} (Bác sĩ)',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: 'NewYork'),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: 130,
                  child: Text(
                    'Công tác tại:',
                    style: TextStyle(
                        color: DefaultTheme.GREY_TEXT,
                        fontSize: 15,
                        fontFamily: 'NewYork'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - (40 + 120 + 20),
                  child: Text(
                    '${doctorDTO.workLocation}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'NewYork'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: 130,
                  child: Text(
                    'Chuyên khoa:',
                    style: TextStyle(
                        color: DefaultTheme.GREY_TEXT,
                        fontSize: 15,
                        fontFamily: 'NewYork'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - (40 + 120 + 20),
                  child: Text(
                    '${state.dto.specialization}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'NewYork'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: 130,
                  child: Text(
                    'Điện thoại:',
                    style: TextStyle(
                        color: DefaultTheme.GREY_TEXT,
                        fontSize: 15,
                        fontFamily: 'NewYork'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - (40 + 120 + 20),
                  child: Text(
                    '${state.dto.phone}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'NewYork'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: 130,
                  child: Text(
                    'Ngày sinh:',
                    style: TextStyle(
                        color: DefaultTheme.GREY_TEXT,
                        fontSize: 15,
                        fontFamily: 'NewYork'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - (40 + 120 + 20),
                  child: Text(
                    '${_dateValidator.parseToDateView(state.dto.dateOfBirth)}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'NewYork'),
                  ),
                ),
              ],
            ),
          ],
        );
      }
      return Container();
    });
  }

  _getPatientInfo(int _patientId) {
    return BlocProvider(
      create: (context4) => PatientBloc(patientRepository: patientRepository)
        ..add(PatientEventSetId(id: _patientId)),
      child: BlocBuilder<PatientBloc, PatientState>(
        builder: (context4, state4) {
          if (state4 is PatientStateLoading) {
            return Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: DefaultTheme.GREY_BUTTON),
              child: Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/images/loading.gif'),
                ),
              ),
            );
          }
          if (state4 is PatientStateFailure) {
            return Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: DefaultTheme.GREY_BUTTON),
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
          if (state4 is PatientStateSuccess) {
            if (state4.dto == null) {
              return Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: DefaultTheme.GREY_BUTTON),
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
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 30),
                    child: Text(
                      'Bên A: ${state4.dto.fullName} (Bệnh nhân)',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: 'NewYork'),
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        width: 130,
                        child: Text(
                          'ĐC thường trú:',
                          style: TextStyle(
                              color: DefaultTheme.GREY_TEXT,
                              fontSize: 15,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Container(
                        width:
                            MediaQuery.of(context).size.width - (40 + 120 + 20),
                        child: Text(
                          '${state4.dto.address}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        width: 130,
                        child: Text(
                          'Điện thoại:',
                          style: TextStyle(
                              color: DefaultTheme.GREY_TEXT,
                              fontSize: 15,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Container(
                        width:
                            MediaQuery.of(context).size.width - (40 + 120 + 20),
                        child: Text(
                          '${state4.dto.phoneNumber}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        width: 130,
                        child: Text(
                          'Ngày sinh:',
                          style: TextStyle(
                              color: DefaultTheme.GREY_TEXT,
                              fontSize: 15,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Container(
                        width:
                            MediaQuery.of(context).size.width - (40 + 120 + 20),
                        child: Text(
                          '${_dateValidator.parseToDateView(state4.dto.dateOfBirth)}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        width: 130,
                        child: Text(
                          'Giới tính:',
                          style: TextStyle(
                              color: DefaultTheme.GREY_TEXT,
                              fontSize: 15,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Container(
                        width:
                            MediaQuery.of(context).size.width - (40 + 120 + 20),
                        child: Text(
                          '${state4.dto.gender}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        width: 130,
                        child: Text(
                          'Nghề nghiệp:',
                          style: TextStyle(
                              color: DefaultTheme.GREY_TEXT,
                              fontSize: 15,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Container(
                        width:
                            MediaQuery.of(context).size.width - (40 + 120 + 20),
                        child: Text(
                          '${state4.dto.career}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: DefaultTheme.GREY_BUTTON),
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
        },
      ),
    );
  }

  _sendRequestContract(RequestContractDTO dto) {
    // _requestContractBloc.add(RequestContractEventSend(dto: dto));
    // Navigator.pushNamedAndRemoveUntil(
    //     context, RoutesHDr.MAIN_HOME, (Route<dynamic> route) => false);

    setState(() {
      //
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
                    width: 250,
                    height: 150,
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
                            'Đang gửi yêu cầu',
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
            );
          });
      //
      if (dto != null) {
        //

        _requestContractBloc.add(RequestContractEventSend(dto: dto));
        Future.delayed(const Duration(seconds: 3), () {
          //
          _contractHelper.isSent().then((value) async {
            //
            if (value == true) {
              // Navigator.of(context).pop();
              // await Navigator.pushNamedAndRemoveUntil(context,
              //     RoutesHDr.MAIN_HOME, (Route<dynamic> route) => false);
              Navigator.of(context).pop();
              Future.delayed(const Duration(seconds: 1), () {
                return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                            child: Container(
                              padding:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              width: MediaQuery.of(context).size.width - 40,
                              height: MediaQuery.of(context).size.height * 0.8,
                              decoration: BoxDecoration(
                                color: DefaultTheme.WHITE.withOpacity(0.8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                      bottom: 10,
                                      top: 10,
                                      left: 20,
                                    ),
                                    child: Text(
                                      'Yêu cầu hợp đồng',
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: DefaultTheme.BLACK,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                      ),
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                DefaultTheme.GRADIENT_1,
                                                DefaultTheme.GRADIENT_2
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 20),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Thành công',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              decoration: TextDecoration.none,
                                              foreground: Paint()
                                                ..shader = _normalHealthColors,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 20),
                                    child: Divider(
                                      height: 2,
                                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'THÔNG TIN BÁC SĨ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: DefaultTheme.GREY_TEXT,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Họ và tên',
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
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${doctorDTO.fullName}',
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
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Số điện thoại',
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
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${doctorDTO.phone}',
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
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 20),
                                    child: Divider(
                                      height: 2,
                                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'THÔNG TIN CHI TIẾT',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: DefaultTheme.GREY_TEXT,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Ngày tạo',
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
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${_dateValidator.parseToDateView(_currentDate)}',
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
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, top: 30),
                                    width: MediaQuery.of(context).size.width,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Yêu cầu của bạn đã được gửi đến bác sĩ, giá trị của hợp đồng sẽ được bác sĩ đưa ra và sẽ được thông báo đến bạn trong thời gian sớm nhất (chậm nhất là 3 ngày kể từ ngày gửi yêu cầu).',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: DefaultTheme.BLACK,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 6,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Divider(
                                    height: 1,
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: ButtonHDr(
                                      height: 40,
                                      style: BtnStyle.BUTTON_TRANSPARENT,
                                      label: 'XÁC NHẬN',
                                      labelColor: DefaultTheme.BLUE_TEXT,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              });
            } else {
              String msg = '';
              _contractHelper.getMsgSendContract().then((value) async {
                msg = value;
              });
              Navigator.of(context).pop();
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 10, top: 10, right: 10),
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
                                  padding: EdgeInsets.only(bottom: 10, top: 10),
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
                                  padding: EdgeInsets.only(left: 20, right: 20),
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
                    );
                  });
            }
          });
        });
      }
    });
  }
}
