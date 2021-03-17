import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_bottom_sheet_field.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_chip_display.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_item.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_list_type.dart';
import 'package:capstone_home_doctor/features/contract/blocs/disease_list_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/disease_list_event.dart';
import 'package:capstone_home_doctor/features/contract/events/medical_share_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/disease_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/disease_list_state.dart';
import 'package:capstone_home_doctor/features/contract/states/medical_share_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/models/disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_share_dto.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final ContractHelper _contractHelper = ContractHelper();

class ContractShareView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContractShareView();
  }
}

class _ContractShareView extends State<ContractShareView>
    with WidgetsBindingObserver {
  //
  DiseaseRepository diseaseRepository =
      DiseaseRepository(httpClient: http.Client());
  int _idDoctor = 0;

  //FOR DISEASE
  List<DiseaseHeartDTO> _listDisease = [];
  List<DiseaseHeartDTO> _listDiseaseSelected = [];
  List<String> _diseaseIds = [];

  //FOR MEDICAL SHARE
  HealthRecordRepository _healthRecordRepository =
      HealthRecordRepository(httpClient: http.Client());
  MedicalShareBloc _medicalShareBloc;
  List<MedicalShareDTO> listMedicalShare = [];
  //List<Diseases> listDiseaseSelected = [];
  bool isLastRemove = true;
  String _labelHR = 'Hồ sơ sức khoẻ';
  //
  //List<MedicalInstructionTypes> medicalInstructionTypes = [];
  List<MedicalInstructions> medicalInstructions1 = [];
  List<MedicalInstructions> medicalInstructions2 = [];
  List<int> medicalInstructionIdsSelected = [];

  bool isChecked = false;
  //

  //PATIENT ID
  int _patientId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialContractHelper();
    _getPatientId();
    _medicalShareBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) async {
      setState(() {
        _patientId = value;
      });
    });
  }

  _initialContractHelper() async {
    await _contractHelper.updateContractSendStatus(false, '');
  }

  //
  @override
  Widget build(BuildContext context) {
    String arguments = ModalRoute.of(context).settings.arguments;
    _idDoctor = int.tryParse(arguments);
    print('ID doctor now: ${arguments.toString()}');

    //
    final requestContractProvider =
        Provider.of<RequestContractDTOProvider>(context, listen: false);
    requestContractProvider.setProvider(
      doctorId: int.parse(arguments.trim()),
      patientId: _patientId,
      dateStarted: '',
      diseaseIds: _diseaseIds,
      note: '',
      medicalInstructionIds: medicalInstructionIdsSelected,
    );
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //
            HeaderWidget(
              title: 'Yêu cầu hợp đồng',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  //
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),

                  _getDiseaseList(),
                  //
                  (isLastRemove == false)
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Divider(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            height: 1,
                          ),
                        )
                      : Container(),
                  // _getMedicalShare(),
                  (isLastRemove == false)
                      ? _showMedicalInstructionRequired()
                      : Container(),
                ],
              ),
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
                              color: DefaultTheme.GREY_TOP_TAB_BAR,
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
                              border: Border.all(
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      'Chia sẻ bệnh lý và hồ sơ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      'Bước 1',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: DefaultTheme.GREY_TEXT),
                    ),
                  ),
                  (medicalInstructions1.length != 0 &&
                          medicalInstructions2.length != 0)
                      ? Container(
                          margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ButtonHDr(
                            style: BtnStyle.BUTTON_BLACK,
                            label: 'Tiếp theo',
                            onTap: () {
                              print('NOW WE HAVE');
                              print('list IDs of disease ${_diseaseIds}');
                              print(
                                  'list medicalInstructionIdsSelected ${medicalInstructionIdsSelected}');
                              Navigator.of(context).pushNamed(
                                  RoutesHDr.CONTRACT_REASON_VIEW,
                                  arguments: {
                                    'REQUEST_OBJ':
                                        requestContractProvider.getProvider,
                                  });
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getDiseaseList() {
    return BlocProvider(
        create: (context2) =>
            DiseaseListBloc(diseaseRepository: diseaseRepository)
              ..add(DiseaseEventGetHealthList()),
        child: BlocBuilder<DiseaseListBloc, DiseaseListState>(
          builder: (context2, state2) {
            if (state2 is DiseaseListStateLoading) {
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
            if (state2 is DiseaseListStateFailure) {
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
            if (state2 is DiseaseHeartListStateSuccess) {
              if (state2.listDisease == null) {
                return Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
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
              _listDisease = state2.listDisease;
            }
            final _itemsView = _listDisease
                .map((disease) => MultiSelectItem<DiseaseHeartDTO>(
                    disease, disease.toString()))
                .toList();
            return Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: DefaultTheme.GREY_VIEW),
              child: MultiSelectBottomSheetField(
                initialChildSize: 0.8,
                selectedItemsTextStyle: TextStyle(color: DefaultTheme.WHITE),
                listType: MultiSelectListType.CHIP,
                searchable: true,
                buttonText: Text(
                  "Chọn bệnh lý tim mạch",
                  style: TextStyle(
                      color: DefaultTheme.BLUE_REFERENCE, fontSize: 16),
                ),
                title: Text(
                  "Danh sách bệnh lý",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                items: _itemsView,
                onConfirm: (values) {
                  setState(() {
                    //FOR CHECKING LAST REMOVE
                    isLastRemove = false;
                    // //FOR RESET LABEL HR
                    // _labelHR = 'Hồ sơ sức khoẻ';
                    // //REFRESH MED_INS_TYPES
                    // medicalInstructionTypes = [];
                    // medicalInstructionIdsSelected = [];
                    medicalInstructions1.clear();
                    medicalInstructions2.clear();
                    medicalInstructionIdsSelected.clear();
                    String _idDisease = '';
                    _diseaseIds.clear();
                    _listDiseaseSelected = values;
                    for (var i = 0; i < values.length; i++) {
                      _idDisease = values[i].toString().split(':')[0];
                      _diseaseIds.add(_idDisease);
                    }
                    // if (_diseaseIds != [] && _patientId != 0) {
                    //   _medicalShareBloc.add(MedicalShareEventGet(
                    //       diseaseIds: _diseaseIds, patientId: _patientId));
                    // }
                    if (_patientId != 0 && _idDoctor != 0) {
                      if (_listDiseaseSelected != [] && _diseaseIds != []) {
                        print('SHOW MED INS REQUIRED!');
                      }
                    }
                  });
                  print('LIST ID DISEASE NOW ${_diseaseIds}');
                  print(
                      'LIST DISEASE SELECTED WHEN CHOOSE NOW ${_listDiseaseSelected}');
                  //do sth here
                },
                chipDisplay: MultiSelectChipDisplay(
                  // icon: SizedBox(
                  //   height: 150,
                  //   child: Image.asset(
                  //       'assets/images/ic-contract.png'),
                  // ),
                  onTap: (value) {
                    setState(() {
                      // //FOR RESET LABEL HR
                      // _labelHR = 'Hồ sơ sức khoẻ';
                      // //REFRESH MED_INS_TYPES
                      // medicalInstructionTypes = [];
                      // medicalInstructionIdsSelected = [];
                      medicalInstructions1.clear();
                      medicalInstructions2.clear();
                      medicalInstructionIdsSelected.clear();
                      _listDiseaseSelected.remove(value);
                      _diseaseIds.remove(value.toString().split(':')[0]);
                      print(
                          'DISEASE LIST SELECT WHEN REMOVE NOW: ${_listDiseaseSelected.toString()}');
                      print('LIST ID DISEASE NOW ${_diseaseIds}');
                      // if (_patientId != 0) {
                      //   _medicalShareBloc.add(MedicalShareEventGet(
                      //       diseaseIds: _diseaseIds, patientId: _patientId));
                      //   if (_diseaseIds.length == 0) {
                      //     isLastRemove = true;
                      //   }
                      // }

                      if (_patientId != 0 && _idDoctor != 0) {
                        if (_listDiseaseSelected != [] && _diseaseIds != []) {
                          print('SHOW MED INS REQUIRED!');
                        }
                        if (_diseaseIds.length == 0) {
                          isLastRemove = true;
                        }
                      }
                    });
                  },
                ),
              ),
            );
          },
        ));
  }

  _showMedicalInstructionRequired() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Container(
            child: Text(
              'Chia sẻ phiếu y lệnh',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          child: Container(
            child: Text(
              'Sau đây là những phiếu y lệnh yêu cầu mà bạn cần phải chia sẻ cho bác sĩ. Những phiếu này tương ứng với bệnh lý mà bạn đã chọn.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),

        //
        Container(
            height: 40,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Phiếu điện tim',
                    style: TextStyle(color: DefaultTheme.BLACK, fontSize: 18),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '*',
                    style: TextStyle(
                        color: DefaultTheme.RED_CALENDAR,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Container(
                  width: 60,
                  height: 40,
                  child: ButtonHDr(
                    style: BtnStyle.BUTTON_TRANSPARENT,
                    labelColor: DefaultTheme.BLUE_REFERENCE,
                    label: '+',
                    onTap: () async {
                      //
                      if (_patientId != 0 && _idDoctor != 0) {
                        if (_listDiseaseSelected != [] && _diseaseIds != []) {
                          print('SHOW MED INS REQUIRED!');
                          await _medicalShareBloc.add(MedicalShareEventGet(
                              diseaseIds: _diseaseIds,
                              patientId: _patientId,
                              medicalInstructionType: 6));
                          //
                          _showMedicalShare('điện tim');
                        }
                      }
                    },
                  ),
                ),
              ],
            )),
        (medicalInstructions1.length != 0)
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: medicalInstructions1.length,
                  itemBuilder: (BuildContext context, int index) {
                    //

                    return Container(
                      width: 150,
                      margin: EdgeInsets.only(left: 20),
                      height: 200,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 150,
                            height: 200,
                            child: Image.network(
                                'http://45.76.186.233:8000/api/v1/Images?pathImage=${medicalInstructions1[index].image}'),
                          ),
                          Container(
                            width: 150,
                            height: 200,
                            color: DefaultTheme.BLACK_BUTTON.withOpacity(0.2),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 150,
                              height: 50,
                              color: DefaultTheme.BLACK_BUTTON.withOpacity(0.5),
                              child: Center(
                                child: Text(
                                  'Phiếu điện tim',
                                  style: TextStyle(color: DefaultTheme.WHITE),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            : Container(),
        //
        Padding(
          padding: EdgeInsets.only(left: 80, right: 80, bottom: 5, top: 5),
          child: Divider(
            color: DefaultTheme.GREY_TOP_TAB_BAR,
            height: 1,
          ),
        ),
        //
        Container(
            height: 40,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Phiếu X-Quang',
                    style: TextStyle(color: DefaultTheme.BLACK, fontSize: 18),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '*',
                    style: TextStyle(
                        color: DefaultTheme.RED_CALENDAR,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Container(
                  width: 60,
                  height: 40,
                  child: ButtonHDr(
                    style: BtnStyle.BUTTON_TRANSPARENT,
                    label: '+',
                    labelColor: DefaultTheme.BLUE_REFERENCE,
                    onTap: () async {
                      //
                      if (_patientId != 0 && _idDoctor != 0) {
                        if (_listDiseaseSelected != [] && _diseaseIds != []) {
                          print('SHOW MED INS REQUIRED!');
                          await _medicalShareBloc.add(MedicalShareEventGet(
                              diseaseIds: _diseaseIds,
                              patientId: _patientId,
                              medicalInstructionType: 4));
                          //
                          _showMedicalShare('X-Quang');
                        }
                      }
                    },
                  ),
                ),
              ],
            )),
        (medicalInstructions2.length != 0)
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: medicalInstructions2.length,
                  itemBuilder: (BuildContext context, int index) {
                    //

                    return Container(
                      width: 150,
                      height: 200,
                      margin: EdgeInsets.only(left: 20),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 150,
                            height: 200,
                            child: Image.network(
                              'http://45.76.186.233:8000/api/v1/Images?pathImage=${medicalInstructions2[index].image}',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            width: 150,
                            height: 200,
                            color: DefaultTheme.BLACK_BUTTON.withOpacity(0.2),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 150,
                              height: 50,
                              color: DefaultTheme.BLACK_BUTTON.withOpacity(0.5),
                              child: Center(
                                child: Text(
                                  'Phiếu X-Quang',
                                  style: TextStyle(color: DefaultTheme.WHITE),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            : Container(),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 80, right: 80),
          child: Divider(
            color: DefaultTheme.GREY_TOP_TAB_BAR,
            height: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          child: Container(
            child: Text(
              'Bạn có thể chia sẻ thêm các phiếu y lệnh khác để bác sĩ dễ dàng chăm khám',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Container(
            height: 40,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Phiếu khác',
                    style: TextStyle(color: DefaultTheme.BLACK, fontSize: 18),
                  ),
                ),
                Spacer(),
                Container(
                  width: 60,
                  height: 40,
                  child: ButtonHDr(
                    style: BtnStyle.BUTTON_TRANSPARENT,
                    labelColor: DefaultTheme.BLUE_REFERENCE,
                    label: '+',
                    onTap: () {
                      //
                    },
                  ),
                ),
              ],
            )),
      ],
    );
  }

  _showMedicalShare(String nameOfList) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      color: DefaultTheme.TRANSPARENT,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15)),
                          color: DefaultTheme.GREY_VIEW,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 30),
                              ),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: BlocBuilder<MedicalShareBloc,
                                          MedicalShareState>(
                                      builder: (context, state) {
                                    //
                                    if (state is MedicalShareStateLoading) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: DefaultTheme.GREY_BUTTON),
                                        child: Center(
                                          child: SizedBox(
                                            width: 150,
                                            height: 150,
                                            child: Image.asset(
                                                'assets/images/loading.gif'),
                                          ),
                                        ),
                                      );
                                    }
                                    if (state is MedicalShareStateFailure) {
                                      //
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
                                      if (state.listMedicalShare == null) {
                                        return Container(
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                //
                                                SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.asset(
                                                      'assets/images/ic-medical-instruction.png'),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 30),
                                                ),
                                                Center(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Text(
                                                      'Hiện không có phiếu y lệnh nào thuộc bệnh lý đã chọn.',
                                                      style: TextStyle(
                                                        color: DefaultTheme
                                                            .GREY_TEXT,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      //
                                      print('OK');
                                      print(
                                          '${state.listMedicalShare[0].healthRecordPlace}');
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Danh sách phiếu ${nameOfList}',
                                              style: TextStyle(
                                                  color: DefaultTheme.BLACK,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  for (MedicalShareDTO i
                                                      in state.listMedicalShare)
                                                    Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          //
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 20),
                                                          ),

                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                SizedBox(
                                                                  width: 20,
                                                                  height: 20,
                                                                  child: Image
                                                                      .asset(
                                                                          'assets/images/ic-health-record.png'),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20),
                                                                ),
                                                                //
                                                                Text(
                                                                  'Hồ sơ ${i.healthRecordPlace}',
                                                                  style: TextStyle(
                                                                      color: DefaultTheme
                                                                          .BLACK,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 3,
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 20),
                                                          ),
                                                          (i.medicalInstructions
                                                                      .length !=
                                                                  0)
                                                              ? ListView
                                                                  .builder(
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: i
                                                                      .medicalInstructions
                                                                      .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    //
                                                                    bool
                                                                        checkTemp =
                                                                        false;
                                                                    if (medicalInstructionIdsSelected.contains(i
                                                                        .medicalInstructions[
                                                                            index]
                                                                        .medicalInstructionId)) {
                                                                      checkTemp =
                                                                          true;
                                                                    }
                                                                    return Container(
                                                                        // height: 200,
                                                                        margin: EdgeInsets
                                                                            .only(
                                                                          // left:
                                                                          //     20,
                                                                          // right:
                                                                          //     20,
                                                                          bottom:
                                                                              10,
                                                                        ),
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                10),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          // color: DefaultTheme
                                                                          //     .WHITE,
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            //
                                                                            Row(
                                                                              children: <Widget>[
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(6),
                                                                                  child: SizedBox(
                                                                                    width: (30 * 1.5),
                                                                                    height: (40 * 1.5),
                                                                                    child: (i.medicalInstructions[index].image != null)
                                                                                        ? Image.network(
                                                                                            'http://45.76.186.233:8000/api/v1/Images?pathImage=${i.medicalInstructions[index].image}',
                                                                                            fit: BoxFit.fill,
                                                                                          )
                                                                                        : Container(
                                                                                            width: (30 * 1.5),
                                                                                            height: (40 * 1.5),
                                                                                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                                                                                          ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.only(left: 20),
                                                                                  child: (nameOfList.contains('điện tim')) ? Text('Phiếu điện tim') : (nameOfList.contains('X-Quang') ? Text('Phiếu X-Quang') : Container()),
                                                                                ),
                                                                                Spacer(),
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(6),
                                                                                  child: Container(
                                                                                    width: 20,
                                                                                    height: 20,
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                                                                    child: Checkbox(
                                                                                      checkColor: DefaultTheme.BLUE_REFERENCE,
                                                                                      activeColor: DefaultTheme.GREY_VIEW,
                                                                                      hoverColor: DefaultTheme.GREY_VIEW,
                                                                                      value: checkTemp,
                                                                                      onChanged: (_) {
                                                                                        setModalState(() {
                                                                                          //  i.medicalInstructions[index].isChecked = !i.medicalInstructions[index].isChecked;
                                                                                          //
                                                                                          checkTemp = !checkTemp;

                                                                                          setState(() {
                                                                                            if (checkTemp == true) {
                                                                                              if (nameOfList.contains('điện tim')) {
                                                                                                medicalInstructions1.removeWhere((item) => item.medicalInstructionId == i.medicalInstructions[index].medicalInstructionId);
                                                                                                medicalInstructions1.add(i.medicalInstructions[index]);
                                                                                              } else if (nameOfList.contains('X-Quang')) {
                                                                                                medicalInstructions2.removeWhere((item) => item.medicalInstructionId == i.medicalInstructions[index].medicalInstructionId);
                                                                                                medicalInstructions2.add(i.medicalInstructions[index]);
                                                                                              }
                                                                                              medicalInstructionIdsSelected.removeWhere((item) => item == i.medicalInstructions[index].medicalInstructionId);
                                                                                              medicalInstructionIdsSelected.add(i.medicalInstructions[index].medicalInstructionId);
                                                                                              print('list medical ins selected: ${medicalInstructionIdsSelected}');
                                                                                            } else {
                                                                                              checkTemp = false;
                                                                                              if (nameOfList.contains('điện tim')) {
                                                                                                medicalInstructions1.removeWhere((item) => item.medicalInstructionId == i.medicalInstructions[index].medicalInstructionId);
                                                                                              } else if (nameOfList.contains('X-Quang')) {
                                                                                                medicalInstructions2.removeWhere((item) => item.medicalInstructionId == i.medicalInstructions[index].medicalInstructionId);
                                                                                              }
                                                                                              medicalInstructionIdsSelected.removeWhere((item) => item == i.medicalInstructions[index].medicalInstructionId);
                                                                                            }
                                                                                          });
                                                                                          //
                                                                                        });
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                //
                                                                              ],
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(bottom: 10, top: 5),
                                                                              child: Divider(
                                                                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                                                                height: 1,
                                                                              ),
                                                                            )
                                                                            //
                                                                          ],
                                                                        ));
                                                                  },
                                                                )
                                                              : Container(
                                                                  height: 100,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child: Text(
                                                                      'Không có phiếu y lệnh nào'),
                                                                ),
                                                          // (i.medicalInstructions
                                                          //             .length !=
                                                          //         0)
                                                          //     ? Padding(
                                                          //         padding: EdgeInsets
                                                          //             .only(
                                                          //                 bottom:
                                                          //                     5,
                                                          //                 top:
                                                          //                     5),
                                                          //         child:
                                                          //             Divider(
                                                          //           color: DefaultTheme
                                                          //               .GREY_TOP_TAB_BAR,
                                                          //           height: 1,
                                                          //         ),
                                                          //       )
                                                          // : Container(),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin:
                                                  EdgeInsets.only(bottom: 30),
                                              child: ButtonHDr(
                                                style: BtnStyle.BUTTON_BLACK,
                                                label: 'Xong',
                                                onTap: () {
                                                  print(
                                                      'list medical ins selected ids: ${medicalInstructionIdsSelected}');
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return Container();
                                  }),
                                ),
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
                ),
              );
            },
          );
        });
  }
}

// class ContractScreen1Provider extends ChangeNotifier{
//   Contract1Obj =
// }
