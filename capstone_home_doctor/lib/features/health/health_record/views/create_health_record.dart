import 'dart:ui';

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

  HealthRecordDTO healthRecordDTO;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _getPatientId();
    _healthRecordCreateBloc = BlocProvider.of(context);
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
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: 5, left: 10),
                      //   child: Text(
                      //     'Bệnh lý tim mạch',
                      //     textAlign: TextAlign.start,
                      //     style: TextStyle(
                      //         color: DefaultTheme.BLACK_BUTTON,
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 16),
                      //   ),
                      // ),
                      // TextFieldHDr(
                      //   controller: _diseaseController,
                      //   style: TFStyle.BORDERED,
                      //   keyboardAction: TextInputAction.next,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 10, right: 20),
                      //   child: Text(
                      //     'Nhập tên bệnh lý đã/ đang theo dõi',
                      //     textAlign: TextAlign.start,
                      //     style: TextStyle(
                      //         color: DefaultTheme.GREY_TEXT,
                      //         fontWeight: FontWeight.w400,
                      //         fontSize: 12),
                      //   ),
                      // ),
                      //
                      //
                      //
                      BlocProvider(
                          create: (context2) => DiseaseListBloc(
                              diseaseRepository: diseaseRepository)
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
                                      child: Image.asset(
                                          'assets/images/loading.gif'),
                                    ),
                                  ),
                                );
                              }
                              if (state2 is DiseaseListStateFailure) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 10, top: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
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
                              if (state2 is DiseaseListStateSuccess) {
                                if (state2.listDisease == null) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        bottom: 10,
                                        top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
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
                                _listDisease = state2.listDisease;
                              }
                              final _itemsView = _listDisease
                                  .map((disease) => MultiSelectItem<DiseaseDTO>(
                                      disease, disease.toString()))
                                  .toList();
                              return Container(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20, right: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: DefaultTheme.GREY_VIEW),
                                child: MultiSelectBottomSheetField(
                                  initialChildSize: 0.3,
                                  selectedItemsTextStyle:
                                      TextStyle(color: DefaultTheme.WHITE),
                                  listType: MultiSelectListType.CHIP,
                                  searchable: true,
                                  buttonText: Text(
                                    "Bệnh lý tim mạch(*)",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  title: Text(
                                    "Chọn các bệnh lý",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                  items: _itemsView,
                                  onConfirm: (values) {
                                    String _idDisease = '';
                                    _diseaseIds.clear();
                                    setState(() {
                                      _listDiseaseSelected = values;
                                      for (var i = 0; i < values.length; i++) {
                                        _idDisease =
                                            values[i].toString().split(':')[0];
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
                                        _diseaseIds.remove(
                                            value.toString().split(':')[0]);
                                        print(
                                            'DISEASE LIST SELECT WHEN REMOVE NOW: ${_listDiseaseSelected.toString()}');
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          )),
                      //
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, left: 10, right: 20),
                          child: Text(
                            'Chọn chính xác bệnh lý tim mạch giúp bác sĩ xem xét sự khả quan trong vấn đề xét duyệt.',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),

                      //
                      //
                      //
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
                          'Nơi khám',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: DefaultTheme.BLACK_BUTTON,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                      TextFieldHDr(
                        controller: _placeController,
                        style: TFStyle.BORDERED,
                        keyboardAction: TextInputAction.next,
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
                                  widget.refresh();
                                  Navigator.pop(context);
                                }
                              })),
                    ]),
              ),
            ]),
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
      ;
    });
/////////////////////////
/////
    // //this is for sucessful Insert
    // Timer timer = Timer(Duration(milliseconds: 10000), () {
    //   Navigator.of(context, rootNavigator: true).pop();
    // });
    // showDialog(
    //     //
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Center(
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.all(Radius.circular(5)),
    //           child: BackdropFilter(
    //             filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
    //             child: Container(
    //               width: 200,
    //               height: 200,
    //               decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(10),
    //                   color: DefaultTheme.WHITE.withOpacity(0.8)),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   SizedBox(
    //                     width: 100,
    //                     height: 100,
    //                     child: Image.asset('assets/images/loading.gif'),
    //                   ),
    //                   Text(
    //                     'Đang tạo...',
    //                     style: TextStyle(
    //                         color: DefaultTheme.GREY_TEXT,
    //                         fontSize: 15,
    //                         fontWeight: FontWeight.w400,
    //                         decoration: TextDecoration.none),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     }).then((value) {
    //   print('OK');
    //   // dispose the timer in case something else has triggered the dismiss.
    //   widget.refresh();
    //   Navigator.pop(context);
    //   timer?.cancel();
    //   timer = null;
    // });

    //
  }

  // _insertHealthRecord() {
  //   healthRecordDTO = HealthRecordDTO(
  //     healthRecordId: '${uuid.v1()}',
  //     dateCreated: '${DateTime.now()}',
  //     personalHealthRecordId: '1',
  //     contractId: null,
  //     doctorName: _doctorNameController.text,
  //     description: _note,
  //     disease: _diseaseController.text,
  //     place: _placeController.text,
  //   );
  //   _sqfLiteHelper.insertHealthRecord(healthRecordDTO);
  // }
}
