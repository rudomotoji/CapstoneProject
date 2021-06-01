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

class _ManageContract extends State<ManageContract>
    with WidgetsBindingObserver {
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

  int _listIndex = 0;

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

  @override
  void dispose() {
    //  NotificationsSelectBloc.instance.newNotification('');
    super.dispose();
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
        NotificationsSelectBloc.instance.newNotification('');
        Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesHDr.MAIN_HOME, (Route<dynamic> route) => false);
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   RoutesHDr.MAIN_HOME,
        //   (Route<dynamic> route) => false,
        // );
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
                          height: 3,
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
                            if (state.listContract != null &&
                                state.listContract.isNotEmpty) {
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
                                          'Danh sách hợp đồng',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (!mounted) return;

                                          setState(() {
                                            _listIndex = 0;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 8,
                                              bottom: 8),
                                          height: 40,
                                          decoration: (_listIndex == 0)
                                              ? BoxDecoration(
                                                  color: DefaultTheme
                                                      .GREY_TOP_TAB_BAR,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                )
                                              : BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: DefaultTheme
                                                          .GREY_TOP_TAB_BAR),
                                                  color: DefaultTheme.WHITE,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                          child: Center(
                                            child: Text('Đang diễn ra',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        (_listIndex == 0)
                                                            ? FontWeight.w500
                                                            : FontWeight.normal,
                                                    color: DefaultTheme.BLACK,
                                                    fontSize: 16)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (!mounted) return;
                                          setState(() {
                                            _listIndex = 1;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 8,
                                              bottom: 8),
                                          height: 40,
                                          decoration: (_listIndex == 1)
                                              ? BoxDecoration(
                                                  color: DefaultTheme
                                                      .GREY_TOP_TAB_BAR,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                )
                                              : BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: DefaultTheme
                                                          .GREY_TOP_TAB_BAR),
                                                  color: DefaultTheme.WHITE,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                          child: Center(
                                            child: Text('Đã kết thúc',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        (_listIndex == 1)
                                                            ? FontWeight.w500
                                                            : FontWeight.normal,
                                                    color: DefaultTheme.BLACK,
                                                    fontSize: 16)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (!mounted) return;
                                          setState(() {
                                            _listIndex = 2;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 8,
                                              bottom: 8),
                                          height: 40,
                                          decoration: (_listIndex == 2)
                                              ? BoxDecoration(
                                                  color: DefaultTheme
                                                      .GREY_TOP_TAB_BAR,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                )
                                              : BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: DefaultTheme
                                                          .GREY_TOP_TAB_BAR),
                                                  color: DefaultTheme.WHITE,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                          child: Center(
                                            child: Text('Đã huỷ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        (_listIndex == 2)
                                                            ? FontWeight.w500
                                                            : FontWeight.normal,
                                                    color: DefaultTheme.BLACK,
                                                    fontSize: 16)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                  ),
                                  _buildDescription(_listIndex),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                  ),
                                  (_listIndex == 0)
                                      ? _buildComponent(_listExecuting)
                                      : (_listIndex == 1)
                                          ? _buildComponent(_listAcitved)
                                          : _buildComponent(_listCancel),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 30),
                                  ),
                                ],
                              );
                            } else {
                              return Container(
                                  height: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //
                                      SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                            'assets/images/ic-contract-empty.png'),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 20),
                                      ),
                                      Text('Hiện không có hợp đồng nào')
                                    ],
                                  ));
                            }
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

  _buildDescription(int index) {
    if (index == 0) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: DefaultTheme.GREY_TOP_TAB_BAR, width: 1),
        ),
        child: Center(
          child: Text(
              'Danh sách hợp đồng đang trong các trạng thái chờ xét duyệt, đã chấp thuận, đã ký nhận và đang hiện hành.'),
        ),
      );
    } else if (index == 1) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: DefaultTheme.GREY_TOP_TAB_BAR, width: 1),
        ),
        child: Center(
          child: Text(
              'Danh sách hợp đồng mà thời gian theo dõi và chăm khám đã kết thúc.'),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: DefaultTheme.GREY_TOP_TAB_BAR, width: 1),
        ),
        child: Center(
          child:
              Text('Danh sách hợp đồng đã huỷ hoặc bác sĩ từ chối xét duyệt.'),
        ),
      );
    }
  }

  _buildComponent(List<ContractListDTO> listItemBuild) {
    //
    listItemBuild.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    return (listItemBuild.length == 0 ||
            listItemBuild.isEmpty ||
            listItemBuild == null)
        ? Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/images/ic-contract-empty.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'Không có hợp đồng nào trong danh sách này.',
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: listItemBuild.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  await _contractHelper
                      .updateContractId(listItemBuild[index].contractId);
                  Navigator.pushNamed(context, RoutesHDr.DETAIL_CONTRACT_VIEW)
                      .then((value) {
                    _getPatientId();
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: DefaultTheme.GREY_VIEW,
                    border: Border(
                      left: BorderSide(
                          width: 2.0,
                          color:
                              _getColorContract(listItemBuild[index].status)),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //
                      Container(
                        height: 30,
                        child: Row(
                          children: [
                            Text(
                              'Hợp đồng',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 10, right: 10),
                              decoration: BoxDecoration(
                                  color: _getColorContract(
                                      listItemBuild[index].status),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                '${_getStatusContract(listItemBuild[index].status)}',
                                style: TextStyle(
                                  color: DefaultTheme.WHITE,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 120,
                              child: Text(
                                'Bác sĩ chăm khám: ',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  (120 + 20 + 40 + 40),
                              child: Text(
                                '${listItemBuild[index].fullNameDoctor}',
                                style: TextStyle(fontWeight: FontWeight.w500),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 1,
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10, top: 5),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 15,
                              height: 15,
                              child: Image.asset(
                                  'assets/images/ic-add-disease.png'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                            ),
                            Text(
                              'Bệnh lý theo dõi',
                              style: TextStyle(
                                fontSize: 16,
                                color: DefaultTheme.BLUE_DARK,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildDiseaseList(listItemBuild[index].diseases),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 1,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 5, left: 0),
                          child: Row(
                            children: [
                              Container(width: 80, child: Text('Ngày tạo: ')),
                              Container(
                                  width: MediaQuery.of(context).size.width -
                                      (60 + 20 + 40 + 40 + 20),
                                  child: Text(
                                      '${_dateValidator.parseToDateView(listItemBuild[index].dateCreated)}')),
                            ],
                          )),
                      // for (Diseases i in listItemBuild[index].diseases) Container()
                    ],
                  ),
                ),
              );
            },
          );
  }

  _buildDiseaseList(List<Diseases> listDiseases) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: listDiseases.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              Container(
                width: 60,
                child: Text('${listDiseases[index].diseaseId}',
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              Container(
                width: MediaQuery.of(context).size.width - (60 + 20 + 40 + 40),
                child: Text(
                  '${listDiseases[index].name}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //
  String _getStatusContract(String status) {
    String result = '';
    if (status == 'PENDING') {
      result = 'Chờ xét duyệt';
    } else if (status == 'APPROVED') {
      result = 'Đã chấp thuận';
    } else if (status == 'SIGNED') {
      result = 'Đã ký';
    } else if (status == 'ACTIVE') {
      result = 'Đang hiện hành';
    } else if (status == 'FINISHED') {
      result = 'Đã kết thúc';
    } else if (status == 'CANCELP') {
      result = 'Đã huỷ';
    } else if (status == 'CANCELD') {
      result = 'Bị từ chối';
    }
    return result;
  }

  Color _getColorContract(String status) {
    Color result;
    if (status == 'PENDING') {
      result = DefaultTheme.ORANGE_TEXT;
    } else if (status == 'APPROVED') {
      result = DefaultTheme.RED_CALENDAR;
    } else if (status == 'SIGNED') {
      result = DefaultTheme.BLUE_TEXT;
    } else if (status == 'ACTIVE') {
      result = DefaultTheme.SUCCESS_STATUS;
    } else if (status == 'FINISHED') {
      result = DefaultTheme.BLUE_DARK;
    } else if (status == 'CANCELP') {
      result = DefaultTheme.BLACK;
    } else if (status == 'CANCELD') {
      result = DefaultTheme.BLACK;
    }
    return result;
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
