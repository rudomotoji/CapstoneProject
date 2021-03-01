// import 'package:capstone_home_doctor/commons/constants/theme.dart';
// import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';
// import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
// import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
// import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
// import 'package:capstone_home_doctor/models/medicine_scheduling_dto.dart';
// import 'package:capstone_home_doctor/models/prescription_dto.dart';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// final DateFormat format = DateFormat("yyyy-MM-dd");
// final DateValidator _dateValidator = DateValidator();
// ArrayValidator _arrayValidator = ArrayValidator();

// final List<PrescriptionDTO> _listPrescription = [
//   PrescriptionDTO(
//     diagnose: 'Đau đầu, tim đập nhanh, khó thở',
//     healthRecordId: '1',
//     startDate: '2021-02-24',
//     endDate: '2021-03-03',
//     listMedicine: _listMedicine1,
//   ),
//   PrescriptionDTO(
//     diagnose: 'Đau đầu, tim đập nhanh, khó thở',
//     healthRecordId: '1',
//     startDate: '2021-02-16',
//     endDate: '2021-02-23',
//     listMedicine: _listMedicine2,
//   ),
//   PrescriptionDTO(
//     diagnose: 'Đau đầu, tim đập nhanh, khó thở',
//     healthRecordId: '1',
//     startDate: '2021-02-08',
//     endDate: '2021-03-15',
//     listMedicine: _listMedicine3,
//   ),
// ];

// final List<MedicineDTO> _listMedicine1 = [
//   MedicineDTO(
//     medicationName: 'Cefadroxil',
//     content: '10 mg',
//     description: 'mô tả số 1. Mô tả số 1. Mô tả số 1.',
//     afternoon: 0,
//     morning: 2,
//     night: 2,
//     noon: 2,
//     unit: 'viên',
//     useTime: 'Trước bữa ăn',
//   ),
//   MedicineDTO(
//     medicationName: 'Medicine2',
//     content: '20 mg',
//     description: 'mô tả số 12. Mô tả số 2. Mô tả số 2.',
//     afternoon: 0,
//     morning: 4,
//     night: 4,
//     noon: 2,
//     unit: 'viên',
//     useTime: 'Sau bữa ăn',
//   ),
//   MedicineDTO(
//     medicationName: 'Medicine3',
//     content: '24 mg',
//     description: 'mô tả số 4. Mô tả số 3. Mô tả số 3.',
//     afternoon: 0,
//     morning: 2,
//     night: 2,
//     noon: 0,
//     unit: 'viên',
//     useTime: 'Sau bữa ăn',
//   ),
//   MedicineDTO(
//     medicationName: 'Medicine4',
//     content: '10 mg',
//     description: 'mô tả số 4. Mô tả số 4. Mô tả số 4.',
//     afternoon: 0,
//     morning: 2,
//     night: 2,
//     noon: 2,
//     unit: 'viên',
//     useTime: 'Trước bữa ăn',
//   ),
//   MedicineDTO(
//     medicationName: 'Medicine5',
//     content: '10 mg',
//     description: 'mô tả số 5. Mô tả số 4. Mô tả số 5.',
//     afternoon: 0,
//     morning: 4,
//     night: 0,
//     noon: 2,
//     unit: 'viên',
//     useTime: 'Trước bữa ăn',
//   ),
// ];
// final List<MedicineDTO> _listMedicine2 = [
//   MedicineDTO(
//     medicationName: 'Cefadroxil222',
//     content: '10 mg',
//     description: 'mô tả số 1. Mô tả số 1. Mô tả số 1.',
//     afternoon: 0,
//     morning: 2,
//     night: 2,
//     noon: 2,
//     unit: 'viên',
//     useTime: 'Trước bữa ăn',
//   ),
//   MedicineDTO(
//     medicationName: 'Medicine233',
//     content: '20 mg',
//     description: 'mô tả số 12. Mô tả số 2. Mô tả số 2.',
//     afternoon: 0,
//     morning: 4,
//     night: 4,
//     noon: 2,
//     unit: 'viên',
//     useTime: 'Sau bữa ăn',
//   ),
//   MedicineDTO(
//     medicationName: 'Medicine344',
//     content: '10 mg',
//     description: 'mô tả số 4. Mô tả số 3. Mô tả số 3.',
//     afternoon: 0,
//     morning: 2,
//     night: 2,
//     noon: 0,
//     unit: 'viên',
//     useTime: 'Sau bữa ăn',
//   ),
//   MedicineDTO(
//     medicationName: 'Medicine455',
//     content: '10 mg',
//     description: 'mô tả số 4. Mô tả số 4. Mô tả số 4.',
//     afternoon: 0,
//     morning: 2,
//     night: 2,
//     noon: 2,
//     unit: 'viên',
//     useTime: 'Trước bữa ăn',
//   ),
//   MedicineDTO(
//     medicationName: 'Medicine566',
//     content: '40 mg',
//     description: 'mô tả số 5. Mô tả số 4. Mô tả số 5.',
//     afternoon: 0,
//     morning: 4,
//     night: 0,
//     noon: 2,
//     unit: 'viên',
//     useTime: 'Trước bữa ăn',
//   ),
// ];
// final List<MedicineDTO> _listMedicine3 = [
//   MedicineDTO(
//     medicationName: 'Cefadroxil666',
//     content: '30 mg',
//     description: 'mô tả số 1. Mô tả số 1. Mô tả số 1.',
//     afternoon: 0,
//     morning: 2,
//     night: 2,
//     noon: 2,
//     unit: 'viên',
//     useTime: 'Trước bữa ăn',
//   ),
//   MedicineDTO(
//     medicationName: 'Medicine2666',
//     content: '20 mg',
//     description: 'mô tả số 12. Mô tả số 2. Mô tả số 2.',
//     afternoon: 0,
//     morning: 4,
//     night: 4,
//     noon: 2,
//     unit: 'viên',
//     useTime: 'Sau bữa ăn',
//   ),
//   MedicineDTO(
//     medicationName: 'Medicine344',
//     content: '10 mg',
//     description: 'mô tả số 4. Mô tả số 3. Mô tả số 3.',
//     afternoon: 0,
//     morning: 2,
//     night: 2,
//     noon: 0,
//     unit: 'viên',
//     useTime: 'Sau bữa ăn',
//   ),
//   MedicineDTO(
//     medicationName: 'Medicine456',
//     content: '30 mg',
//     description: 'mô tả số 4. Mô tả số 4. Mô tả số 4.',
//     afternoon: 0,
//     morning: 2,
//     night: 2,
//     noon: 2,
//     unit: 'viên',
//     useTime: 'Trước bữa ăn',
//   ),
//   MedicineDTO(
//     medicationName: 'Medicine5523',
//     content: '20 mg',
//     description: 'mô tả số 5. Mô tả số 4. Mô tả số 5.',
//     afternoon: 0,
//     morning: 4,
//     night: 0,
//     noon: 2,
//     unit: 'viên',
//     useTime: 'Trước bữa ăn',
//   ),
// ];

