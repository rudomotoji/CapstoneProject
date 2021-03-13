import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_full_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_id_now_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_update_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/contract_full_event.dart';
import 'package:capstone_home_doctor/features/contract/events/contract_id_now_event.dart';
import 'package:capstone_home_doctor/features/contract/events/contract_update_event.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_full_state_dto.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_id_now_state.dart';
import 'package:capstone_home_doctor/models/contract_full_dto.dart';
import 'package:capstone_home_doctor/models/contract_update_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class ContractStatusDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContractStatusDetail();
  }
}

class _ContractStatusDetail extends State<ContractStatusDetail>
    with WidgetsBindingObserver {
  int _patientId = 0;
  int _doctorId = 0;
  int _contractId = 0;
  ContractIdNowBloc _contractIdNowBloc;
  ContractFullBloc _contractFullBloc;
  ContractUpdateBloc _contractUpdateBloc;
  ContractFullDTO _contractFullDTO = ContractFullDTO();
  String _stateContract = '';
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _getContractId();
    _contractIdNowBloc = BlocProvider.of(context);
    _contractFullBloc = BlocProvider.of(context);
    _contractUpdateBloc = BlocProvider.of(context);
  }

  _getContractId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        _patientId = value;
      });
    });
    await _contractHelper.getDoctorId().then((value) {
      _doctorId = value;
    });
    _doctorId = 2;
    if (_patientId != 0 && _doctorId != 0) {
      _contractIdNowBloc
          .add(ContractIdNowEventSetPIdAndDId(pId: _patientId, dId: _doctorId));
    }
  }

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
                title: 'Trạng thái hợp đồng',
                isMainView: true,
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
                  if (state is ContractIdNowStateLoading) {}
                  if (state is ContractIdNowStateFailure) {}
                  if (state is ContractIdNowStateSuccess) {
                    _contractId = state.id;
                    if (_contractId != 0) {
                      _contractFullBloc
                          .add(ContractFullEventSetCId(cId: _contractId));
                    }
                  }
                  return Expanded(
                    child: BlocBuilder<ContractFullBloc, ContractFullState>(
                      builder: (context, state) {
                        //
                        if (state is ContractFullStateLoading) {
                          return Container(
                            width: 200,
                            height: 200,
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/images/loading.gif'),
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
                        return RefreshIndicator(
                          onRefresh: _refreshData,
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              //
                              Container(
                                width: MediaQuery.of(context).size.width - 40,
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
                                width: MediaQuery.of(context).size.width - 40,
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
                                margin: EdgeInsets.only(left: 20, bottom: 20),
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
                                    width: MediaQuery.of(context).size.width -
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
                                    height: 20,
                                    child: Text(
                                      'Làm việc tại',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        100 -
                                        40,
                                    height: 20,
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
                                    width: MediaQuery.of(context).size.width -
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
                                    bottom: 30, top: 10, left: 20, right: 20),
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
                                    width: MediaQuery.of(context).size.width -
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
                                    height: 20,
                                    child: Text(
                                      'Địa chỉ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        100 -
                                        40,
                                    height: 20,
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
                                padding: EdgeInsets.only(bottom: 5),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 40),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20, bottom: 20),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child:
                                          (_stateContract.contains('PENDING'))
                                              ? SizedBox(
                                                  width: 35,
                                                  height: 35,
                                                  child: Image.asset(
                                                      'assets/images/ic-contract.png'),
                                                )
                                              : Container(),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child:
                                          (_stateContract.contains('APPROVED'))
                                              ? SizedBox(
                                                  width: 35,
                                                  height: 35,
                                                  child: Image.asset(
                                                      'assets/images/ic-contract.png'),
                                                )
                                              : Container(),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: (_stateContract.contains('ACTIVE'))
                                          ? SizedBox(
                                              width: 35,
                                              height: 35,
                                              child: Image.asset(
                                                  'assets/images/ic-contract.png'),
                                            )
                                          : Container(),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child:
                                          (_stateContract.contains('FINISHED'))
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
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
                                              color:
                                                  DefaultTheme.GREY_TOP_TAB_BAR,
                                              width: ((MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.25) /
                                                      2) -
                                                  10,
                                            ),
                                            (_stateContract
                                                        .contains('PENDING') ||
                                                    _stateContract
                                                        .contains('APPROVED') ||
                                                    _stateContract
                                                        .contains('ACTIVE') ||
                                                    _stateContract
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
                                              color:
                                                  DefaultTheme.GREY_TOP_TAB_BAR,
                                              width: ((MediaQuery.of(context)
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
                                    width: MediaQuery.of(context).size.width *
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
                                              color:
                                                  DefaultTheme.GREY_TOP_TAB_BAR,
                                              width: ((MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.25) /
                                                      2) -
                                                  10,
                                            ),
                                            (_stateContract
                                                        .contains('APPROVED') ||
                                                    _stateContract
                                                        .contains('ACTIVE') ||
                                                    _stateContract
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
                                              color:
                                                  DefaultTheme.GREY_TOP_TAB_BAR,
                                              width: ((MediaQuery.of(context)
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
                                    width: MediaQuery.of(context).size.width *
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
                                              color:
                                                  DefaultTheme.GREY_TOP_TAB_BAR,
                                              width: ((MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.25) /
                                                      2) -
                                                  10,
                                            ),
                                            (_stateContract
                                                        .contains('ACTIVE') ||
                                                    _stateContract
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
                                              color:
                                                  DefaultTheme.GREY_TOP_TAB_BAR,
                                              width: ((MediaQuery.of(context)
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
                                    width: MediaQuery.of(context).size.width *
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
                                              color:
                                                  DefaultTheme.GREY_TOP_TAB_BAR,
                                              width: ((MediaQuery.of(context)
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
                                              color:
                                                  DefaultTheme.GREY_TOP_TAB_BAR,
                                              width: ((MediaQuery.of(context)
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Center(
                                        child: Text('Yêu cầu'),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Center(
                                        child: Text('Đã duyệt'),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Center(
                                        child: Text('Hiện hành'),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
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
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: DefaultTheme.GREY_VIEW),
                                      child: ButtonHDr(
                                        label: 'Xác nhận hợp đồng',
                                        image: Image.asset(
                                            'assets/images/ic-note.png'),
                                        style: BtnStyle.BUTTON_IN_LIST,
                                        imgHeight: 30,
                                        labelColor: DefaultTheme.ORANGE_TEXT,
                                        onTap: () {
                                          //
                                          ContractUpdateDTO contractUpdateDTO =
                                              ContractUpdateDTO(
                                            contractId: _contractId,
                                            doctorId: 1,
                                            patientId: _patientId,
                                            status: 'ACTIVE',
                                          );
                                          _contractUpdateBloc.add(
                                              ContractUpdateEventUpdate(
                                                  dto: contractUpdateDTO));
                                        },
                                      ),
                                    )
                                  : Container(),

                              ///
                              ///
                              ///
                              ///
                              Padding(
                                padding: EdgeInsets.only(bottom: 40),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20, bottom: 10),
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
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          _contractFullDTO.diseases.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 5),
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
                                  label: 'Về trang chủ',
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ]),
      ),
    );
  }
  //
}
