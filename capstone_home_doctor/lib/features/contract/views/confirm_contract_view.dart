// import 'dart:ui';

// import 'package:capstone_home_doctor/commons/constants/theme.dart';
// import 'package:capstone_home_doctor/commons/routes/routes.dart';
// import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
// import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
// import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
// import 'package:capstone_home_doctor/features/contract/blocs/contract_request_bloc.dart';
// import 'package:capstone_home_doctor/features/contract/events/contract_request_event.dart';

// import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
// import 'package:capstone_home_doctor/features/contract/states/contract_request_state.dart';
// import 'package:capstone_home_doctor/models/disease_dto.dart';
// import 'package:capstone_home_doctor/models/req_contract_dto.dart';
// import 'package:capstone_home_doctor/services/authen_helper.dart';
// import 'package:capstone_home_doctor/services/contract_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:capstone_home_doctor/features/contract/views/request_contract_view.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// //
// // final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
// final ContractHelper _contractHelper = ContractHelper();

// class ConfirmContract extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _ConfirmContract();
//   }
// }

// class _ConfirmContract extends State<ConfirmContract>
//     with WidgetsBindingObserver {
//   ContractRepository requestContractRepository =
//       ContractRepository(httpClient: http.Client());
//   RequestContractBloc _requestContractBloc;

//   DateValidator _dateValidator = DateValidator();
//   String _currentDate = DateTime.now().toString().split(' ')[0];
//   String _dateInWeek = DateFormat('EEEE').format(DateTime.now());
//   //
//   // int _patientId = 0;

//   //
//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//     // _getPatientId();
//     _requestContractBloc = BlocProvider.of(context);
//   }

//   // _getPatientId() async {
//   //   await _authenticateHelper.getPatientId().then((value) {
//   //     setState(() {
//   //       _patientId = value;
//   //     });
//   //   });
//   // }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.addObserver(this);
//     super.dispose();
//   }

//   //
//   bool _isAccept = false;

