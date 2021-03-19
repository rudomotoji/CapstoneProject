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
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_with_type_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/hr_create_event.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

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
  //
  //
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
  //var _doctorNameController = TextEditingController();
  var _diseaseController = TextEditingController();
  String _note = '';
  List<DiseaseDTO> _listDisease = [];
  List<DiseaseDTO> _listDiseaseSelected = [];
  List<String> _diseaseIds = [];
  DiseaseListBloc _diseaseListBloc;

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
                        itemFilter: (suggestion, input) => suggestion
                            .toLowerCase()
                            .contains(input.toLowerCase()),
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
                              onTap: () async {
                                // print('\n\n\nLIST DISEASE ID: ${_diseaseIds}');
                                if (_patientId != 0) {
                                  healthRecordDTO = HealthRecordDTO(
                                    patientId: _patientId,
                                    diceaseIds: _diseaseIds,
                                    place: _placeController.text,
                                    description: _note,
                                  );
                                  await _insertHealthRecord(healthRecordDTO);
                                  // widget.refresh();
                                  Navigator.pop(context);
                                }
                              })),
                    ]),
              ),
            ]),
      ),
    );
  }

  _selectBoxIns() {
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
          setState(() {
            _listDiseaseSelected = values;
            for (var i = 0; i < values.length; i++) {
              _idDisease = values[i].toString().split(':')[0];
              _diseaseIds.add(_idDisease);
            }
          });
          //  print('VALUES: ${values.toString()}');

          print('LIST ID DISEASE NOW ${_diseaseIds}');
          print(
              'LIST DISEASE SELECTED WHEN CHOOSE NOW ${_listDiseaseSelected}');
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
          return _selectBoxIns();
        }
        if (state is DiseaseHeartListStateSuccess) {
          if (state.listDisease.length > 0) {
            _listDisease = state.listDisease;
          }
          return _selectBoxIns();
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
              },
            );
          },
        ),
      ),
    );
  }

  _insertHealthRecord(HealthRecordDTO dto) async {
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
    await _healthRecordCreateBloc.add(HRCreateEventSend(dto: dto));
    return BlocBuilder<HealthRecordCreateBloc, HRCreateState>(
      builder: (context, state) {
        //
        if (state is HRCreateStateLoading) {
          showDialog(
              //
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
              });
        }
        if (state is HRCreateStateFailure) {
          Navigator.of(context).pop();
          showDialog(
              //
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
              });
        }
        if (state is HRCreateStateSuccess) {
          widget.refresh();
          Navigator.pop(context);
        }
        //FOR FAILED TO OTHER STATE

        return Dialog(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: DefaultTheme.WHITE),
            child: Text('Không thể tạo hồ sơ'),
          ),
        );
      },
    );
  }
}
