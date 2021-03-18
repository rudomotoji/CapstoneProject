import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_list_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/contract_list_event.dart';
import 'package:capstone_home_doctor/features/contract/events/medical_share_event.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_list_state.dart';
import 'package:capstone_home_doctor/features/contract/states/medical_share_state.dart';
import 'package:capstone_home_doctor/features/health/medical_share/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/health/medical_share/events/medical_Share_event.dart';
import 'package:capstone_home_doctor/features/health/medical_share/repositories/medical_share_repository.dart';
import 'package:capstone_home_doctor/features/health/medical_share/states/medical_share_state.dart';
import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class MedicalShare extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MedicalShare();
  }
}

class _MedicalShare extends State<MedicalShare> with WidgetsBindingObserver {
  final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

  int _contractId;
  int _patientId = 0;
  List<ContractListDTO> _listContracts = List<ContractListDTO>();
  ContractListDTO dropdownValue;
  ContractListBloc _contractListBloc;
  List<int> medicalInstructionIdsSelected = [];
  MedicalShareBloc _medicalShareBloc;
  MedicalShareInsBloc _medicalShareInsBloc;

  MedicalShareInsRepository _medicalShareInsRepository =
      MedicalShareInsRepository(httpClient: http.Client());

  List<MedInsByDiseaseDTO> listMedicalInsShare;
  //
  bool sendStatus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contractListBloc = BlocProvider.of(context);
    _medicalShareBloc = BlocProvider.of(context);
    _medicalShareInsBloc = BlocProvider.of(context);

