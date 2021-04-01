import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/medical_share_event.dart';
import 'package:capstone_home_doctor/features/contract/states/medical_share_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/health_record_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/hr_list_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/hr_list_state.dart';
import 'package:capstone_home_doctor/features/health/medical_share/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/health/medical_share/events/medical_Share_event.dart';
import 'package:capstone_home_doctor/features/health/medical_share/repositories/medical_share_repository.dart';
import 'package:capstone_home_doctor/features/health/medical_share/states/medical_share_state.dart';
import 'package:capstone_home_doctor/models/contract_inlist_dto.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
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

  List<MedInsByDiseaseDTO> listMedicalInsShare;
  //
  bool sendStatus = false;

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

  //
  _showFullImageDescription(String img, String miName, String dateCreate) {
    showDialog(
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
                          _checkingShare(dropdownValue.contractId,
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
            if (_patientId != 0 && dropdownValue.contractId != 0) {
              await _medicalShareBloc.add(MedicalShareEventGetMediIns(
                  patientID: _patientId,
                  contractID: dropdownValue.contractId,
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
                                                      InkWell(
                                                        onTap: () {
                                                          if (itemMedi.image ==
                                                                  null ||
                                                              itemMedi.medicalInstructionTypeId ==
                                                                  1) {
                                                            Navigator.pushNamed(
                                                                context,
                                                                RoutesHDr
                                                                    .MEDICAL_HISTORY_DETAIL,
                                                                arguments: itemMedi
                                                                    .medicalInstructionId);
                                                          } else {
                                                            _showFullImageDescription(
                                                                itemMedi.image,
                                                                element
                                                                    .medicalInstructionTypes[
                                                                        indexType]
                                                                    .miTypeName,
                                                                itemMedi
                                                                    .dateCreate);
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

  _checkingShare(int _contractId, List<int> _listMedIns) {
    setState(() {
      showDialog(
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
      if (_contractId != 0 && _listMedIns.length > 0) {
        _medicalShareInsBloc.add(MedicalShareInsEventSend(
            healthRecordId: dropdownValue.healthRecordId,
            listMediIns: medicalInstructionIdsSelected));
        Navigator.of(context).pop();
        Future.delayed(const Duration(seconds: 3), () {
          _medicalShareHelper.isMedicalShared().then((value) {
            if (value == true) {
              showDialog(
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
                                child:
                                    Image.asset('assets/images/ic-checked.png'),
                              ),
                              Text(
                                'Chia sẻ thêm thành công',
                                style: TextStyle(
                                    color: DefaultTheme.GREY_TEXT,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.none),
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
                Navigator.of(context).pop();
              });
            } else {
              _alertError('Không thể chia sẻ, vui lòng thử lại');
            }
          });
        });
      } else {
        Navigator.of(context).pop();
        _alertError('Bạn phải chọn ít nhất 1 phiếu để chia sẻ');
      }
    });
  }

  _alertError(String title) {
    showDialog(
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
}
