import 'dart:async';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_list_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/contract_list_event.dart';

import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_list_state.dart';

import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:capstone_home_doctor/services/notifications_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barcode_scan/barcode_scan.dart';

final ContractHelper _contractHelper = ContractHelper();

final Shader _normalHealthColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_2,
    DefaultTheme.GRADIENT_1,
  ],
).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 90.0));

enum ContractStatus {
  CONTRACT_PENDING,
  CONTRACT_ACTIVED,
  CONTRACT_FINISHED,
}
//
final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

DateValidator _dateValidator = DateValidator();

class ManageContract extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ManageContract();
  }
}

class _ManageContract extends State<ManageContract> {
  ContractRepository contractRepository =
      ContractRepository(httpClient: http.Client());
  List<ContractListDTO> _listExecuting = List<ContractListDTO>();
  List<ContractListDTO> _listAcitved = List<ContractListDTO>();
  //
  List<ContractListDTO> _listPending = List<ContractListDTO>();
  List<ContractListDTO> _listApprove = List<ContractListDTO>();
  List<ContractListDTO> _listSigned = List<ContractListDTO>();
  List<ContractListDTO> _listActive = List<ContractListDTO>();
  List<ContractListDTO> _listFinished = List<ContractListDTO>();

  List<ContractListDTO> _listCancel = List<ContractListDTO>();
  List<ContractListDTO> _listCancelD = List<ContractListDTO>();
  List<ContractListDTO> _listCancelP = List<ContractListDTO>();
  var _idDoctorController = TextEditingController();
  String _idDoctor = '';
  ContractListBloc _contractListBloc;
  //
  int _patientId = 0;
  int _contractId = 0;

  Stream<ReceiveNotification> _notificationsStream;

  @override
  void initState() {
    super.initState();
    _getPatientId();
    _contractListBloc = BlocProvider.of(context);

    _notificationsStream = NotificationsBloc.instance.notificationsStream;
    _notificationsStream.listen((notification) {
      _getPatientId();
    });
  }