    _getPatientId();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listMedicalInsShare = [];
    _contractId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Chia sẻ y lệnh',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Expanded(
              child: BlocBuilder<MedicalShareInsBloc, MedicalShareInsState>(
                builder: (context, state) {
                  if (state is MedicalShareInsStateLoading) {
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
                  if (state is MedicalShareInsStateFailure) {
                    print('---MedicalShareInsStateFailure---');
                  }
                  if (state is MedicalShareInsStateSuccess) {
                    print('---MedicalShareInsStateSuccess---');
                    // Navigator.pop(context);
                    setState(() {
                      dropdownValue = null;
                      listMedicalInsShare = [];
                      medicalInstructionIdsSelected = [];
                    });
                    // _popupDialog();
                  }
                  return RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: (_contractId == null)
                        ? ListView(
                            children: [
                              BlocBuilder<ContractListBloc, ListContractState>(
                                builder: (context, state) {
                                  if (state is ListContractStateLoading) {
                                    return Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: DefaultTheme.GREY_BUTTON),
                                      child: Center(
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: Image.asset(
                                              'assets/images/loading.gif'),
                                        ),
                                      ),
                                    );
                                  }
                                  if (state is ListContractStateFailure) {
                                    print('---ListContractStateFailure---');
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          bottom: 10,
                                          top: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: DefaultTheme.GREY_BUTTON),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 20,
                                            right: 20),
                                        child: Text(
                                            'Không thể lấy danh sách hợp đồng',
                                            style: TextStyle(
                                              color: DefaultTheme.GREY_TEXT,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ),
                                    );
                                  }
                                  if (state is ListContractStateSuccess) {
                                    _listContracts = [];
                                    for (var contract in state.listContract) {
                                      if (contract.status.contains('ACTIVE')) {
                                        _listContracts.add(contract);
                                      }
                                    }
                                    return _selectContract();
                                  }
                                  return Container();
                                },
                              ),
                              Text(
                                'Danh sách phiếu y lệnh:',
                                style: TextStyle(
                                    color: DefaultTheme.BLACK,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                              ),
                              _listShare(),
                            ],
                          )
                        : ListView(
                            children: [
                              Text(
                                'Danh sách phiếu y lệnh:',
                                style: TextStyle(
                                    color: DefaultTheme.BLACK,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                              ),
                              _listShare(),
                            ],
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectContract() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            color: DefaultTheme.GREY_VIEW,
            borderRadius: BorderRadius.circular(6)),
        child: DropdownButton<ContractListDTO>(
          value: dropdownValue,
          items: _listContracts.map((ContractListDTO value) {
            return new DropdownMenuItem<ContractListDTO>(
              value: value,
              child: new Text(
                value.contractCode,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            );
          }).toList(),
          dropdownColor: DefaultTheme.GREY_VIEW,
          elevation: 1,
          hint: Container(
            width: MediaQuery.of(context).size.width - 84,
            child: Text(
              'Chọn hợp đồng để chia sẻ:',
              style: TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          underline: Container(
            width: 0,
          ),
          isExpanded: false,
          onChanged: (res) async {
            setState(() {
              dropdownValue = res;
              listMedicalInsShare = [];
              medicalInstructionIdsSelected = [];
            });
            await _medicalShareBloc.add(
                MedicalShareEventGetMediIns(patientID: 2, contractID: 4043));
          },
        ),
      ),
    );
  }

  _popupDialog() {
    setState(() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                    width: 250,
                    height: 150,
                    decoration: BoxDecoration(
                      color: DefaultTheme.WHITE.withOpacity(0.7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Container(
                        //   padding: EdgeInsets.only(bottom: 10, top: 10),
                        //   child: Text(
                        //     'Chia sẻ thành công',
                        //     style: TextStyle(
                        //       decoration: TextDecoration.none,
                        //       color: DefaultTheme.BLACK,
                        //       fontWeight: FontWeight.w600,
                        //       fontSize: 18,
                        //     ),
                        //   ),
                        // ),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Bạn đã chia sẻ thành công',
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
    });
  }

  Widget _listShare() {
    return (dropdownValue != null)
        ? BlocBuilder<MedicalShareBloc, MedicalShareState>(
            builder: (context, state) {
            if (state is MedicalShareStateLoading) {
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
            if (state is MedicalShareStateFailure) {
              //
              return Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: DefaultTheme.GREY_BUTTON),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  child: Text('Không thể tải',
                      style: TextStyle(
                        color: DefaultTheme.GREY_TEXT,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                ),
              );
            }
            if (state is MedicalShareStateSuccess) {
              listMedicalInsShare = state.listMedicalInsShare;
              if (listMedicalInsShare == null) {
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                              'assets/images/ic-medical-instruction.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              'Hiện không có phiếu y lệnh nào thuộc bệnh lý đã chọn.',
                              style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              //
              return Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (MedInsByDiseaseDTO element in listMedicalInsShare)
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset(
                                        'assets/images/ic-health-record.png'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                  ),
                                  //
                                  Text(
                                    'Hồ sơ ${element.healthRecordPlace}',
                                    style: TextStyle(
                                        color: DefaultTheme.BLACK,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                            ),
                            (element.medicalInstructionTypes.length > 0)
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        element.medicalInstructionTypes.length,
                                    itemBuilder:
                                        (BuildContext context, int indexType) {
                                      return Container(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: element
                                              .medicalInstructionTypes[
                                                  indexType]
                                              .medicalInstructions
                                              .length,
                                          itemBuilder: (BuildContext context,
                                              int indexMedicalInstructions) {
                                            bool checkTemp = false;
                                            var itemMedi = element
                                                    .medicalInstructionTypes[
                                                        indexType]
                                                    .medicalInstructions[
                                                indexMedicalInstructions];
                                            if (medicalInstructionIdsSelected
                                                .contains(itemMedi
                                                    .medicalInstructionId)) {
                                              checkTemp = true;
                                            }
                                            return Container(
                                              margin: EdgeInsets.only(
                                                bottom: 10,
                                              ),
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  //
                                                  Row(
                                                    children: <Widget>[
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        child: SizedBox(
                                                          width: (30 * 1.5),
                                                          height: (40 * 1.5),
                                                          child: (itemMedi
                                                                      .image !=
                                                                  null)
                                                              ? Image.network(
                                                                  'http://45.76.186.233:8000/api/v1/Images?pathImage=${itemMedi.image}',
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )
                                                              : Container(
                                                                  width: (30 *
                                                                      1.5),
                                                                  height: (40 *
                                                                      1.5),
                                                                  color: DefaultTheme
                                                                      .GREY_TOP_TAB_BAR,
                                                                ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20),
                                                        child: Text(
                                                            '${element.medicalInstructionTypes[indexType].miTypeName}'),
                                                      ),
                                                      Spacer(),
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Checkbox(
                                                            checkColor: DefaultTheme
                                                                .BLUE_REFERENCE,
                                                            activeColor:
                                                                DefaultTheme
                                                                    .GREY_VIEW,
                                                            hoverColor:
                                                                DefaultTheme
                                                                    .GREY_VIEW,
                                                            value: checkTemp,
                                                            onChanged: (_) {
                                                              setState(() {
                                                                checkTemp =
                                                                    !checkTemp;

                                                                setState(() {
                                                                  if (checkTemp ==
                                                                      true) {
                                                                    medicalInstructionIdsSelected.removeWhere((item) =>
                                                                        item ==
                                                                        itemMedi
                                                                            .medicalInstructionId);
                                                                    medicalInstructionIdsSelected.add(
                                                                        itemMedi
                                                                            .medicalInstructionId);
                                                                  } else {
                                                                    checkTemp =
                                                                        false;
                                                                    medicalInstructionIdsSelected.removeWhere((item) =>
                                                                        item ==
                                                                        itemMedi
                                                                            .medicalInstructionId);
                                                                  }
                                                                });
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      //
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 10, top: 5),
                                                    child: Divider(
                                                      color: DefaultTheme
                                                          .GREY_TOP_TAB_BAR,
                                                      height: 1,
                                                    ),
                                                  )
                                                  //
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text('Không có phiếu y lệnh nào'),
                                  ),
                          ],
                        ),
                      ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 30),
                      child: ButtonHDr(
                        style: BtnStyle.BUTTON_BLACK,
                        label: 'Chia sẻ',
                        onTap: () {
                          _medicalShareInsBloc.add(MedicalShareInsEventSend(
                              contractID: dropdownValue.contractId,
                              listMediIns: medicalInstructionIdsSelected));
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          })
        : Container();
  }

  Future<void> _pullRefresh() async {
    _getPatientId();
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) async {
      setState(() {
        _patientId = value;
        dropdownValue = null;
        medicalInstructionIdsSelected = [];
        medicalInstructionIdsSelected = [];
        if (_patientId != 0 && _contractId == null) {
          _contractListBloc.add(ListContractEventSetPatientId(id: _patientId));
        }
      });
    });
  }
}