//   _updateAcceptState() {
//     setState(() {
//       _isAccept = !_isAccept;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Map<String, Object> arguments = ModalRoute.of(context).settings.arguments;
//     RequestContractDTO _requestContract = arguments['REQUEST_OBJ'];
//     ContractViewObj _componentViews = arguments['VIEWS_OBJ'];
//     print(
//         'request Contract, medicalins list: ${_requestContract.diseases.toString()}\n${_requestContract.dateStarted}\n${_requestContract.doctorId}\n${_requestContract.note}\n${_requestContract.patientId}');
//     return Scaffold(
//         body: SafeArea(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           HeaderWidget(
//             title: 'Xác nhận',
//             isMainView: false,
//             buttonHeaderType: ButtonHeaderType.BACK_HOME,
//           ),
//           Expanded(
//             child: ListView(children: <Widget>[
//               //
//               Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: DefaultTheme.GREY_VIEW),
//                 margin:
//                     EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
//                 padding: EdgeInsets.only(top: 30, bottom: 30),
//                 width: MediaQuery.of(context).size.width - 20,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.only(left: 0, right: 0),
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Text(
//                           'CỘNG HOÀ XÃ HỘI CHỦ NGHĨA VIỆT NAM',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w600),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Text(
//                           'Độc lập - Tự do - Hạnh phúc',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 10, right: 10),
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Text(
//                           'HỢP ĐỒNG KHÁM CHỮA BỆNH',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               fontSize: 20,
//                               fontFamily: 'NewYork'),
//                         ),
//                       ),
//                     ),
//                     // Padding(
//                     //   padding: EdgeInsets.only(top: 10, left: 20, right: 20),
//                     //   child: Align(
//                     //     alignment: Alignment.centerRight,
//                     //     child: Text(
//                     //       '${_dateValidator.parseDateInWeekToView(_dateInWeek)}, ngày ${_dateValidator.parseToDateView(_currentDate)}',
//                     //       style: TextStyle(
//                     //           color: DefaultTheme.GREY_TEXT,
//                     //           fontSize: 15,
//                     //           fontFamily: 'NewYork'),
//                     //     ),
//                     //   ),
//                     // ),
//                     Padding(
//                       padding: EdgeInsets.only(top: 20, left: 20, right: 20),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           //
//                           Text(
//                             '- Căn cứ Bộ luật Dân sự ngày 14 tháng 6 năm 2005;',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: DefaultTheme.BLACK,
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(bottom: 5),
//                           ),
//                           Text(
//                             '- Căn cứ Luật khám bệnh, chữa bệnh ngày 23 tháng 11 năm 2009;',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: DefaultTheme.BLACK,
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(bottom: 5),
//                           ),
//                           Text(
//                             '- Căn cứ Nghị định số 87/2011/NĐ-CP ngày 27 tháng 9 năm 2011 của Chính phủ quy định chi tiết và hướng dẫn thi hành một số điều của Luật khám bệnh, chữa bệnh;',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: DefaultTheme.BLACK,
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(bottom: 20),
//                           ),
//                           Text(
//                             'Hôm nay ngày ${_dateValidator.parseToDateView2(_currentDate)}.\nChúng tôi gồm có:',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: DefaultTheme.BLACK,
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     ///
//                     ///
//                     ///
//                     ///
//                     Padding(
//                       padding: EdgeInsets.only(
//                           left: 20, right: 20, bottom: 20, top: 30),
//                       child: Text(
//                         'Bên A: ${_componentViews.pname} (Bệnh nhân)',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18,
//                             fontFamily: 'NewYork'),
//                       ),
//                     ),

//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(left: 20),
//                           width: 130,
//                           child: Text(
//                             'ĐC thường trú:',
//                             style: TextStyle(
//                                 color: DefaultTheme.GREY_TEXT,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: 10),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width -
//                               (40 + 120 + 20),
//                           child: Text(
//                             '${_componentViews.pAdd}',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(bottom: 5),
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(left: 20),
//                           width: 130,
//                           child: Text(
//                             'Điện thoại:',
//                             style: TextStyle(
//                                 color: DefaultTheme.GREY_TEXT,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: 10),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width -
//                               (40 + 120 + 20),
//                           child: Text(
//                             '${_componentViews.pSdt}',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(bottom: 5),
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(left: 20),
//                           width: 130,
//                           child: Text(
//                             'Ngày sinh:',
//                             style: TextStyle(
//                                 color: DefaultTheme.GREY_TEXT,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: 10),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width -
//                               (40 + 120 + 20),
//                           child: Text(
//                             '${_dateValidator.parseToDateView(_componentViews.pBirthdate)}',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(bottom: 5),
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(left: 20),
//                           width: 130,
//                           child: Text(
//                             'Giới tính:',
//                             style: TextStyle(
//                                 color: DefaultTheme.GREY_TEXT,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: 10),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width -
//                               (40 + 120 + 20),
//                           child: Text(
//                             '${_componentViews.pGender}',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(bottom: 5),
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(left: 20),
//                           width: 130,
//                           child: Text(
//                             'Nghề nghiệp:',
//                             style: TextStyle(
//                                 color: DefaultTheme.GREY_TEXT,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: 10),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width -
//                               (40 + 120 + 20),
//                           child: Text(
//                             '${_componentViews.pCareer}',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                       ],
//                     ),

//                     ///
//                     ///
//                     Padding(
//                       padding: EdgeInsets.only(
//                           left: 20, right: 20, bottom: 20, top: 30),
//                       child: Text(
//                         'Bên B: ${_componentViews.dname} (Bác sĩ)',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18,
//                             fontFamily: 'NewYork'),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(left: 20),
//                           width: 130,
//                           child: Text(
//                             'Công tác tại:',
//                             style: TextStyle(
//                                 color: DefaultTheme.GREY_TEXT,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: 10),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width -
//                               (40 + 120 + 20),
//                           child: Text(
//                             '${_componentViews.dplace}',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(bottom: 5),
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(left: 20),
//                           width: 130,
//                           child: Text(
//                             'Chuyên khoa:',
//                             style: TextStyle(
//                                 color: DefaultTheme.GREY_TEXT,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: 10),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width -
//                               (40 + 120 + 20),
//                           child: Text(
//                             '${_componentViews.dSpec}',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                       ],
//                     ),

//                     Padding(
//                       padding: EdgeInsets.only(bottom: 5),
//                     ),

//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(left: 20),
//                           width: 130,
//                           child: Text(
//                             'Điện thoại:',
//                             style: TextStyle(
//                                 color: DefaultTheme.GREY_TEXT,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: 10),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width -
//                               (40 + 120 + 20),
//                           child: Text(
//                             '${_componentViews.dSdt}',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(bottom: 5),
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(left: 20),
//                           width: 130,
//                           child: Text(
//                             'Ngày sinh:',
//                             style: TextStyle(
//                                 color: DefaultTheme.GREY_TEXT,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: 10),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width -
//                               (40 + 120 + 20),
//                           child: Text(
//                             '${_dateValidator.parseToDateView(_componentViews.dBirthDate)}',
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontFamily: 'NewYork'),
//                           ),
//                         ),
//                       ],
//                     ),

//                     //
//                     //

//                     //
//                     Padding(
//                       padding: EdgeInsets.only(top: 30, left: 20, right: 20),
//                       child: Text(
//                           'Sau khi thỏa thuận, Hai bên thống nhất ký kết hợp đồng khám, chữa bệnh theo các điều khoản cụ thể như sau:',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 15,
//                               fontStyle: FontStyle.italic,
//                               fontFamily: 'NewYork')),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                           left: 20, right: 20, bottom: 10, top: 20),
//                       child: Text(
//                         'Điều 1: Thời hạn và nhiệm vụ hợp đồng',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                             fontFamily: 'NewYork'),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
//                       child: Text(
//                         'Thời hạn hợp đồng kể từ ngày ${_dateValidator.parseToDateView2(_currentDate)}',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                             fontFamily: 'NewYork'),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                           left: 20, right: 20, bottom: 20, top: 30),
//                       child: Text(
//                         'Điều 2: Chế độ thăm khám và theo dõi',
//                         style: TextStyle(
//                             decoration: TextDecoration.underline,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                             fontFamily: 'NewYork'),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                           left: 20, right: 20, bottom: 20, top: 30),
//                       child: Text(
//                         'Điều 3: Trách nhiệm của hai bên',
//                         style: TextStyle(
//                             decoration: TextDecoration.underline,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                             fontFamily: 'NewYork'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     InkWell(
//                       onTap: () => _updateAcceptState(),
//                       borderRadius: BorderRadius.circular(40),
//                       child: _isAccept
//                           ? SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: Image.asset('assets/images/ic-dot.png'),
//                             )
//                           : SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: Image.asset(
//                                   'assets/images/ic-dot-unselect.png'),
//                             ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 10),
//                     ),
//                     Text(
//                       'Tôi đồng ý với tất cả các điều khoản.',
//                       style: TextStyle(
//                         color: DefaultTheme.GREY_TEXT,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               (_isAccept == false)
//                   ? Container(
//                       margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
//                       height: 50,
//                       decoration: BoxDecoration(
//                           color: DefaultTheme.GREY_BUTTON,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Align(
//                         alignment: Alignment.center,
//                         heightFactor: 50,
//                         child: Text('Gửi yêu cầu',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w500, fontSize: 16)),
//                       ),
//                     )
//                   : new Padding(
//                       padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
//                       child: ButtonHDr(
//                         label: 'Gửi yêu cầu',
//                         style: BtnStyle.BUTTON_BLACK,
//                         onTap: () {
//                           if (_isAccept) {
//                             //
//                             print(
//                                 'DTO PATIENT ID: ${_requestContract.patientId}');
//                             print(
//                                 'DTO DOCTOR ID: ${_requestContract.doctorId}');
//                             print(
//                                 'DTO DATE START: ${_requestContract.dateStarted}');
//                             print('DTO NOTE: ${_requestContract.note}');
//                             print(
//                                 'DTO DISEASES LIST : ${_requestContract.diseases.toString()}');
//                             if (_requestContract.doctorId != 0 ||
//                                 _requestContract.doctorId != null) {
//                               if (_requestContract.patientId != null ||
//                                   _requestContract.patientId != 0) {
//                                 _sendRequestContract(_requestContract);
//                               }
//                             } else {
//                               return showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return Center(
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(15)),
//                                         child: BackdropFilter(
//                                           filter: ImageFilter.blur(
//                                               sigmaX: 25, sigmaY: 25),
//                                           child: Container(
//                                             padding: EdgeInsets.only(
//                                                 left: 10, top: 10, right: 10),
//                                             width: 250,
//                                             height: 150,
//                                             decoration: BoxDecoration(
//                                               color: DefaultTheme.WHITE
//                                                   .withOpacity(0.7),
//                                             ),
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: <Widget>[
//                                                 Container(
//                                                   padding: EdgeInsets.only(
//                                                       bottom: 10, top: 10),
//                                                   child: Text(
//                                                     'Gửi yêu cầu thất bại',
//                                                     style: TextStyle(
//                                                       decoration:
//                                                           TextDecoration.none,
//                                                       color: DefaultTheme.BLACK,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       fontSize: 18,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   padding: EdgeInsets.only(
//                                                       left: 20, right: 20),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Text(
//                                                       'Kiểm tra lại kết nối mạng',
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       style: TextStyle(
//                                                         decoration:
//                                                             TextDecoration.none,
//                                                         color: DefaultTheme
//                                                             .GREY_TEXT,
//                                                         fontWeight:
//                                                             FontWeight.w400,
//                                                         fontSize: 13,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Spacer(),
//                                                 Divider(
//                                                   height: 1,
//                                                   color: DefaultTheme
//                                                       .GREY_TOP_TAB_BAR,
//                                                 ),
//                                                 ButtonHDr(
//                                                   height: 40,
//                                                   style: BtnStyle
//                                                       .BUTTON_TRANSPARENT,
//                                                   label: 'OK',
//                                                   labelColor:
//                                                       DefaultTheme.BLUE_TEXT,
//                                                   onTap: () {
//                                                     Navigator.of(context).pop();
//                                                   },
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   });
//                             }
//                           }
//                         },
//                       ),
//                     ),
//             ]),
//           ),
//         ],
//       ),
//     ));
//   }

