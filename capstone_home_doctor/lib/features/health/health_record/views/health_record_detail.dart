import 'dart:io';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/img_util.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_type_dto.dart';
import 'package:capstone_home_doctor/services/health_record_helper.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final List<MedicalInstructionTypeDTO> _listMedInsType = [
  MedicalInstructionTypeDTO(id: 1, typeName: 'Phiếu khám bệnh'),
  MedicalInstructionTypeDTO(id: 2, typeName: 'Bệnh án nội khoa'),
  MedicalInstructionTypeDTO(id: 3, typeName: 'Phiếu xét nghiệm huyết học'),
  MedicalInstructionTypeDTO(id: 4, typeName: 'Phiếu xét nghiệm hoá sinh máu'),
  MedicalInstructionTypeDTO(id: 5, typeName: 'Phiếu chụp X-Quang'),
  MedicalInstructionTypeDTO(id: 6, typeName: 'Phiếu siêu âm'),
  MedicalInstructionTypeDTO(id: 7, typeName: 'Phiếu điện tim'),
  MedicalInstructionTypeDTO(id: 8, typeName: 'Phiếu theo dõi chức năng sống'),
  MedicalInstructionTypeDTO(id: 9, typeName: 'Phiếu chăm sóc'),
  MedicalInstructionTypeDTO(id: 10, typeName: 'Hồ sơ khác'),
];

class HealthRecordDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HealthRecordDetail();
  }
}

