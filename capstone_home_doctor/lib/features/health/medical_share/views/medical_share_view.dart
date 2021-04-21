import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/medical_share_event.dart';
import 'package:capstone_home_doctor/features/contract/states/medical_share_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/health_record_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_detail_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/hr_list_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_get_by_id_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/hr_list_state.dart';
import 'package:capstone_home_doctor/features/health/medical_share/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/health/medical_share/events/medical_Share_event.dart';
import 'package:capstone_home_doctor/features/health/medical_share/repositories/medical_share_repository.dart';
import 'package:capstone_home_doctor/features/health/medical_share/states/medical_share_state.dart';
import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/medical_share_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';

final MedicalShareHelper _medicalShareHelper = MedicalShareHelper();

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
  List<HealthRecordDTO> _listContracts = List<HealthRecordDTO>();
  HealthRecordDTO dropdownValue;
  HealthRecordListBloc _healthRecordListBloc;
  List<int> medicalInstructionIdsSelected = [];
  MedicalShareBloc _medicalShareBloc;
  MedicalShareInsBloc _medicalShareInsBloc;

  MedicalShareInsRepository _medicalShareInsRepository =
      MedicalShareInsRepository(httpClient: http.Client());
  MedicalInstructionRepository _medicalInstructionRepository =
      MedicalInstructionRepository(httpClient: http.Client());

  List<MedInsByDiseaseDTO> listMedicalInsShare;
  //
  bool sendStatus = false;
  DateValidator _dateValidator = DateValidator();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _healthRecordListBloc = BlocProvider.of(context);
    _medicalShareBloc = BlocProvider.of(context);
    _medicalShareInsBloc = BlocProvider.of(context);

    _getPatientId();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _medicalShareInsBloc.add(MedicalShareInsEventInitial());
    super.dispose();
  }

  showFullDetailComponent(
      List<String> imgs, String miName, String dateCreate, String dianose) {
    int positionImage = 0;
    bool isTappedOut = false;

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
                                    Text(
                                      'Chuẩn đoán $dianose',
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
                                      'Ngày tạo $dateCreate',
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
                    dropdownValue = null;
                    listMedicalInsShare = [];
                    medicalInstructionIdsSelected = [];
                    _medicalShareInsBloc.add(MedicalShareInsEventInitial());
                  }
                  return RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: (_contractId == null)
                        ? ListView(
                            children: [
                              BlocBuilder<HealthRecordListBloc, HRListState>(
                                builder: (context, state) {
                                  if (state is HRListStateLoading) {
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
                                  if (state is HRListStateFailure) {
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
                                  if (state is HRListStateSuccess) {
                                    if (state.listHealthRecord != null) {
                                      _listContracts = [];
                                      for (var contract
                                          in state.listHealthRecord) {
                                        if (contract.contractId != null) {
                                          _listContracts.add(contract);
                                        }
                                      }
                                    }
                                    return _selectContract();
                                  }
                                  return Container();
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  'Danh sách phiếu y lệnh:',
                                  style: TextStyle(
                                      color: DefaultTheme.BLACK,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                ),
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
            (medicalInstructionIdsSelected.length <= 0)
                ? Container()
                : Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      margin: EdgeInsets.only(bottom: 20),
                      child: ButtonHDr(
                        style: BtnStyle.BUTTON_BLACK,
                        label: 'Chia sẻ',
                        onTap: () {
                          _checkingShare(dropdownValue.healthRecordId,
                              medicalInstructionIdsSelected);
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  checkImageNull(MedicalInstructionsDTO dto) {
    int size = 20;
    if (dto.image == null) {
      if (dto.medicalInstructionTypeId == 1) {
        return Container(
          width: (size * 1.5),
          height: (size * 1.5),
          child: Image.asset('assets/images/ic-medicine.png'),
        );
      } else if (dto.medicalInstructionTypeId == 8) {
        return Container(
          width: (size * 1.5),
          height: (size * 1.5),
          child: Image.asset('assets/images/ic-health-selected.png'),
        );
      } else if (dto.medicalInstructionTypeId == 10) {
        return Container(
          width: (size * 1.5),
          height: (size * 1.5),
          child: Image.asset('assets/images/ic-calendar.png'),
        );
      } else {
        return Container(
            width: (size * 1.5),
            height: (size * 1.5),
            color: DefaultTheme.GREY_TOP_TAB_BAR);
      }
    } else {
      if (dto.image.length <= 0) {
        if (dto.medicalInstructionTypeId == 1) {
          return Container(
            width: (size * 1.5),
            height: (size * 1.5),
            child: Image.asset('assets/images/ic-medicine.png'),
          );
        } else if (dto.medicalInstructionTypeId == 8) {
          return Container(
            width: (size * 1.5),
            height: (size * 1.5),
            child: Image.asset('assets/images/ic-health-selected.png'),
          );
        } else if (dto.medicalInstructionTypeId == 10) {
          return Container(
            width: (size * 1.5),
            height: (size * 1.5),
            child: Image.asset('assets/images/ic-calendar.png'),
          );
        } else {
          return Container(
              width: (size * 1.5),
              height: (size * 1.5),
              color: DefaultTheme.GREY_TOP_TAB_BAR);
        }
      } else {
        return Image.network(
          'http://45.76.186.233:8000/api/v1/Images?pathImage=${dto?.image.first}',
          fit: BoxFit.fill,
        );
      }
    }
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
        child: DropdownButton<HealthRecordDTO>(
          value: dropdownValue,
          items: _listContracts.map((HealthRecordDTO value) {
            DateTime dateCreated =
                DateFormat('yyyy-MM-dd').parse(value.dateCreated);
            return new DropdownMenuItem<HealthRecordDTO>(
              value: value,
              child: new Text(
                '${value.place}-${DateFormat('dd/MM/yyyy').format(dateCreated)}',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            );
          }).toList(),
          dropdownColor: DefaultTheme.GREY_VIEW,
          elevation: 1,
          hint: Container(
            width: MediaQuery.of(context).size.width - 84,
            child: Text(
              'Chọn hồ sơ cần chia sẻ:',
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
            if (_patientId != 0 && dropdownValue.contractId != 0) {
              await _medicalShareBloc.add(MedicalShareEventGetMediIns(
                  patientID: _patientId,
                  healthRecordId: dropdownValue.healthRecordId));
            }
          },
        ),
      ),
    );
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
                                    'Hồ sơ tại ${element.healthRecordPlace}',
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
                                                      InkWell(
                                                        onTap: () {
                                                          if (itemMedi.image
                                                                      .length <=
                                                                  0 &&
                                                              itemMedi.medicalInstructionTypeId ==
                                                                  1) {
                                                            print(itemMedi
                                                                .medicalInstructionId);
                                                            Navigator.pushNamed(
                                                                context,
                                                                RoutesHDr
                                                                    .MEDICAL_HISTORY_DETAIL,
                                                                arguments: itemMedi
                                                                    .medicalInstructionId);
                                                          } else if (itemMedi
                                                                      .image
                                                                      .length <=
                                                                  0 &&
                                                              itemMedi.medicalInstructionTypeId ==
                                                                  8) {
                                                            _showDetailVitalSign(
                                                                itemMedi
                                                                    .medicalInstructionId);
                                                          } else if (itemMedi
                                                                  .image
                                                                  .length >
                                                              0) {
                                                            showFullDetailComponent(
                                                                itemMedi.image,
                                                                element
                                                                    .medicalInstructionTypes[
                                                                        indexType]
                                                                    .miTypeName,
                                                                itemMedi
                                                                    .dateCreate,
                                                                itemMedi
                                                                    .diagnose);
                                                          }
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          child: SizedBox(
                                                            width: (30 * 1.5),
                                                            height: (40 * 1.5),
                                                            child: (itemMedi
                                                                        .image !=
                                                                    null)
                                                                ? Stack(
                                                                    children: [
                                                                      Container(
                                                                        width: (30 *
                                                                            1.5),
                                                                        height: (40 *
                                                                            1.5),
                                                                        color: DefaultTheme
                                                                            .GREY_TOP_TAB_BAR,
                                                                        child: checkImageNull(
                                                                            itemMedi),
                                                                        // (itemMedi.image.length <=
                                                                        //         0)
                                                                        //     ? Container
                                                                        //     : Image.network(
                                                                        //         'http://45.76.186.233:8000/api/v1/Images?pathImage=${itemMedi.image.first}',
                                                                        //         fit: BoxFit.fill,
                                                                        //       ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 0,
                                                                        child: Container(
                                                                            width: (30 * 1.5),
                                                                            height: (40 * 1.5),
                                                                            color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.2),
                                                                            child: Center(
                                                                              child: Text(
                                                                                (itemMedi.image.length > 1) ? '${itemMedi.image.length}+' : '',
                                                                                style: TextStyle(color: DefaultTheme.WHITE),
                                                                              ),
                                                                            )),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Container(
                                                                    width: (30 *
                                                                        1.5),
                                                                    height: (40 *
                                                                        1.5),
                                                                    color: DefaultTheme
                                                                        .GREY_TOP_TAB_BAR,
                                                                    child: checkImageNull(
                                                                        itemMedi),
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                '${element.medicalInstructionTypes[indexType].miTypeName}'),
                                                            Text(
                                                                '${itemMedi.dateCreate.trim()}',
                                                                style: TextStyle(
                                                                    color: DefaultTheme
                                                                        .GREY_TEXT)),
                                                          ],
                                                        ),
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
                  ],
                ),
              );
            }
            return Container();
          })
        : Container(
            child: Text('Hãy chọn hợp đồng muốn chia sẻ trước',
                style: TextStyle(color: DefaultTheme.GREY_TEXT)),
          );
  }

  _checkingShare(int healthRecordId, List<int> _listMedIns) {
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
                            'Đang chia sẻ',
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
      if (healthRecordId != 0 && _listMedIns.length > 0) {
        // _medicalShareInsBloc.add(MedicalShareInsEventSend(
        //     healthRecordId: dropdownValue.healthRecordId,
        //     listMediIns: medicalInstructionIdsSelected));
        //
        _medicalShareInsRepository
            .shareMoreMedIns(
                dropdownValue.healthRecordId, medicalInstructionIdsSelected)
            .then((value) {
          Navigator.of(context).pop();
          if (value) {
            // showDialog(
            //   barrierDismissible: false,
            //   context: context,
            //   builder: (BuildContext context) {
            //     return Center(
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.all(Radius.circular(5)),
            //         child: BackdropFilter(
            //           filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            //           child: Container(
            //             width: 200,
            //             height: 200,
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(10),
            //                 color: DefaultTheme.WHITE.withOpacity(0.8)),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 SizedBox(
            //                   width: 100,
            //                   height: 100,
            //                   child:
            //                       Image.asset('assets/images/ic-checked.png'),
            //                 ),
            //                 Text(
            //                   'Chia sẻ thêm thành công',
            //                   style: TextStyle(
            //                       color: DefaultTheme.GREY_TEXT,
            //                       fontSize: 15,
            //                       fontWeight: FontWeight.w400,
            //                       decoration: TextDecoration.none),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // );
            // Future.delayed(const Duration(seconds: 3), () {
            // Navigator.of(context).pop();
            Navigator.of(context).pop();
            // });
          } else {
            _alertError('Không thể chia sẻ, vui lòng thử lại');
          }
        });

        // Future.delayed(const Duration(seconds: 3), () {
        //   _medicalShareHelper.isMedicalShared().then((value) {

        //   });
        // });
      } else {
        Navigator.of(context).pop();
        _alertError('Bạn phải chọn ít nhất 1 phiếu để chia sẻ');
      }
    });
  }

  _alertError(String title) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: DefaultTheme.WHITE.withOpacity(0.8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/images/ic-failed.png'),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '$title',
                        style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
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
          _healthRecordListBloc.add(
              HRListEventSetPersonalHRId(personalHealthRecordId: _patientId));
        }
      });
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
        if (value.vitalSignScheduleRespone != null) {
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
                                              'Ngày Kết thúc: ${dateFinished}',
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
                                  Center(
                                    child: ButtonHDr(
                                      style: BtnStyle.BUTTON_BLACK,
                                      label: 'Chi tiết',
                                      onTap: () {
                                        Map<String, dynamic> arguments = {
                                          'healthRecordId':
                                              dropdownValue.healthRecordId,
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
}