//   _sendRequestContract(RequestContractDTO dto) {
//     // _requestContractBloc.add(RequestContractEventSend(dto: dto));
//     // Navigator.pushNamedAndRemoveUntil(
//     //     context, RoutesHDr.MAIN_HOME, (Route<dynamic> route) => false);

//     setState(() {
//       //
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(15)),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     width: 250,
//                     height: 150,
//                     decoration: BoxDecoration(
//                       color: DefaultTheme.WHITE.withOpacity(0.7),
//                     ),
//                     child: Column(
//                       children: <Widget>[
//                         SizedBox(
//                           width: 130,
//                           // height: 100,
//                           child: Image.asset('assets/images/loading.gif'),
//                         ),
//                         // Spacer(),
//                         Container(
//                           padding: EdgeInsets.only(bottom: 10),
//                           child: Text(
//                             'Đang gửi yêu cầu',
//                             style: TextStyle(
//                               decoration: TextDecoration.none,
//                               color: DefaultTheme.GREY_TEXT,
//                               fontWeight: FontWeight.w400,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           });
//       //
//       if (dto != null) {
//         _requestContractBloc.add(RequestContractEventSend(dto: dto));
//         Future.delayed(const Duration(seconds: 3), () {
//           //
//           _contractHelper.isSent().then((value) async {
//             //
//             if (value == true) {
//               Navigator.of(context).pop();
//               await Navigator.pushNamedAndRemoveUntil(
//                   context,
//                   RoutesHDr.CONTRACT_DETAIL_STATUS,
//                   (Route<dynamic> route) => false);
//             } else {
//               String msg = '';
//               _contractHelper.getMsgSendContract().then((value) async {
//                 msg = value;
//               });
//               Navigator.of(context).pop();
//               return showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return Center(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.all(Radius.circular(15)),
//                         child: BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
//                           child: Container(
//                             padding:
//                                 EdgeInsets.only(left: 10, top: 10, right: 10),
//                             width: 250,
//                             height: 150,
//                             decoration: BoxDecoration(
//                               color: DefaultTheme.WHITE.withOpacity(0.7),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 Container(
//                                   padding: EdgeInsets.only(bottom: 10, top: 10),
//                                   child: Text(
//                                     'Gửi yêu cầu thất bại',
//                                     style: TextStyle(
//                                       decoration: TextDecoration.none,
//                                       color: DefaultTheme.BLACK,
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.only(left: 20, right: 20),
//                                   child: Align(
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       '$msg',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         decoration: TextDecoration.none,
//                                         color: DefaultTheme.GREY_TEXT,
//                                         fontWeight: FontWeight.w400,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Divider(
//                                   height: 1,
//                                   color: DefaultTheme.GREY_TOP_TAB_BAR,
//                                 ),
//                                 ButtonHDr(
//                                   height: 40,
//                                   style: BtnStyle.BUTTON_TRANSPARENT,
//                                   label: 'OK',
//                                   labelColor: DefaultTheme.BLUE_TEXT,
//                                   onTap: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   });
//             }
//           });
//         });
//       }
//     });
//   }
// }
