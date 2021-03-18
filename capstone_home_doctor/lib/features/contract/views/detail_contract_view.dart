import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_full_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_id_now_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_update_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/doctor_info_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/contract_full_event.dart';
import 'package:capstone_home_doctor/features/contract/events/contract_id_now_event.dart';
import 'package:capstone_home_doctor/features/contract/events/contract_update_event.dart';
import 'package:capstone_home_doctor/features/contract/events/doctor_info_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/doctor_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_full_state_dto.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_id_now_state.dart';
import 'package:capstone_home_doctor/features/contract/states/doctor_info_state.dart';
import 'package:capstone_home_doctor/features/information/blocs/patient_bloc.dart';
import 'package:capstone_home_doctor/features/information/events/patient_event.dart';
import 'package:capstone_home_doctor/features/information/repositories/patient_repository.dart';
import 'package:capstone_home_doctor/features/information/states/patient_state.dart';
import 'package:capstone_home_doctor/models/contract_full_dto.dart';
import 'package:capstone_home_doctor/models/contract_update_dto.dart';
import 'package:capstone_home_doctor/models/doctor_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

//
final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final ContractHelper _contractHelper = ContractHelper();
final DateValidator _dateValidator = DateValidator();

final Shader _normalHealthColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_1,
    DefaultTheme.GRADIENT_2,
  ],
).createShader(new Rect.fromLTWH(10.0, 1.0, 100.0, 90.0));

class DetailContractView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailContractView();
  }
}