class _HealthRecordDetail extends State<HealthRecordDetail>
    with WidgetsBindingObserver {
  //
  var _dianoseController = TextEditingController();
  var _startDateController = TextEditingController();
  var _endDateController = TextEditingController();

  HealthRecordHelper _healthRecordHelper = HealthRecordHelper();
  String _hrId = '';
  final picker = ImagePicker();
  var uuid = Uuid();

  //
  SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
  List<MedicalInstructionDTO> listMedicalIns;
  HealthRecordDTO _healthRecordDTO = HealthRecordDTO(
      contractId: 0,
      dateCreated: '',
      description: '',
      disease: '',
      doctorName: '',
      healthRecordId: 0,
      personalHealthRecordId: '',
      place: '');
  //
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    listMedicalIns = [];
    getHRId();
    refreshListMedicalIns();
    print('LENGTH OF LIST MEDINS: ${listMedicalIns.length}');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _findHealthRecordById();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Chi tiết hồ sơ',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.NONE,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                      ),
                      Container(
                        width: 125,
                        child: Text(
                          'Bệnh lý tim mạch',
                          style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - (155),
                        child: Text(
                          '${_healthRecordDTO.disease}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                      ),
                      Container(
                        width: 125,
                        child: Text(
                          'Chăm khám tại ',
                          style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - (155),
                        child: Text(
                          '${_healthRecordDTO.place}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                      ),
                      Container(
                        width: 125,
                        child: Text(
                          'Bác sĩ theo dõi',
                          style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - (155),
                        child: Text(
                          '${_healthRecordDTO.doctorName}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  (_healthRecordDTO.description != '')
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                ),
                                Container(
                                  width: 125,
                                  child: Text(
                                    'Ghi chú',
                                    style: TextStyle(
                                      color: DefaultTheme.GREY_TEXT,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - (155),
                                  child: Text(
                                    '${_healthRecordDTO.description}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                            ),
                          ],
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                  Container(
                    padding: EdgeInsets.only(left: 20, bottom: 5),
                    child: Text(
                      'Tạo ngày ${_healthRecordDTO.dateCreated?.split(' ')[0].split("-")[2]}, tháng ${_healthRecordDTO?.dateCreated.split(' ')[0].split("-")[1]}, năm ${_healthRecordDTO?.dateCreated.split(' ')[0].split("-")[0]}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: DefaultTheme.GREY_TEXT, fontSize: 13),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 30, left: 20, bottom: 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Danh sách y lệnh',
                                  style: TextStyle(
                                    color: DefaultTheme.BLACK,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 20,
                              ),
                              child: Text(
                                'Bao gồm các phiếu bệnh án/ y lệnh được thêm trước đó',
                                style: TextStyle(
                                    color: DefaultTheme.GREY_TEXT,
                                    fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ButtonHDr(
                          style: BtnStyle.BUTTON_GREY,
                          label: 'Thêm y lệnh',
                          onTap: () {
                            //
                            _showCreateMedInsForm();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  (listMedicalIns.length == 0 || listMedicalIns.isEmpty)
                      ? Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text('Không có hồ sơ nào'),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: listMedicalIns.length,
                          itemBuilder: (BuildContext buildContext, int index) {
                            String _typeName = getMedInsTypeName(
                                listMedicalIns[index].medicalInstructionTypeId);
                            // print('TYPE NAME IS $_typeName');
                            return Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: [
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        width: 0.5,
                                        height: 65,
                                        color: DefaultTheme.GREY_TEXT,
                                      ),
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color:
                                                DefaultTheme.GREY_TOP_TAB_BAR,
                                            width: 0.5,
                                          ),
                                          color: DefaultTheme.WHITE,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${listMedicalIns[index]?.dateStarted.split(' ')[0].split('-')[2]}',
                                              style: TextStyle(
                                                  color:
                                                      DefaultTheme.RED_CALENDAR,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              ' th ${listMedicalIns[index]?.dateStarted.split(' ')[0].split('-')[1]}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    DefaultTheme.BLACK_BUTTON,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 0.5,
                                        height: 65,
                                        color: DefaultTheme.GREY_TEXT,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  Expanded(
                                    child: Stack(
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 180,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 10,
                                                        color: DefaultTheme
                                                            .GREY_VIEW)
                                                  ]),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  70,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    top: 15,
                                                    bottom: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //
                                                    Text('${_typeName}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                    Text(
                                                        'Chẩn đoán: ${listMedicalIns[index]?.dianose}'),
                                                    Text(
                                                        'img decode length ${listMedicalIns[index]?.image.length}'),
                                                    Container(
                                                      width: 80,
                                                      height: 80,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: SizedBox(
                                                          width: 80,
                                                          height: 80,
                                                          child: ImageUltility
                                                              .imageFromBase64String(
                                                                  '${listMedicalIns[index]?.image}'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          width: 35,
                                          height: 35,
                                          top: 7,
                                          right: 0,
                                          child: ButtonHDr(
                                            style: BtnStyle.BUTTON_IMAGE,
                                            image: Image.asset(
                                                'assets/images/ic-more.png'),
                                            onTap: () {
                                              _showMorePopup();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showMorePopup() {
    showModalBottomSheet(
        isScrollControlled: false,
        context: this.context,
        backgroundColor: Colors.white.withOpacity(0),
        builder: (context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Container(
                      height: 270,
                      width: MediaQuery.of(context).size.width - 20,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 170,
                            decoration: BoxDecoration(
                              color: DefaultTheme.WHITE.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 30, left: 10, right: 10),
                                  child: Text(
                                    'Phiếu bệnh...',
                                    style: TextStyle(
                                        color: DefaultTheme.GREY_TEXT),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Spacer(),
                                Divider(
                                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                                  height: 0.5,
                                ),
                                ButtonHDr(
                                  label: 'Chi tiết',
                                  height: 60,
                                  labelColor: DefaultTheme.BLUE_TEXT,
                                  style: BtnStyle.BUTTON_IN_LIST,
                                  onTap: () {
                                    //
                                  },
                                ),
                                Divider(
                                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                                  height: 0.5,
                                ),
                                ButtonHDr(
                                  label: 'Xoá',
                                  height: 60,
                                  labelColor: DefaultTheme.RED_TEXT,
                                  style: BtnStyle.BUTTON_IN_LIST,
                                  onTap: () {
                                    // _sqfLiteHelper
                                    //     .deleteHealthRecord(healthRecordId);
                                    // refreshListMedicalIns();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: DefaultTheme.WHITE.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ButtonHDr(
                              label: 'Huỷ',
                              labelColor: DefaultTheme.BLUE_TEXT,
                              style: BtnStyle.BUTTON_IN_LIST,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                    ),
                  ],
                ),
              ));
        });
  }

  void _showCreateMedInsForm() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: DefaultTheme.TRANSPARENT,
        builder: (context) {
          String _imgString = '';
          String nowDate = '${DateTime.now()}';
          String _dateView = '${nowDate.split(" ")[0]}';
          String _startDate = '${nowDate}';
          String _selectedHRType = '';
          String _note = '';
          int indexSelectMedIns = 0;
          return StatefulBuilder(
              builder: (BuildContext context2, StateSetter setModalState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 600,
                    color: DefaultTheme.TRANSPARENT,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          color: DefaultTheme.TRANSPARENT,
                        ),
                        Container(
                          height: 580,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: DefaultTheme.WHITE,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 40, left: 0),
                                    child: Text(
                                      'Thêm hồ sơ',
                                      style: TextStyle(
                                        color: DefaultTheme.BLACK,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    margin: EdgeInsets.only(left: 0, top: 40),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: DefaultTheme.GREY_VIEW),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                        ),
                                        Text(
                                          'Loại hồ sơ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        ButtonHDr(
                                          label: 'Chọn',
                                          style: BtnStyle.BUTTON_FULL,
                                          image: Image.asset(
                                              'assets/images/ic-dropdown.png'),
                                          width: 30,
                                          height: 40,
                                          labelColor:
                                              DefaultTheme.BLUE_REFERENCE,
                                          bgColor: DefaultTheme.TRANSPARENT,
                                          onTap: () {
                                            showDialog(
                                                context: context2,
                                                builder:
                                                    (BuildContext context2) {
                                                  return Center(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15)),
                                                      child: BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                                sigmaX: 25,
                                                                sigmaY: 25),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              20,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.5,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: DefaultTheme
                                                                .WHITE
                                                                .withOpacity(
                                                                    0.6),
                                                          ),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            20,
                                                                            20,
                                                                            20,
                                                                            0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    'Loại hồ sơ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          25,
                                                                      color: DefaultTheme
                                                                          .BLACK,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .none,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    CupertinoPicker(
                                                                  itemExtent:
                                                                      50,
                                                                  scrollController:
                                                                      FixedExtentScrollController(
                                                                          initialItem:
                                                                              3),
                                                                  children: <
                                                                      Widget>[
                                                                    //
                                                                    for (MedicalInstructionTypeDTO hrType
                                                                        in _listMedInsType)
                                                                      Text(
                                                                        hrType
                                                                            .typeName,
                                                                      ),
                                                                  ],
                                                                  onSelectedItemChanged:
                                                                      (value) {
                                                                    setModalState(
                                                                        () {
                                                                      //
                                                                      indexSelectMedIns =
                                                                          value +
                                                                              1;
                                                                      _selectedHRType =
                                                                          _listMedInsType[value]
                                                                              .typeName;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              ButtonHDr(
                                                                style: BtnStyle
                                                                    .BUTTON_BLACK,
                                                                label: 'Chọn',
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              (_selectedHRType == '')
                                  ? Container(
                                      height: 0,
                                      width: 0,
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(top: 20, left: 0),
                                      child: Text(
                                        '${_selectedHRType}',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Divider(
                                  height: 0.1,
                                  color: DefaultTheme.GREY_LIGHT,
                                ),
                              ),
                              TextFieldHDr(
                                controller: _dianoseController,
                                style: TFStyle.NO_BORDER,
                                label: 'Chuẩn đoán',
                                keyboardAction: TextInputAction.next,
                              ),
                              Divider(
                                height: 0.1,
                                color: DefaultTheme.GREY_LIGHT,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 5),
                                      child: Text(
                                        'Ngày',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    ),
                                    (_startDate == '')
                                        ? Container()
                                        : Text(
                                            '${_dateView?.split("-")[2]}, tháng ${_dateView?.split("-")[1]}, ${_dateView.split("-")[0]}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15),
                                          ),
                                    Expanded(
                                      child: ButtonHDr(
                                        label: 'Chọn',
                                        style: BtnStyle.BUTTON_FULL,
                                        image: Image.asset(
                                            'assets/images/ic-choose-date.png'),
                                        width: 30,
                                        height: 40,
                                        labelColor: DefaultTheme.BLUE_REFERENCE,
                                        bgColor: DefaultTheme.TRANSPARENT,
                                        onTap: () {
                                          showDialog(
                                            context: context2,
                                            builder: (BuildContext context2) {
                                              return Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 25, sigmaY: 25),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              20,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.5,
                                                      decoration: BoxDecoration(
                                                        color: DefaultTheme
                                                            .WHITE
                                                            .withOpacity(0.6),
                                                      ),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(20,
                                                                    20, 20, 0),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                'Ngày',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 25,
                                                                  color:
                                                                      DefaultTheme
                                                                          .BLACK,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .none,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                CupertinoDatePicker(
                                                                    mode: CupertinoDatePickerMode
                                                                        .date,
                                                                    onDateTimeChanged:
                                                                        (dateTime) {
                                                                      setModalState(
                                                                          () {
                                                                        _dateView = dateTime
                                                                            .toString()
                                                                            .split(' ')[0];

                                                                        _startDate =
                                                                            dateTime.toString();
                                                                      });
                                                                    }),
                                                          ),
                                                          ButtonHDr(
                                                            style: BtnStyle
                                                                .BUTTON_BLACK,
                                                            label: 'Chọn',
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 0.1,
                                color: DefaultTheme.GREY_LIGHT,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 5, left: 20, top: 10),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                height: 80,
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
                                padding: EdgeInsets.only(bottom: 10),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (_imgString == '')
                                      ? InkWell(
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: DefaultTheme.TRANSPARENT,
                                              border: Border.all(
                                                color: DefaultTheme
                                                    .GREY_TOP_TAB_BAR,
                                                width: 0.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Thêm ảnh +',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: DefaultTheme
                                                        .BLUE_REFERENCE),
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            var pickedFile =
                                                await picker.getImage(
                                                    source:
                                                        ImageSource.gallery);
                                            setModalState(() {
                                              if (pickedFile != null) {
                                                _imgString =
                                                    ImageUltility.base64String(
                                                        File(pickedFile.path)
                                                            .readAsBytesSync());
                                              } else {
                                                print('No image selected.');
                                              }
                                            });
                                          },
                                        )
                                      : Container(),
                                  (_imgString == '')
                                      ? Container()
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: SizedBox(
                                              width: 120,
                                              height: 120,
                                              child: ImageUltility
                                                  .imageFromBase64String(
                                                      _imgString)),
                                        ),
                                ],
                              ),
                              Spacer(),
                              ButtonHDr(
                                width: MediaQuery.of(context).size.width - 40,
                                style: BtnStyle.BUTTON_BLACK,
                                label: 'Tạo hồ sơ',
                                onTap: () {
                                  // _insertHealthRecord();
                                  // widget.refresh();
                                  MedicalInstructionDTO medInsDTO =
                                      MedicalInstructionDTO(
                                    medicalIntructionId: '${uuid.v1()}',
                                    description: '${_note}',
                                    dateStarted: '${_startDate}',
                                    dateFinished: '${_startDate}',
                                    dianose: '${_dianoseController.text}',
                                    healthRecordId:
                                        '${_healthRecordDTO.healthRecordId}',
                                    image: '${_imgString}',
                                    medicalInstructionTypeId:
                                        '${indexSelectMedIns.toString()}',
                                  );
                                  // print('${uuid.v1()}');
                                  // print('${_note}');
                                  // print('${_startDate}');

                                  // print('${_dianoseController.text}');
                                  print(
                                      'HR ID when prepare submit is ${_healthRecordDTO.healthRecordId}');
                                  print('${_imgString.length}');
                                  print(
                                      'INDEX SELECTED IS ALSO ID TYPE ${indexSelectMedIns.toString()}');

                                  _insertMedicalInstruction(medInsDTO);
                                  refreshListMedicalIns();
                                  Navigator.pop(context);
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 25),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
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
          });
        });
  }

  getHRId() async {
    await _healthRecordHelper.getHRId().then((value) {
      print('HR ID IN SHARED_PR ${value}');
      setState(() {
        _hrId = value;
      });
    });
  }

  String getMedInsTypeName(String id) {
    String result = "";
    for (MedicalInstructionTypeDTO i in _listMedInsType) {
      if (id.trim() == i.id.toString()) {
        result = i.typeName;
      }
    }
    return result;
  }

  _findHealthRecordById() async {
    Map<String, Object> arguments = ModalRoute.of(context).settings.arguments;
    String _healthRecordId = arguments['HR_ID'];
    //_healthRecordDTO = _sqfLiteHelper.findHealthRecordById(_healthRecordId);
    await _sqfLiteHelper.findHealthRecordById(_hrId).then((value) {
      setState(() {
        _healthRecordDTO = value;
      });
    });
  }

  _insertMedicalInstruction(MedicalInstructionDTO dto) async {
    _sqfLiteHelper.insertMedicalIns(dto);
  }

  refreshListMedicalIns() async {
    String id = '';
    await _healthRecordHelper.getHRId().then((value) {
      setState(() {
        id = value;
      });
    });
    await _sqfLiteHelper.getListMedicalIns(id).then((values) {
      setState(() {
        listMedicalIns.clear();
        listMedicalIns.addAll(values);
        print(listMedicalIns);
      });
    });
  }
}
