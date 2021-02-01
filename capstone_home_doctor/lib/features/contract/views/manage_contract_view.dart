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
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barcode_scan/barcode_scan.dart';

final Shader _normalHealthColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_1,
    DefaultTheme.GRADIENT_2,
  ],
).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 90.0));

enum ContractStatus {
  CONTRACT_PENDING,
  CONTRACT_ACTIVED,
  CONTRACT_FINISHED,
}

DateValidator _dateValidator = DateValidator();

class ManageContract extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ManageContract();
  }
}

class _ManageContract extends State<ManageContract> {
  ContractRepository listContractRepository =
      ContractRepository(httpClient: http.Client());
  List<ContractListDTO> _listPending = List<ContractListDTO>();
  List<ContractListDTO> _listActived = List<ContractListDTO>();
  List<ContractListDTO> _listFinished = List<ContractListDTO>();
  var _idDoctorController = TextEditingController();
  String _idDoctor = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
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
              //
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Yêu cầu hợp đồng',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 50, bottom: 10),
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        Navigator.pushNamed(context, RoutesHDr.CONFIRM_CONTRACT,
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
                padding: EdgeInsets.only(bottom: 20),
              ),
              TabBar(
                  isScrollable: true,
                  //labelColor: Colors.black,
                  labelStyle: TextStyle(
                      fontSize: 28,
                      foreground: Paint()..shader = _normalHealthColors),
                  indicatorPadding: EdgeInsets.only(left: 20),
                  unselectedLabelStyle:
                      TextStyle(color: DefaultTheme.BLACK.withOpacity(0.6)),
                  indicatorColor: Colors.white.withOpacity(0.0),
                  tabs: [
                    Tab(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        height: 40,
                        child: Text(
                          'Chờ xét duyệt',
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 40,
                        child: Text(
                          'Đang hiện hành',
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 40,
                        child: Text(
                          'Đã hoàn tất',
                        ),
                      ),
                    ),
                  ]),
              Expanded(
                child: _loadListContract(),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showContractComponent(ContractListDTO dto) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: DefaultTheme.GREY_VIEW,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Hợp đồng ${dto.contractCode}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 80,
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
                  child: Text(
                    '${dto.fullNameDoctor}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 80,
                  child: Text(
                    'Thời gian',
                    style: TextStyle(
                      color: DefaultTheme.GREY_TEXT,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    '${dto.daysOfTracking} ngày',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            //timeline here
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                //tree here
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 1,
                      height: 10,
                      color: DefaultTheme.GREY_TEXT,
                    ),
                    SizedBox(
                      height: 10,
                      child: Image.asset('assets/images/ic-dot.png'),
                    ),
                    Container(
                      width: 1,
                      height: 10,
                      color: DefaultTheme.GREY_TEXT,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                Container(
                  height: 30,
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        child: Text(
                          'Bắt đầu',
                          style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Text(
                        '${_dateValidator.parseToDateView(dto.dateCreated)}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                //tree here
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 1,
                      height: 10,
                      color: DefaultTheme.GREY_TEXT,
                    ),
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: Image.asset('assets/images/ic-dot.png'),
                    ),
                    Container(
                      width: 1,
                      height: 10,
                      color: DefaultTheme.WHITE.withOpacity(0.0),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                Container(
                  height: 30,
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        child: Text(
                          'Kết thúc',
                          style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Text(
                        '${_dateValidator.parseToDateView(dto.dateFinished)}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Divider(
              color: DefaultTheme.GREY_TEXT,
              height: 0.1,
            ),
            ButtonHDr(
              label: 'Chi tiết',
              style: BtnStyle.BUTTON_TRANSPARENT,
              onTap: () {},
            ),
          ],
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
                        Navigator.pushNamed(context, RoutesHDr.CONFIRM_CONTRACT,
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

  _loadListContract() {
    return BlocProvider(
      create: (context) => ContractListBloc(contractAPI: listContractRepository)
        ..add(ListContractEventSetPatientId(id: 2)),
      child: BlocBuilder<ContractListBloc, ListContractState>(
          builder: (context, state) {
        if (state is ListContractStateLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ListContractStateFailure) {
          return Center(child: Text('Kiểm tra lại đường truyền kết nối mạng'));
        }
        if (state is ListContractStateSuccess) {
          for (var i = 0; i < state.listContract.length; i++) {
            if (state.listContract[i].status == 'ACTIVE') {
              _listActived.add(ContractListDTO(
                  contractId: state.listContract[i].contractId,
                  contractCode: state.listContract[i].contractCode,
                  daysOfTracking: state.listContract[i].daysOfTracking,
                  fullNameDoctor: state.listContract[i].fullNameDoctor,
                  dateCreated: state.listContract[i].dateCreated,
                  dateFinished: state.listContract[i].dateFinished,
                  dateStarted: state.listContract[i].dateStarted,
                  status: state.listContract[i].status));
            }
            if (state.listContract[i].status == 'PENDING') {
              _listPending.add(ContractListDTO(
                  contractId: state.listContract[i].contractId,
                  contractCode: state.listContract[i].contractCode,
                  daysOfTracking: state.listContract[i].daysOfTracking,
                  fullNameDoctor: state.listContract[i].fullNameDoctor,
                  dateCreated: state.listContract[i].dateCreated,
                  dateFinished: state.listContract[i].dateFinished,
                  dateStarted: state.listContract[i].dateStarted,
                  status: state.listContract[i].status));
            }
            if (state.listContract[i].status == 'FINISHED') {
              _listFinished.add(ContractListDTO(
                  contractId: state.listContract[i].contractId,
                  contractCode: state.listContract[i].contractCode,
                  daysOfTracking: state.listContract[i].daysOfTracking,
                  fullNameDoctor: state.listContract[i].fullNameDoctor,
                  dateCreated: state.listContract[i].dateCreated,
                  dateFinished: state.listContract[i].dateFinished,
                  dateStarted: state.listContract[i].dateStarted,
                  status: state.listContract[i].status));
            }
          }
          return TabBarView(
            children: <Widget>[
              (_listPending.length == 0)
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.asset(
                                'assets/images/ic-contract-empty.png'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * (1 / 4),
                              right:
                                  MediaQuery.of(context).size.width * (1 / 4),
                            ),
                            child: Text(
                              'Không có hợp đồng chờ xét duyệt nào.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 30),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: ListView.builder(
                        itemCount: _listPending.length,
                        itemBuilder: (BuildContext buildContext, int index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                              ),
                              _showContractComponent(_listPending[index]),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
              (_listActived.length == 0)
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.asset(
                                'assets/images/ic-contract-empty.png'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * (1 / 4),
                              right:
                                  MediaQuery.of(context).size.width * (1 / 4),
                            ),
                            child: Text(
                              'Không có hợp đồng đang hiện hành nào.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 30),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: ListView.builder(
                        itemCount: _listActived.length,
                        itemBuilder: (BuildContext buildContext, int index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                              ),
                              _showContractComponent(_listActived[index]),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
              (_listFinished.length == 0)
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.asset(
                                'assets/images/ic-contract-empty.png'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * (1 / 4),
                              right:
                                  MediaQuery.of(context).size.width * (1 / 4),
                            ),
                            child: Text(
                              'Không có hợp đồng đã hoàn tất nào.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 30),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: ListView.builder(
                        itemCount: _listFinished.length,
                        itemBuilder: (BuildContext buildContext, int index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                              ),
                              _showContractComponent(_listFinished[index]),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
            ],
          );
        }
        return Text('Lỗi');
      }),
    );
  }
}