  Future _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) async {
      setState(() {
        _patientId = value;
        if (_patientId != 0) {
          _contractListBloc.add(ListContractEventSetPatientId(id: _patientId));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RoutesHDr.MAIN_HOME,
          (Route<dynamic> route) => false,
        );
        return new Future(() => false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              HeaderWidget(
                title: 'Hợp đồng',
                isMainView: false,
                buttonHeaderType: ButtonHeaderType.BACK_HOME,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _getPatientId,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Yêu cầu hợp đồng',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          )),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 50, bottom: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Quét QR hoặc nhập ID kết nối với bác sĩ',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15, color: DefaultTheme.GREY_TEXT),
                            ),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ButtonHDr(
                            label: 'Quét QR',
                            labelColor: DefaultTheme.BLACK,
                            width: MediaQuery.of(context).size.width * 0.5 - 30,
                            bgColor: DefaultTheme.GREY_VIEW,
                            image: Image.asset('assets/images/ic-scan-qr.png'),
                            style: BtnStyle.BUTTON_FULL,
                            onTap: () async {
                              String codeScanner = await BarcodeScanner.scan();
                              if (codeScanner != null) {
                                Navigator.of(context).pop();
                                Navigator.pushNamed(
                                    context, RoutesHDr.DOCTOR_INFORMATION,
                                    arguments: codeScanner);
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                          ),
                          ButtonHDr(
                            label: 'Nhập ID',
                            labelColor: DefaultTheme.BLACK,
                            width: MediaQuery.of(context).size.width * 0.5 - 30,
                            bgColor: DefaultTheme.GREY_VIEW,
                            image: Image.asset('assets/images/ic-id.png'),
                            style: BtnStyle.BUTTON_FULL,
                            onTap: () {
                              _showInputIdDoctor(context);
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 30, top: 20, left: 20, right: 20),
                        child: Divider(
                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                          height: 2,
                        ),
                      ),

                      //
                      BlocBuilder<ContractListBloc, ListContractState>(
                        builder: (context, state) {
                          //
                          if (state is ListContractStateLoading) {
                            return Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Center(
                                child: SizedBox(
                                  width: 200,
                                  child:
                                      Image.asset('assets/images/loading.gif'),
                                ),
                              ),
                            );
                          }
                          if (state is ListContractStateFailure) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10, top: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: DefaultTheme.GREY_BUTTON),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20, right: 20),
                                child: Text('Không thể tải',
                                    style: TextStyle(
                                      color: DefaultTheme.GREY_TEXT,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            );
                          }
                          if (state is ListContractStateSuccess) {
                            print('GO INTO STATE SUCCESS');

                            // for (var i = 0; i < state.listContract.length; i++) {
                            //   if (state.listContract[i].status
                            //           .contains('PENDING') ||
                            //       // state.listContract[i].status
                            //       //     .contains('ACTIVE') ||
                            //       state.listContract[i].status
                            //           .contains('APPROVED')) {
                            //     _listExecuting.add(ContractListDTO(
                            //         contractId: state.listContract[i].contractId,
                            //         contractCode:
                            //             state.listContract[i].contractCode,
                            //         daysOfTracking:
                            //             state.listContract[i].daysOfTracking,
                            //         fullNameDoctor:
                            //             state.listContract[i].fullNameDoctor,
                            //         dateCreated:
                            //             state.listContract[i].dateCreated,
                            //         dateFinished:
                            //             state.listContract[i].dateFinished,
                            //         dateStarted:
                            //             state.listContract[i].dateStarted,
                            //         status: state.listContract[i].status));
                            //   }
                            // }

                            // for (var i = 0; i < state.listContract.length; i++) {
                            //   if (state.listContract[i].status
                            //       .contains('FINISHED')) {
                            //     _listAcitved.add(ContractListDTO(
                            //         contractId: state.listContract[i].contractId,
                            //         contractCode:
                            //             state.listContract[i].contractCode,
                            //         daysOfTracking:
                            //             state.listContract[i].daysOfTracking,
                            //         fullNameDoctor:
                            //             state.listContract[i].fullNameDoctor,
                            //         dateCreated:
                            //             state.listContract[i].dateCreated,
                            //         dateFinished:
                            //             state.listContract[i].dateFinished,
                            //         dateStarted:
                            //             state.listContract[i].dateStarted,
                            //         status: state.listContract[i].status));
                            //   }

                            _listPending = state.listContract
                                .where((item) => item.status == 'PENDING')
                                .toList();
                            _listApprove = state.listContract
                                .where((item) => item.status == 'APPROVED')
                                .toList();
                            _listActive = state.listContract
                                .where((item) => item.status == 'ACTIVE')
                                .toList();
                            _listSigned = state.listContract
                                .where((item) => item.status == 'SIGNED')
                                .toList();
                            //
                            _listExecuting.clear();
                            _listExecuting = _listPending +
                                _listApprove +
                                _listSigned +
                                _listActive;
                            //
                            _listAcitved.clear();
                            _listAcitved = state.listContract
                                .where((item) => item.status == 'FINISHED')
                                .toList();

                            _listCancelP = state.listContract
                                .where((item) => item.status == 'CANCELP')
                                .toList();
                            _listCancelD = state.listContract
                                .where((item) => item.status == 'CANCELD')
                                .toList();

                            //
                            _listCancel.clear();
                            _listCancel = _listCancelP + _listCancelD;

                            //
                            return Column(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Hợp đồng đang diễn ra',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 50, bottom: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Danh sách các hợp đồng đang trong trạng thái yêu cầu, chờ xử lý và hiện hành',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: DefaultTheme.GREY_TEXT),
                                      ),
                                    )),

                                /////List here
                                (_listExecuting.length != 0)
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 350,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          // shrinkWrap: true,
                                          // physics: NeverScrollableScrollPhysics(),
                                          itemCount: _listExecuting.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String statusTemp = '';
                                            Color statusColor =
                                                DefaultTheme.BLACK_BUTTON;
                                            if (_listExecuting[index]
                                                .status
                                                .contains('PENDING')) {
                                              statusTemp = 'Xét duyệt';
                                              statusColor =
                                                  DefaultTheme.ORANGE_TEXT;
                                            }
                                            if (_listExecuting[index]
                                                .status
                                                .contains('SIGNED')) {
                                              statusTemp = 'Đã ký';
                                              statusColor =
                                                  DefaultTheme.BLUE_TEXT;
                                            }
                                            if (_listExecuting[index]
                                                .status
                                                .contains('ACTIVE')) {
                                              statusTemp = 'Hiện hành';
                                              statusColor =
                                                  DefaultTheme.SUCCESS_STATUS;
                                            }
                                            if (_listExecuting[index]
                                                .status
                                                .contains('APPROVE')) {
                                              statusTemp = 'Chấp thuận';
                                              statusColor =
                                                  DefaultTheme.GRADIENT_2;
                                            }
                                            if (_listExecuting[index]
                                                .status
                                                .contains('FINISHED')) {
                                              statusTemp = 'Kết thúc';
                                              statusColor =
                                                  DefaultTheme.CHIP_BLUE;
                                            }

                                            //
                                            return Container(
                                              width: 250,
                                              height: 350,
                                              // padding: EdgeInsets.only(left: 10),
                                              margin: EdgeInsets.only(left: 10),
                                              decoration: BoxDecoration(
                                                  color: DefaultTheme.GREY_VIEW,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: DefaultTheme
                                                          .GREY_TOP_TAB_BAR)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  //
                                                  Container(
                                                    color: DefaultTheme.YELLOW
                                                        .withOpacity(0.5),
                                                    padding: EdgeInsets.only(
                                                        top: 20,
                                                        bottom: 10,
                                                        left: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // SizedBox(
                                                        //   width: 20,
                                                        //   child: Image.asset(
                                                        //       'assets/images/ic-contract.png'),
                                                        // ),
                                                        // Padding(
                                                        //   padding:
                                                        //       EdgeInsets.only(
                                                        //           left: 5),
                                                        // ),
                                                        Center(
                                                          child: Text(
                                                            'HỢP ĐỒNG',
                                                            style: TextStyle(
                                                              //

                                                              color:
                                                                  DefaultTheme
                                                                      .BLACK,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        top: 9,
                                                        bottom: 5),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 10,
                                                          height: 10,
                                                          child: Image.asset(
                                                              'assets/images/ic-add-disease.png'),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                        ),
                                                        Text(
                                                          'Bệnh lý theo dõi',
                                                          style: TextStyle(
                                                              color: DefaultTheme
                                                                  .BLUE_DARK,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  for (Diseases i
                                                      in _listExecuting[index]
                                                          .diseases)
                                                    Container(
                                                      width: 250,
                                                      padding: EdgeInsets.only(
                                                          bottom: 5,
                                                          top: 5,
                                                          left: 10),
                                                      child: Text(
                                                        '${i.diseaseId}: ${i.name}',
                                                        style: TextStyle(
                                                          //
                                                          fontFamily: 'NewYork',
                                                          // foreground: Paint()
                                                          //   ..shader =
                                                          //       _normalHealthColors,
                                                          color: DefaultTheme
                                                              .BLACK,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  Spacer(),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 90,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child:
                                                            Text('Trạng thái:'),
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        child: Text(
                                                          '${statusTemp}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  statusColor),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 90,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text('Bác sĩ:'),
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        child: Text(
                                                          '${_listExecuting[index].fullNameDoctor}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 90,
                                                        child:
                                                            Text('Tạo ngày:'),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        child: Text(
                                                          '${_dateValidator.parseToDateView(_listExecuting[index].dateCreated)}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Divider(
                                                      color: DefaultTheme
                                                          .GREY_TOP_TAB_BAR,
                                                      height: 1,
                                                    ),
                                                  ),
                                                  ButtonHDr(
                                                    style: BtnStyle
                                                        .BUTTON_TRANSPARENT,
                                                    label: 'Chi tiết',
                                                    onTap: () async {
                                                      await _contractHelper
                                                          .updateContractId(
                                                              _listExecuting[
                                                                      index]
                                                                  .contractId);
                                                      Navigator.pushNamed(
                                                          context,
                                                          RoutesHDr
                                                              .DETAIL_CONTRACT_VIEW);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        child: Center(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: Image.asset(
                                                  'assets/images/ic-contract-empty.png'),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                            ),
                                            Text(
                                              'Không có hợp đồng nào trong danh sách này',
                                              style: TextStyle(
                                                  color:
                                                      DefaultTheme.GREY_TEXT),
                                            ),
                                          ],
                                        )),
                                      ),
                                /////
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                ),

                                /////
                                ///
                                ///
                                ///
                                ///
                                ///
                                ///
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 30, top: 20, left: 20, right: 20),
                                  child: Divider(
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    height: 2,
                                  ),
                                ),

                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Hợp đồng đã kết thúc',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 50, bottom: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Danh sách các hợp đồng đã hết hạn',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: DefaultTheme.GREY_TEXT),
                                      ),
                                    )),
                                /////List here
                                (_listAcitved.length != 0)
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 350,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          // shrinkWrap: true,
                                          // physics: NeverScrollableScrollPhysics(),
                                          itemCount: _listAcitved.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String statusTemp = '';
                                            Color statusColor =
                                                DefaultTheme.BLACK_BUTTON;
                                            if (_listAcitved[index]
                                                .status
                                                .contains('PENDING')) {
                                              statusTemp = 'Xét duyệt';
                                              statusColor =
                                                  DefaultTheme.ORANGE_TEXT;
                                            }
                                            if (_listAcitved[index]
                                                .status
                                                .contains('ACTIVE')) {
                                              statusTemp = 'Hiện hành';
                                              statusColor =
                                                  DefaultTheme.SUCCESS_STATUS;
                                            }
                                            if (_listAcitved[index]
                                                .status
                                                .contains('APPROVE')) {
                                              statusTemp = 'Chấp thuận';
                                              statusColor =
                                                  DefaultTheme.GRADIENT_2;
                                            }
                                            if (_listAcitved[index]
                                                .status
                                                .contains('FINISHED')) {
                                              statusTemp = 'Kết thúc';
                                              statusColor =
                                                  DefaultTheme.CHIP_BLUE;
                                            }

                                            //
                                            return Container(
                                              width: 250,
                                              height: 350,
                                              // padding: EdgeInsets.only(left: 10),
                                              margin: EdgeInsets.only(left: 10),
                                              decoration: BoxDecoration(
                                                  color: DefaultTheme.GREY_VIEW,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: DefaultTheme
                                                          .GREY_TOP_TAB_BAR)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  //
                                                  Container(
                                                    color: DefaultTheme.YELLOW
                                                        .withOpacity(0.5),
                                                    padding: EdgeInsets.only(
                                                        top: 20,
                                                        bottom: 10,
                                                        left: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // SizedBox(
                                                        //   width: 20,
                                                        //   child: Image.asset(
                                                        //       'assets/images/ic-contract.png'),
                                                        // ),
                                                        // Padding(
                                                        //   padding:
                                                        //       EdgeInsets.only(
                                                        //           left: 5),
                                                        // ),
                                                        Center(
                                                          child: Text(
                                                            'HỢP ĐỒNG',
                                                            style: TextStyle(
                                                              //

                                                              color:
                                                                  DefaultTheme
                                                                      .BLACK,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        top: 9,
                                                        bottom: 5),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 10,
                                                          height: 10,
                                                          child: Image.asset(
                                                              'assets/images/ic-add-disease.png'),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                        ),
                                                        Text(
                                                          'Bệnh lý theo dõi',
                                                          style: TextStyle(
                                                              color: DefaultTheme
                                                                  .BLUE_DARK,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  for (Diseases i
                                                      in _listAcitved[index]
                                                          .diseases)
                                                    Container(
                                                      width: 250,
                                                      padding: EdgeInsets.only(
                                                          bottom: 5,
                                                          top: 5,
                                                          left: 10),
                                                      child: Text(
                                                        '${i.diseaseId}: ${i.name}',
                                                        style: TextStyle(
                                                          //
                                                          fontFamily: 'NewYork',
                                                          // foreground: Paint()
                                                          //   ..shader =
                                                          //       _normalHealthColors,
                                                          color: DefaultTheme
                                                              .BLACK,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  Spacer(),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 90,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child:
                                                            Text('Trạng thái:'),
                                                      ),
                                                      Container(
                                                        width: 145,
                                                        child: Text(
                                                          '${statusTemp}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  statusColor),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 90,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text('Bác sĩ:'),
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        child: Text(
                                                          '${_listAcitved[index].fullNameDoctor}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 90,
                                                        child:
                                                            Text('Tạo ngày:'),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        child: Text(
                                                          '${_dateValidator.parseToDateView(_listAcitved[index].dateCreated)}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Divider(
                                                      color: DefaultTheme
                                                          .GREY_TOP_TAB_BAR,
                                                      height: 1,
                                                    ),
                                                  ),
                                                  ButtonHDr(
                                                    style: BtnStyle
                                                        .BUTTON_TRANSPARENT,
                                                    label: 'Chi tiết',
                                                    onTap: () async {
                                                      await _contractHelper
                                                          .updateContractId(
                                                              _listAcitved[
                                                                      index]
                                                                  .contractId);
                                                      Navigator.pushNamed(
                                                          context,
                                                          RoutesHDr
                                                              .DETAIL_CONTRACT_VIEW);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        child: Center(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: Image.asset(
                                                  'assets/images/ic-contract-empty.png'),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                            ),
                                            Text(
                                              'Không có hợp đồng nào trong danh sách này',
                                              style: TextStyle(
                                                  color:
                                                      DefaultTheme.GREY_TEXT),
                                            ),
                                          ],
                                        )),
                                      ),
                                /////
                                /////
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                ),
                                //

                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 30, top: 20, left: 20, right: 20),
                                  child: Divider(
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    height: 2,
                                  ),
                                ),

                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Hợp đồng bị huỷ',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 50, bottom: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Danh sách các hợp đồng đã huỷ và không được phê duyệt',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: DefaultTheme.GREY_TEXT),
                                    ),
                                  ),
                                ),
                                (_listCancel.length != 0)
                                    ? Container()
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        child: Center(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: Image.asset(
                                                  'assets/images/ic-contract-empty.png'),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                            ),
                                            Text(
                                              'Không có hợp đồng nào trong danh sách này',
                                              style: TextStyle(
                                                  color:
                                                      DefaultTheme.GREY_TEXT),
                                            ),
                                          ],
                                        )),
                                      ),
                                /////List here
                                (_listCancel.length != 0)
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 350,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          // shrinkWrap: true,
                                          // physics: NeverScrollableScrollPhysics(),
                                          itemCount: _listCancel.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String statusTemp = '';
                                            Color statusColor =
                                                DefaultTheme.BLACK_BUTTON;
                                            if (_listCancel[index]
                                                .status
                                                .contains('CANCELP')) {
                                              statusTemp = 'Đã huỷ';
                                              statusColor =
                                                  DefaultTheme.RED_CALENDAR;
                                            }
                                            if (_listCancel[index]
                                                .status
                                                .contains('CANCELD')) {
                                              statusTemp = 'Đã huỷ';
                                              statusColor =
                                                  DefaultTheme.RED_CALENDAR;
                                            }

                                            //
                                            return Container(
                                              width: 250,
                                              height: 350,
                                              // padding: EdgeInsets.only(left: 10),
                                              margin: EdgeInsets.only(left: 10),
                                              decoration: BoxDecoration(
                                                  color: DefaultTheme.GREY_VIEW,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: DefaultTheme
                                                          .GREY_TOP_TAB_BAR)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  //
                                                  Container(
                                                    color: DefaultTheme.YELLOW
                                                        .withOpacity(0.5),
                                                    padding: EdgeInsets.only(
                                                        top: 20,
                                                        bottom: 10,
                                                        left: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // SizedBox(
                                                        //   width: 20,
                                                        //   child: Image.asset(
                                                        //       'assets/images/ic-contract.png'),
                                                        // ),
                                                        // Padding(
                                                        //   padding:
                                                        //       EdgeInsets.only(
                                                        //           left: 5),
                                                        // ),
                                                        Center(
                                                          child: Text(
                                                            'HỢP ĐỒNG',
                                                            style: TextStyle(
                                                              //

                                                              color:
                                                                  DefaultTheme
                                                                      .BLACK,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        top: 9,
                                                        bottom: 5),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 10,
                                                          height: 10,
                                                          child: Image.asset(
                                                              'assets/images/ic-add-disease.png'),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                        ),
                                                        Text(
                                                          'Bệnh lý theo dõi',
                                                          style: TextStyle(
                                                              color: DefaultTheme
                                                                  .BLUE_DARK,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  for (Diseases i
                                                      in _listCancel[index]
                                                          .diseases)
                                                    Container(
                                                      width: 250,
                                                      padding: EdgeInsets.only(
                                                          bottom: 5,
                                                          top: 5,
                                                          left: 10),
                                                      child: Text(
                                                        '${i.diseaseId}: ${i.name}',
                                                        style: TextStyle(
                                                          //
                                                          fontFamily: 'NewYork',
                                                          // foreground: Paint()
                                                          //   ..shader =
                                                          //       _normalHealthColors,
                                                          color: DefaultTheme
                                                              .BLACK,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  Spacer(),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 90,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child:
                                                            Text('Trạng thái:'),
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        child: Text(
                                                          '${statusTemp}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  statusColor),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 90,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text('Bác sĩ:'),
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        child: Text(
                                                          '${_listCancel[index].fullNameDoctor}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 90,
                                                        child:
                                                            Text('Tạo ngày:'),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        child: Text(
                                                          '${_dateValidator.parseToDateView(_listCancel[index].dateCreated)}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Divider(
                                                      color: DefaultTheme
                                                          .GREY_TOP_TAB_BAR,
                                                      height: 1,
                                                    ),
                                                  ),
                                                  ButtonHDr(
                                                    style: BtnStyle
                                                        .BUTTON_TRANSPARENT,
                                                    label: 'Chi tiết',
                                                    onTap: () async {
                                                      await _contractHelper
                                                          .updateContractId(
                                                              _listCancel[index]
                                                                  .contractId);
                                                      Navigator.pushNamed(
                                                          context,
                                                          RoutesHDr
                                                              .DETAIL_CONTRACT_VIEW);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        child: Center(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: Image.asset(
                                                  'assets/images/ic-contract-empty.png'),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                            ),
                                            Text(
                                              'Không có hợp đồng nào trong danh sách này',
                                              style: TextStyle(
                                                  color:
                                                      DefaultTheme.GREY_TEXT),
                                            ),
                                          ],
                                        )),
                                      ),
                                /////
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 30),
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showInputIdDoctor(BuildContext currentContext) {
    showDialog(
      context: currentContext,
      builder: (currentContext) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height * 0.5,
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
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/images/ic-id.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        Text(
                          'Bác sĩ',
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
                              'Mã định danh giúp bệnh nhân dễ dàng ghép nối với bác sĩ thông qua hợp đồng',
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
                              label: 'ID:',
                              controller: _idDoctorController,
                              keyboardAction: TextInputAction.done,
                              onChange: (text) {
                                setState(() {
                                  _idDoctor = text;
                                });
                              },
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
                      label: 'Tiếp theo',
                      onTap: () {
                        Navigator.of(this.context).pop();
                        Navigator.pushNamed(
                            context, RoutesHDr.DOCTOR_INFORMATION,
                            arguments: _idDoctor);
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
