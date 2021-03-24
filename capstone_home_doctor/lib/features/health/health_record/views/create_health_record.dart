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
import 'package:expandable_group/expandable_group_widget.dart';

import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/hr_create_state.dart';
import 'package:capstone_home_doctor/models/disease_dto.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

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

  List<String> suggestions = [
    'Bệnh Viện Đại Học Y Dược',
    'Bệnh Viện Chợ Rẫy',
    'Bệnh Viện Từ Dũ',
    'Bệnh Viện Nhi Đồng 1',
    'Bệnh Viện Nhi Đồng 2',
    'Bệnh viện Đại học Y Dược TP. HCM',
    'Viện Tim Tp.HCM',
    'Bệnh viện Tim Tâm Đức',
    'Phòng khám Bệnh viện Đại học Y Dược 1',
    'Bệnh viện Đa khoa Quốc tế Vinmec',
    'Phòng khám Đa khoa Saigon Healthcare',
    'Bệnh Viện Thống Nhất',
    'Bệnh Viện Ung Bướu',
    'Bệnh viện truyền máu huyết học',
    'Bệnh viện Nhân dân 115',
    'Bệnh viện Nhân dân Gia Định',
    'Bệnh viện Nguyễn Trãi',
    'Bệnh viện Nguyễn Tri Phương',
    'Bệnh viện Bệnh Nhiệt đới',
    'Viện Y dược học cổ truyền',
    'Bệnh viện Đa khoa Khu vực Thủ Đức'
  ];

  String _valueTypeIns;
  List<String> _listType = ['Bệnh tim', 'Các bệnh khác'];

  //
  //SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
  DateValidator _dateValidator = DateValidator();
  var _placeController = TextEditingController();
  var _diseaseController = TextEditingController();
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

  HealthRecordDTO healthRecordDTO;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _getPatientId();
    _healthRecordCreateBloc = BlocProvider.of(context);
    _diseaseListBloc = BlocProvider.of(context);
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        _patientId = value;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _diseaseListBloc.add(DiseaseEventSetInitial());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Tạo hồ sơ sức khoẻ',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.NONE,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_dateValidator.getDateTimeView()}',
                  style: TextStyle(color: DefaultTheme.GREY_TEXT),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(left: 20, right: 20),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  _selectTypeIns(),
                  _checkSelectIns(),
                  //
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, left: 10, right: 20),
                      child: Text(
                        'Chọn mã bệnh chính xác được ghi trên hồ sơ bệnh án của bạn',
                        style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Divider(
                      color: DefaultTheme.GREY_LIGHT,
                      height: 0.1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, left: 10),
                    child: Text(
                      'Nơi khám (*)',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: DefaultTheme.BLACK_BUTTON,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  AutoCompleteTextField(
                    controller: _placeController,
                    clearOnSubmit: false,
                    suggestions: suggestions,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      counter: Offstage(),
                      // labelText: _label,
                      // helperText: _helperText,
                      filled: true,
                      fillColor: DefaultTheme.GREY_BUTTON.withOpacity(0.8),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(
                          DefaultNumeralUI.PADDING,
                          0,
                          DefaultNumeralUI.PADDING,
                          0),
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
                    itemFilter: (suggestion, input) =>
                        suggestion.toLowerCase().contains(input.toLowerCase()),
                    itemSorter: (a, b) {
                      return a.compareTo(b);
                    },
                    itemSubmitted: (item) => _placeController.text = item,
                    itemBuilder: (context, suggestion) => new Padding(
                        child: new ListTile(title: new Text(suggestion)),
                        padding: EdgeInsets.all(8.0)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 0),
                    child: Text(
                      'Nhập tên bệnh viện, tên bác sĩ hoặc địa chỉ chăm khám...',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: DefaultTheme.GREY_TEXT,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Divider(
                      color: DefaultTheme.GREY_LIGHT,
                      height: 0.1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, left: 10),
                    child: Text(
                      'Ghi chú',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: DefaultTheme.BLACK_BUTTON,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    height: 150,
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
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: ButtonHDr(
                      style: BtnStyle.BUTTON_BLACK,
                      label: 'Tạo hồ sơ',
                      onTap: () {
                        if (_patientId != 0) {
                          healthRecordDTO = HealthRecordDTO(
                            patientId: _patientId,
                            diceaseIds: _diseaseIds.length <= 0
                                ? _listLv3IdSelected
                                : _diseaseIds,
                            place: _placeController.text,
                            description: _note,
                          );
                          _insertHealthRecord(healthRecordDTO);
                          // widget.refresh();
                          // Navigator.pop(context);
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
    );
  }

  _selectBoxInsOtherDissease() {
    final _itemsView = _listDisease
        .map((disease) =>
            MultiSelectItem<DiseaseDTO>(disease, disease.toString()))
        .toList();
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: DefaultTheme.GREY_VIEW),
      child: MultiSelectBottomSheetField(
        initialChildSize: 0.3,
        selectedItemsTextStyle: TextStyle(color: DefaultTheme.WHITE),
        listType: MultiSelectListType.CHIP,
        searchable: true,
        buttonText: Text(
          "Chọn mã bệnh(*)",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        title: Text(
          "Chọn mã bệnh",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        items: _itemsView,
        onConfirm: (values) {
          String _idDisease = '';
          _diseaseIds.clear();
          setState(
            () {
              _listDiseaseSelected = values;
              for (var i = 0; i < values.length; i++) {
                _idDisease = values[i].toString().split(':')[0];
                _diseaseIds.add(_idDisease);
              }
            },
          );
        },
        chipDisplay: MultiSelectChipDisplay(
          onTap: (value) {
            setState(() {
              _listDiseaseSelected.remove(value);
              _diseaseIds.remove(value.toString().split(':')[0]);
              print(
                  'DISEASE LIST SELECT WHEN REMOVE NOW: ${_listDiseaseSelected.toString()}');
            });
          },
        ),
      ),
    );
  }

  Widget _buildInheritedChipDisplay() {
    final _itemsView = _listLv3Selected
        .map((disease) =>
            MultiSelectItem<DiseaseLeverThrees>(disease, disease.toString()))
        .toList();

    List<MultiSelectItem<DiseaseLeverThrees>> chipDisplayItems = [];
    chipDisplayItems = _listLv3Selected
        .map((e) => _itemsView.firstWhere((element) => e == element.value,
            orElse: () => null))
        .toList();
    chipDisplayItems.removeWhere((element) => element == null);
    return MultiSelectChipDisplay<DiseaseLeverThrees>(
      items: chipDisplayItems,
      // colorator: widget.chipDisplay.colorator ?? widget.colorator,
      onTap: (item) {},
      chipColor: DefaultTheme.BLUE_REFERENCE,
      textStyle: TextStyle(
        color: DefaultTheme.BLACK,
      ),
    );
  }

  _selectBoxInsHeart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          color: DefaultTheme.GREY_VIEW,
          borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          InkWell(
            child: Row(
              children: [
                Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width - 90,
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chọn bệnh lý cần theo dõi (*)',
                        style: TextStyle(
                          color: DefaultTheme.BLACK,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset('assets/images/ic-dropdown.png'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              _getListDiseaseContract();
            },
          ),
          _buildInheritedChipDisplay()
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
                                                  color:
                                                      DefaultTheme.GREY_TEXT)),
                                        ),
                                        _searchDiseases(setModalState),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 20),
                                        ),
                                        Expanded(
                                          child: ListView(
                                            children: <Widget>[
                                              Column(
                                                children: (_listDiseaseForHeartForSearch
                                                                .length >
                                                            0
                                                        ? _listDiseaseForHeartForSearch
                                                        : _listDiseaseForHeart)
                                                    .map((group) {
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
                                                          padding:
                                                              EdgeInsets.only(
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
                                                                fontSize: 13,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text(
                    '${e.diseaseLevelThreeId} - ${e.diseaseLeverThreeName}',
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
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      checkColor: DefaultTheme.GRADIENT_1,
                      activeColor: DefaultTheme.GREY_VIEW,
                      hoverColor: DefaultTheme.GREY_VIEW,
                      value: checkTemp,
                      onChanged: (_) {
                        setModalState(
                          () {
                            checkTemp = !checkTemp;

                            setState(
                              () {
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
                                }
                              },
                            );
                          },
                        );
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
          if (state.listDisease.length > 0) {
            _listDisease = state.listDisease;
          }
          return _selectBoxInsOtherDissease();
        }
        if (state is DiseaseHeartListStateSuccess) {
          _listDiseaseForHeart = state.listDiseaseContract;
          return _selectBoxInsHeart();
        }
        return Container();
      },
    );
  }

  Widget _selectTypeIns() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.only(left: 20),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: DefaultTheme.GREY_VIEW),
        child: DropdownButton<String>(
          value: _valueTypeIns,
          items: _listType.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            );
          }).toList(),
          dropdownColor: DefaultTheme.GREY_VIEW,
          elevation: 1,
          hint: Container(
            width: MediaQuery.of(context).size.width - 84,
            child: Text(
              'Chọn loại bệnh để chia sẻ (*):',
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
            if (_listType[0].contains(res)) {
              _diseaseListBloc.add(DiseaseEventGetHealthList());
            } else {
              _diseaseListBloc.add(DiseaseListEventSetStatus());
            }
            setState(
              () {
                _valueTypeIns = res;
                _listDiseaseSelected = [];
                _listDisease = [];
                _diseaseIds = [];
                _listDiseaseForHeart = [];
                _listLv3Selected = [];
                _listLv3IdSelected = [];
                _listDiseaseForHeartForSearch = [];
              },
            );
          },
        ),
      ),
    );
  }

  _insertHealthRecord(HealthRecordDTO dto) {
    if (dto == null) {
      return Dialog(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: DefaultTheme.WHITE),
          child: Text('Bệnh lý rỗng.'),
        ),
      );
    }

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
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: DefaultTheme.WHITE.withOpacity(0.8)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset('assets/images/loading.gif'),
                      ),
                      Text(
                        'Đang tạo...',
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

      _healthRecordCreateBloc.add(HRCreateEventSend(dto: dto));
      Future.delayed(
        const Duration(seconds: 3),
        () {
          hrHelper.getHRResponse().then(
            (value) {
              Navigator.of(context).pop();
              if (value) {
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
                                  child: Image.asset(
                                      'assets/images/ic-checked.png'),
                                ),
                                Text(
                                  'Tạo thành công',
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
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
              } else {
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
                                  child: Image.asset(
                                      'assets/images/ic-failed.png'),
                                ),
                                Text(
                                  'Lỗi tạo hồ sơ',
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
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.of(context).pop();
                });
              }
            },
          );
        },
      );
    });
  }

  List<DiseaseContractDTO> updateSearchQueryForInsurance(
      String val, List<DiseaseContractDTO> allItems) {
    if (val != null && val.trim().isNotEmpty) {
      List<DiseaseContractDTO> filteredItems = [];
      for (var item in allItems) {
        if (item.diseaseLevelTwoId
            .toLowerCase()
            .contains(val[0].toLowerCase())) {
          var listDiseases = item.diseaseLevelTwoId.split('-');
          if (listDiseases.length > 1) {
            int num1 = int.parse(listDiseases[0].substring(1));
            int num2 = int.parse(listDiseases[1].substring(1));
            if (val.substring(1) != '') {
              if (num1 <= int.parse(val.substring(1)) &&
                  int.parse(val.substring(1)) <= num2) {
                filteredItems.add(item);
              }
            } else {
              if (item.diseaseLevelTwoId
                  .toLowerCase()
                  .contains(val.toLowerCase())) {
                filteredItems.add(item);
              }
            }
          } else {
            if (item.diseaseLevelTwoId
                .toLowerCase()
                .contains(val.toLowerCase())) {
              filteredItems.add(item);
            }
          }
        }
      }
      return filteredItems;
    } else {
      return allItems;
    }
  }

  Widget _searchDiseases(StateSetter setModalState) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: TextField(
        controller: _diseaseIDController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Tìm kiếm mã bệnh....",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        onChanged: (val) {
          setModalState(() {
            _listDiseaseForHeartForSearch =
                updateSearchQueryForInsurance(val, _listDiseaseForHeart);
          });
        },
      ),
    );
  }
}
