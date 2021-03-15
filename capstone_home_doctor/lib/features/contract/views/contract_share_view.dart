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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

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
  List<DiseaseDTO> _listDisease = [];
  List<DiseaseDTO> _listDiseaseSelected = [];
  List<String> _diseaseIds = [];

  //FOR MEDICAL SHARE
  HealthRecordRepository _healthRecordRepository =
      HealthRecordRepository(httpClient: http.Client());
  MedicalShareBloc _medicalShareBloc;
  List<MedicalShareDTO> listMedicalShare = [];
  bool isLastRemove = false;
  String _labelHR = 'Hồ sơ sức khoẻ';
  List<MedicalInstructionTypes> medicalInstructionTypes = [];
  List<MedicalInstructions> medicalInstructions = [];
  bool isChecked = false;
  //
  List<int> medicalInstructionIdsSelected = [];

  //PATIENT ID
  int _patientId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

  Map<String, bool> values = {
    'foo': true,
    'bar': false,
  };

  //
  @override
  Widget build(BuildContext context) {
    String arguments = ModalRoute.of(context).settings.arguments;
    // _idDoctor = int.tryParse(arguments);
    print('ID doctor now: ${arguments.toString()}');
    _listDisease.clear();
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
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Divider(
                      color: DefaultTheme.GREY_TEXT,
                      height: 2,
                    ),
                  ),
                  _getMedicalShare(),
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
                   (medicalInstructionIdsSelected.length != 0)
                      ? Container(
                          margin: EdgeInsets.only(left: 20),
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
                                    RoutesHDr.CONFIRM_CONTRACT_VIEW,
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
              ..add(DiseaseListEventSetStatus(status: 'ACTIVE')),
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
            if (state2 is DiseaseListStateSuccess) {
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
                .map((disease) =>
                    MultiSelectItem<DiseaseDTO>(disease, disease.toString()))
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
                  "Bệnh lý tim mạch",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                title: Text(
                  "Chọn các bệnh lý",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                items: _itemsView,
                onConfirm: (values) {
                  setState(() {
                    //FOR CHECKING LAST REMOVE
                    isLastRemove = false;
                    //FOR RESET LABEL HR
                    _labelHR = 'Hồ sơ sức khoẻ';
                    //REFRESH MED_INS_TYPES
                    medicalInstructionTypes = [];
                    medicalInstructionIdsSelected = [];

                    String _idDisease = '';
                    _diseaseIds.clear();
                    _listDiseaseSelected = values;
                    for (var i = 0; i < values.length; i++) {
                      _idDisease = values[i].toString().split(':')[0];
                      _diseaseIds.add(_idDisease);
                    }
                    if (_diseaseIds != [] && _patientId != 0) {
                      _medicalShareBloc.add(MedicalShareEventGet(
                          diseaseIds: _diseaseIds, patientId: _patientId));
                    }
                  });
                  //  print('VALUES: ${values.toString()}');

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
                      //FOR RESET LABEL HR
                      _labelHR = 'Hồ sơ sức khoẻ';
                      //REFRESH MED_INS_TYPES
                      medicalInstructionTypes = [];
                      medicalInstructionIdsSelected = [];
                      //
                      _listDiseaseSelected.remove(value);
                      _diseaseIds.remove(value.toString().split(':')[0]);
                      print(
                          'DISEASE LIST SELECT WHEN REMOVE NOW: ${_listDiseaseSelected.toString()}');
                      print('LIST ID DISEASE NOW ${_diseaseIds}');
                      if (_patientId != 0) {
                        _medicalShareBloc.add(MedicalShareEventGet(
                            diseaseIds: _diseaseIds, patientId: _patientId));
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

  _getMedicalShare() {
    return BlocBuilder<MedicalShareBloc, MedicalShareState>(
        builder: (context, state) {
      //
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
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: DefaultTheme.GREY_BUTTON),
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
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
        // medicalInstructions.clear();
        // for (int a = 0; a < state.listMedicalShare.length; a++) {
        //   for (int b = 0;
        //       b < state.listMedicalShare[a].medicalInstructionTypes.length;
        //       b++) {
        //     medicalInstructions.add(state.listMedicalShare[a]
        //         .medicalInstructionTypes[b].medicalInstructions);
        //   }
        //}
        //
        // medicalInstructions =
        //     medicalInstructionTypes[index].medicalInstructions;
        if (state.listMedicalShare == null) {
          if (isLastRemove == false) {
            return Column(
              children: <Widget>[
                //
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Center(
                  child: SizedBox(
                    height: 50,
                    child: Image.asset('assets/images/ic-health-record.png'),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 60, right: 60, top: 10),
                  child: Center(
                    child: Text(
                      'Hiện bạn chưa có hồ sơ sức khoẻ\ncho bệnh lý này',
                      style: TextStyle(
                        color: DefaultTheme.GREY_TEXT,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        }
        return (state.listMedicalShare != [])
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Text(
                      'Chọn hồ sơ sức khoẻ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                    child: Text(
                        'Dưới đây là danh sách hồ sơ sức khoẻ mà bạn đã thêm vào hệ thống trước đó. Các hồ sơ sức khoẻ tương ứng với bệnh lý đã chọn.'),
                  ),
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemCount: state.listMedicalShare.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return

                  //     //Text(
                  //     //  '${state.listMedicalShare[index].healthRecordPlace}');
                  //   },
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                      padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          color: DefaultTheme.GREY_VIEW,
                          borderRadius: BorderRadius.circular(6)),
                      child: DropdownButton<MedicalShareDTO>(
                        items:
                            state.listMedicalShare.map((MedicalShareDTO value) {
                          return new DropdownMenuItem<MedicalShareDTO>(
                            value: value,
                            child: new Text(
                              value.healthRecordPlace,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                        dropdownColor: DefaultTheme.GREY_VIEW,
                        // icon: SizedBox(
                        //   width: 15,
                        //   height: 15,
                        //   child: Image.asset('assets/images/ic-health-record.png'),
                        // ),
                        elevation: 1,
                        hint: Container(
                          width: MediaQuery.of(context).size.width - 84,
                          child: Text(
                            '${_labelHR}',
                            style: TextStyle(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),

                        underline: Container(
                          width: 0,
                        ),
                        isExpanded: false,
                        onChanged: (_) {
                          setState(() {
                            // medicalInstructionTypes.clear();
                            medicalInstructionTypes = _.medicalInstructionTypes;
                            _labelHR = _.healthRecordPlace;
                            print('${_.healthRecordPlace}');
                            // _medInsTypeId = _.medicalInstructionTypeId;
                            // _selectedHRType = _.name;
                            // print('${_selectedHRType}');
                          });
                        },
                      ),
                    ),
                  ),

                  //
                  // ListView(
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   children: values.keys.map((String key) {
                  //     return new CheckboxListTile(
                  //       title: new Text(key),
                  //       value: values[key],
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           values[key] = value;
                  //         });
                  //       },
                  //     );
                  //   }).toList(),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Divider(
                      color: DefaultTheme.GREY_TEXT,
                      height: 2,
                    ),
                  ),
                  (medicalInstructions != [] || !medicalInstructions.isEmpty)
                      ? Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 30),
                          child: Text(
                            'Chia sẻ phiếu y lệnh',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : Container(),
                  (medicalInstructions != [] || !medicalInstructions.isEmpty)
                      ? Container(
                          padding: EdgeInsets.only(left: 20, right: 10, top: 5),
                          child: Text(
                              'Dưới đây là danh sách các phiếu y lệnh tương ứng với các tập hồ sơ sức khoẻ mà bạn thêm trước đó.'),
                        )
                      : Container(),
                  (medicalInstructions != [] || !medicalInstructions.isEmpty)
                      ? Container(
                          margin:
                              EdgeInsets.only(left: 20, top: 20, bottom: 30),
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            // shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            itemCount: medicalInstructionTypes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (MedicalInstructions i
                                      in medicalInstructionTypes[index]
                                          .medicalInstructions)
                                    Container(
                                      height: 250,
                                      width: 200,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          onTap: () async {
                                            setState(() {
                                              isChecked = true;
                                            });
                                            if (!medicalInstructionIdsSelected
                                                .contains(
                                                    i.medicalInstructionId)) {
                                              medicalInstructionIdsSelected
                                                  .add(i.medicalInstructionId);
                                            }

                                            print(
                                                'list medicalInstructionIdsSelected now: ${medicalInstructionIdsSelected}');
                                          },
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: DefaultTheme.GREY_VIEW,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              (i.image != null)
                                                  ? SizedBox(
                                                      height: 250,
                                                      width: 200,
                                                      child: Image.network(
                                                        'http://45.76.186.233:8000/api/v1/Images?pathImage=${i.image}',
                                                        fit: BoxFit.fill,
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 250,
                                                      width: 200,
                                                      decoration: BoxDecoration(
                                                          color: DefaultTheme
                                                              .GREY_VIEW),
                                                      child: Text(
                                                          'Đơn thuốc từ hệ thống HDr'),
                                                    ),
                                              Positioned(
                                                bottom: 0,
                                                child: Container(
                                                  height: 50,
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              bottom: Radius
                                                                  .circular(5)),
                                                      color: DefaultTheme.BLACK
                                                          .withOpacity(0.65)),
                                                  child: Center(
                                                    child: Text(
                                                      '${medicalInstructionTypes[index].miTypeName}',
                                                      style: TextStyle(
                                                        color:
                                                            DefaultTheme.WHITE,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // (isChecked)
                                              //     ? Positioned(
                                              //         top: 0,
                                              //         child: Container(
                                              //           height: 250,
                                              //           width: 200,
                                              //           decoration: BoxDecoration(
                                              //               color: DefaultTheme
                                              //                   .BLACK_BUTTON
                                              //                   .withOpacity(0.4)),
                                              //         ),
                                              //       )
                                              //     : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        )
                      : Container(),

                  for (int x in medicalInstructionIdsSelected)
                    Container(
                      child: Text('${x}'),
                    ),
                ],
              )
            : Container();
      }
      return Container();
    });
  }
}

// class ContractScreen1Provider extends ChangeNotifier{
//   Contract1Obj =
// }
