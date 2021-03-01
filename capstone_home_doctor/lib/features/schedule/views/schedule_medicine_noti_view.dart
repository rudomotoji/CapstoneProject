// import 'package:capstone_home_doctor/commons/constants/theme.dart';
// import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
// import 'package:capstone_home_doctor/models/medicine_scheduling_dto.dart';
// import 'package:capstone_home_doctor/models/prescription_dto.dart';
// import 'package:flutter/material.dart';

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

// class ScheduleMedNotiView extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _ScheduleMedNotiView();
//   }
// }

// class _ScheduleMedNotiView extends State<ScheduleMedNotiView>
//     with WidgetsBindingObserver {
//   PrescriptionDTO _currentPrescription = PrescriptionDTO();
//   @override
//   Widget build(BuildContext context) {
//     _listPrescription.sort((a, b) => b.startDate.compareTo(a.startDate));
//     _currentPrescription = _listPrescription[0];
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             HeaderWidget(
//               title: 'Dùng thuốc',
//               isMainView: false,
//             ),
//             Expanded(
//               child: ListView.builder(
//                   itemCount: _currentPrescription.listMedicine.length,
//                   itemBuilder: (BuildContext buildContext, int index) {
//                     return Container(
//                       color: DefaultTheme.GREY_VIEW,
//                       child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             (_currentPrescription.listMedicine[index].noon == 0)
//                                 ? Container(
//                                     width: 0,
//                                     height: 0,
//                                   )
//                                 : Container(
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                             '${_currentPrescription.listMedicine[index].medicationName}'),
//                                         Text(
//                                             '${_currentPrescription.listMedicine[index].noon} ${_currentPrescription.listMedicine[index].unit}'),
//                                       ],
//                                     ),
//                                   ),
//                           ]),
//                     );
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
