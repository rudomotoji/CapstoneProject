// final List<HRTypeDTO> _listHealthRecordType = [
//   HRTypeDTO(id: 1, typeName: 'Phiếu khám bệnh'),
//   HRTypeDTO(id: 2, typeName: 'Bệnh án nội khoa'),
//   HRTypeDTO(id: 3, typeName: 'Phiếu xét nghiệm huyết học'),
//   HRTypeDTO(id: 4, typeName: 'Phiếu xét nghiệm hoá sinh máu'),
//   HRTypeDTO(id: 5, typeName: 'Phiếu chụp X-Quang'),
//   HRTypeDTO(id: 6, typeName: 'Phiếu siêu âm'),
//   HRTypeDTO(id: 7, typeName: 'Phiếu điện tim'),
//   HRTypeDTO(id: 8, typeName: 'Phiếu theo dõi chức năng sống'),
//   HRTypeDTO(id: 9, typeName: 'Phiếu chăm sóc'),
//   HRTypeDTO(id: 10, typeName: 'Hồ sơ khác'),
// ];

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
  SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
  DateValidator _dateValidator = DateValidator();
  var _placeController = TextEditingController();
  var _doctorNameController = TextEditingController();
  var _diseaseController = TextEditingController();
  String _note = '';
  var uuid = Uuid();
  HealthRecordDTO healthRecordDTO;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
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
                      Padding(
                        padding: EdgeInsets.only(bottom: 5, left: 10),
                        child: Text(
                          'Bệnh lý tim mạch',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: DefaultTheme.BLACK_BUTTON,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                      TextFieldHDr(
                        controller: _diseaseController,
                        style: TFStyle.BORDERED,
                        keyboardAction: TextInputAction.next,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 20),
                        child: Text(
                          'Nhập tên bệnh lý đã/ đang theo dõi',
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
                        padding: EdgeInsets.only(left: 10, right: 20),
                        child: Text(
                          'Nhập tên bệnh viện hoặc địa chỉ chăm khám...',
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
                          'Bác sĩ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: DefaultTheme.BLACK_BUTTON,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                      TextFieldHDr(
                        controller: _doctorNameController,
                        style: TFStyle.BORDERED,
                        keyboardAction: TextInputAction.next,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 20),
                        child: Text(
                          'Nhập họ tên bác sĩ chăm khám.',
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
                              onTap: () {
                                //_insertHealthRecord();
                                // widget.refresh();
                                Navigator.pop(context);
                              })),
                    ]),
              ),
            ]),
      ),
    );
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
