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
                title: 'Thêm bệnh lý',
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
                                _insertHealthRecord();
                                widget.refresh();
                                Navigator.pop(context);
                              })),
                    ]),
              ),
            ]),
      ),
    );
  }

  _insertHealthRecord() {
    healthRecordDTO = HealthRecordDTO(
      healthRecordId: '${uuid.v1()}',
      dateCreated: '${DateTime.now()}',
      personalHealthRecordId: '1',
      contractId: null,
      doctorName: _doctorNameController.text,
      description: _note,
      disease: _diseaseController.text,
      place: _placeController.text,
    );
    _sqfLiteHelper.insertHealthRecord(healthRecordDTO);
  }
}
//   DateValidator _dateValidator = DateValidator();
//   SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
//   String _selectedHRType = '';
//   String _tmp = '';
//   String _imgString = '';
//   final picker = ImagePicker();
//   var uuid = Uuid();
//   UniqueKey key;
//   HealthRecordDTO hrDTO = HealthRecordDTO(
//       id: '',
//       diseaseType: '',
//       patientId: 2,
//       imgage: '',
//       createdDate: '${DateTime.now()}',
//       updatedDate: '${DateTime.now()}');
//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.addObserver(this);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             HeaderWidget(
//               title: 'Thêm bệnh lý',
//               isMainView: false,
//               buttonHeaderType: ButtonHeaderType.NONE,
//             ),
//             Expanded(
//               child: ListView(
//                 padding: EdgeInsets.only(left: 20, right: 20),
//                 children: <Widget>[
//                   //
//                   Padding(
//                     padding: EdgeInsets.only(top: 30),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(6),
//                           color: DefaultTheme.GREY_BUTTON),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Padding(
//                             padding: EdgeInsets.only(left: 20),
//                           ),
//                           Text(
//                             'Loại hồ sơ',
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.w400),
//                           ),
//                           Spacer(),
//                           ButtonHDr(
//                             label: 'Chọn',
//                             style: BtnStyle.BUTTON_FULL,
//                             image: Image.asset('assets/images/ic-dropdown.png'),
//                             width: 30,
//                             height: 40,
//                             labelColor: DefaultTheme.BLUE_REFERENCE,
//                             bgColor: DefaultTheme.TRANSPARENT,
//                             onTap: () {
//                               _openListHRType();
//                             },
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(right: 10),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   (_selectedHRType == '')
//                       ? Container(
//                           height: 0,
//                           width: 0,
//                         )
//                       : Container(
//                           margin: EdgeInsets.only(top: 20, left: 10),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 '${_selectedHRType}',
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.w500),
//                               ),
//                               Text(
//                                 'Ngày tạo: ${_dateValidator.getDateTimeView()}',
//                                 style: TextStyle(
//                                     color: DefaultTheme.GREY_TEXT,
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 13),
//                               ),
//                             ],
//                           ),
//                         ),
//                   Padding(
//                     padding: EdgeInsets.only(top: 20),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       (_imgString == '')
//                           ? InkWell(
//                               child: Container(
//                                 width: 100,
//                                 height: 100,
//                                 decoration: BoxDecoration(
//                                   color: DefaultTheme.TRANSPARENT,
//                                   border: Border.all(
//                                     color: DefaultTheme.GREY_TOP_TAB_BAR,
//                                     width: 0.5,
//                                   ),
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     'Thêm ảnh +',
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         color: DefaultTheme.BLUE_REFERENCE),
//                                   ),
//                                 ),
//                               ),
//                               onTap: pickImageFromGallery,
//                             )
//                           : Container(),
//                       (_imgString == '')
//                           ? Container()
//                           : ClipRRect(
//                               borderRadius: BorderRadius.circular(15),
//                               child: SizedBox(
//                                   width: 200,
//                                   height: 200,
//                                   child: ImageUltility.imageFromBase64String(
//                                       _imgString)),
//                             ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             ButtonHDr(
//               style: BtnStyle.BUTTON_BLACK,
//               label: 'Tạo hồ sơ',
//               onTap: () {
//                 hrDTO = HealthRecordDTO(
//                     id: '${uuid.v1()}',
//                     diseaseType: _selectedHRType,
//                     imgage: _imgString,
//                     createdDate: '${DateTime.now()}',
//                     patientId: 2,
//                     updatedDate: '${DateTime.now()}');
//                 _sqfLiteHelper.saveHR(hrDTO);
//                 print('IMG STRING IS ${hrDTO.imgage}');
//                 print('DATE TIME NOW  IS ${hrDTO.createdDate}');
//                 print('UNIQUE KEY NOW ${uuid.v1()}');
//                 // _sqfLiteHelper.deleteHR(0);
//                 Navigator.pushNamedAndRemoveUntil(context, RoutesHDr.MAIN_HOME,
//                     (Route<dynamic> route) => false);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future pickImageFromGallery() async {
//     var pickedFile = await picker.getImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _imgString =
//             ImageUltility.base64String(File(pickedFile.path).readAsBytesSync());
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   _openListHRType() {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Center(
//             child: ClipRRect(
//               borderRadius: BorderRadius.all(Radius.circular(15)),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
//                 child: Container(
//                   padding: EdgeInsets.all(10),
//                   width: MediaQuery.of(context).size.width - 20,
//                   height: MediaQuery.of(context).size.height * 0.5,
//                   decoration: BoxDecoration(
//                     color: DefaultTheme.WHITE.withOpacity(0.6),
//                   ),
//                   child: Column(
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Theo dõi liên tục',
//                             style: TextStyle(
//                               fontSize: 25,
//                               color: DefaultTheme.BLACK,
//                               decoration: TextDecoration.none,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: CupertinoPicker(
//                           itemExtent: 50,
//                           scrollController:
//                               FixedExtentScrollController(initialItem: 3),
//                           children: <Widget>[
//                             //
//                             for (HRTypeDTO hrType in _listHealthRecordType)
//                               Text(
//                                 hrType.typeName,
//                               ),
//                           ],
//                           onSelectedItemChanged: (value) {
//                             setState(() {
//                               setState(() {
//                                 _selectedHRType =
//                                     _listHealthRecordType[value].typeName;
//                               });
//                             });
//                           },
//                         ),
//                       ),
//                       ButtonHDr(
//                         style: BtnStyle.BUTTON_BLACK,
//                         label: 'Chọn',
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
