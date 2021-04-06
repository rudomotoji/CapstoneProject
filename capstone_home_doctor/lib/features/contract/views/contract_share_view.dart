import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:expandable_group/expandable_group_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/disease_list_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/disease_list_event.dart';
import 'package:capstone_home_doctor/features/contract/events/medical_share_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/disease_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/disease_list_state.dart';
import 'package:capstone_home_doctor/features/contract/states/medical_share_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_type_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_type_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_type_list_state.dart';
import 'package:capstone_home_doctor/models/disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_type_dto.dart';
import 'package:capstone_home_doctor/models/medical_share_dto.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';

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
  int _medInsTypeId = 0;

  //FOR DISEASE
  List<DiseaseDTO> _listDisease = [];
  List<DiseaseDTO> _listDiseaseSelected = [];
  List<String> _diseaseIds = [];

  //
  List<DiseaseLeverThrees> _listLv3Selected = [];
  List<String> _listLv3IdSelected = [];

  //FOR MEDICAL SHARE
  HealthRecordRepository _healthRecordRepository =
      HealthRecordRepository(httpClient: http.Client());
  MedicalInstructionRepository medicalInstructionRepository =
      MedicalInstructionRepository(httpClient: http.Client());

  MedicalShareBloc _medicalShareBloc;
  MedInsTypeListBloc _medInsTypeListBloc;
  DiseaseListBloc _diseaseListBloc;

  List<MedicalShareDTO> listMedicalShare = [];
  //List<Diseases> listDiseaseSelected = [];
  bool isLastRemove = true;
  String _labelHR = 'Hồ sơ sức khoẻ';
  String _selectedHRType = '';
  //
  //List<MedicalInstructionTypes> medicalInstructionTypes = [];
  List<MedicalInstructions> medicalInstructions1 = [];
  List<MedicalInstructions> medicalInstructions2 = [];
  List<MedicalInstructions> medicalInstructions3 = [];
  List<int> medicalInstructionIdsSelected = [];
  List<MedicalInstructionTypeDTO> _listMedInsType = [];

  //
  String nameOther = '';
  MedicalInstructionRepository _medicalInstructionRepository =
      MedicalInstructionRepository(httpClient: http.Client());

  bool isChecked = false;
  //
  List<ListTile> _buildItems(BuildContext context,
      List<DiseaseLeverThrees> items, StateSetter setModalState) {
    return items.map((e) {
      bool checkTemp = false;
      if (_listLv3IdSelected.contains(e.diseaseLevelThreeId)) {
        checkTemp = true;
      }

      return ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 120,
                  child: Text(
                    '${e.diseaseLevelThreeId} - ${e.diseaseLeverThreeName}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      color: DefaultTheme.BLUE_DARK,
                      // fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      checkColor: DefaultTheme.GRADIENT_1,
                      activeColor: DefaultTheme.GREY_VIEW,
                      hoverColor: DefaultTheme.GREY_VIEW,
                      value: checkTemp,
                      onChanged: (_) {
                        setModalState(() {
                          checkTemp = !checkTemp;

                          setState(() {
                            if (checkTemp == true) {
                              _listLv3IdSelected.removeWhere(
                                  (item) => item == e.diseaseLevelThreeId);
                              _listLv3IdSelected.add(e.diseaseLevelThreeId);

                              _listLv3Selected.removeWhere((item) =>
                                  item.diseaseLevelThreeId ==
                                  e.diseaseLevelThreeId);
                              _listLv3Selected.add(e);
                            } else {
                              _listLv3IdSelected.removeWhere(
                                  (item) => item == e.diseaseLevelThreeId);
                              _listLv3Selected.removeWhere((item) =>
                                  item.diseaseLevelThreeId ==
                                  e.diseaseLevelThreeId);
                              medicalInstructionIdsSelected.clear();
                              medicalInstructions2.clear();
                              medicalInstructions1.clear();
                              medicalInstructions3.clear();
                            }
                            if (_listLv3IdSelected.length == 0) {
                              isLastRemove = true;
                            } else {
                              isLastRemove = false;
                            }
                            //
                          });
                          //
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  List<ListTile> _buildMedInsRequired(
      BuildContext context,
      List<MedicalInstructions> items,
      StateSetter setModalState,
      String nameOfList) {
    //
    return items.map((e) {
      bool checkTemp = false;
      if (medicalInstructionIdsSelected.contains(e.medicalInstructionId)) {
        checkTemp = true;
      }

      return ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: (30 * 1.5),
                    height: (40 * 1.5),
                    child: (e.image != null)
                        ? Image.network(
                            'http://45.76.186.233:8000/api/v1/Images?pathImage=${e.image}',
                            fit: BoxFit.fill,
                          )
                        : Container(
                            width: (30 * 1.5),
                            height: (40 * 1.5),
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                          ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: (nameOfList.contains('điện tim'))
                          ? Text('Phiếu điện tim')
                          : (nameOfList.contains('X-Quang')
                              ? Text('Phiếu X-Quang')
                              : Container()),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Ngày tạo: ${e.dateCreate}',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),

                Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      checkColor: DefaultTheme.GRADIENT_1,
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
                                medicalInstructions1.removeWhere((item) =>
                                    item.medicalInstructionId ==
                                    e.medicalInstructionId);
                                medicalInstructions1.add(e);
                              } else if (nameOfList.contains('X-Quang')) {
                                medicalInstructions2.removeWhere((item) =>
                                    item.medicalInstructionId ==
                                    e.medicalInstructionId);
                                medicalInstructions2.add(e);
                              }
                              medicalInstructionIdsSelected.removeWhere(
                                  (item) => item == e.medicalInstructionId);
                              medicalInstructionIdsSelected
                                  .add(e.medicalInstructionId);
                              print(
                                  'list medical ins selected: ${medicalInstructionIdsSelected}');
                            } else {
                              checkTemp = false;
                              if (nameOfList.contains('điện tim')) {
                                medicalInstructions1.removeWhere((item) =>
                                    item.medicalInstructionId ==
                                    e.medicalInstructionId);
                              } else if (nameOfList.contains('X-Quang')) {
                                medicalInstructions2.removeWhere((item) =>
                                    item.medicalInstructionId ==
                                    e.medicalInstructionId);
                              }
                              medicalInstructionIdsSelected.removeWhere(
                                  (item) => item == e.medicalInstructionId);
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
          ],
        ),
      );

      //
    }).toList();
  }
  //

  List<ListTile> _buildMedInsOptional(
      BuildContext context,
      List<MedicalInstructions> items,
      StateSetter setModalState,
      String nameOfList) {
    //
    return items.map((e) {
      bool checkTemp = false;
      if (medicalInstructionIdsSelected.contains(e.medicalInstructionId)) {
        checkTemp = true;
      }

      return ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: (30 * 1.5),
                    height: (40 * 1.5),
                    child: (e.image != null)
                        ? Image.network(
                            'http://45.76.186.233:8000/api/v1/Images?pathImage=${e.image}',
                            fit: BoxFit.fill,
                          )
                        : Container(
                            width: (30 * 1.5),
                            height: (40 * 1.5),
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                          ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('${nameOfList}'),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Ngày tạo: ${e.dateCreate}',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),

                Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      checkColor: DefaultTheme.GRADIENT_1,
                      activeColor: DefaultTheme.GREY_VIEW,
                      hoverColor: DefaultTheme.GREY_VIEW,
                      value: checkTemp,
                      onChanged: (_) {
                        setModalState(() {
                          checkTemp = !checkTemp;

                          setState(() {
                            if (checkTemp == true) {
                              medicalInstructions3.removeWhere((item) =>
                                  item.medicalInstructionId ==
                                  e.medicalInstructionId);
                              medicalInstructions3.add(e);
                              //
                              medicalInstructionIdsSelected.removeWhere(
                                  (item) => item == e.medicalInstructionId);
                              medicalInstructionIdsSelected
                                  .add(e.medicalInstructionId);
                              print(
                                  'list medical ins selected: ${medicalInstructionIdsSelected}');
                            } else {
                              medicalInstructions3.removeWhere((item) =>
                                  item.medicalInstructionId ==
                                  e.medicalInstructionId);
                              //
                              medicalInstructionIdsSelected.removeWhere(
                                  (item) => item == e.medicalInstructionId);
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
          ],
        ),
      );

      //
    }).toList();
  }
  //
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
    _medInsTypeListBloc = BlocProvider.of(context);
    _diseaseListBloc = BlocProvider.of(context);
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
      _diseaseListBloc.add(DiseaseContractGetList(patientId: _patientId));
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
      diseaseIds: _listLv3IdSelected,
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
                  //new disease list
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    height: 45,
                    decoration: BoxDecoration(
                        color: DefaultTheme.GREY_VIEW,
                        borderRadius: BorderRadius.circular(6)),
                    child: InkWell(
                      child: Row(
                        children: [
                          Text(
                            'Chọn bệnh lý cần theo dõi',
                            style: TextStyle(
                                color: DefaultTheme.BLUE_DARK,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                Image.asset('assets/images/ic-add-disease.png'),
                          )
                        ],
                      ),
                      onTap: () {
                        _getListDiseaseContract();
                      },
                    ),
                  ),
                  //  _getDiseaseList(),
                  //
                  (_listLv3Selected.length != 0)
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Container(
                            child: Text(
                              'Bệnh lý đã chọn',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  (_listLv3Selected.length != 0)
                      ? Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _listLv3Selected.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 15, bottom: 15),
                                decoration: BoxDecoration(
                                    color:
                                        DefaultTheme.BLUE_DARK.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //
                                    Container(
                                      child: Text(
                                        '${_listLv3Selected[index].diseaseLevelThreeId} - ${_listLv3Selected[index].diseaseLeverThreeName}',
                                        style: TextStyle(
                                            color: DefaultTheme.BLUE_DARK,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : Container(),

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

                  // (medicalInstructions1.length != 0 &&
                  //         medicalInstructions2.length != 0)
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ButtonHDr(
                      style: BtnStyle.BUTTON_BLACK,
                      label: 'Tiếp theo',
                      onTap: () {
                        if (medicalInstructions1.length == 0 ||
                            medicalInstructions2.length == 0) {
                          return showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 25, sigmaY: 25),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 10, top: 10, right: 10),
                                      width: 250,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color:
                                            DefaultTheme.WHITE.withOpacity(0.7),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                bottom: 5, top: 10),
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
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Yêu cầu của bạn có thể bị bác sĩ từ chối nếu chia sẻ không đủ các phiếu y lệnh cần thiết.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
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
                                            color:
                                                DefaultTheme.GREY_TOP_TAB_BAR,
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
                                                        color: DefaultTheme
                                                            .BLUE_TEXT)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              Container(
                                                height: 40,
                                                width: 0.5,
                                                color: DefaultTheme
                                                    .GREY_TOP_TAB_BAR,
                                              ),
                                              FlatButton(
                                                height: 40,
                                                minWidth: 250 / 2 - 10.5,
                                                child: Text('Tiếp tục',
                                                    style: TextStyle(
                                                        color: DefaultTheme
                                                            .BLUE_TEXT)),
                                                onPressed: () {
                                                  //
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pushNamed(
                                                      RoutesHDr
                                                          .CONTRACT_REASON_VIEW,
                                                      arguments: {
                                                        'REQUEST_OBJ':
                                                            requestContractProvider
                                                                .getProvider,
                                                      });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        if (medicalInstructions1.length != 0 &&
                            medicalInstructions2.length != 0) {
                          Navigator.of(context).pushNamed(
                              RoutesHDr.CONTRACT_REASON_VIEW,
                              arguments: {
                                'REQUEST_OBJ':
                                    requestContractProvider.getProvider,
                              });
                        }
                        print('NOW WE HAVE');
                        print('list IDs of disease ${_listLv3IdSelected}');
                        print(
                            'list medicalInstructionIdsSelected ${medicalInstructionIdsSelected}');
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getListDiseaseContract() {
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
                                  child: BlocBuilder<DiseaseListBloc,
                                          DiseaseListState>(
                                      builder: (context, state) {
                                    //
                                    if (state is DiseaseListStateLoading) {
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
                                    if (state is DiseaseListStateFailure) {
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
                                    if (state is DiseaseContractStateSuccess) {
                                      if (state.listDiseaseContract == null) {
                                        return Container(
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                //
                                                Spacer(),
                                                SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.asset(
                                                      'assets/images/ic-health-record.png'),
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
                                                      'Hiện bạn không lưu trữ hồ sơ sức khoẻ nào',
                                                      style: TextStyle(
                                                        color: DefaultTheme
                                                            .GREY_TEXT,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 30),
                                                  child: InkWell(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 50,
                                                      child: Center(
                                                        child: Text(
                                                          'Gợi ý: Tạo hồ sơ sức khoẻ và thêm các phiếu y lệnh',
                                                          style: TextStyle(
                                                              color: DefaultTheme
                                                                  .BLUE_REFERENCE,
                                                              fontSize: 12,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      //
                                                      // Navigator.of(context)
                                                      //     .pushNamed(RoutesHDr
                                                      //         .CREATE_HEALTH_RECORD);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      //

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
                                              'Danh sách bệnh lý tim mạch',
                                              style: TextStyle(
                                                  color: DefaultTheme.BLACK,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 20, top: 5),
                                              child: Text(
                                                  'Danh sách dưới đây tương ứng với loại bệnh lý tim mạch mà bạn đã thêm vào các hồ sơ trước đó.',
                                                  style: TextStyle(
                                                      color: DefaultTheme
                                                          .GREY_TEXT)),
                                            ),

                                            // Padding(
                                            //   padding: EdgeInsets.only(
                                            //       bottom: 10, top: 10),
                                            //   child: Container(
                                            //     width: MediaQuery.of(context)
                                            //         .size
                                            //         .width,
                                            //     height: 35,
                                            //     decoration: BoxDecoration(
                                            //       color: DefaultTheme
                                            //           .GREY_TOP_TAB_BAR,
                                            //       borderRadius:
                                            //           BorderRadius.circular(20),
                                            //     ),
                                            //     child: Text('Tìm kiếm mã bệnh'),
                                            //   ),
                                            // ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 20),
                                            ),
                                            Expanded(
                                              child: ListView(
                                                children: <Widget>[
                                                  Column(
                                                    children: state
                                                        .listDiseaseContract
                                                        .map((group) {
                                                      int index = state
                                                          .listDiseaseContract
                                                          .indexOf(group);
                                                      //

                                                      return ExpandableGroup(
                                                        collapsedIcon: SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: Image.asset(
                                                                'assets/images/ic-navigator.png')),
                                                        expandedIcon: SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: Image.asset(
                                                                'assets/images/ic-down.png')),
                                                        isExpanded: false,
                                                        header: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child: Image.asset(
                                                                  'assets/images/ic-add-disease.png'),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  122,
                                                              child: Text(
                                                                '${group.diseaseLevelTwoId}: ${group.diseaseLeverTwoName}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        items: _buildItems(
                                                            context,
                                                            group
                                                                .diseaseLeverThrees,
                                                            setModalState),
                                                      );
                                                    }).toList(),
                                                  )
                                                ],
                                              ),
                                            ),
//
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
                                                      'list disease lv3  selected ids: ${_listLv3IdSelected}');
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
                InkWell(
                  child: Container(
                    width: 40,
                    height: 40,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.asset('assets/images/ic-add-more-mi.png'),
                    ),
                  ),
                  onTap: () async {
                    //
                    if (_patientId != 0 && _idDoctor != 0) {
                      if (_listLv3Selected != [] && _listLv3IdSelected != []) {
                        print('SHOW MED INS REQUIRED!');
                        await _medicalShareBloc.add(MedicalShareEventGet(
                            diseaseIds: _listLv3IdSelected,
                            patientId: _patientId,
                            medicalInstructionType: 6));
                        //
                        _showMedicalShare('điện tim');
                      }
                    }
                  },
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
                      child: InkWell(
                        onTap: () {
                          print('tap');
                          _showFullImageDescription(
                              medicalInstructions1[index].image,
                              'Phiếu điện tim',
                              '${medicalInstructions1[index].dateCreate}',
                              '${medicalInstructions1[index].diagnose}');
                        },
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
                                color:
                                    DefaultTheme.BLACK_BUTTON.withOpacity(0.5),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Phiếu điện tim',
                                        style: TextStyle(
                                            color: DefaultTheme.WHITE),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Ngày tạo${medicalInstructions1[index].dateCreate}',
                                        style: TextStyle(
                                            color: DefaultTheme.WHITE,
                                            fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                InkWell(
                    child: Container(
                      width: 40,
                      height: 40,
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset('assets/images/ic-add-more-mi.png'),
                      ),
                    ),
                    onTap: () async {
                      //
                      if (_patientId != 0 && _idDoctor != 0) {
                        if (_listLv3Selected != [] &&
                            _listLv3IdSelected != []) {
                          print('SHOW MED INS REQUIRED!');
                          await _medicalShareBloc.add(MedicalShareEventGet(
                              diseaseIds: _listLv3IdSelected,
                              patientId: _patientId,
                              medicalInstructionType: 4));
                          //
                          _showMedicalShare('X-Quang');
                        }
                      }
                      ;
                    }),
                // Container(
                //   width: 60,
                //   height: 40,
                //   child: ButtonHDr(
                //     style: BtnStyle.BUTTON_TRANSPARENT,
                //     label: '+',
                //     labelColor: DefaultTheme.BLUE_REFERENCE,
                //     onTap: () async {
                //       //
                //       if (_patientId != 0 && _idDoctor != 0) {
                //         if (_listDiseaseSelected != [] && _diseaseIds != []) {
                //           print('SHOW MED INS REQUIRED!');
                //           await _medicalShareBloc.add(MedicalShareEventGet(
                //               diseaseIds: _diseaseIds,
                //               patientId: _patientId,
                //               medicalInstructionType: 4));
                //           //
                //           _showMedicalShare('X-Quang');
                //         }
                //       }
                //     },
                //   ),
                // ),
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
                      child: InkWell(
                        onTap: () {
                          print('tap');
                          _showFullImageDescription(
                              medicalInstructions2[index].image,
                              'Phiếu X-Quang',
                              '${medicalInstructions2[index].dateCreate}',
                              '${medicalInstructions2[index].diagnose}');
                        },
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
                                color:
                                    DefaultTheme.BLACK_BUTTON.withOpacity(0.5),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Phiếu X-Quang',
                                        style: TextStyle(
                                            color: DefaultTheme.WHITE),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Ngày tạo${medicalInstructions2[index].dateCreate}',
                                        style: TextStyle(
                                            color: DefaultTheme.WHITE,
                                            fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
              InkWell(
                  child: Container(
                    width: 40,
                    height: 40,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.asset('assets/images/ic-add-more-mi.png'),
                    ),
                  ),
                  onTap: () async {
                    if (_patientId != 0) {
                      _medInsTypeListBloc.add(
                          MedInsTypeEventGetListToShare(patientId: _patientId));
                    }

                    _showMedicalInstructionOptional();
                  }),
            ],
          ),
        ),
        (medicalInstructions3.length != 0)
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: medicalInstructions3.length,
                  itemBuilder: (BuildContext context, int index) {
                    //

                    return Container(
                      width: 150,
                      height: 200,
                      margin: EdgeInsets.only(left: 20),
                      child: InkWell(
                        onTap: () {
                          print('tap');
                          if (medicalInstructions3[index].image == null) {
                            _showDetailVitalSign(medicalInstructions3[index]
                                .medicalInstructionId);
                          } else {
                            _showFullImageDescription(
                                medicalInstructions3[index].image,
                                'Phiếu khác',
                                '${medicalInstructions3[index].dateCreate}',
                                '${medicalInstructions3[index].diagnose}');
                          }
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 150,
                              height: 200,
                              child: Image.network(
                                'http://45.76.186.233:8000/api/v1/Images?pathImage=${medicalInstructions3[index].image}',
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
                                color:
                                    DefaultTheme.BLACK_BUTTON.withOpacity(0.5),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Phiếu khác',
                                        style: TextStyle(
                                            color: DefaultTheme.WHITE),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Ngày tạo${medicalInstructions3[index].dateCreate}',
                                        style: TextStyle(
                                            color: DefaultTheme.WHITE,
                                            fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container(),
      ],
    );
  }

  _showFullImageDescription(
      String img, String miName, String dateCreate, String dianose) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          //
          return Material(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: DefaultTheme.BLACK,
              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: PhotoView(
                      customSize: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height),
                      imageProvider: NetworkImage(
                          'http://45.76.186.233:8000/api/v1/Images?pathImage=${img}'),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 10,
                    child: Container(
                      width: 30,
                      height: 30,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset('assets/images/ic-close.png'),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      padding: EdgeInsets.only(left: 30, right: 30),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              DefaultTheme.TRANSPARENT,
                              DefaultTheme.BLACK.withOpacity(0.9),
                            ]),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //

                          Text(
                            '$miName',
                            style: TextStyle(
                                color: DefaultTheme.WHITE,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                          ),
                          Divider(
                            color: DefaultTheme.WHITE,
                            height: 1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                          ),
                          Text(
                            'Chuẩn đoán $dianose',
                            style: TextStyle(
                                color: DefaultTheme.WHITE, fontSize: 15),
                          ),
                          Text(
                            'Ngày tạo $dateCreate',
                            style: TextStyle(
                                color: DefaultTheme.WHITE, fontSize: 15),
                          ),

                          Padding(
                            padding: EdgeInsets.only(bottom: 50),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          //
        });
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
                                                Spacer(),
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
                                                Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 30),
                                                  child: InkWell(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 50,
                                                      child: Center(
                                                        child: Text(
                                                          'Gợi ý: Tạo hồ sơ sức khoẻ và thêm các phiếu y lệnh',
                                                          style: TextStyle(
                                                              color: DefaultTheme
                                                                  .BLUE_REFERENCE,
                                                              fontSize: 12,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      //
                                                      // Navigator.of(context)
                                                      //     .pushNamed(RoutesHDr
                                                      //         .CREATE_HEALTH_RECORD);
                                                    },
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
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 20, top: 5),
                                              child: Text(
                                                  'Danh sách dưới đây tương ứng với hồ sơ sức khoẻ và phiếu y lệnh mà bạn đã thêm vào các hồ sơ trước đó.',
                                                  style: TextStyle(
                                                      color: DefaultTheme
                                                          .GREY_TEXT)),
                                            ),
                                            Expanded(
                                              child: ListView(
                                                children: <Widget>[
                                                  //
                                                  Column(
                                                    children: state
                                                        .listMedicalShare
                                                        .map((group) {
                                                      //
                                                      int index = state
                                                          .listMedicalShare
                                                          .indexOf(group);
                                                      return ExpandableGroup(
                                                        collapsedIcon: SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: Image.asset(
                                                                'assets/images/ic-navigator.png')),
                                                        expandedIcon: SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: Image.asset(
                                                                'assets/images/ic-down.png')),
                                                        isExpanded: false,
                                                        header: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child: Image.asset(
                                                                  'assets/images/ic-health-record.png'),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                            ),
                                                            Column(
                                                              children: <
                                                                  Widget>[
                                                                //
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      122,
                                                                  child: Text(
                                                                    'Hồ sơ ${group.healthRecordPlace}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 2,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      122,
                                                                  child: Text(
                                                                    'Ngày tạo: ${group.dateCreate}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        items: _buildMedInsRequired(
                                                            context,
                                                            group
                                                                .medicalInstructions,
                                                            setModalState,
                                                            nameOfList),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Expanded(
                                            //   child: Column(
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.start,
                                            //     children: [
                                            //       for (MedicalShareDTO i
                                            //           in state.listMedicalShare)
                                            //         Container(
                                            //           child: Column(
                                            //             mainAxisAlignment:
                                            //                 MainAxisAlignment
                                            //                     .start,
                                            //             crossAxisAlignment:
                                            //                 CrossAxisAlignment
                                            //                     .start,
                                            //             children: <Widget>[
                                            //               //
                                            //               Padding(
                                            //                 padding:
                                            //                     EdgeInsets.only(
                                            //                         top: 20),
                                            //               ),

                                            //               Container(
                                            //                 width:
                                            //                     MediaQuery.of(
                                            //                             context)
                                            //                         .size
                                            //                         .width,
                                            //                 child: Row(
                                            //                   children: <
                                            //                       Widget>[
                                            //                     SizedBox(
                                            //                       width: 20,
                                            //                       height: 20,
                                            //                       child: Image
                                            //                           .asset(
                                            //                               'assets/images/ic-health-record.png'),
                                            //                     ),
                                            //                     Padding(
                                            //                       padding: EdgeInsets
                                            //                           .only(
                                            //                               left:
                                            //                                   20),
                                            //                     ),
                                            //                     //
                                            //                     Container(
                                            //                       width: MediaQuery.of(
                                            //                                   context)
                                            //                               .size
                                            //                               .width -
                                            //                           80,
                                            //                       child: Text(
                                            //                         'Hồ sơ ${i.healthRecordPlace}',
                                            //                         style: TextStyle(
                                            //                             color: DefaultTheme
                                            //                                 .BLACK,
                                            //                             fontSize:
                                            //                                 15,
                                            //                             fontWeight:
                                            //                                 FontWeight.w500),
                                            //                         overflow:
                                            //                             TextOverflow
                                            //                                 .ellipsis,
                                            //                         maxLines: 3,
                                            //                       ),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //               ),

                                            //               Padding(
                                            //                 padding:
                                            //                     EdgeInsets.only(
                                            //                         bottom: 20),
                                            //               ),
                                            //               (i.medicalInstructions
                                            //                           .length !=
                                            //                       0)
                                            //                   ? ListView
                                            //                       .builder(
                                            //                       physics:
                                            //                           NeverScrollableScrollPhysics(),
                                            //                       shrinkWrap:
                                            //                           true,
                                            //                       itemCount: i
                                            //                           .medicalInstructions
                                            //                           .length,
                                            //                       itemBuilder:
                                            //                           (BuildContext
                                            //                                   context,
                                            //                               int index) {
                                            //                         //
                                            //                         bool
                                            //                             checkTemp =
                                            //                             false;
                                            //                         if (medicalInstructionIdsSelected.contains(i
                                            //                             .medicalInstructions[
                                            //                                 index]
                                            //                             .medicalInstructionId)) {
                                            //                           checkTemp =
                                            //                               true;
                                            //                         }
                                            //                         return Container(
                                            //                             // height: 200,
                                            //                             margin: EdgeInsets
                                            //                                 .only(
                                            //                               // left:
                                            //                               //     20,
                                            //                               // right:
                                            //                               //     20,
                                            //                               bottom:
                                            //                                   10,
                                            //                             ),
                                            //                             padding: EdgeInsets.only(
                                            //                                 left:
                                            //                                     10,
                                            //                                 right:
                                            //                                     10),
                                            //                             decoration:
                                            //                                 BoxDecoration(
                                            //                               // color: DefaultTheme
                                            //                               //     .WHITE,
                                            //                               borderRadius:
                                            //                                   BorderRadius.circular(5),
                                            //                             ),
                                            //                             width: MediaQuery.of(context)
                                            //                                 .size
                                            //                                 .width,
                                            //                             child:
                                            //                                 Column(
                                            //                               mainAxisAlignment:
                                            //                                   MainAxisAlignment.start,
                                            //                               children: <
                                            //                                   Widget>[
                                            //                                 //
                                            //                                 Row(
                                            //                                   children: <Widget>[
                                            //                                     ClipRRect(
                                            //                                       borderRadius: BorderRadius.circular(6),
                                            //                                       child: SizedBox(
                                            //                                         width: (30 * 1.5),
                                            //                                         height: (40 * 1.5),
                                            //                                         child: (i.medicalInstructions[index].image != null)
                                            //                                             ? Image.network(
                                            //                                                 'http://45.76.186.233:8000/api/v1/Images?pathImage=${i.medicalInstructions[index].image}',
                                            //                                                 fit: BoxFit.fill,
                                            //                                               )
                                            //                                             : Container(
                                            //                                                 width: (30 * 1.5),
                                            //                                                 height: (40 * 1.5),
                                            //                                                 color: DefaultTheme.GREY_TOP_TAB_BAR,
                                            //                                               ),
                                            //                                       ),
                                            //                                     ),
                                            //                                     Container(
                                            //                                       padding: EdgeInsets.only(left: 20),
                                            //                                       child: (nameOfList.contains('điện tim')) ? Text('Phiếu điện tim') : (nameOfList.contains('X-Quang') ? Text('Phiếu X-Quang') : Container()),
                                            //                                     ),
                                            //                                     Spacer(),
                                            //                                     ClipRRect(
                                            //                                       borderRadius: BorderRadius.circular(6),
                                            //                                       child: Container(
                                            //                                         width: 25,
                                            //                                         height: 25,
                                            //                                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                            //                                         child: Checkbox(
                                            //                                           checkColor: DefaultTheme.BLUE_REFERENCE,
                                            //                                           activeColor: DefaultTheme.GREY_VIEW,
                                            //                                           hoverColor: DefaultTheme.GREY_VIEW,
                                            //                                           value: checkTemp,
                                            //                                           onChanged: (_) {
                                            //                                             setModalState(() {
                                            //                                               //  i.medicalInstructions[index].isChecked = !i.medicalInstructions[index].isChecked;
                                            //                                               //
                                            //                                               checkTemp = !checkTemp;

                                            //                                               setState(() {
                                            //                                                 if (checkTemp == true) {
                                            //                                                   if (nameOfList.contains('điện tim')) {
                                            //                                                     medicalInstructions1.removeWhere((item) => item.medicalInstructionId == i.medicalInstructions[index].medicalInstructionId);
                                            //                                                     medicalInstructions1.add(i.medicalInstructions[index]);
                                            //                                                   } else if (nameOfList.contains('X-Quang')) {
                                            //                                                     medicalInstructions2.removeWhere((item) => item.medicalInstructionId == i.medicalInstructions[index].medicalInstructionId);
                                            //                                                     medicalInstructions2.add(i.medicalInstructions[index]);
                                            //                                                   }
                                            //                                                   medicalInstructionIdsSelected.removeWhere((item) => item == i.medicalInstructions[index].medicalInstructionId);
                                            //                                                   medicalInstructionIdsSelected.add(i.medicalInstructions[index].medicalInstructionId);
                                            //                                                   print('list medical ins selected: ${medicalInstructionIdsSelected}');
                                            //                                                 } else {
                                            //                                                   checkTemp = false;
                                            //                                                   if (nameOfList.contains('điện tim')) {
                                            //                                                     medicalInstructions1.removeWhere((item) => item.medicalInstructionId == i.medicalInstructions[index].medicalInstructionId);
                                            //                                                   } else if (nameOfList.contains('X-Quang')) {
                                            //                                                     medicalInstructions2.removeWhere((item) => item.medicalInstructionId == i.medicalInstructions[index].medicalInstructionId);
                                            //                                                   }
                                            //                                                   medicalInstructionIdsSelected.removeWhere((item) => item == i.medicalInstructions[index].medicalInstructionId);
                                            //                                                 }
                                            //                                               });
                                            //                                               //
                                            //                                             });
                                            //                                           },
                                            //                                         ),
                                            //                                       ),
                                            //                                     ),
                                            //                                     //
                                            //                                   ],
                                            //                                 ),
                                            //                                 Padding(
                                            //                                   padding: EdgeInsets.only(bottom: 10, top: 5),
                                            //                                   child: Divider(
                                            //                                     color: DefaultTheme.GREY_TOP_TAB_BAR,
                                            //                                     height: 1,
                                            //                                   ),
                                            //                                 )
                                            //                                 //
                                            //                               ],
                                            //                             ));
                                            //                       },
                                            //                     )
                                            //                   : Container(
                                            //                       height: 100,
                                            //                       width: MediaQuery.of(
                                            //                               context)
                                            //                           .size
                                            //                           .width,
                                            //                       child: Text(
                                            //                           'Không có phiếu y lệnh nào'),
                                            //                     ),
                                            //               // (i.medicalInstructions
                                            //               //             .length !=
                                            //               //         0)
                                            //               //     ? Padding(
                                            //               //         padding: EdgeInsets
                                            //               //             .only(
                                            //               //                 bottom:
                                            //               //                     5,
                                            //               //                 top:
                                            //               //                     5),
                                            //               //         child:
                                            //               //             Divider(
                                            //               //           color: DefaultTheme
                                            //               //               .GREY_TOP_TAB_BAR,
                                            //               //           height: 1,
                                            //               //         ),
                                            //               //       )
                                            //               // : Container(),
                                            //             ],
                                            //           ),
                                            //         ),
                                            //     ],
                                            //   ),
                                            // ),

                                            //
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

  _showMedicalInstructionOptional() {
    //
    _selectedHRType = 'Chọn loại phiếu';
    _medInsTypeId = 0;
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 30),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 5),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Chia sẻ phiếu y lệnh khác',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 30, bottom: 20),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Chọn loại phiếu y lệnh mà bạn mong muốn chia sẻ với bác sĩ, sau đó tích chọn các phiếu.',
                                  style: TextStyle(
                                    // fontSize: 15,
                                    color: DefaultTheme.GREY_TEXT,
                                    // fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    // border: Border.all(
                                    //     color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    //     width: 1),
                                    color: DefaultTheme.GREY_TOP_TAB_BAR
                                        .withOpacity(0.5)),
                                child: BlocBuilder<MedInsTypeListBloc,
                                    MedInsTypeState>(
                                  builder: (context, state) {
                                    if (state is MedInsTypeStateLoading) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 40,
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Image.asset(
                                              'assets/images/loading.gif'),
                                        ),
                                      );
                                    }
                                    if (state is MedInsTypeStateFailure) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text('Lỗi'),
                                      );
                                    }
                                    if (state is MedInsTypeStateSuccess) {
                                      // nameOther = _selectedHRType;

                                      _listMedInsType = state.listMedInsType;
                                      // medicalInstructionIdsSelected.removeWhere(
                                      //     (item) =>
                                      //         item ==
                                      //         i.medicalInstructions[index]
                                      //             .medicalInstructionId);
                                      _listMedInsType.removeWhere((item) =>
                                          item.medicalInstructionTypeId == 4);
                                      _listMedInsType.removeWhere((item) =>
                                          item.medicalInstructionTypeId == 6);

                                      // return Text('OK');
                                      return Container(
                                        padding: EdgeInsets.only(
                                            left: 30, right: 30),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: DropdownButton<
                                            MedicalInstructionTypeDTO>(
                                          items: _listMedInsType.map(
                                              (MedicalInstructionTypeDTO
                                                  value) {
                                            return new DropdownMenuItem<
                                                MedicalInstructionTypeDTO>(
                                              value: value,
                                              child: new Text(value.name),
                                            );
                                          }).toList(),
                                          hint: Text(
                                            '${_selectedHRType}',
                                            style: TextStyle(
                                              color:
                                                  DefaultTheme.BLUE_REFERENCE,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          underline: Container(
                                            width: 0,
                                          ),
                                          isExpanded: true,
                                          onChanged: (_) {
                                            setModalState(() {
                                              _medInsTypeId =
                                                  _.medicalInstructionTypeId;
                                              _selectedHRType = _.name;
                                              print('${_selectedHRType}');
                                              //
                                              setState(() {
                                                nameOther = _selectedHRType;
                                              });
                                              _medicalShareBloc.add(
                                                  MedicalShareEventGet(
                                                      diseaseIds:
                                                          _listLv3IdSelected,
                                                      patientId: _patientId,
                                                      medicalInstructionType:
                                                          _medInsTypeId));
                                            });
                                            //
                                          },
                                        ),
                                      );
                                      //
                                    }
                                    return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Center(child: Text('Lỗi')));
                                  },
                                ),
                              ),
                              (_medInsTypeId != 0)
                                  ? Expanded(
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
                                                color:
                                                    DefaultTheme.GREY_BUTTON),
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
                                                color:
                                                    DefaultTheme.GREY_BUTTON),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 20,
                                                  right: 20),
                                              child: Text('Không thể tải',
                                                  style: TextStyle(
                                                    color:
                                                        DefaultTheme.GREY_TEXT,
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
                                                    Spacer(),
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
                                                        width: MediaQuery.of(
                                                                    context)
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
                                                    Spacer(),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 30),
                                                      child: InkWell(
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 50,
                                                          child: Center(
                                                            child: Text(
                                                              'Gợi ý: Tạo hồ sơ sức khoẻ và thêm các phiếu y lệnh',
                                                              style: TextStyle(
                                                                  color: DefaultTheme
                                                                      .BLUE_REFERENCE,
                                                                  fontSize: 12,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          //
                                                          // Navigator.of(context)
                                                          //     .pushNamed(RoutesHDr
                                                          //         .CREATE_HEALTH_RECORD);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          //

                                          // print(
                                          //     '${state.listMedicalShare[0].healthRecordPlace}');
                                          return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: ListView(
                                              children: <Widget>[
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: state
                                                      .listMedicalShare
                                                      .map((group) {
                                                    //

                                                    return ExpandableGroup(
                                                      collapsedIcon: SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: Image.asset(
                                                              'assets/images/ic-navigator.png')),
                                                      expandedIcon: SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: Image.asset(
                                                              'assets/images/ic-down.png')),
                                                      isExpanded: false,
                                                      header: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: Image.asset(
                                                                'assets/images/ic-health-record.png'),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                          ),
                                                          Column(
                                                            children: [
                                                              //
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    122,
                                                                child: Text(
                                                                  'Hồ sơ ${group.healthRecordPlace}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 2,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    122,
                                                                child: Text(
                                                                  'Ngày tạo: ${group.dateCreate}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      items: _buildMedInsOptional(
                                                          context,
                                                          group
                                                              .medicalInstructions,
                                                          setModalState,
                                                          nameOther),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return Container(child: Text('????'));
                                      }),
                                    )
                                  : Container(
                                      height: 200,
                                      child: Center(
                                        child: Text(
                                            'Chọn loại phiếu > chọn phiếu'),
                                      )),
                              // )

                              //
                              (_medInsTypeId != 0)
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(
                                          bottom: 30, left: 20, right: 20),
                                      child: ButtonHDr(
                                        style: BtnStyle.BUTTON_BLACK,
                                        label: 'Xong',
                                        onTap: () {
                                          print(
                                              'list medical ins selected ids: ${medicalInstructionIdsSelected}');
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    )
                                  : Container(),
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

  void _showDetailVitalSign(int medicalInstructionId) {
    setState(() {
      showDialog(
          barrierDismissible: false,
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
                            'Vui lòng chờ chút',
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
    });

    _medicalInstructionRepository
        .getMedicalInstructionById(medicalInstructionId)
        .then((value) {
      Navigator.pop(context);
      if (value != null) {
        // var dateStarted = new DateFormat('dd/MM/yyyy').format(
        //     new DateFormat("yyyy-MM-dd")
        //         .parse(value.vitalSignResponse.dateStarted));
        // var dateFinished = new DateFormat('dd/MM/yyyy').format(
        //     new DateFormat("yyyy-MM-dd")
        //         .parse(value.vitalSignResponse.dateFinished));
        var dateStarted = '';
        var dateFinished = '';

        if (value.medicationsRespone != null) {
          Navigator.pushNamed(context, RoutesHDr.MEDICAL_HISTORY_DETAIL,
              arguments: value.medicalInstructionId);
        } else {
          setState(() {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: MediaQuery.of(context).size.height * 0.35,
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
                                Text(
                                  '${value.medicalInstructionType}',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Divider(
                                    color: DefaultTheme.GREY_TEXT,
                                    height: 0.25,
                                  ),
                                  Text(
                                    'Người đặt: ${value.placeHealthRecord}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.none,
                                      color: DefaultTheme.GREY_TEXT,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'Ngày bắt đầu: ${dateStarted}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.none,
                                      color: DefaultTheme.GREY_TEXT,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'Ngày bắt đầu: ${dateFinished}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.none,
                                      color: DefaultTheme.GREY_TEXT,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  // Divider(
                                  //   color: DefaultTheme.GREY_TEXT,
                                  //   height: 0.25,
                                  // ),
                                ],
                              ),
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
          });
        }
      }
    });
  }
}
