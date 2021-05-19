import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/numeral_ui.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_bottom_sheet_field.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_chip_display.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_item.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_list_type.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/disease_list_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/disease_list_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/disease_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/disease_list_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/health_record_create_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/hr_create_event.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:capstone_home_doctor/services/health_record_helper.dart';
import 'package:capstone_home_doctor/services/medical_instruction_helper.dart';
import 'package:expandable_group/expandable_group_widget.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';

import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/models/disease_dto.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final MedicalInstructionHelper _medicalInstructionHelper =
    MedicalInstructionHelper();

class CreateHealthRecord extends StatefulWidget {
  final Function refresh;

  CreateHealthRecord(this.refresh);
  @override
  State<StatefulWidget> createState() {
    return _CreateHealthRecord();
  }
}

class _CreateHealthRecord extends State<CreateHealthRecord>
    with WidgetsBindingObserver {
  int _patientId = 0;
  HealthRecordRepository healthRecordRepository =
      HealthRecordRepository(httpClient: http.Client());
  HealthRecordCreateBloc _healthRecordCreateBloc;
  DiseaseRepository diseaseRepository =
      DiseaseRepository(httpClient: http.Client());

  List<String> suggestions = [];
  // List<String> _listType = [];

  String _valueTypeIns;
  String dateCreate;

  //
  //SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
  DateValidator _dateValidator = DateValidator();
  var _placeController = TextEditingController();
  // var _diseaseController = TextEditingController();
  String _note = '';
  List<DiseaseDTO> _listDisease = [];
  List<DiseaseDTO> _listDiseaseSelected = [];
  List<String> _diseaseIds = [];
  DiseaseListBloc _diseaseListBloc;

  //disease for heart
  List<DiseaseContractDTO> _listDiseaseForHeart = [];
  List<DiseaseContractDTO> _listDiseaseForHeartForSearch = [];
  List<DiseaseLeverThrees> _listLv3Selected = [];
  List<String> _listLv3IdSelected = [];
  var _diseaseIDController = TextEditingController();
  final HealthRecordHelper hrHelper = HealthRecordHelper();

  Timer searchOnStoppedTyping;

  HealthRecordDTO healthRecordDTO;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _getPatientId();
    getDataFromJSONFile();
    _healthRecordCreateBloc = BlocProvider.of(context);
    _diseaseListBloc = BlocProvider.of(context);
    _diseaseListBloc.add(DiseaseListEventSetStatus());
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        _patientId = value;
      });
    });
  }

  Future<void> getDataFromJSONFile() async {
    final String response = await rootBundle.loadString('assets/global.json');

    if (response.contains('suggestions')) {
      final data = await json.decode(response);
      for (var item in data['suggestions']) {
        suggestions.add(item);
      }
    }

    // if (response.contains('listType')) {
    //   final data = await json.decode(response);
    //   for (var item in data['listType']) {
    //     _listType.add(item);
    //   }
    // }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _diseaseListBloc.add(DiseaseEventSetInitial());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _medicalInstructionHelper.getCreateHRFromDetail().then((check) async {
          //
          if (check) {
            ///CODE HERE FOR NAVIGATE
            ///
            int currentIndex = 2;
            Navigator.of(context).pushNamedAndRemoveUntil(
                RoutesHDr.MAIN_HOME, (Route<dynamic> route) => false,
                arguments: currentIndex);

            ///
            await _medicalInstructionHelper.updateCreateHRFromDetail(false);
          } else {
            Navigator.pop(context);
            await _medicalInstructionHelper.updateCreateHRFromDetail(false);
          }
        });
        return new Future(() => false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              HeaderWidget(
                title: 'Tạo hồ sơ sức khỏe',
                isMainView: false,
                buttonHeaderType: ButtonHeaderType.BACK_HOME,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 5, top: 20),
                      child: Text('Thông tin bệnh lý',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 0, right: 20, bottom: 10),
                        child: Text(
                          'Chọn bệnh lý chính xác được ghi trên hồ sơ sức khoẻ',
                          style: TextStyle(
                              color: DefaultTheme.GREY_TEXT,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    _checkSelectIns(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 10, top: 20),
                      child: Text('Thông tin hồ sơ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 10, top: 10, left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: DefaultTheme.GREY_VIEW,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 75,
                                child: Text(
                                  'Ngày khám',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: DefaultTheme.BLACK),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                width: 10,
                                child: Text(
                                  '*',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: DefaultTheme.RED_CALENDAR),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  DateTime newDateTime =
                                      await showRoundedDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(
                                              DateTime.now().year - 100),
                                          lastDate: DateTime.now(),
                                          borderRadius: 16,
                                          theme: ThemeData.dark());
                                  if (newDateTime != null) {
                                    setState(() {
                                      dateCreate = newDateTime.toString();
                                    });
                                  }
                                },
                                child: Container(
                                  height: 45,
                                  width:
                                      MediaQuery.of(context).size.width - 180,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                      ),
                                      Text(
                                          (dateCreate == null)
                                              ? 'Chọn ngày khám'
                                              : '${_dateValidator.parseToDateView3(dateCreate)}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: (dateCreate == null)
                                                  ? DefaultTheme.BLUE_REFERENCE
                                                  : DefaultTheme.BLACK))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            height: 2,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 75,
                                child: Text(
                                  'Nơi khám',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: DefaultTheme.BLACK),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                width: 10,
                                child: Text(
                                  '*',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: DefaultTheme.RED_CALENDAR),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width - 190,
                                height: 45,
                                child: AutoCompleteTextField(
                                  controller: _placeController,
                                  clearOnSubmit: false,
                                  suggestions: suggestions,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    counter: Offstage(),
                                    // labelText: _label,
                                    // helperText: _helperText,
                                    filled: true,
                                    fillColor: DefaultTheme.GREY_BUTTON
                                        .withOpacity(0.8),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        width: 0.25,
                                        color: DefaultTheme.TRANSPARENT,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        width: 0.25,
                                        color: DefaultTheme.TRANSPARENT,
                                      ),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  itemFilter: (suggestion, input) => suggestion
                                      .toLowerCase()
                                      .contains(input.toLowerCase()),
                                  itemSorter: (a, b) {
                                    return a.compareTo(b);
                                  },
                                  itemSubmitted: (item) =>
                                      _placeController.text = item,
                                  itemBuilder: (context, suggestion) =>
                                      new Padding(
                                          child: new ListTile(
                                              title: new Text(suggestion)),
                                          padding: EdgeInsets.all(8.0)),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                            height: 2,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                width: 85,
                                child: Text(
                                  'Ghi chú',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: DefaultTheme.BLACK),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                width: MediaQuery.of(context).size.width - 170,
                                height: 150,
                                padding: EdgeInsets.all(0),
                                child: TextFieldHDr(
                                    keyboardAction: TextInputAction.done,
                                    placeHolder: 'Mô tả thêm các vấn đề khác',
                                    style: TFStyle.TEXT_AREA,
                                    onChange: (text) {
                                      setState(() {
                                        _note = text;
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: ButtonHDr(
                        style: BtnStyle.BUTTON_BLACK,
                        label: 'Tạo hồ sơ',
                        onTap: () {
                          if (dateCreate == null || dateCreate == '') {
                            alertError('Vui lòng chọn ngày khám');
                          } else {
                            if (_patientId != 0 &&
                                _placeController.text != null &&
                                _placeController.text != '' &&
                                _placeController.text.length > 0 &&
                                (_listLv3IdSelected.length > 0 ||
                                    _diseaseIds.length > 0)) {
                              healthRecordDTO = HealthRecordDTO(
                                  patientId: _patientId,
                                  diceaseIds: _diseaseIds.length <= 0
                                      ? _listLv3IdSelected
                                      : _diseaseIds,
                                  place: _placeController.text,
                                  description: _note,
                                  dateCreated: dateCreate.split(' ')[0]);
                              // dateCreated: _dateValidator.convertDateCreate(
                              //     dateCreate, 'yyyy-MM-dd', 'yyyy-MM-dd'));
                              _insertHealthRecord(healthRecordDTO);
                            } else {
                              _insertHealthRecord(null);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildSelectedDisease() {
    return (_listLv3Selected.length == 0 || _listLv3Selected == null)
        ? Container()
        : Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _listLv3Selected.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 5),
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 5),
                  decoration: BoxDecoration(
                    color: DefaultTheme.GREY_VIEW,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            child: Text(
                                '${_listLv3Selected[index].diseaseLevelThreeId}:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: DefaultTheme.BLUE_DARK,
                                  fontSize: 15,
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 130,
                            child: Text(
                                '${_listLv3Selected[index].diseaseLevelThreeName}',
                                style: TextStyle(fontSize: 15)),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _listLv3IdSelected.removeAt(index);
                              _listLv3Selected.removeAt(index);
                            });
                          },
                          child: SizedBox(
                            width: 15,
                            height: 15,
                            child: Image.asset('assets/images/ic-close.png'),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
  }

  _selectBoxInsHeart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          // color: DefaultTheme.GREY_VIEW,
          borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildSelectedDisease(),
          InkWell(
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: MediaQuery.of(context).size.width - 40,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          width: 1, color: DefaultTheme.GREY_TOP_TAB_BAR)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Image.asset('assets/images/ic-add-disease.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                      ),
                      Text(
                        'Thêm bệnh lý',
                        style: TextStyle(
                          color: DefaultTheme.BLACK_BUTTON,
                          // fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              _getListDiseaseContract();
            },
          )
        ],
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
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Danh sách bệnh lý',
                                          style: TextStyle(
                                              color: DefaultTheme.BLACK,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: 20, top: 5),
                                          child: Text(
                                              'Danh sách dưới đây tương ứng với loại bệnh lý có trong hồ sơ của bạn.',
                                              style: TextStyle(
                                                  color:
                                                      DefaultTheme.GREY_TEXT)),
                                        ),
                                        _searchDiseases(setModalState),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 20),
                                        ),
                                        Expanded(
                                          child: ListView(
                                            children: (_listDiseaseForHeartForSearch
                                                            .length >
                                                        0
                                                    ? _listDiseaseForHeartForSearch
                                                    : _listDiseaseForHeart)
                                                .asMap()
                                                .map(
                                                  (key, value) => MapEntry(
                                                    key,
                                                    Container(
                                                      child: showItem(context,
                                                          value, setModalState),
                                                    ),
                                                  ),
                                                )
                                                .values
                                                .toList(),
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(bottom: 30),
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
                                  ),
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
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  // bui(diseaseContractDTO, StateSetter setModalState) {
  //   // if (item == null) {
  //   //   item = showItem(context, diseaseContractDTO, setModalState);
  //   // }
  //   return showItem(context, diseaseContractDTO, setModalState);
  // }

  // Widget item;

  // List<ListTile> _buildItems(BuildContext context,
  //     List<DiseaseLeverThrees> items, StateSetter setModalState) {
  //   return items.map((e) {
  //     bool checkTemp = false;
  //     if (_listLv3IdSelected.contains(e.diseaseLevelThreeId)) {
  //       checkTemp = true;
  //     }

  //     return ListTile(
  //       title: InkWell(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: <Widget>[
  //                 Container(
  //                   width: MediaQuery.of(context).size.width - 100,
  //                   child: Text(
  //                     '${e.diseaseLevelThreeId} - ${e.diseaseLevelThreeName}',
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 3,
  //                     style: TextStyle(
  //                         color: DefaultTheme.BLUE_REFERENCE,
  //                         fontWeight: FontWeight.w500),
  //                   ),
  //                 ),
  //                 Spacer(),
  //                 ClipRRect(
  //                   borderRadius: BorderRadius.circular(6),
  //                   child: Container(
  //                     width: 20,
  //                     height: 20,
  //                     decoration:
  //                         BoxDecoration(borderRadius: BorderRadius.circular(5)),
  //                     child: Checkbox(
  //                       materialTapTargetSize: MaterialTapTargetSize.padded,
  //                       checkColor: DefaultTheme.GRADIENT_1,
  //                       activeColor: DefaultTheme.GREY_VIEW,
  //                       hoverColor: DefaultTheme.GREY_VIEW,
  //                       value: checkTemp,
  //                       onChanged: (_) {
  //                         // setModalState(
  //                         //   () {
  //                         //     checkTemp = !checkTemp;

  //                         //     setState(
  //                         //       () {
  //                         //         if (checkTemp == true) {
  //                         //           _listLv3IdSelected.removeWhere(
  //                         //               (item) => item == e.diseaseLevelThreeId);
  //                         //           _listLv3IdSelected.add(e.diseaseLevelThreeId);

  //                         //           _listLv3Selected.removeWhere((item) =>
  //                         //               item.diseaseLevelThreeId ==
  //                         //               e.diseaseLevelThreeId);
  //                         //           _listLv3Selected.add(e);
  //                         //         } else {
  //                         //           _listLv3IdSelected.removeWhere(
  //                         //               (item) => item == e.diseaseLevelThreeId);
  //                         //           _listLv3Selected.removeWhere((item) =>
  //                         //               item.diseaseLevelThreeId ==
  //                         //               e.diseaseLevelThreeId);
  //                         //         }
  //                         //       },
  //                         //     );
  //                         //   },
  //                         // );
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         onTap: () {
  //           setModalState(
  //             () {
  //               checkTemp = !checkTemp;

  //               setState(
  //                 () {
  //                   if (checkTemp == true) {
  //                     _listLv3IdSelected
  //                         .removeWhere((item) => item == e.diseaseLevelThreeId);
  //                     _listLv3IdSelected.add(e.diseaseLevelThreeId);

  //                     _listLv3Selected.removeWhere((item) =>
  //                         item.diseaseLevelThreeId == e.diseaseLevelThreeId);
  //                     _listLv3Selected.add(e);
  //                   } else {
  //                     _listLv3IdSelected
  //                         .removeWhere((item) => item == e.diseaseLevelThreeId);
  //                     _listLv3Selected.removeWhere((item) =>
  //                         item.diseaseLevelThreeId == e.diseaseLevelThreeId);
  //                   }
  //                 },
  //               );
  //             },
  //           );
  //         },
  //       ),
  //     );
  //   }).toList();
  // }

  // void checkSelectDisease(DiseaseLeverThrees lv3) {
  //   bool checkTemp = false;
  //   if (_listLv3IdSelected.contains(lv3.diseaseLevelThreeId)) {
  //     checkTemp = true;
  //   }

  //   setState(() {
  //     if (!checkTemp) {
  //       _listLv3IdSelected.add(lv3.diseaseLevelThreeId);
  //       _listLv3Selected.add(lv3);
  //     } else {
  //       _listLv3IdSelected
  //           .removeWhere((item) => item == lv3.diseaseLevelThreeId);
  //       _listLv3Selected.removeWhere(
  //           (item) => item.diseaseLevelThreeId == lv3.diseaseLevelThreeId);
  //     }
  //   });

  //   print(_listLv3IdSelected);
  // }

  Widget _checkSelectIns() {
    return BlocBuilder<DiseaseListBloc, DiseaseListState>(
      builder: (context, state) {
        if (state is DiseaseListStateLoading) {
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
        if (state is DiseaseListStateFailure) {
          return Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: DefaultTheme.GREY_BUTTON),
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              child: Text('Không có dữ liệu',
                  style: TextStyle(
                    color: DefaultTheme.GREY_TEXT,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          );
        }
        if (state is DiseaseListStateSuccess) {
          // if (state.listDisease != null) {
          //   _listDisease = [];
          //   for (var item in state.listDisease) {
          //     String alpha = item.diseaseId[0];
          //     String strDisID = '';
          //     var listDiseasesID = item.diseaseId.split('-');
          //     int num1 = int.parse(listDiseasesID[0].substring(1));
          //     int num2 = int.parse(listDiseasesID[1].substring(1));
          //     for (var num = num1; num <= num2; num++) {
          //       strDisID += '$alpha$num';
          //     }
          //     item.strDiseaseID = strDisID;
          //     _listDisease.add(item);
          //   }

          //   // _listDisease = state.listDisease;
          // }
          // return _selectBoxInsOtherDissease();
          if (state.listDisease != null) {
            _listDiseaseForHeart = state.listDisease;
          }
          return _selectBoxInsHeart();
        }
        if (state is DiseaseHeartListStateSuccess) {
          if (state.listDiseaseContract != null) {
            _listDiseaseForHeart = state.listDiseaseContract;
          }
          return _selectBoxInsHeart();
        }
        return Container();
      },
    );
  }

  _insertHealthRecord(HealthRecordDTO dto) {
    if (dto == null) {
      alertError('Vui lòng nhập đầy đủ các thông tin yêu cầu');
    } else {
      setState(() {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Material(
              color: DefaultTheme.TRANSPARENT,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      width: 250,
                      height: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: DefaultTheme.WHITE.withOpacity(0.8)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 120,
                            child: Image.asset('assets/images/loading.gif'),
                          ),
                          Text(
                            'Đang tạo',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );

        _healthRecordCreateBloc.add(HRCreateEventSend(dto: dto));
        Future.delayed(
          const Duration(seconds: 3),
          () {
            hrHelper.getHRResponse().then(
              (value) {
                Navigator.of(context).pop();
                if (value > 0) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return Material(
                        color: DefaultTheme.TRANSPARENT,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                width: 250,
                                height: 185,
                                decoration: BoxDecoration(
                                  color: DefaultTheme.WHITE.withOpacity(0.7),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.only(bottom: 10, top: 10),
                                      child: Text(
                                        'Tạo thành công',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: DefaultTheme.BLACK,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    //Spacer(),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 20, right: 20, top: 20),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Bạn có muốn tạo thêm y lệnh ngay không?',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: DefaultTheme.BLACK,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Divider(
                                      height: 1,
                                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FlatButton(
                                          height: 40,
                                          minWidth: 250 / 2 - 10.5,
                                          child: Text('Không',
                                              style: TextStyle(
                                                  color:
                                                      DefaultTheme.BLUE_TEXT)),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            int currentIndex = 2;
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    RoutesHDr.MAIN_HOME,
                                                    (Route<dynamic> route) =>
                                                        false,
                                                    arguments: currentIndex);
                                          },
                                        ),
                                        Container(
                                          height: 40,
                                          width: 0.5,
                                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                                        ),
                                        FlatButton(
                                          height: 40,
                                          minWidth: 250 / 2 - 10.5,
                                          child: Text('Tiếp tục',
                                              style: TextStyle(
                                                  color:
                                                      DefaultTheme.BLUE_TEXT)),
                                          onPressed: () async {
                                            //refresh data
                                            setState(() {
                                              _listDiseaseSelected = [];
                                              _diseaseIds = [];
                                              _listLv3Selected = [];
                                              _listLv3IdSelected = [];
                                              _listDiseaseForHeartForSearch =
                                                  [];
                                              _placeController.text = '';
                                            });

                                            _diseaseListBloc
                                                .add(DiseaseEventSetInitial());
                                            //navigate to health record detail
                                            Navigator.of(context).pop();
                                            hrHelper.setHealthReCordId(value);
                                            //
                                            await _medicalInstructionHelper
                                                .updateCheckToCreateOrList(
                                                    true);
                                            Navigator.of(context)
                                                .pushNamed(RoutesHDr
                                                    .HEALTH_RECORD_DETAIL)
                                                .then((value) =>
                                                    Navigator.of(context)
                                                        .pop());
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  alertError('Lỗi tạo hồ sơ');
                }
              },
            );
          },
        );
      });
    }
  }

  alertError(String title) {
    setState(() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: DefaultTheme.TRANSPARENT,
            child: Center(
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
                        Spacer(),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.asset('assets/images/ic-failed.png'),
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '$title',
                            style: TextStyle(
                                color: DefaultTheme.BLACK,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    });
  }

  List<DiseaseContractDTO> updateSearchQueryForInsurance(
      String val, List<DiseaseContractDTO> allItems) {
    if (val != null && val.trim().isNotEmpty) {
      List<DiseaseContractDTO> filteredItems = [];
      for (var item in allItems) {
        for (var el in item.diseaseLevelThrees) {
          if (el.strDiseaseID.toLowerCase().contains(val.toLowerCase()) &&
              !filteredItems.contains(item)) {
            filteredItems.add(item);
          }
        }
        // if (item.diseaseLevelTwoId
        //         .toLowerCase()
        //         .contains(val[0].toLowerCase()) &&
        //     !filteredItems.contains(item)) {
        //   var listDiseases = item.diseaseLevelTwoId.split('-');
        //   if (listDiseases.length > 1) {
        //     int num1 = int.parse(listDiseases[0].substring(1));
        //     int num2 = int.parse(listDiseases[1].substring(1));
        //     if (val.substring(1) != '') {
        //       if (num1 <= int.parse(val.substring(1)) &&
        //           int.parse(val.substring(1)) <= num2) {
        //         filteredItems.add(item);
        //       }
        //     } else {
        //       if (item.diseaseLevelTwoId
        //           .toLowerCase()
        //           .contains(val.toLowerCase())) {
        //         filteredItems.add(item);
        //       }
        //     }
        //   } else {
        //     if (item.diseaseLevelTwoId
        //         .toLowerCase()
        //         .contains(val.toLowerCase())) {
        //       filteredItems.add(item);
        //     }
        //   }
        // } else {
        //   for (var itemLV3 in item.diseaseLevelThrees) {
        //     if (itemLV3.diseaseLevelThreeName
        //             .toLowerCase()
        //             .contains(val.toLowerCase()) &&
        //         !filteredItems.contains(item)) {
        //       filteredItems.add(item);
        //     }
        //   }
        // }
      }
      return filteredItems;
    } else {
      return allItems;
    }
  }

  Widget _searchDiseases(StateSetter setModalState) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10),
      child: TextField(
        controller: _diseaseIDController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "Tìm kiếm mã bệnh",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        onChanged: (val) {
          // const duration = Duration(
          //     milliseconds:
          //         1000); // set the duration that you want call search() after that.
          // if (searchOnStoppedTyping != null) {
          //   setModalState(() => searchOnStoppedTyping.cancel()); // clear timer
          // }
          // setModalState(() =>
          //     searchOnStoppedTyping = new Timer(duration, () => print(val)));

          setModalState(() {
            setState(() {
              _listDiseaseForHeartForSearch =
                  updateSearchQueryForInsurance(val, _listDiseaseForHeart);
            });
          });
        },
      ),
    );
  }

  Widget showItem(context, diseaseContractDTO, StateSetter setModalState) {
    return ExpandableGroup(
      collapsedIcon: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset('assets/images/ic-navigator.png')),
      expandedIcon: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset('assets/images/ic-down.png')),
      isExpanded: true,
      header: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Image.asset('assets/images/ic-add-disease.png'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 122,
            child: Text(
              '${diseaseContractDTO.diseaseLevelTwoId}: ${diseaseContractDTO.diseaseLevelTwoName}',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
      items: _buildItems(
          context, diseaseContractDTO.diseaseLevelThrees, setModalState),
    );
  }

  List<ListTile> _buildItems(BuildContext context,
      List<DiseaseLeverThrees> items, StateSetter setModalState) {
    return items.map((e) {
      bool checkTemp = false;
      if (_listLv3IdSelected.contains(e.diseaseLevelThreeId)) {
        checkTemp = true;
      }

      return ListTile(
        title: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(
                      '${e.diseaseLevelThreeId} - ${e.diseaseLevelThreeName}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                          color: DefaultTheme.BLUE_REFERENCE,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 20,
                      height: 20,
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
                          bool temp = false;
                          if (_listLv3IdSelected
                              .contains(e.diseaseLevelThreeId)) {
                            temp = true;
                          }

                          setModalState(() {
                            setState(() {
                              if (!temp) {
                                _listLv3IdSelected.add(e.diseaseLevelThreeId);
                                _listLv3Selected.add(e);
                              } else {
                                _listLv3IdSelected.removeWhere(
                                    (item) => item == e.diseaseLevelThreeId);
                                _listLv3Selected.removeWhere((item) =>
                                    item.diseaseLevelThreeId ==
                                    e.diseaseLevelThreeId);
                              }
                            });
                          });

                          print(_listLv3IdSelected);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            bool temp = false;
            if (_listLv3IdSelected.contains(e.diseaseLevelThreeId)) {
              temp = true;
            }

            setModalState(() {
              setState(() {
                if (!temp) {
                  _listLv3IdSelected.add(e.diseaseLevelThreeId);
                  _listLv3Selected.add(e);
                } else {
                  _listLv3IdSelected
                      .removeWhere((item) => item == e.diseaseLevelThreeId);
                  _listLv3Selected.removeWhere((item) =>
                      item.diseaseLevelThreeId == e.diseaseLevelThreeId);
                }
              });
            });

            print(_listLv3IdSelected);
          },
        ),
      );
    }).toList();
  }
}