// class MedicineHistory extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _MedicineHistory();
//   }
// }

// class _MedicineHistory extends State<MedicineHistory>
//     with WidgetsBindingObserver {
//   @override
//   Widget build(BuildContext context) {
//     // _listPrescription.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             HeaderWidget(
//               title: 'Lịch sử đơn thuốc',
//               isMainView: false,
//               buttonHeaderType: ButtonHeaderType.NONE,
//             ),
//             Expanded(
//               child: ListView.builder(
//                   itemCount: _listPrescription.length,
//                   itemBuilder: (BuildContext buildContext, int index) {
//                     return Container(
//                       padding: EdgeInsets.only(left: 20, right: 20),
//                       child: Row(
//                         children: <Widget>[
//                           Column(
//                             children: <Widget>[
//                               //line
//                               Container(
//                                 width: 0.5,
//                                 height: 95,
//                                 color: DefaultTheme.GREY_TEXT,
//                               ),
//                               //icon in line
//                               SizedBox(
//                                 width: 15,
//                                 height: 15,
//                                 child: Image.asset('assets/images/ic-dot.png'),
//                               ),
//                               Container(
//                                 width: 0.5,
//                                 height: 95,
//                                 color: DefaultTheme.GREY_TEXT,
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(left: 10),
//                           ),
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.only(top: 20),
//                                 ),
//                                 Container(
//                                   height: 170,
//                                   padding: EdgeInsets.only(top: 5),
//                                   decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: DefaultTheme.GREY_TOP_TAB_BAR,
//                                         width: 0.5,
//                                       ),
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(5),
//                                       boxShadow: [
//                                         BoxShadow(
//                                             blurRadius: 10,
//                                             color: DefaultTheme.GREY_VIEW)
//                                       ]),
//                                   width: MediaQuery.of(context).size.width - 70,
//                                   child: Padding(
//                                     padding: EdgeInsets.only(left: 10, top: 10),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Container(
//                                           child: Text(
//                                             'ĐƠN THUỐC ',
//                                             style: TextStyle(
//                                               color: DefaultTheme.BLACK_BUTTON,
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.w400,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.only(top: 5),
//                                         ),
//                                         Container(
//                                           child: Text(
//                                             'Chẩn đoán: ${_listPrescription[index].diagnose}',
//                                             style: TextStyle(
//                                               color: DefaultTheme.BLACK_BUTTON,
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.w400,
//                                             ),
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 3,
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.only(top: 10),
//                                         ),
//                                         Container(
//                                           height: 15,
//                                           child: Text(
//                                             'Ngày kê đơn: ${_dateValidator.parseToDateView(_listPrescription[index].startDate)}',
//                                             style: TextStyle(
//                                                 color: DefaultTheme.GREY_TEXT,
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                         ),
//                                         Container(
//                                           height: 15,
//                                           child: Text(
//                                             'Đến ngày: ${_dateValidator.parseToDateView(_listPrescription[index].endDate)}',
//                                             style: TextStyle(
//                                                 color: DefaultTheme.GREY_TEXT,
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         Divider(
//                                           height: 1,
//                                           color: DefaultTheme.GREY_TOP_TAB_BAR,
//                                         ),
//                                         ButtonHDr(
//                                           style: BtnStyle.BUTTON_IN_LIST,
//                                           label: 'Chi Tiết',
//                                           labelColor: DefaultTheme.BLACK_BUTTON
//                                               .withOpacity(0.8),
//                                           height: 40,
//                                           onTap: () {},
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   _showDetailPrescription(String healthRecordId) {
//     //
//   }
// }
