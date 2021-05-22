import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/models/medical_type_required_dto.dart';
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
  int _idDoctor = 0;
  int _medInsTypeId = 0;

  //FOR DISEASE
  List<DiseaseDTO> _listDisease = [];
  List<DiseaseDTO> _listDiseaseSelected = [];
  List<String> _diseaseIds = [];
  int countList = 0;
  //
  List<DiseaseLeverThrees> _listLv3Selected = [];
  List<String> _listLv3IdSelected = [];
  List<MedicalInstructionTypeDTO> _listMedInsType = [];

  ///////AAAA
  List<DiseaseMedicalInstructions> diseaseMedicalInstructionsSelected = [];
////
  //FOR MEDICAL SHARE
  HealthRecordRepository _healthRecordRepository =
      HealthRecordRepository(httpClient: http.Client());
  MedicalInstructionRepository medicalInstructionRepository =
      MedicalInstructionRepository(httpClient: http.Client());
  DiseaseRepository diseaseRepository =
      DiseaseRepository(httpClient: http.Client());
  MedicalInstructionRepository _medicalInstructionRepository =
      MedicalInstructionRepository(httpClient: http.Client());

  final DateValidator _dateValidator = DateValidator();

  MedicalShareBloc _medicalShareBloc;
  MedInsTypeListBloc _medInsTypeListBloc;
  DiseaseListBloc _diseaseListBloc;

  List<MedicalShareDTO> listMedicalShare = [];
  //List<Diseases> listDiseaseSelected = [];
  bool isLastRemove = true;
  String _labelHR = 'Hồ sơ sức khoẻ';
  String _selectedHRType = '';
  //
  MedInsTypeReqListBloc _medInsTypeReqListBloc;

  //int countList = 0;
  List<List<MedicalInstructions>> listMi = [];
  List<List<MedicalInstructions>> listMiOther = [];

  List<MedicalInstructions> medicalInstructions1 = [];
  List<MedicalInstructions> medicalInstructions2 = [];
  List<MedicalInstructions> medicalInstructions3 = [];
  List<int> medicalInstructionIdsSelected = [];
  // List<MedicalInstructionTypeDTO> _listMedInsType = [];

  //
  String nameOther = '';
  bool isChecked = false;
  bool isAddNewList = false;

  List<ListTile> _buildMedInsRequired(
    BuildContext context,
    List<MedicalInstructions> items,
    StateSetter setModalState,
    String nameOfList,
    int indexItemNow,
    String diseaseIdFromSelected,
  ) {
    ///
    print('INDEX ITEM NOW: $indexItemNow');
    print('diseaseIdFromSelected: $diseaseIdFromSelected');
    return items.map((e) {
      bool checkTemp = false;
      for (MedicalInstructions x in listMi[indexItemNow]) {
        if (x.medicalInstructionId == e.medicalInstructionId) {
          checkTemp = true;
        }
      }

      return ListTile(
        contentPadding: EdgeInsets.only(left: 0, right: 0),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    //
                    print(
                        'e images length: ${e.images.length} - e mi id: ${e.medicalInstructionId}');
                    if (e.images == null || e.images.isEmpty) {
                      _showDetailVitalSign(e.medicalInstructionId);
                    } else {
                      showFullDetailComponent(e.images, nameOfList,
                          e.dateCreate, e.disease, e.conclusion);
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      width: (30 * 1.5),
                      height: (40 * 1.5),
                      child: (e.images == null || e.images.isEmpty)
                          ? Container(
                              width: (30 * 1.5),
                              height: (40 * 1.5),
                              color: DefaultTheme.GREY_TOP_TAB_BAR,
                              child: Center(
                                  child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Image.asset((e
                                                  .medicalInstructionTypeName ==
                                              'Sinh hiệu')
                                          ? 'assets/images/ic-health-selected.png'
                                          : 'assets/images/ic-medicine.png'))),
                            )
                          : Stack(
                              children: [
                                Container(
                                  width: (30 * 1.5),
                                  height: (40 * 1.5),
                                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                                  child: (e.images == null || e.images.isEmpty)
                                      ? Container()
                                      : Image.network(
                                          'http://45.76.186.233:8000/api/v1/Images?pathImage=${e.images.first}',
                                          fit: BoxFit.fill,
                                        ),
                                ),
                                Positioned(
                                  top: 0,
                                  child: Container(
                                      width: (30 * 1.5),
                                      height: (40 * 1.5),
                                      color: DefaultTheme.GREY_TOP_TAB_BAR
                                          .withOpacity(0.4),
                                      child: Center(
                                        child: Text(
                                          (e.images.length > 1)
                                              ? '${e.images.length}+'
                                              : '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: DefaultTheme.WHITE),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    //
                    setModalState(() {
                      checkTemp = !checkTemp;
                      print('item index in list outside now: $indexItemNow');
                      setState(() {
                        if (checkTemp == true) {
                          listMi[indexItemNow].removeWhere((item) =>
                              item.medicalInstructionId ==
                              e.medicalInstructionId);

                          listMi[indexItemNow].add(e);
                          ////
                          medicalInstructionIdsSelected.removeWhere(
                              (item) => item == e.medicalInstructionId);
                          medicalInstructionIdsSelected
                              .add(e.medicalInstructionId);
                          print(
                              'list medical ins selected: ${medicalInstructionIdsSelected}');
                          print(
                              'list mi[${indexItemNow}] has lenght: ${listMi[indexItemNow].length}');
                          /////////////

                          for (int ind = 0;
                              ind < diseaseMedicalInstructionsSelected.length;
                              ind++) {
                            if (diseaseMedicalInstructionsSelected[ind]
                                    .diseaseId ==
                                diseaseIdFromSelected) {
                              diseaseMedicalInstructionsSelected[ind]
                                  .medicalInstructionIds
                                  .removeWhere(
                                      (item) => item == e.medicalInstructionId);
                              diseaseMedicalInstructionsSelected[ind]
                                  .medicalInstructionIds
                                  .add(e.medicalInstructionId);
                            }
                            print(
                                'diseaseMedicalInstructionsSelected->medIds now:${diseaseMedicalInstructionsSelected[ind].diseaseId}-- ${diseaseMedicalInstructionsSelected[ind].medicalInstructionIds}');
                          }
                        } else {
                          checkTemp = false;
                          listMi[indexItemNow].removeWhere((item) =>
                              item.medicalInstructionId ==
                              e.medicalInstructionId);
                          ////
                          medicalInstructionIdsSelected.removeWhere(
                              (item) => item == e.medicalInstructionId);
                          print(
                              'list medical ins selected: ${medicalInstructionIdsSelected}');
                          print(
                              'list mi[${indexItemNow}] has lenght: ${listMi[indexItemNow].length}');
                          ///////////////////////
                          for (int ind = 0;
                              ind < diseaseMedicalInstructionsSelected.length;
                              ind++) {
                            if (diseaseMedicalInstructionsSelected[ind]
                                    .diseaseId ==
                                diseaseIdFromSelected) {
                              diseaseMedicalInstructionsSelected[ind]
                                  .medicalInstructionIds
                                  .removeWhere(
                                      (item) => item == e.medicalInstructionId);
                            }
                          }
                        }
                      });
                      //
                    });
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width -
                          ((30 * 1.5) + 40 + 60),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text('$nameOfList'),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text('Ngày tạo: ${e.dateCreate}',
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      )),
                ),
                Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      checkColor: DefaultTheme.GRADIENT_1,
                      activeColor: DefaultTheme.GREY_VIEW,
                      hoverColor: DefaultTheme.GREY_VIEW,
                      value: checkTemp,
                      onChanged: (_) {
                        setModalState(() {
                          checkTemp = !checkTemp;
                          print(
                              'item index in list outside now: $indexItemNow');
                          setState(() {
                            if (checkTemp == true) {
                              listMi[indexItemNow].removeWhere((item) =>
                                  item.medicalInstructionId ==
                                  e.medicalInstructionId);

                              listMi[indexItemNow].add(e);
                              ////
                              medicalInstructionIdsSelected.removeWhere(
                                  (item) => item == e.medicalInstructionId);
                              medicalInstructionIdsSelected
                                  .add(e.medicalInstructionId);
                              print(
                                  'list medical ins selected: ${medicalInstructionIdsSelected}');
                              print(
                                  'list mi[${indexItemNow}] has lenght: ${listMi[indexItemNow].length}');
                              /////////////

                              for (int ind = 0;
                                  ind <
                                      diseaseMedicalInstructionsSelected.length;
                                  ind++) {
                                if (diseaseMedicalInstructionsSelected[ind]
                                        .diseaseId ==
                                    diseaseIdFromSelected) {
                                  diseaseMedicalInstructionsSelected[ind]
                                      .medicalInstructionIds
                                      .removeWhere((item) =>
                                          item == e.medicalInstructionId);
                                  diseaseMedicalInstructionsSelected[ind]
                                      .medicalInstructionIds
                                      .add(e.medicalInstructionId);
                                }
                                print(
                                    'diseaseMedicalInstructionsSelected->medIds now:${diseaseMedicalInstructionsSelected[ind].diseaseId}-- ${diseaseMedicalInstructionsSelected[ind].medicalInstructionIds}');
                              }
                            } else {
                              checkTemp = false;
                              listMi[indexItemNow]
                                  .removeWhere((item) => item == e);
                              ////
                              medicalInstructionIdsSelected.removeWhere(
                                  (item) => item == e.medicalInstructionId);
                              print(
                                  'list medical ins selected: ${medicalInstructionIdsSelected}');
                              print(
                                  'list mi[${indexItemNow}] has lenght: ${listMi[indexItemNow].length}');
                              ///////////////////////
                              for (int ind = 0;
                                  ind <
                                      diseaseMedicalInstructionsSelected.length;
                                  ind++) {
                                if (diseaseMedicalInstructionsSelected[ind]
                                        .diseaseId ==
                                    diseaseIdFromSelected) {
                                  diseaseMedicalInstructionsSelected[ind]
                                      .medicalInstructionIds
                                      .removeWhere((item) =>
                                          item == e.medicalInstructionId);
                                }
                              }
                            }
                          });
                          //
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 14),
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
      e.medicalInstructionTypeName = nameOfList;
      return ListTile(
        contentPadding: EdgeInsets.only(left: 0, right: 0),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    //
                    if (e.images == null || e.images.isEmpty) {
                      print(
                          'medical instruction id now: ${e.medicalInstructionId}');
                      _showDetailVitalSign(e.medicalInstructionId);
                    } else {
                      showFullDetailComponent(
                          e.images,
                          e.medicalInstructionTypeName,
                          e.dateCreate,
                          e.disease,
                          e.conclusion);
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                        width: (30 * 1.5),
                        height: (40 * 1.5),
                        child: (e.images == null || e.images.isEmpty)
                            ? Container(
                                width: (30 * 1.5),
                                height: (40 * 1.5),
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                child: Center(
                                    child: SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: Image.asset((e
                                                    .medicalInstructionTypeName ==
                                                'Sinh hiệu')
                                            ? 'assets/images/ic-health-selected.png'
                                            : 'assets/images/ic-medicine.png'))),
                              )
                            : Stack(
                                children: [
                                  Container(
                                    width: (30 * 1.5),
                                    height: (40 * 1.5),
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    child: (e.images == null)
                                        ? Container
                                        : Image.network(
                                            'http://45.76.186.233:8000/api/v1/Images?pathImage=${e.images.first}',
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                        width: (30 * 1.5),
                                        height: (40 * 1.5),
                                        color: DefaultTheme.GREY_TOP_TAB_BAR
                                            .withOpacity(0.4),
                                        child: Center(
                                          child: Text(
                                            (e.images.length > 1)
                                                ? '${e.images.length}+'
                                                : '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: DefaultTheme.WHITE),
                                          ),
                                        )),
                                  ),
                                ],
                              )),
                  ),
                ),
                InkWell(
                  onTap: () {
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

                          /////
                          ///
                          ///
                          for (int ind = 0;
                              ind < diseaseMedicalInstructionsSelected.length;
                              ind++) {
                            if (diseaseMedicalInstructionsSelected[ind]
                                    .diseaseId ==
                                null) {
                              diseaseMedicalInstructionsSelected[ind]
                                  .medicalInstructionIds
                                  .removeWhere(
                                      (item) => item == e.medicalInstructionId);
                              diseaseMedicalInstructionsSelected[ind]
                                  .medicalInstructionIds
                                  .add(e.medicalInstructionId);
                            }
                            print(
                                'diseaseMedicalInstructionsSelected->medIds now:${diseaseMedicalInstructionsSelected[ind].diseaseId}-- ${diseaseMedicalInstructionsSelected[ind].medicalInstructionIds}');
                          }
                        } else {
                          medicalInstructions3.removeWhere((item) =>
                              item.medicalInstructionId ==
                              e.medicalInstructionId);
                          //
                          medicalInstructionIdsSelected.removeWhere(
                              (item) => item == e.medicalInstructionId);

                          /////
                          ///
                          ///
                          for (int ind = 0;
                              ind < diseaseMedicalInstructionsSelected.length;
                              ind++) {
                            if (diseaseMedicalInstructionsSelected[ind]
                                    .diseaseId ==
                                null) {
                              diseaseMedicalInstructionsSelected[ind]
                                  .medicalInstructionIds
                                  .removeWhere(
                                      (item) => item == e.medicalInstructionId);
                            }
                            print(
                                'diseaseMedicalInstructionsSelected->medIds now:${diseaseMedicalInstructionsSelected[ind].diseaseId}-- ${diseaseMedicalInstructionsSelected[ind].medicalInstructionIds}');
                          }
                        }
                      });
                      //
                    });
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width -
                          ((30 * 1.5) + 40 + 60),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text('$nameOfList'),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Text('Ngày tạo: ${e.dateCreate}',
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      )),
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

                              /////
                              ///
                              ///
                              for (int ind = 0;
                                  ind <
                                      diseaseMedicalInstructionsSelected.length;
                                  ind++) {
                                if (diseaseMedicalInstructionsSelected[ind]
                                        .diseaseId ==
                                    null) {
                                  diseaseMedicalInstructionsSelected[ind]
                                      .medicalInstructionIds
                                      .removeWhere((item) =>
                                          item == e.medicalInstructionId);
                                  diseaseMedicalInstructionsSelected[ind]
                                      .medicalInstructionIds
                                      .add(e.medicalInstructionId);
                                }
                                print(
                                    'diseaseMedicalInstructionsSelected->medIds now:${diseaseMedicalInstructionsSelected[ind].diseaseId}-- ${diseaseMedicalInstructionsSelected[ind].medicalInstructionIds}');
                              }
                            } else {
                              medicalInstructions3.removeWhere((item) =>
                                  item.medicalInstructionId ==
                                  e.medicalInstructionId);
                              //
                              medicalInstructionIdsSelected.removeWhere(
                                  (item) => item == e.medicalInstructionId);

                              /////
                              ///
                              ///
                              for (int ind = 0;
                                  ind <
                                      diseaseMedicalInstructionsSelected.length;
                                  ind++) {
                                if (diseaseMedicalInstructionsSelected[ind]
                                        .diseaseId ==
                                    null) {
                                  diseaseMedicalInstructionsSelected[ind]
                                      .medicalInstructionIds
                                      .removeWhere((item) =>
                                          item == e.medicalInstructionId);
                                }
                                print(
                                    'diseaseMedicalInstructionsSelected->medIds now:${diseaseMedicalInstructionsSelected[ind].diseaseId}-- ${diseaseMedicalInstructionsSelected[ind].medicalInstructionIds}');
                              }
                            }
                          });
                          //
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 14),
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

  List<ListTile> _buildMedInsOptionalIntoDisease(
      BuildContext context,
      List<MedicalInstructions> items,
      int indexItemOtherNow,
      String diseaseIdFromSelected,
      StateSetter setModalState,
      String nameOfList) {
    //

    return items.map((e) {
      bool checkTemp = false;
      // if (medicalInstructionIdsSelected.contains(e.medicalInstructionId)) {
      //   checkTemp = true;
      // }
      for (MedicalInstructions x in listMiOther[indexItemOtherNow]) {
        if (x.medicalInstructionId == e.medicalInstructionId) {
          checkTemp = true;
        }
      }
      e.medicalInstructionTypeName = nameOfList;
      return ListTile(
        contentPadding: EdgeInsets.only(left: 0, right: 0),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    //
                    if (e.images == null || e.images.isEmpty) {
                      print(
                          'medical instruction id now: ${e.medicalInstructionId}');
                      _showDetailVitalSign(e.medicalInstructionId);
                    } else {
                      showFullDetailComponent(
                          e.images,
                          e.medicalInstructionTypeName,
                          e.dateCreate,
                          e.disease,
                          e.conclusion);
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                        width: (30 * 1.5),
                        height: (40 * 1.5),
                        child: (e.images == null || e.images.isEmpty)
                            ? Container(
                                width: (30 * 1.5),
                                height: (40 * 1.5),
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                child: Center(
                                    child: SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: Image.asset((e
                                                    .medicalInstructionTypeName ==
                                                'Sinh hiệu')
                                            ? 'assets/images/ic-health-selected.png'
                                            : 'assets/images/ic-medicine.png'))),
                              )
                            : Stack(
                                children: [
                                  Container(
                                    width: (30 * 1.5),
                                    height: (40 * 1.5),
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    child: (e.images == null)
                                        ? Container
                                        : Image.network(
                                            'http://45.76.186.233:8000/api/v1/Images?pathImage=${e.images.first}',
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                        width: (30 * 1.5),
                                        height: (40 * 1.5),
                                        color: DefaultTheme.GREY_TOP_TAB_BAR
                                            .withOpacity(0.4),
                                        child: Center(
                                          child: Text(
                                            (e.images.length > 1)
                                                ? '${e.images.length}+'
                                                : '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: DefaultTheme.WHITE),
                                          ),
                                        )),
                                  ),
                                ],
                              )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setModalState(() {
                      checkTemp = !checkTemp;

                      setState(() {
                        if (checkTemp == true) {
                          // medicalInstructions3.removeWhere((item) =>
                          //     item.medicalInstructionId ==
                          //     e.medicalInstructionId);
                          // medicalInstructions3.add(e);
                          //
                          listMiOther[indexItemOtherNow].removeWhere((item) =>
                              item.medicalInstructionId ==
                              e.medicalInstructionId);

                          listMiOther[indexItemOtherNow].add(e);
                          /////

                          //
                          medicalInstructionIdsSelected.removeWhere(
                              (item) => item == e.medicalInstructionId);
                          medicalInstructionIdsSelected
                              .add(e.medicalInstructionId);
                          print(
                              'list medical ins selected: ${medicalInstructionIdsSelected}');

                          /////
                          ///
                          ///
                          for (int ind = 0;
                              ind < diseaseMedicalInstructionsSelected.length;
                              ind++) {
                            if (diseaseMedicalInstructionsSelected[ind]
                                    .diseaseId ==
                                diseaseIdFromSelected) {
                              diseaseMedicalInstructionsSelected[ind]
                                  .medicalInstructionIds
                                  .removeWhere(
                                      (item) => item == e.medicalInstructionId);
                              diseaseMedicalInstructionsSelected[ind]
                                  .medicalInstructionIds
                                  .add(e.medicalInstructionId);
                            }
                            print(
                                'diseaseMedicalInstructionsSelected->medIds now:${diseaseMedicalInstructionsSelected[ind].diseaseId}-- ${diseaseMedicalInstructionsSelected[ind].medicalInstructionIds}');
                          }
                        } else {
                          // medicalInstructions3.removeWhere((item) =>
                          //     item.medicalInstructionId ==
                          //     e.medicalInstructionId);
                          listMiOther[indexItemOtherNow].removeWhere((item) =>
                              item.medicalInstructionId ==
                              e.medicalInstructionId);
                          //
                          medicalInstructionIdsSelected.removeWhere(
                              (item) => item == e.medicalInstructionId);
                          medicalInstructionIdsSelected.removeWhere(
                              (item) => item == e.medicalInstructionId);

                          /////
                          ///
                          ///
                          for (int ind = 0;
                              ind < diseaseMedicalInstructionsSelected.length;
                              ind++) {
                            if (diseaseMedicalInstructionsSelected[ind]
                                    .diseaseId ==
                                diseaseIdFromSelected) {
                              diseaseMedicalInstructionsSelected[ind]
                                  .medicalInstructionIds
                                  .removeWhere(
                                      (item) => item == e.medicalInstructionId);
                            }
                            print(
                                'diseaseMedicalInstructionsSelected->medIds now:${diseaseMedicalInstructionsSelected[ind].diseaseId}-- ${diseaseMedicalInstructionsSelected[ind].medicalInstructionIds}');
                          }
                        }
                      });
                      //
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width -
                        ((30 * 1.5) + 40 + 60),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text('$nameOfList'),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text('Ngày tạo: ${e.dateCreate}',
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
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
                              // medicalInstructions3.removeWhere((item) =>
                              //     item.medicalInstructionId ==
                              //     e.medicalInstructionId);
                              // medicalInstructions3.add(e);
                              //
                              listMiOther[indexItemOtherNow].removeWhere(
                                  (item) =>
                                      item.medicalInstructionId ==
                                      e.medicalInstructionId);

                              listMiOther[indexItemOtherNow].add(e);
                              /////

                              //
                              medicalInstructionIdsSelected.removeWhere(
                                  (item) => item == e.medicalInstructionId);
                              medicalInstructionIdsSelected
                                  .add(e.medicalInstructionId);
                              print(
                                  'list medical ins selected: ${medicalInstructionIdsSelected}');

                              /////
                              ///
                              ///
                              for (int ind = 0;
                                  ind <
                                      diseaseMedicalInstructionsSelected.length;
                                  ind++) {
                                if (diseaseMedicalInstructionsSelected[ind]
                                        .diseaseId ==
                                    diseaseIdFromSelected) {
                                  diseaseMedicalInstructionsSelected[ind]
                                      .medicalInstructionIds
                                      .removeWhere((item) =>
                                          item == e.medicalInstructionId);
                                  diseaseMedicalInstructionsSelected[ind]
                                      .medicalInstructionIds
                                      .add(e.medicalInstructionId);
                                }
                                print(
                                    'diseaseMedicalInstructionsSelected->medIds now:${diseaseMedicalInstructionsSelected[ind].diseaseId}-- ${diseaseMedicalInstructionsSelected[ind].medicalInstructionIds}');
                              }
                            } else {
                              // medicalInstructions3.removeWhere((item) =>
                              //     item.medicalInstructionId ==
                              //     e.medicalInstructionId);
                              listMiOther[indexItemOtherNow].removeWhere(
                                  (item) =>
                                      item.medicalInstructionId ==
                                      e.medicalInstructionId);
                              //
                              medicalInstructionIdsSelected.removeWhere(
                                  (item) => item == e.medicalInstructionId);
                              medicalInstructionIdsSelected.removeWhere(
                                  (item) => item == e.medicalInstructionId);

                              /////
                              ///
                              ///
                              for (int ind = 0;
                                  ind <
                                      diseaseMedicalInstructionsSelected.length;
                                  ind++) {
                                if (diseaseMedicalInstructionsSelected[ind]
                                        .diseaseId ==
                                    diseaseIdFromSelected) {
                                  diseaseMedicalInstructionsSelected[ind]
                                      .medicalInstructionIds
                                      .removeWhere((item) =>
                                          item == e.medicalInstructionId);
                                }
                                print(
                                    'diseaseMedicalInstructionsSelected->medIds now:${diseaseMedicalInstructionsSelected[ind].diseaseId}-- ${diseaseMedicalInstructionsSelected[ind].medicalInstructionIds}');
                              }
                            }
                          });
                          //
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 14),
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
  List<ListTile> _buildItems(BuildContext context,
      List<DiseaseLeverThrees> items, StateSetter setModalState) {
    return items.map((e) {
      bool checkTemp = false;
      if (_listLv3IdSelected.contains(e.diseaseLevelThreeId)) {
        checkTemp = true;
      }

      return ListTile(
        contentPadding: EdgeInsets.only(top: 0, bottom: 0),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //
            InkWell(
              onTap: () {
                setModalState(() {
                  checkTemp = !checkTemp;

                  setState(() {
                    if (checkTemp == true) {
                      _listLv3IdSelected
                          .removeWhere((item) => item == e.diseaseLevelThreeId);
                      _listLv3IdSelected.add(e.diseaseLevelThreeId);

                      _listLv3Selected.removeWhere((item) =>
                          item.diseaseLevelThreeId == e.diseaseLevelThreeId);
                      _listLv3Selected.add(e);
                    } else {
                      listMi.clear();
                      listMiOther.clear();
                      isAddNewList = true;
                      _listLv3IdSelected
                          .removeWhere((item) => item == e.diseaseLevelThreeId);
                      _listLv3Selected.removeWhere((item) =>
                          item.diseaseLevelThreeId == e.diseaseLevelThreeId);
                      medicalInstructionIdsSelected.clear();
                      // medicalInstructions2.clear();
                      // medicalInstructions1.clear();
                      // medicalInstructions3.clear();
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 120,
                    child: Text(
                      '${e.diseaseLevelThreeId} - ${e.diseaseLevelThreeName}',
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
                                listMi.clear();
                                listMiOther.clear();
                                isAddNewList = true;
                                _listLv3IdSelected.removeWhere(
                                    (item) => item == e.diseaseLevelThreeId);
                                _listLv3Selected.removeWhere((item) =>
                                    item.diseaseLevelThreeId ==
                                    e.diseaseLevelThreeId);
                                medicalInstructionIdsSelected.clear();
                                // medicalInstructions2.clear();
                                // medicalInstructions1.clear();
                                // medicalInstructions3.clear();
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
            ),
          ],
        ),
      );
    }).toList();
  }

  //PATIENT ID
  int _patientId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    isAddNewList = false;
    _initialContractHelper();
    _getPatientId();
    _medInsTypeReqListBloc = BlocProvider.of(context);
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

    print('listMi now ${listMi.length}');
    print('listMiOther now ${listMiOther.length}');
    //
    //
    print('list disease lv3  selected ids: ${_listLv3IdSelected}');
    //
    final requestContractProvider =
        Provider.of<RequestContractDTOProvider>(context, listen: false);
    requestContractProvider.setProvider(
      doctorId: int.parse(arguments.trim()),
      patientId: _patientId,
      dateStarted: '',
      diseaseHealthRecordIds: _listLv3IdSelected,
      note: '',
      diseaseMedicalInstructions: diseaseMedicalInstructionsSelected,
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

                  (_listLv3Selected.isEmpty)
                      ? Container(
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
                                  child: Image.asset(
                                      'assets/images/ic-add-disease.png'),
                                )
                              ],
                            ),
                            onTap: () {
                              _getListDiseaseContract();
                            },
                          ),
                        )
                      : Container(),
                  (_listLv3Selected.length != 0)
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Divider(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            height: 1,
                          ))
                      : Container(),
                  //
                  (_listLv3Selected.length != 0)
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Container(
                              child: Row(
                            children: [
                              Text(
                                'Bệnh lý đã chọn',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                  onTap: () {
                                    //
                                    setState(() {
                                      medicalInstructionIdsSelected.clear();
                                      _listLv3IdSelected.clear();
                                      isLastRemove = true;
                                      _listLv3Selected.clear();
                                      listMi.clear();
                                      listMiOther.clear();
                                      medicalInstructions3.clear();
                                      isAddNewList = false;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: Image.asset(
                                              'assets/images/ic-close.png'),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                        ),
                                        Text('Chọn lại'),
                                      ],
                                    ),
                                  ))
                            ],
                          )),
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
                                        '${_listLv3Selected[index].diseaseLevelThreeId} - ${_listLv3Selected[index].diseaseLevelThreeName}',
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

                  (isLastRemove == false)
                      ? _showMedicalInstructionRequired()
                      : Container(),

                  //
                  (_listLv3Selected.length != 0)
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Divider(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            height: 1,
                          ),
                        )
                      : Container(),
                  (_listLv3Selected.length != 0)
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Container(
                            child: Text(
                              'Chia sẻ phiếu y lệnh khác',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  (_listLv3Selected.length != 0)
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 20, right: 20, bottom: 20),
                          child: Container(
                            child: Text(
                              'Chia sẻ thêm các phiếu y lệnh khác ngoài các bệnh lý trên để bác sĩ dễ dàng xét duyệt và chăm khám cho bạn.',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  (_listLv3Selected.length != 0)
                      ? Container(
                          height: 40,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Phiếu khác',
                                  style: TextStyle(
                                      color: DefaultTheme.BLACK, fontSize: 18),
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
                                      child: Image.asset(
                                          'assets/images/ic-add-more-mi.png'),
                                    ),
                                  ),
                                  onTap: () async {
                                    if (_patientId != 0) {
                                      _medInsTypeListBloc.add(
                                          MedInsTypeEventGetListToShare(
                                              patientId: _patientId,
                                              diseaseId: null,
                                              medicalInstructionsIds:
                                                  medicalInstructionIdsSelected));
                                    }

                                    _showMedicalInstructionOptional();
                                  }),
                            ],
                          ),
                        )
                      : Container(),
                  (medicalInstructions3.length != 0 &&
                          _listLv3Selected.length != 0 &&
                          medicalInstructions3 != null &&
                          _listLv3Selected != null)
                      ? Container(
                          margin: EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: medicalInstructions3.length,
                            itemBuilder: (BuildContext context, int index) {
                              //

                              return Stack(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 200,
                                    margin: EdgeInsets.only(left: 10),
                                    child: InkWell(
                                      onTap: () {
                                        print('tap');
                                        if (medicalInstructions3[index]
                                                    .images ==
                                                null ||
                                            medicalInstructions3[index]
                                                .images
                                                .isEmpty) {
                                          _showDetailVitalSign(
                                              medicalInstructions3[index]
                                                  .medicalInstructionId);
                                        } else {
                                          showFullDetailComponent(
                                              medicalInstructions3[index]
                                                  .images,
                                              '${medicalInstructions3[index].medicalInstructionTypeName}',
                                              '${medicalInstructions3[index].dateCreate}',
                                              medicalInstructions3[index]
                                                  .disease,
                                              '${medicalInstructions3[index].conclusion}');
                                        }
                                      },
                                      child:
                                          (medicalInstructions3[index].images ==
                                                      null ||
                                                  medicalInstructions3[index]
                                                      .images
                                                      .isEmpty)
                                              ? Stack(
                                                  children: [
                                                    Container(
                                                      width: 150,
                                                      height: 200,
                                                      color: DefaultTheme
                                                          .BLACK_BUTTON
                                                          .withOpacity(0.4),
                                                    ),
                                                    SizedBox(
                                                      width: 150,
                                                      height: 200,
                                                      child: Center(
                                                        child: Image.asset(
                                                          (medicalInstructions3[
                                                                          index]
                                                                      .medicalInstructionTypeName ==
                                                                  'Đơn thuốc')
                                                              ? 'assets/images/ic-medicine.png'
                                                              : 'assets/images/ic-health-selected.png',
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      child: Container(
                                                        width: 150,
                                                        height: 200,
                                                        color: DefaultTheme
                                                            .GREY_TOP_TAB_BAR
                                                            .withOpacity(0.3),
                                                        child: Center(
                                                            child: (medicalInstructions3[index]
                                                                            .images ==
                                                                        null ||
                                                                    medicalInstructions3[index]
                                                                            .images
                                                                            .length <
                                                                        2)
                                                                ? Text('')
                                                                : Text(
                                                                    '${medicalInstructions3[index].images.length}+',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: DefaultTheme
                                                                            .WHITE,
                                                                        fontSize:
                                                                            25),
                                                                  )),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      child: Container(
                                                        width: 150,
                                                        height: 50,
                                                        color: DefaultTheme
                                                            .BLACK_BUTTON
                                                            .withOpacity(0.5),
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                '${medicalInstructions3[index].medicalInstructionTypeName}',
                                                                style: TextStyle(
                                                                    color: DefaultTheme
                                                                        .WHITE),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              Text(
                                                                'Ngày tạo: ${medicalInstructions3[index].dateCreate}',
                                                                style: TextStyle(
                                                                    color: DefaultTheme
                                                                        .WHITE,
                                                                    fontSize:
                                                                        12),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Stack(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      height: 200,
                                                      child: Image.network(
                                                        'http://45.76.186.233:8000/api/v1/Images?pathImage=${medicalInstructions3[index].images.first}',
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 150,
                                                      height: 200,
                                                      color: DefaultTheme
                                                          .BLACK_BUTTON
                                                          .withOpacity(0.4),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      child: Container(
                                                        width: 150,
                                                        height: 200,
                                                        color: DefaultTheme
                                                            .GREY_TOP_TAB_BAR
                                                            .withOpacity(0.3),
                                                        child: Center(
                                                            child: (medicalInstructions3[index]
                                                                            .images ==
                                                                        null ||
                                                                    medicalInstructions3[index]
                                                                            .images
                                                                            .length <
                                                                        2)
                                                                ? Text('')
                                                                : Text(
                                                                    '${medicalInstructions3[index].images.length}+',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: DefaultTheme
                                                                            .WHITE,
                                                                        fontSize:
                                                                            25),
                                                                  )),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      child: Container(
                                                        width: 150,
                                                        height: 50,
                                                        color: DefaultTheme
                                                            .BLACK_BUTTON
                                                            .withOpacity(0.5),
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                '${medicalInstructions3[index].medicalInstructionTypeName}',
                                                                style: TextStyle(
                                                                    color: DefaultTheme
                                                                        .WHITE),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              Text(
                                                                'Ngày tạo: ${medicalInstructions3[index].dateCreate}',
                                                                style: TextStyle(
                                                                    color: DefaultTheme
                                                                        .WHITE,
                                                                    fontSize:
                                                                        12),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        int medInsIdRemove =
                                            medicalInstructions3[index]
                                                .medicalInstructionId;
                                        print(
                                            'Medical instruction id when remove: ${medicalInstructions3[index].medicalInstructionId}');
                                        setState(() {
                                          medicalInstructions3.removeWhere(
                                              (item) =>
                                                  item.medicalInstructionId ==
                                                  medicalInstructions3[index]
                                                      .medicalInstructionId);

                                          medicalInstructionIdsSelected
                                              .removeWhere((item) =>
                                                  item == medInsIdRemove);

                                          ///
                                          for (int ind = 0;
                                              ind <
                                                  diseaseMedicalInstructionsSelected
                                                      .length;
                                              ind++) {
                                            if (diseaseMedicalInstructionsSelected[
                                                        ind]
                                                    .diseaseId ==
                                                null) {
                                              diseaseMedicalInstructionsSelected[
                                                      ind]
                                                  .medicalInstructionIds
                                                  .removeWhere((item) =>
                                                      item == medInsIdRemove);
                                            }
                                            print(
                                                'diseaseMedicalInstructionsSelected->medIds now:${diseaseMedicalInstructionsSelected[ind].diseaseId}-- ${diseaseMedicalInstructionsSelected[ind].medicalInstructionIds}');
                                          }
                                        });
                                      },
                                      child: SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: Image.asset(
                                            'assets/images/ic-close.png'),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  )
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
                  (medicalInstructionIdsSelected.length > 0)
                      ? Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: DefaultTheme.BLUE_DARK,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.only(
                              left: 10, right: 10, bottom: 5, top: 5),
                          child: Text(
                            'Đã chọn ${medicalInstructionIdsSelected.length} phiếu',
                            style: TextStyle(
                              fontSize: 15,
                              color: DefaultTheme.WHITE,
                            ),
                          ),
                        )
                      : Container(),

                  (medicalInstructionIdsSelected.length > 0)
                      ? Container(
                          margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ButtonHDr(
                            style: BtnStyle.BUTTON_BLACK,
                            label: 'Tiếp theo',
                            onTap: () {
                              // if (medicalInstructions1.length == 0 ||
                              //     medicalInstructions2.length == 0) {
                              //   return showDialog(
                              //     barrierDismissible: false,
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return Center(
                              //         child: ClipRRect(
                              //           borderRadius:
                              //               BorderRadius.all(Radius.circular(15)),
                              //           child: BackdropFilter(
                              //             filter: ImageFilter.blur(
                              //                 sigmaX: 25, sigmaY: 25),
                              //             child: Container(
                              //               padding: EdgeInsets.only(
                              //                   left: 10, top: 10, right: 10),
                              //               width: 250,
                              //               height: 160,
                              //               decoration: BoxDecoration(
                              //                 color:
                              //                     DefaultTheme.WHITE.withOpacity(0.7),
                              //               ),
                              //               child: Column(
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment.start,
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment.center,
                              //                 children: <Widget>[
                              //                   Container(
                              //                     padding: EdgeInsets.only(
                              //                         bottom: 5, top: 10),
                              //                     child: Text(
                              //                       'Lưu ý',
                              //                       style: TextStyle(
                              //                         decoration: TextDecoration.none,
                              //                         color: DefaultTheme.BLACK,
                              //                         fontWeight: FontWeight.w600,
                              //                         fontSize: 18,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   Container(
                              //                     padding: EdgeInsets.only(
                              //                         left: 20, right: 20),
                              //                     child: Align(
                              //                       alignment: Alignment.center,
                              //                       child: Text(
                              //                         'Yêu cầu của bạn có thể bị bác sĩ từ chối nếu chia sẻ không đủ các phiếu y lệnh cần thiết.',
                              //                         textAlign: TextAlign.center,
                              //                         style: TextStyle(
                              //                           decoration:
                              //                               TextDecoration.none,
                              //                           color: DefaultTheme.GREY_TEXT,
                              //                           fontWeight: FontWeight.w400,
                              //                           fontSize: 13,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   Spacer(),
                              //                   Divider(
                              //                     height: 1,
                              //                     color:
                              //                         DefaultTheme.GREY_TOP_TAB_BAR,
                              //                   ),
                              //                   Row(
                              //                     mainAxisAlignment:
                              //                         MainAxisAlignment.center,
                              //                     children: [
                              //                       FlatButton(
                              //                         height: 40,
                              //                         minWidth: 250 / 2 - 10.5,
                              //                         child: Text('Đóng',
                              //                             style: TextStyle(
                              //                                 color: DefaultTheme
                              //                                     .BLUE_TEXT)),
                              //                         onPressed: () {
                              //                           Navigator.of(context).pop();
                              //                         },
                              //                       ),
                              //                       Container(
                              //                         height: 40,
                              //                         width: 0.5,
                              //                         color: DefaultTheme
                              //                             .GREY_TOP_TAB_BAR,
                              //                       ),
                              //                       FlatButton(
                              //                         height: 40,
                              //                         minWidth: 250 / 2 - 10.5,
                              //                         child: Text('Tiếp tục',
                              //                             style: TextStyle(
                              //                                 color: DefaultTheme
                              //                                     .BLUE_TEXT)),
                              //                         onPressed: () {
                              //                           //
                              //                           Navigator.of(context).pop();
                              //                           Navigator.of(context).pushNamed(
                              //                               RoutesHDr
                              //                                   .CONTRACT_REASON_VIEW,
                              //                               arguments: {
                              //                                 'REQUEST_OBJ':
                              //                                     requestContractProvider
                              //                                         .getProvider,
                              //                               });
                              //                         },
                              //                       ),
                              //                     ],
                              //                   ),
                              //                 ],
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //   );
                              // }
                              // if (medicalInstructions1.length != 0 &&
                              //     medicalInstructions2.length != 0) {
                              Navigator.of(context).pushNamed(
                                  RoutesHDr.CONTRACT_REASON_VIEW,
                                  arguments: {
                                    'REQUEST_OBJ':
                                        requestContractProvider.getProvider,
                                  });
                              // }
                              // print('NOW WE HAVE');
                              // print('list IDs of disease ${_listLv3IdSelected}');
                              // print(
                              //     'list medicalInstructionIdsSelected ${medicalInstructionIdsSelected}');
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

  _showMedicalInstructionRequired() {
    int insideCount = 0;
    int insideCountOther = 0;
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
              'Sau đây là những phiếu y lệnh cần thiết mà hệ thống gợi ý cho bạn để chia sẻ cho bác sĩ. Những phiếu này tương ứng với bệnh lý mà bạn đã chọn.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        (_listLv3Selected.length != 0)
            ? Container(
                child: BlocBuilder<MedInsTypeReqListBloc, MedInsTypeReqState>(
                builder: (context, state) {
                  if (isAddNewList) {
                    insideCount = 0;
                    insideCountOther = 0;
                  }
                  if (state is MedInsTypeReqStateLoading) {}
                  if (state is MedInsTypeReqStateFailure) {
                    return Container(child: Text('FAILED'));
                  }
                  if (state is MedInsTypeReqStateSuccess) {
                    if (state.list == null || state.list.isEmpty) {
                      return Container(child: Text('empty'));
                    } else {
                      int totalHeader = 0;
                      List<int> listCountItemHeader = [];
                      List<int> medicalTypeIdAvailable = [];
                      if (isAddNewList) {
                        ////////
                        insideCount = 0;
                        insideCountOther = 0;
                        listMi.clear();
                        listMiOther.clear();
                        diseaseMedicalInstructionsSelected.clear();
                        diseaseMedicalInstructionsSelected.add(
                            DiseaseMedicalInstructions(
                                diseaseId: null, medicalInstructionIds: []));
                      }

                      for (MedicalTypeRequiredDTO miTyperequired
                          in state.list) {
                        totalHeader++;

                        if (isAddNewList) {
                          diseaseMedicalInstructionsSelected.add(
                              DiseaseMedicalInstructions(
                                  diseaseId: miTyperequired.diseaseId,
                                  medicalInstructionIds: []));
                          listMiOther.add([]);
                        }
                        int countElement = 0;
                        for (MedicalInstructions2 mi2
                            in miTyperequired.medicalInstructions) {
                          medicalTypeIdAvailable
                              .add(mi2.medicalInstructionTypeId);
                          countList++;
                          countElement++;
                          if (isAddNewList) {
                            listMi.add([]);
                          }
                        }
                        listCountItemHeader.add(countElement);
                      }
                      // print('length of mi list now: ${listMi.length}');
                      // print(
                      //     'length of miOther list now: ${listMiOther.length}');
                      // print(
                      //     'length ofdiseaseMedicalInstructionsSelected now: ${diseaseMedicalInstructionsSelected.length}');
                      isAddNewList = false;
                      return (state.list.length > 0)
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: state.list.length,
                              itemBuilder: (BuildContext context, int index) {
                                insideCountOther++;
                                int insideCountOtherNow = insideCountOther;
                                return Container(
                                  padding: EdgeInsets.only(
                                      bottom: 10, top: 10, left: 20, right: 20),
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  decoration: BoxDecoration(
                                      color: DefaultTheme.GREY_VIEW,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: Image.asset(
                                                  'assets/images/ic-add-disease.png'),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                            ),
                                            Text(
                                              'Mã bệnh ${state.list[index].diseaseId}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: DefaultTheme.BLUE_DARK,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            Spacer(),
                                            Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: DefaultTheme
                                                        .BLUE_DARK
                                                        .withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Center(
                                                  child: Text(
                                                      '${state.list[index].medicalInstructions.length} phiếu yêu cầu',
                                                      style: TextStyle(
                                                          color: DefaultTheme
                                                              .WHITE)),
                                                )),
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
                                      (state.list[index].medicalInstructions
                                                  .length >
                                              0)
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: state.list[index]
                                                  .medicalInstructions.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index2) {
                                                insideCount++;
                                                int insideCountNow =
                                                    insideCount;
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 15,
                                                                  bottom: 10),
                                                          child: Text(
                                                            '${state.list[index].medicalInstructions[index2].medicalInstructionTypeName}',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  DefaultTheme
                                                                      .BLACK,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        ButtonHDr(
                                                            onTap: () async {
                                                              print(
                                                                  '---------------------\n type id: ${state.list[index].medicalInstructions[index2].medicalInstructionTypeId}, p ID: ${_patientId}, diseaseId: ${state.list[index].diseaseId}');
                                                              await _medicalShareBloc.add(MedicalShareEventGet(
                                                                  patientId:
                                                                      _patientId,
                                                                  medicalInstructionType: state
                                                                      .list[
                                                                          index]
                                                                      .medicalInstructions[
                                                                          index2]
                                                                      .medicalInstructionTypeId,
                                                                  diseaseId: state
                                                                      .list[
                                                                          index]
                                                                      .diseaseId,
                                                                  medicalInstructionIds: []));

                                                              print(
                                                                  'inside count now: ${insideCountNow}');
                                                              _showMedicalShare(
                                                                  state
                                                                      .list[
                                                                          index]
                                                                      .medicalInstructions[
                                                                          index2]
                                                                      .medicalInstructionTypeName,
                                                                  (insideCountNow -
                                                                      1),
                                                                  state
                                                                      .list[
                                                                          index]
                                                                      .diseaseId);
                                                            },
                                                            style: BtnStyle
                                                                .BUTTON_IMAGE,
                                                            image: Image.asset(
                                                                'assets/images/ic-add-more-mi.png')),
                                                      ],
                                                    ),
                                                    (listMi[insideCountNow -
                                                                    1] !=
                                                                null &&
                                                            listMi[insideCountNow -
                                                                    1]
                                                                .isNotEmpty)
                                                        ? Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 200,
                                                            child: ListView
                                                                .builder(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount: listMi[
                                                                      insideCountNow -
                                                                          1]
                                                                  .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index3) {
                                                                //

                                                                return Container(
                                                                  width: 150,
                                                                  height: 200,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              20),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      if (listMi[insideCountNow - 1][index3].images ==
                                                                              null ||
                                                                          listMi[insideCountNow - 1][index3]
                                                                              .images
                                                                              .isEmpty) {
                                                                        _showDetailVitalSign(listMi[insideCountNow -
                                                                                1][index3]
                                                                            .medicalInstructionId);
                                                                      } else {
                                                                        showFullDetailComponent(
                                                                            listMi[insideCountNow - 1][index3].images,
                                                                            '${state.list[index].medicalInstructions[index2].medicalInstructionTypeName}',
                                                                            '${listMi[insideCountNow - 1][index3].dateCreate}',
                                                                            listMi[insideCountNow - 1][index3].disease,
                                                                            '${listMi[insideCountNow - 1][index3].conclusion}');
                                                                      }
                                                                    },
                                                                    child: (listMi[insideCountNow - 1][index3].images ==
                                                                                null ||
                                                                            listMi[insideCountNow - 1][index3].images.isEmpty)
                                                                        ? Stack(
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 150,
                                                                                height: 200,
                                                                                child: Center(
                                                                                  child: Image.asset((listMi[insideCountNow - 1][index3].medicalInstructionTypeName == 'Đơn thuốc') ? 'assets/images/ic-medicine.png' : 'assets/images/ic-health-selected.png', width: 50, height: 50),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: 150,
                                                                                height: 200,
                                                                                color: DefaultTheme.BLACK_BUTTON.withOpacity(0.4),
                                                                              ),
                                                                              Positioned(
                                                                                bottom: 0,
                                                                                child: Container(
                                                                                  width: 150,
                                                                                  height: 200,
                                                                                  color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.3),
                                                                                  child: Center(
                                                                                      child: (listMi[insideCountNow - 1][index3].images == null || listMi[insideCountNow - 1][index3].images.length < 2)
                                                                                          ? Text('')
                                                                                          : Text(
                                                                                              '${listMi[insideCountNow - 1][index3].images.length}+',
                                                                                              style: TextStyle(fontWeight: FontWeight.w600, color: DefaultTheme.WHITE, fontSize: 25),
                                                                                            )),
                                                                                ),
                                                                              ),
                                                                              Positioned(
                                                                                bottom: 0,
                                                                                child: Container(
                                                                                  width: 150,
                                                                                  height: 50,
                                                                                  color: DefaultTheme.BLACK_BUTTON.withOpacity(0.5),
                                                                                  child: Center(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          '${state.list[index].medicalInstructions[index2].medicalInstructionTypeName}',
                                                                                          style: TextStyle(color: DefaultTheme.WHITE),
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                        Text(
                                                                                          'Ngày tạo: ${listMi[insideCountNow - 1][index3].dateCreate}',
                                                                                          style: TextStyle(color: DefaultTheme.WHITE, fontSize: 12),
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : Stack(
                                                                            children: [
                                                                              SizedBox(
                                                                                width: 150,
                                                                                height: 200,
                                                                                child: Image.network(
                                                                                  'http://45.76.186.233:8000/api/v1/Images?pathImage=${listMi[insideCountNow - 1][index3].images.first}',
                                                                                  fit: BoxFit.fill,
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: 150,
                                                                                height: 200,
                                                                                color: DefaultTheme.BLACK_BUTTON.withOpacity(0.4),
                                                                              ),
                                                                              Positioned(
                                                                                bottom: 0,
                                                                                child: Container(
                                                                                  width: 150,
                                                                                  height: 200,
                                                                                  color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.3),
                                                                                  child: Center(
                                                                                      child: (listMi[insideCountNow - 1][index3].images == null || listMi[insideCountNow - 1][index3].images.length < 2)
                                                                                          ? Text('')
                                                                                          : Text(
                                                                                              '${listMi[insideCountNow - 1][index3].images.length}+',
                                                                                              style: TextStyle(fontWeight: FontWeight.w600, color: DefaultTheme.WHITE, fontSize: 25),
                                                                                            )),
                                                                                ),
                                                                              ),
                                                                              Positioned(
                                                                                bottom: 0,
                                                                                child: Container(
                                                                                  width: 150,
                                                                                  height: 50,
                                                                                  color: DefaultTheme.BLACK_BUTTON.withOpacity(0.5),
                                                                                  child: Center(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          '${state.list[index].medicalInstructions[index2].medicalInstructionTypeName}',
                                                                                          style: TextStyle(color: DefaultTheme.WHITE),
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                        Text(
                                                                                          'Ngày tạo: ${listMi[insideCountNow - 1][index3].dateCreate}',
                                                                                          style: TextStyle(color: DefaultTheme.WHITE, fontSize: 12),
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
                                                      padding: EdgeInsets.only(
                                                          top: 5, bottom: 5),
                                                      child: Divider(
                                                        color: DefaultTheme
                                                            .GREY_TOP_TAB_BAR,
                                                        height: 1,
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                            )
                                          : Container(),
                                      Container(
                                        height: 40,
                                        child: Row(
                                          children: [
                                            Text(
                                              'Phiếu khác',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: DefaultTheme.GREY_TEXT,
                                              ),
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: () async {
                                                //
                                                // await _medicalShareBloc.add(
                                                //     MedicalShareEventGet(
                                                //         patientId: _patientId,
                                                //         medicalInstructionType:
                                                //             null,
                                                //         diseaseId: state
                                                //             .list[index]
                                                //             .diseaseId,
                                                //         medicalInstructionIds: []));
                                                // print(
                                                //     'inside count now: ${insideCountOtherNow}');
                                                // _showMedicalShareOptional(
                                                //     'Phiếu khác',
                                                //     (insideCountOtherNow - 1),
                                                //     state
                                                //         .list[index].diseaseId);
                                                //
                                                if (_patientId != 0) {
                                                  _medInsTypeListBloc.add(
                                                      MedInsTypeEventGetListToShare(
                                                          patientId: _patientId,
                                                          diseaseId: state
                                                              .list[index]
                                                              .diseaseId,
                                                          medicalInstructionsIds: []));
                                                }

                                                _showMedicalInstructionOptionalIntoDisease(
                                                    state.list[index].diseaseId,
                                                    (insideCountOtherNow - 1),
                                                    medicalTypeIdAvailable);
                                              },
                                              child: SizedBox(
                                                width: 36,
                                                height: 36,
                                                child: Image.asset(
                                                    'assets/images/ic-add-more-mi.png'),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                            )
                                          ],
                                        ),
                                      ),
                                      (listMiOther[insideCountOtherNow - 1] !=
                                                  null &&
                                              listMiOther[
                                                      insideCountOtherNow - 1]
                                                  .isNotEmpty)
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 200,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: listMiOther[
                                                        insideCountOtherNow - 1]
                                                    .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index3) {
                                                  //

                                                  return Container(
                                                    width: 150,
                                                    height: 200,
                                                    margin: EdgeInsets.only(
                                                        right: 20),
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (listMiOther[insideCountOtherNow -
                                                                            1]
                                                                        [index3]
                                                                    .images ==
                                                                null ||
                                                            listMiOther[
                                                                    insideCountOtherNow -
                                                                        1][index3]
                                                                .images
                                                                .isEmpty) {
                                                          _showDetailVitalSign(listMiOther[
                                                                  insideCountOtherNow -
                                                                      1][index3]
                                                              .medicalInstructionId);
                                                        } else {
                                                          showFullDetailComponent(
                                                              listMiOther[insideCountOtherNow -
                                                                      1][index3]
                                                                  .images,
                                                              '${listMiOther[insideCountOtherNow - 1][index3].medicalInstructionTypeName}',
                                                              '${listMiOther[insideCountOtherNow - 1][index3].dateCreate}',
                                                              listMiOther[insideCountOtherNow -
                                                                      1][index3]
                                                                  .disease,
                                                              '${listMiOther[insideCountOtherNow - 1][index3].conclusion}');
                                                        }
                                                      },
                                                      child: (listMiOther[insideCountOtherNow -
                                                                              1]
                                                                          [
                                                                          index3]
                                                                      .images ==
                                                                  null ||
                                                              listMiOther[insideCountOtherNow -
                                                                      1][index3]
                                                                  .images
                                                                  .isEmpty)
                                                          ? Stack(
                                                              children: [
                                                                Container(
                                                                  width: 150,
                                                                  height: 200,
                                                                  color: DefaultTheme
                                                                      .GREY_TOP_TAB_BAR
                                                                      .withOpacity(
                                                                          0.6),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  height: 200,
                                                                  color: DefaultTheme
                                                                      .BLACK_BUTTON
                                                                      .withOpacity(
                                                                          0.4),
                                                                ),
                                                                Positioned(
                                                                  bottom: 0,
                                                                  child:
                                                                      Container(
                                                                    width: 150,
                                                                    height: 200,
                                                                    color: DefaultTheme
                                                                        .GREY_TOP_TAB_BAR
                                                                        .withOpacity(
                                                                            0.3),
                                                                    child: Center(
                                                                        child: (listMiOther[insideCountOtherNow - 1][index3].images == null || listMiOther[insideCountOtherNow - 1][index3].images.length < 2)
                                                                            ? Text('')
                                                                            : Text(
                                                                                '${listMiOther[insideCountOtherNow - 1][index3].images.length}+',
                                                                                style: TextStyle(fontWeight: FontWeight.w600, color: DefaultTheme.WHITE, fontSize: 25),
                                                                              )),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 0,
                                                                  child:
                                                                      Container(
                                                                    width: 150,
                                                                    height: 50,
                                                                    color: DefaultTheme
                                                                        .BLACK_BUTTON
                                                                        .withOpacity(
                                                                            0.5),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            '${listMiOther[insideCountOtherNow - 1][index3].medicalInstructionTypeName}',
                                                                            style:
                                                                                TextStyle(color: DefaultTheme.WHITE),
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                          Text(
                                                                            'Ngày tạo: ${listMiOther[insideCountOtherNow - 1][index3].dateCreate}',
                                                                            style:
                                                                                TextStyle(color: DefaultTheme.WHITE, fontSize: 12),
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Stack(
                                                              children: [
                                                                SizedBox(
                                                                  width: 150,
                                                                  height: 200,
                                                                  child: Image
                                                                      .network(
                                                                    'http://45.76.186.233:8000/api/v1/Images?pathImage=${listMiOther[insideCountOtherNow - 1][index3].images.first}',
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  height: 200,
                                                                  color: DefaultTheme
                                                                      .BLACK_BUTTON
                                                                      .withOpacity(
                                                                          0.4),
                                                                ),
                                                                Positioned(
                                                                  bottom: 0,
                                                                  child:
                                                                      Container(
                                                                    width: 150,
                                                                    height: 200,
                                                                    color: DefaultTheme
                                                                        .GREY_TOP_TAB_BAR
                                                                        .withOpacity(
                                                                            0.3),
                                                                    child: Center(
                                                                        child: (listMiOther[insideCountOtherNow - 1][index3].images == null || listMiOther[insideCountOtherNow - 1][index3].images.length < 2)
                                                                            ? Text('')
                                                                            : Text(
                                                                                '${listMiOther[insideCountOtherNow - 1][index3].images.length}+',
                                                                                style: TextStyle(fontWeight: FontWeight.w600, color: DefaultTheme.WHITE, fontSize: 25),
                                                                              )),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 0,
                                                                  child:
                                                                      Container(
                                                                    width: 150,
                                                                    height: 50,
                                                                    color: DefaultTheme
                                                                        .BLACK_BUTTON
                                                                        .withOpacity(
                                                                            0.5),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            '${listMiOther[insideCountOtherNow - 1][index3].medicalInstructionTypeName}',
                                                                            style:
                                                                                TextStyle(color: DefaultTheme.WHITE),
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                          Text(
                                                                            'Ngày tạo: ${listMiOther[insideCountOtherNow - 1][index3].dateCreate}',
                                                                            style:
                                                                                TextStyle(color: DefaultTheme.WHITE, fontSize: 12),
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
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
                                  ),
                                );
                              },
                            )
                          : Container();
                    }
                  }
                  return Container();
                },
              ))
            : Container(),
      ],
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
                                                    onTap: () {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }

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
                                                                '${group.diseaseLevelTwoId}: ${group.diseaseLevelTwoName}',
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
                                                                .diseaseLevelThrees,
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
                                                onTap: () async {
                                                  print(
                                                      'list disease lv3  selected ids: ${_listLv3IdSelected}');

                                                  ///
                                                  Navigator.of(context).pop();
                                                  if (listMi.length > 0) {
                                                    listMi.clear();
                                                  }
                                                  isAddNewList = true;
                                                  // await Future.delayed(
                                                  //     const Duration(
                                                  //         seconds: 1),
                                                  //     () async {
                                                  if (_listLv3IdSelected
                                                          .length >
                                                      0) {
                                                    _medInsTypeReqListBloc.add(
                                                        MedInsTypeReqEventGet(
                                                            diseaseIds:
                                                                _listLv3IdSelected));
                                                  }
                                                  // });

                                                  ///
                                                  ///PROCESS REQUIRED MEDICAL INSTRUCTIONC HERE.
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

  showFullDetailComponent(List<String> imgs, String miName, String dateCreate,
      String diseases, String conclusion) {
    int positionImage = 0;
    bool isTappedOut = false;
    print('disease list: $diseases');
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          //
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Material(
              child: InkWell(
                onTap: () {
                  setModalState(() {
                    isTappedOut = !isTappedOut;
                  });
                },
                child: (isTappedOut)
                    ? Container(
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
                                customSize: Size(
                                    MediaQuery.of(context).size.width,
                                    MediaQuery.of(context).size.height),
                                imageProvider: NetworkImage(
                                    'http://45.76.186.233:8000/api/v1/Images?pathImage=${imgs[positionImage]}'),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
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
                                customSize: Size(
                                    MediaQuery.of(context).size.width,
                                    MediaQuery.of(context).size.height),
                                imageProvider: NetworkImage(
                                    'http://45.76.186.233:8000/api/v1/Images?pathImage=${imgs[positionImage]}'),
                              ),
                            ),
                            (imgs.length > 1)
                                ? Positioned(
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        setModalState(() {
                                          if (positionImage == imgs.length) {
                                            positionImage = 0;
                                          } else if (positionImage <
                                              imgs.length - 1) {
                                            positionImage++;
                                          } else {
                                            positionImage = 0;
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.centerRight,
                                              end: Alignment.centerLeft,
                                              colors: [
                                                DefaultTheme.BLACK
                                                    .withOpacity(0.3),
                                                DefaultTheme.TRANSPARENT,
                                              ]),
                                        ),
                                        child: SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: Image.asset(
                                              'assets/images/ic-next.png'),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            (imgs.length > 1)
                                ? Positioned(
                                    left: 0,
                                    child: InkWell(
                                      onTap: () {
                                        setModalState(() {
                                          // if (positionImage == imgs.length) {
                                          //   positionImage = 0;
                                          // } else if (positionImage < imgs.length - 1) {
                                          //   positionImage--;
                                          // } else {
                                          //   positionImage = 0;
                                          // }
                                          if (positionImage == 0) {
                                            positionImage = imgs.length - 1;
                                          } else {
                                            positionImage--;
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                DefaultTheme.BLACK
                                                    .withOpacity(0.3),
                                                DefaultTheme.TRANSPARENT,
                                              ]),
                                        ),
                                        child: SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: Image.asset(
                                              'assets/images/ic-prev.png'),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            (imgs != null)
                                ? Positioned(
                                    top: 25,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Text(
                                          '${positionImage + 1}/${imgs.length}',
                                          style: TextStyle(
                                              color: DefaultTheme.WHITE)),
                                    ),
                                  )
                                : Container(),
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
                                    child: Image.asset(
                                        'assets/images/ic-close.png'),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
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
                                    (diseases == null || diseases == '')
                                        ? Container()
                                        : Text(
                                            'Chẩn đoán: $diseases',
                                            style: TextStyle(
                                                color: DefaultTheme.WHITE,
                                                fontSize: 15),
                                          ),
                                    Text(
                                      (conclusion == null)
                                          ? ''
                                          : 'Kết luận: $conclusion',
                                      style: TextStyle(
                                          color: DefaultTheme.WHITE,
                                          fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Text(
                                      'Ngày tạo: $dateCreate',
                                      style: TextStyle(
                                          color: DefaultTheme.WHITE,
                                          fontSize: 15),
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
              ),
            );
            //
          });
        });
  }

  _showMedicalShare(
      String nameOfList, int indexItemNow, String diseaseIdFromSelected) {
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
                                      if (state.listMedicalShare == null ||
                                          state.listMedicalShare.isEmpty) {
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
                                                    onTap: () {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
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
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                                width: 30,
                                                                height: 30,
                                                                child: Image.asset(
                                                                    'assets/images/ic-health-record.png'),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  //
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        132,
                                                                    child: Text(
                                                                      'Hồ sơ tại ${group.healthRecordPlace}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                    ),
                                                                  ),
                                                                  // Padding(
                                                                  //   padding: EdgeInsets
                                                                  //       .only(
                                                                  //           bottom:
                                                                  //               3),
                                                                  // ),
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        132,
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
                                                                      maxLines:
                                                                          1,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom:
                                                                            5),
                                                                  ),
                                                                  // _genderDiseaseCheckBox(
                                                                  //     group
                                                                  //         .diseases),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          items: _buildMedInsRequired(
                                                              context,
                                                              group
                                                                  .medicalInstructions,
                                                              setModalState,
                                                              nameOfList,
                                                              indexItemNow,
                                                              diseaseIdFromSelected),
                                                        );
                                                      }).toList(),
                                                    ),
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
                                                        'list medical ins selected ids: ${medicalInstructionIdsSelected}');
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      //
                                    }
                                    return Container();
                                  }),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ));
          });
        });
  }

  // Widget _genderDiseaseCheckBox(List<String> diseases) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       for (String disease in diseases)
  //         Container(
  //           width: MediaQuery.of(context).size.width - 132,
  //           margin: EdgeInsets.only(bottom: 5),
  //           child: Text('$disease',
  //               style: TextStyle(fontSize: 12, color: DefaultTheme.BLUE_DARK),
  //               overflow: TextOverflow.ellipsis,
  //               maxLines: 2),
  //         ),
  //     ],
  //   );
  // }

  void _showDetailVitalSign(int medicalInstructionId) {
    setState(() {
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
                              'Đang tải',
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
    });

    _medicalInstructionRepository
        .getMedicalInstructionById(medicalInstructionId)
        .then((value) {
      Navigator.pop(context);
      if (value != null) {
        if (value.medicationsRespone != null) {
          Navigator.pushNamed(context, RoutesHDr.MEDICAL_HISTORY_DETAIL,
              arguments: value.medicalInstructionId);
        } else {
          var dateStarted = _dateValidator.convertDateCreate(
              value.vitalSignScheduleRespone.timeStared,
              'dd/MM/yyyy',
              "yyyy-MM-dd");
          var dateFinished = _dateValidator.convertDateCreate(
              value.vitalSignScheduleRespone.timeCanceled,
              'dd/MM/yyyy',
              "yyyy-MM-dd");

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
                        height: MediaQuery.of(context).size.height * 0.4,
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
                                  Padding(padding: EdgeInsets.only(top: 5)),
                                  Text(
                                    'Người đặt: ${value.placeHealthRecord}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.none,
                                      color: DefaultTheme.GREY_TEXT,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 10)),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: value.vitalSignScheduleRespone
                                          .vitalSigns.length,
                                      itemBuilder: (context, index) {
                                        var item = value
                                            .vitalSignScheduleRespone
                                            .vitalSigns[index];
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Divider(
                                              color: DefaultTheme.GREY_TEXT,
                                              height: 0.25,
                                            ),
                                            Text(
                                              '${value.vitalSignScheduleRespone.vitalSigns[0].vitalSignType}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                decoration: TextDecoration.none,
                                                color: DefaultTheme.GREY_TEXT,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Chỉ số an toàn:',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    decoration:
                                                        TextDecoration.none,
                                                    color:
                                                        DefaultTheme.GREY_TEXT,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  '${value.vitalSignScheduleRespone.vitalSigns[0].numberMin} - ${value.vitalSignScheduleRespone.vitalSigns[0].numberMax}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    decoration:
                                                        TextDecoration.none,
                                                    color:
                                                        DefaultTheme.GREY_TEXT,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
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
                                          ],
                                        );
                                      },
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                    ),
                                  ),
                                  ButtonHDr(
                                    style: BtnStyle.BUTTON_BLACK,
                                    label: 'Chi tiết',
                                    onTap: () {
                                      Map<String, dynamic> arguments = {
                                        'healthRecordId': 0,
                                        'medicalInstructionId':
                                            medicalInstructionId,
                                        "timeStared": value
                                            .vitalSignScheduleRespone
                                            .timeStared,
                                        "timeCanceled": value
                                            .vitalSignScheduleRespone
                                            .timeCanceled,
                                      };
                                      Navigator.pushNamed(context,
                                          RoutesHDr.VITAL_SIGN_CHART_DETAIL,
                                          arguments: arguments);
                                    },
                                  ),
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

                                      // _listMedInsType.removeWhere((item) =>
                                      //     item.medicalInstructionTypeId == 4);
                                      // _listMedInsType.removeWhere((item) =>
                                      //     item.medicalInstructionTypeId == 6);

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
                                                      patientId: _patientId,
                                                      medicalInstructionType:
                                                          _medInsTypeId,
                                                      diseaseId: '',
                                                      medicalInstructionIds:
                                                          medicalInstructionIdsSelected));
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
                                                            width: 30,
                                                            height: 30,
                                                            child: Image.asset(
                                                                'assets/images/ic-health-record.png'),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              //
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    132,
                                                                child: Text(
                                                                  'Hồ sơ tại ${group.healthRecordPlace}',
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
                                                              // Padding(
                                                              //   padding: EdgeInsets
                                                              //       .only(
                                                              //           bottom:
                                                              //               3),
                                                              // ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    132,
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
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            5),
                                                              ),
                                                              // _genderDiseaseCheckBox(
                                                              //     group
                                                              //         .diseases),
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

  _showMedicalInstructionOptionalIntoDisease(String diseaseIdInto,
      int insideCountOtherNow, List<int> medicalTypeIdAvailable) {
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

                                      // print(
                                      //     'medicalTypeIdAvailable: ${medicalTypeIdAvailable}');
                                      // print(
                                      //     'LIST MED INS TYPE LENGTH BEFORE REMOVE NOW: ${_listMedInsType.length}');

                                      // // _listMedInsType.removeWhere((item) =>
                                      // //     item.medicalInstructionTypeId == 4);
                                      // // _listMedInsType.removeWhere((item) =>
                                      // //     item.medicalInstructionTypeId == 6);
                                      // for (MedicalInstructionTypeDTO x
                                      //     in _listMedInsType) {
                                      //   print(
                                      //       'id in list get from api: ${x.medicalInstructionTypeId}');
                                      // }

                                      for (int y = 0;
                                          y < medicalTypeIdAvailable.length;
                                          y++) {
                                        //
                                        _listMedInsType.removeWhere((item) =>
                                            item.medicalInstructionTypeId ==
                                            medicalTypeIdAvailable[y]);
                                      }
                                      // print(
                                      //     'LIST MED INS TYPE LENGTH NOW: ${_listMedInsType.length}');
                                      // // return Text('OK');
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
                                                      patientId: _patientId,
                                                      medicalInstructionType:
                                                          _medInsTypeId,
                                                      diseaseId: diseaseIdInto,
                                                      medicalInstructionIds: []));
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
                                                            width: 30,
                                                            height: 30,
                                                            child: Image.asset(
                                                                'assets/images/ic-health-record.png'),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              //
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    132,
                                                                child: Text(
                                                                  'Hồ sơ tại ${group.healthRecordPlace}',
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
                                                              // Padding(
                                                              //   padding: EdgeInsets
                                                              //       .only(
                                                              //           bottom:
                                                              //               3),
                                                              // ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    132,
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
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            5),
                                                              ),
                                                              // _genderDiseaseCheckBox(
                                                              //     group
                                                              //         .diseases),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      items: _buildMedInsOptionalIntoDisease(
                                                          context,
                                                          group
                                                              .medicalInstructions,
                                                          insideCountOtherNow,
                                                          diseaseIdInto,
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
}