class _DetailContractView extends State<DetailContractView>
    with WidgetsBindingObserver {
  bool _isAccept = false;
  int _patientId = 0;
  int _doctorId = 0;
  int _contractId = 0;
  ContractIdNowBloc _contractIdNowBloc;
  ContractFullBloc _contractFullBloc;
  ContractUpdateBloc _contractUpdateBloc;
  ContractFullDTO _contractFullDTO = ContractFullDTO();
  String _stateContract = '';
  String _currentDate = DateTime.now().toString().split(' ')[0];
  DoctorDTO doctorDTO = DoctorDTO();
  //
  DoctorRepository doctorRepository =
      DoctorRepository(httpClient: http.Client());
  PatientRepository patientRepository =
      PatientRepository(httpClient: http.Client());
  //

  //
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _getPatientId();
    _contractIdNowBloc = BlocProvider.of(context);
    _contractFullBloc = BlocProvider.of(context);
    _contractUpdateBloc = BlocProvider.of(context);
    _refreshData();
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        _patientId = value;
      });
    });
  }
  //   await _contractHelper.getDoctorId().then((value) {
  //     _doctorId = value;
  //   });
  //   if (_patientId != 0 && _doctorId != 0) {
  //     _contractIdNowBloc
  //         .add(ContractIdNowEventSetPIdAndDId(pId: _patientId, dId: _doctorId));
  //   }
  // }

  // _refreshPage() async {
  //   if (_patientId != 0 && _doctorId != 0) {
  //     _contractIdNowBloc
  //         .add(ContractIdNowEventSetPIdAndDId(pId: _patientId, dId: _doctorId));
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future _refreshData() async {
    setState(() {
      //   _contractId = 0;
      //   _contractIdNowBloc
      //       .add(ContractIdNowEventSetPIdAndDId(pId: _patientId, dId: _doctorId));

      if (_contractId != 0) {
        _contractFullBloc.add(ContractFullEventSetCId(cId: _contractId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //idContract

    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
    //

    //
    setState(() {
      _contractId = 0;
      _contractId = arguments['C_ID'];
    });
    _refreshData();
    print('contract id ${_contractId}');
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      // backgroundColor: DefaultTheme.WHITE,
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //
              HeaderWidget(
                title: 'Chi tiết hợp đồng',
                isMainView: false,
                buttonHeaderType: ButtonHeaderType.BACK_HOME,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: Divider(
                  height: 1,
                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                ),
              ),
              //
              BlocBuilder<ContractIdNowBloc, ContractIdNowState>(
                builder: (context, state) {
                  if (state is ContractIdNowStateLoading) {
                    return Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset('assets/images/loading.gif'),
                        ),
                      ),
                    );
                  }
                  if (state is ContractIdNowStateFailure) {
                    return Container(
                      width: 200,
                      height: 200,
                      child: Text('Lỗi'),
                    );
                  }
                  if (state is ContractIdNowStateSuccess) {
                    _contractId = 0;
                    setState(() {
                      _contractId = state.id;
                    });

                    if (_contractId != 0) {
                      _contractFullBloc
                          .add(ContractFullEventSetCId(cId: _contractId));
                    }
                  }

                  return (_contractId != 0)
                      ? Expanded(
                          child:
                              BlocBuilder<ContractFullBloc, ContractFullState>(
                            builder: (context, state) {
                              //
                              if (state is ContractFullStateLoading) {
                                return Container(
                                  width: 200,
                                  height: 200,
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(
                                        'assets/images/loading.gif'),
                                  ),
                                );
                              }
                              if (state is ContractFullStateFailure) {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child: Text(
                                            'Kiểm tra lại đường truyền kết nối mạng')));
                              }
                              if (state is ContractFullStateSuccess) {
                                _contractFullDTO = state.dto;
                                _stateContract = state.dto.status;
                              }
                              if (_contractId == 0) {
                                _refreshData();
                              }
                              if (_contractFullDTO.contractCode == null) {
                                _refreshData();
                              }

                              return RefreshIndicator(
                                onRefresh: _refreshData,
                                child: ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    //
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        'Hợp đồng mã ${_contractFullDTO.contractCode}',
                                        style: TextStyle(
                                            foreground: Paint()
                                              ..shader = _normalHealthColors,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        'Ngày tạo ${_dateValidator.parseToDateView2(_contractFullDTO.dateCreated)}',
                                        style: TextStyle(
                                            color: DefaultTheme.GREY_TEXT,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    //

                                    Padding(
                                      padding: EdgeInsets.only(bottom: 40),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 20, bottom: 20),
                                      child: Text(
                                        'Thông tin hai bên',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        //
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 20,
                                          child: Text(
                                            'Bác sĩ',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100 -
                                              40,
                                          height: 20,
                                          child: Text(
                                            '${_contractFullDTO.fullNameDoctor}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                    ),
                                    Row(
                                      children: [
                                        //
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                        Container(
                                          width: 100,
                                          child: Text(
                                            'Nơi làm việc',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100 -
                                              40,
                                          child: Text(
                                            '${_contractFullDTO.workLocationDoctor}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                    ),
                                    Row(
                                      children: [
                                        //
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 20,
                                          child: Text(
                                            'Điện thoại',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100 -
                                              40,
                                          height: 20,
                                          child: Text(
                                            '${_contractFullDTO.phoneNumberDoctor}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 30,
                                          top: 10,
                                          left: 20,
                                          right: 20),
                                      child: Divider(
                                        height: 1,
                                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        //
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 20,
                                          child: Text(
                                            'Bệnh nhân',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100 -
                                              40,
                                          height: 20,
                                          child: Text(
                                            '${_contractFullDTO.fullNamePatient}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                    ),
                                    Row(
                                      children: [
                                        //
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                        Container(
                                          width: 100,
                                          child: Text(
                                            'Địa chỉ',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100 -
                                              40,
                                          child: Text(
                                            '${_contractFullDTO.addressPatient}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                      ],
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(bottom: 40),
                                    ),
                                    //
                                    (_contractFullDTO.nameLicense != null &&
                                            _contractFullDTO.daysOfTracking !=
                                                null)
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              //
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 20, bottom: 20),
                                                child: Text(
                                                  'Thông tin giá tiền',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  //
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    child: Text(
                                                      'Số ngày theo dõi',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            150 -
                                                            40,
                                                    child: Text(
                                                      '${_contractFullDTO.daysOfTracking} ngày',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                              ),
                                              Row(
                                                children: [
                                                  //
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    child: Text(
                                                      'Thành tiền',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            150 -
                                                            40,
                                                    child: Text(
                                                      '${_contractFullDTO.daysOfTracking * _contractFullDTO.priceLicense} VND',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: DefaultTheme
                                                              .BLUE_TEXT),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              //
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 20, bottom: 10),
                                                child: Text(
                                                  'Thông tin giá tiền',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 20, bottom: 20),
                                                child: Text(
                                                  'Được cập nhật sau khi bác sĩ phê duyệt',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 40),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 20, bottom: 20),
                                      child: Text(
                                        'Trạng thái hợp đồng',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),

                                    /////////////////

                                    //
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: (_stateContract
                                                    .contains('PENDING'))
                                                ? SizedBox(
                                                    width: 35,
                                                    height: 35,
                                                    child: Image.asset(
                                                        'assets/images/ic-contract.png'),
                                                  )
                                                : Container(),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: (_stateContract
                                                    .contains('APPROVED'))
                                                ? SizedBox(
                                                    width: 35,
                                                    height: 35,
                                                    child: Image.asset(
                                                        'assets/images/ic-contract.png'),
                                                  )
                                                : Container(),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: (_stateContract
                                                    .contains('ACTIVE'))
                                                ? SizedBox(
                                                    width: 35,
                                                    height: 35,
                                                    child: Image.asset(
                                                        'assets/images/ic-contract.png'),
                                                  )
                                                : Container(),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: (_stateContract
                                                    .contains('FINISHED'))
                                                ? SizedBox(
                                                    width: 35,
                                                    height: 35,
                                                    child: Image.asset(
                                                        'assets/images/ic-contract.png'),
                                                  )
                                                : Container(),
                                          ),
                                        ]),
//
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          height: 50,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 2,
                                                    color: DefaultTheme
                                                        .GREY_TOP_TAB_BAR,
                                                    width:
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    0.25) /
                                                                2) -
                                                            10,
                                                  ),
                                                  (_stateContract.contains(
                                                              'PENDING') ||
                                                          _stateContract
                                                              .contains(
                                                                  'APPROVED') ||
                                                          _stateContract
                                                              .contains(
                                                                  'ACTIVE') ||
                                                          _stateContract
                                                              .contains(
                                                                  'FINISHED'))
                                                      ? SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: Image.asset(
                                                              'assets/images/ic-dot.png'),
                                                        )
                                                      : SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: Image.asset(
                                                              'assets/images/ic-dot-unselect.png'),
                                                        ),
                                                  Container(
                                                    height: 2,
                                                    color: DefaultTheme
                                                        .GREY_TOP_TAB_BAR,
                                                    width:
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    0.25) /
                                                                2) -
                                                            10,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        //
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          height: 50,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 2,
                                                    color: DefaultTheme
                                                        .GREY_TOP_TAB_BAR,
                                                    width:
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    0.25) /
                                                                2) -
                                                            10,
                                                  ),
                                                  (_stateContract.contains(
                                                              'APPROVED') ||
                                                          _stateContract
                                                              .contains(
                                                                  'ACTIVE') ||
                                                          _stateContract
                                                              .contains(
                                                                  'FINISHED'))
                                                      ? SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: Image.asset(
                                                              'assets/images/ic-dot.png'),
                                                        )
                                                      : SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: Image.asset(
                                                              'assets/images/ic-dot-unselect.png'),
                                                        ),
                                                  Container(
                                                    height: 2,
                                                    color: DefaultTheme
                                                        .GREY_TOP_TAB_BAR,
                                                    width:
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    0.25) /
                                                                2) -
                                                            10,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        //
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          height: 50,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 2,
                                                    color: DefaultTheme
                                                        .GREY_TOP_TAB_BAR,
                                                    width:
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    0.25) /
                                                                2) -
                                                            10,
                                                  ),
                                                  (_stateContract.contains(
                                                              'ACTIVE') ||
                                                          _stateContract
                                                              .contains(
                                                                  'FINISHED'))
                                                      ? SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: Image.asset(
                                                              'assets/images/ic-dot.png'),
                                                        )
                                                      : SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: Image.asset(
                                                              'assets/images/ic-dot-unselect.png'),
                                                        ),
                                                  Container(
                                                    height: 2,
                                                    color: DefaultTheme
                                                        .GREY_TOP_TAB_BAR,
                                                    width:
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    0.25) /
                                                                2) -
                                                            10,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          height: 50,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 2,
                                                    color: DefaultTheme
                                                        .GREY_TOP_TAB_BAR,
                                                    width:
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    0.25) /
                                                                2) -
                                                            10,
                                                  ),
                                                  (_stateContract
                                                          .contains('FINISHED'))
                                                      ? SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: Image.asset(
                                                              'assets/images/ic-dot.png'),
                                                        )
                                                      : SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: Image.asset(
                                                              'assets/images/ic-dot-unselect.png'),
                                                        ),
                                                  Container(
                                                    height: 2,
                                                    color: DefaultTheme
                                                        .GREY_TOP_TAB_BAR,
                                                    width:
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    0.25) /
                                                                2) -
                                                            10,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: Center(
                                              child: Text('Yêu cầu'),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: Center(
                                              child: Text('Đã duyệt'),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: Center(
                                              child: Text('Hiện hành'),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: Center(
                                              child: Text('Đã kết thúc'),
                                            ),
                                          ),
                                        ]),
                                    /////////
                                    ///
                                    ///
                                    ///

                                    (_stateContract.contains('APPROVED'))
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20, top: 30),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: DefaultTheme.ORANGE_TEXT
                                                    .withOpacity(0.3)),
                                            child: ButtonHDr(
                                              label: 'Xác nhận hợp đồng',
                                              // image: Image.asset(
                                              //     'assets/images/ic-note.png'),
                                              style: BtnStyle.BUTTON_IN_LIST,
                                              imgHeight: 30,
                                              labelColor:
                                                  DefaultTheme.ORANGE_TEXT,
                                              onTap: () {
                                                //
                                                ContractUpdateDTO
                                                    contractUpdateDTO =
                                                    ContractUpdateDTO(
                                                  contractId: _contractId,
                                                  doctorId: 1,
                                                  patientId: _patientId,
                                                  status: 'ACTIVE',
                                                );

                                                _showContractDocument(
                                                    contractUpdateDTO, true);
                                              },
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20, top: 30),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: DefaultTheme.GREY_VIEW),
                                            child: ButtonHDr(
                                              label: 'Xem bản hợp đồng',
                                              image: Image.asset(
                                                  'assets/images/ic-contract.png'),
                                              style: BtnStyle.BUTTON_IN_LIST,
                                              imgHeight: 30,
                                              labelColor: DefaultTheme.BLACK,
                                              onTap: () {
                                                //
                                                ContractUpdateDTO
                                                    contractUpdateDTO =
                                                    ContractUpdateDTO(
                                                  contractId: _contractId,
                                                  doctorId: 1,
                                                  patientId: _patientId,
                                                  status: 'ACTIVE',
                                                );

                                                _showContractDocument(
                                                    contractUpdateDTO, false);

                                                // _contractUpdateBloc.add(
                                                //     ContractUpdateEventUpdate(
                                                //         dto:
                                                //             contractUpdateDTO));
                                                // _refreshData();
                                              },
                                            ),
                                          ),

                                    ///
                                    ///
                                    ///
                                    ///
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 40),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 20, bottom: 10),
                                      child: Text(
                                        'Bệnh lý theo dõi',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    (_contractFullDTO.diseases == null)
                                        ? Container()
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: _contractFullDTO
                                                .diseases.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                margin: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 5),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    40,
                                                child: Text(
                                                  '${_contractFullDTO.diseases[index].diseaseId} - ${_contractFullDTO.diseases[index].nameDisease}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 50,
                                        bottom: 30,
                                      ),
                                      child: ButtonHDr(
                                        style: BtnStyle.BUTTON_GREY,
                                        label: 'Chia sẻ thêm y lệnh',
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              RoutesHDr.MEDICAL_SHARE,
                                              arguments: _contractId);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : Container();
                },
              ),
            ]),
      ),
    );
  }
  //

  _showContractDocument(ContractUpdateDTO dto, bool isSigned) {
    //

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            _updateAcceptState() {
              setModalState(() {
                _isAccept = !_isAccept;
              });
            }

            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Stack(
                  //
                  children: <Widget>[
                    //
                    Container(
                      height: MediaQuery.of(context).size.height * 0.96,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      color: DefaultTheme.TRANSPARENT,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.96,
                        padding: EdgeInsets.only(top: 1),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                          color: DefaultTheme.GREY_VIEW,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              //
                              Expanded(
                                child: ListView(children: <Widget>[
                                  //
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: DefaultTheme.GREY_VIEW),
                                    margin: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 20,
                                        bottom: 20),
                                    padding:
                                        EdgeInsets.only(top: 30, bottom: 30),
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'CỘNG HOÀ XÃ HỘI CHỦ NGHĨA VIỆT NAM',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 30),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Độc lập - Tự do - Hạnh phúc',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
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
                                          padding: EdgeInsets.only(
                                              top: 20, left: 20, right: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
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
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
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
                                                padding:
                                                    EdgeInsets.only(bottom: 20),
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
                                        _getPatientInfo(dto.patientId),

                                        ///
                                        ///
                                        BlocProvider(
                                          create: (context) => DoctorInfoBloc(
                                              doctorAPI: doctorRepository)
                                            ..add(DoctorInfoEventSetId(
                                                id: dto.doctorId)),
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
                                          padding: EdgeInsets.only(
                                              top: 30, left: 20, right: 20),
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
                                              left: 20,
                                              right: 20,
                                              bottom: 10,
                                              top: 20),
                                          child: Text(
                                            'Điều 1: Thời hạn và nhiệm vụ hợp đồng',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 20),
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
                                              left: 20,
                                              right: 20,
                                              bottom: 10,
                                              top: 30),
                                          child: Text(
                                            'Điều 2: Chế độ thăm khám và theo dõi',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 20),
                                          child: Text(
                                            'Bên B sẽ sử dụng HDr system để hỗ trợ khám và tư vấn cho bên A.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 20,
                                              top: 30),
                                          child: Text(
                                            'Điều 3: Nghĩa vụ và quyền lợi của bên A',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 20),
                                          child: Text(
                                            '1. Quyền lợi của bên A:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            'a) Được khám, chữa bệnh và chăm sóc dưới sự giám sát của bên B.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            'b) Đề xuất, khiếu nại hoặc đề nghị thay đổi hoặc chấm dứt hợp đồng.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            'c) Bên A có thể chấm dứt hợp đồng bất cứ khi nào.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 20,
                                              top: 20),
                                          child: Text(
                                            '2. Nghĩa vụ:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            'a) Cung cấp những thông tin cần thiết cho bên B để có thể theo dõi và khám chữa bệnh.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            'b) Hoàn thành những nghĩa vụ đã cam kết trong hợp đồng giữa hai bên theo các điều mục 5,6 bên dưới.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            'c) Phối hợp theo đúng chỉ định của bên B về việc khám và chữa bệnh.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            'd) Chấp hành nội quy, quy chế theo quy định của bộ y tế về việc tổ chức khám chữa bệnh.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 20,
                                              top: 30),
                                          child: Text(
                                            'Điều 4. Nghĩa vụ và quyền lợi của bên B',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 20),
                                          child: Text(
                                            '1. Quyền lợi của bên B:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            'a) Yêu cầu bên A cung cấp và chia sẻ các thông tin cần thiết.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            'b) Bên B có thể đơn phương chấm dứt hợp đồng khi có bằng chứng việc bên A có những sai phạm trong các điều khoản 5 và 6 cũng như các nghĩa vụ mà bên A phải thực hiện hoặc sai phạm luật của bộ y tế theo nghị định số 87/2011/NĐ-CP ngày 27 tháng 9 năm 2011 cũng như không tuân thủ các quy định được đưa ra trong ứng dụng HDr, gây ảnh hưởng tới việc không thể theo dõi và chăm sóc bệnh nhân.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 20,
                                              top: 20),
                                          child: Text(
                                            '2. Nghĩa vụ của bên B:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            'a) Xác nhận quá trình theo quy định của Luật khám bệnh, chữa bệnh ngày 23 tháng 11 năm 2009; Nghị định số 87/2011/NĐ-CP ngày 27 tháng 9 năm 2011 của Chính phủ quy định chi tiết và hướng dẫn thi hành một số điều của Luật khám bệnh, chữa bệnh và Thông tư số 41/2011/TT-BYT ngày 14 tháng 11 năm 2011 của Bộ trưởng Bộ Y tế Hướng dẫn cấp chứng chỉ hành nghề đối với người hành nghề và cấp giấy phép hoạt động đối với cơ sở khám bệnh, chữa bệnh.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            'b) Đảm bảo thực hiện đầy đủ những điều đã cam kết trong hợp đồng làm việc.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            'c) Không được chấm dứt hợp đồng nếu bên A không sai phạm các điều luật đã quy định trong hợp đồng.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            'd) Khi bên B tự động chấm dứt hợp đồng trước thời hạn, phải bồi thường cho bên A theo quy định của pháp luật.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 20,
                                              top: 30),
                                          child: Text(
                                            'Điều 5. Nghĩa vụ và quyền lợi của bên B',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            '1. Khi có tranh chấp, hai bên thống nhất giải quyết trên nguyên tắc bình đẳng, hợp tác, hòa giải. Trong thời gian tranh chấp, hai Bên vẫn phải bảo đảm điều kiện để khám bệnh, chữa bệnh đầy đủ.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            '2. Trường hợp hai Bên không hòa giải được sẽ báo cáo cơ quan có thẩm quyền giải quyết.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 20,
                                              top: 30),
                                          child: Text(
                                            'Điều 6. Tiền dịch vụ và phương thức thanh toán',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        (_contractFullDTO.priceLicense != null)
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 10),
                                                child: Text(
                                                  '- Phí tiền dịch vụ: ${_contractFullDTO.daysOfTracking * _contractFullDTO.priceLicense} VND',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      fontFamily: 'NewYork'),
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 10),
                                                child: Text(
                                                  '- Phí tiền dịch vụ: Được cập nhật sau khi bác sĩ phê duyệt',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      fontFamily: 'NewYork'),
                                                ),
                                              ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            '- Phương thức thanh toán: Chuyển khoản trực tiếp vào tài khoản của HDr (Tên TK: Home Doctor Vietnam, Số TK: 123456789, Ngân hàng TP Bank)',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 20,
                                              top: 30),
                                          child: Text(
                                            'Điều 7. Cam kết chung',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            '1. Hai bên cam kết thực hiện đúng những điều khoản trong hợp đồng, những vấn đề phát sinh khác ngoài hợp đồng, kể cả việc kéo dài hoặc chấm dứt hợp đồng trước thời hạn sẽ được hai bên cùng thảo luận giải quyết, thể hiện bằng việc ký kết một hợp mới, hợp đồng hiện hành sẽ hết hạn kể từ khi hợp đồng mới được ký.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Text(
                                            '2. Hai bên thống nhất việc sử dụng ứng dụng HDr cho việc khám chữa bệnh và tuân thủ các quy định liên quan tới phần mềm để hỗ trợ việc theo dõi bệnh.',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  (isSigned)
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () =>
                                                    _updateAcceptState(),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                child: _isAccept
                                                    ? SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: Image.asset(
                                                            'assets/images/ic-dot.png'),
                                                      )
                                                    : SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: Image.asset(
                                                            'assets/images/ic-dot-unselect.png'),
                                                      ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
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
                                        )
                                      : Container(),
                                  (isSigned && _isAccept)
                                      ? Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              bottom: 30, left: 20, right: 20),
                                          child: ButtonHDr(
                                            style: BtnStyle.BUTTON_BLACK,
                                            label: 'Xác nhận hợp đồng',
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _contractUpdateBloc.add(
                                                  ContractUpdateEventUpdate(
                                                      dto: dto));
                                              _refreshData();
                                            },
                                          ),
                                        )
                                      : (isSigned && _isAccept == false)
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 30,
                                                  left: 20,
                                                  right: 20),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: DefaultTheme
                                                      .GREY_TOP_TAB_BAR,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Align(
                                                alignment: Alignment.center,
                                                heightFactor: 50,
                                                child: Text('Gửi yêu cầu',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16)),
                                              ),
                                            )
                                          : Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 50,
                                              margin: EdgeInsets.only(
                                                  bottom: 30,
                                                  left: 20,
                                                  right: 20),
                                              child: ButtonHDr(
                                                style: BtnStyle.BUTTON_BLACK,
                                                label: 'Đóng',
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                ]),
                              ),
                            ]),
                      ),
                    ),
                    Positioned(
                      top: 23,
                      left: MediaQuery.of(context).size.width * 0.3,
                      height: 5,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.3),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 15,
                        decoration: BoxDecoration(
                            color: DefaultTheme.WHITE.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  ],
                ));
          });
        });
  }

  //
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

  //

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
}
