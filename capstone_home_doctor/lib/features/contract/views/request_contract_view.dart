// import 'dart:io';
// import 'dart:ui';

// import 'package:capstone_home_doctor/commons/constants/theme.dart';
// import 'package:capstone_home_doctor/commons/routes/routes.dart';
// import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
// import 'package:capstone_home_doctor/commons/utils/img_util.dart';

// import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
// import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
// import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_bottom_sheet_field.dart';
// import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_chip_display.dart';
// import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_item.dart';
// import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_list_type.dart';
// import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
// import 'package:capstone_home_doctor/features/contract/blocs/contract_request_bloc.dart';

// import 'package:capstone_home_doctor/features/contract/blocs/disease_list_bloc.dart';
// import 'package:capstone_home_doctor/features/contract/blocs/doctor_info_bloc.dart';

// import 'package:capstone_home_doctor/features/contract/events/disease_list_event.dart';
// import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_detail_bloc.dart';
// import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_with_type_list_bloc.dart';
// import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_get_by_id_event.dart';
// import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_list_with_type_event.dart';
// import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
// import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_get_by_id_state.dart';
// import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_with_type_state.dart';
// import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
// import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
// import 'package:capstone_home_doctor/services/authen_helper.dart';
// import 'package:capstone_home_doctor/services/contract_helper.dart';
// import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
// import 'package:capstone_home_doctor/features/contract/events/doctor_info_event.dart';

// import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
// import 'package:capstone_home_doctor/features/contract/repositories/disease_repository.dart';
// import 'package:capstone_home_doctor/features/contract/repositories/doctor_repository.dart';
// import 'package:capstone_home_doctor/features/contract/states/contract_request_state.dart';
// import 'package:capstone_home_doctor/features/contract/states/disease_list_state.dart';
// import 'package:capstone_home_doctor/features/contract/states/doctor_info_state.dart';
// import 'package:capstone_home_doctor/features/information/blocs/patient_bloc.dart';
// import 'package:capstone_home_doctor/features/information/events/patient_event.dart';
// import 'package:capstone_home_doctor/features/information/repositories/patient_repository.dart';
// import 'package:capstone_home_doctor/features/information/states/patient_state.dart';
// import 'package:capstone_home_doctor/models/disease_dto.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:capstone_home_doctor/models/req_contract_dto.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';

// final Shader _normalHealthColors = LinearGradient(
//   colors: <Color>[
//     DefaultTheme.GRADIENT_1,
//     DefaultTheme.GRADIENT_2,
//   ],
// ).createShader(new Rect.fromLTWH(10.0, 1.0, 100.0, 90.0));

// final picker = ImagePicker();

// final ContractHelper _contractHelper = ContractHelper();
// String _medInsDefaultSelected = 'Chọn loại phiếu';
// int indexSelectMedIns = 0;
// final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
// String _selectedHRType = '';
// MedInsWithTypeListBloc _medInsWithTypeListBloc;

// class RequestContract extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _RequestContract();
//   }
// }

// class _RequestContract extends State<RequestContract>
//     with WidgetsBindingObserver {
//   String _startDate = DateTime.now().toString().split(' ')[0];
//   int _licenseId = 1;
//   var _noteController = TextEditingController();
//   List<String> _diseaseIds = [];
//   List<int> _medinsId = [];
//   String _note = '';
//   //for list
//   List<Object> listMedicalShare = [];
//   List<PickedFile> imageFiles = [];

//   //
//   List<int> listIdMedInsID = [];
//   //
//   int _dayOfTrackingValue = 30;
//   String _dayOfTrackingView = '1 tháng';

//   RequestContractDTO reqContractDTO;
//   DoctorRepository doctorRepository =
//       DoctorRepository(httpClient: http.Client());
//   ContractRepository requestContractRepository =
//       ContractRepository(httpClient: http.Client());
//   DiseaseRepository diseaseRepository =
//       DiseaseRepository(httpClient: http.Client());
//   PatientRepository patientRepository =
//       PatientRepository(httpClient: http.Client());
//   MedicalInstructionRepository medicalInstructionRepository =
//       MedicalInstructionRepository(httpClient: http.Client());
//   //
//   DateValidator _dateValidator = DateValidator();
//   //
//   int _patientId = 0;
//   //
//   String medInsType = '';

//   TextEditingController _searchDiseaseController = TextEditingController();

//   //view to move next
//   String _dname = '';
//   String _dplace = '';
//   String _dSdt = '';
//   String _pname = '';
//   String _pSdt = '';
//   String _pBirthdate = '';
//   String _pAdd = '';
//   String _dEmail = '';
//   String _pGender = '';
//   String _pCareer = '';
//   String _dBirthDate = '';
//   String _dSpec = '';

//   ///
//   String idDiseaseSelected = '';
//   String nameDiseaseSelected = '';

//   //List<DiseaseDTO> _listDiseaseView = [];
//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//     _initialContractHelper();
//     _getPatientId();
//     _medInsWithTypeListBloc = BlocProvider.of(context);
//   }

//   _initialContractHelper() async {
//     await _contractHelper.updateContractSendStatus(false, '');
//   }

//   _getPatientId() async {
//     await _authenticateHelper.getPatientId().then((value) async {
//       setState(() {
//         _patientId = value;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   List<DiseaseDTO> _listDisease = [];
//   List<DiseaseDTO> _listDiseaseSelected = [];
//   //
//   List<MedInsByDiseaseDTO> _medInswithType = [];

//   //FOR NEW CONTRACT
//   List<Diseases> listDiseasesNewContract = [];
//   int countItemNewContract = 0;
//   List<DiseaseBoxDTO> listDiseaseBox = [];

//   @override
//   Widget build(BuildContext context) {
//     //

//     //idDoctor
//     String arguments = ModalRoute.of(context).settings.arguments;
//     //SET DOCTOR ID S_P

//     _contractHelper.updateDoctorId(int.tryParse(arguments));
//     //
//     final requestContractProvider =
//         Provider.of<RequestContractDTOProvider>(context, listen: false);
//     requestContractProvider.setProvider(
//       doctorId: int.parse(arguments.trim()),
//       patientId: _patientId,
//       dateStarted: _startDate,
//       licenseId: 1,
//       note: _note,
//       diseases: listDiseasesNewContract,
//     );

//     final rContractViewProvider =
//         Provider.of<RContractProvider>(context, listen: false);
//     rContractViewProvider.setProvider(
//         dname: _dname,
//         dplace: _dplace,
//         dSdt: _dSdt,
//         dEmail: _dEmail,
//         pname: _pname,
//         pSdt: _pSdt,
//         diseases: _listDiseaseSelected,
//         //  listMedInsChecked: listMedInsChecked,
//         pCareer: _pCareer,
//         duration: _dayOfTrackingView,
//         note: _note,
//         pGender: _pGender,
//         dSpec: _dSpec,
//         dBirthDate: _dBirthDate,
//         pAdd: _pAdd,
//         pBirthdate: _pBirthdate,
//         sDate: _startDate);

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<DoctorInfoBloc>(
//           create: (BuildContext context) =>
//               DoctorInfoBloc(doctorAPI: doctorRepository),
//         ),
//         BlocProvider<RequestContractBloc>(
//           create: (BuildContext context) => RequestContractBloc(
//               requestContractAPI: requestContractRepository),
//         ),
//         BlocProvider<DiseaseListBloc>(
//           create: (BuildContext context) =>
//               DiseaseListBloc(diseaseRepository: diseaseRepository),
//         ),
//         BlocProvider<PatientBloc>(
//           create: (BuildContext context) =>
//               PatientBloc(patientRepository: patientRepository),
//         ),
//         BlocProvider<MedInsWithTypeListBloc>(
//           create: (BuildContext context) => MedInsWithTypeListBloc(
//               medicalInstructionRepository: medicalInstructionRepository),
//         ),
//       ],
//       child: Scaffold(
//         body: SafeArea(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 HeaderWidget(
//                   title: 'Yêu cầu hợp đồng',
//                   isMainView: false,
//                   buttonHeaderType: ButtonHeaderType.BACK_HOME,
//                 ),
//                 Expanded(
//                   child: ListView(
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.only(
//                             left: 20, right: 20, bottom: 20, top: 30),
//                         child: Text(
//                           'Thông tin bác sĩ',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600, fontSize: 20),
//                         ),
//                       ),
//                       BlocProvider(
//                         create: (context) =>
//                             DoctorInfoBloc(doctorAPI: doctorRepository)
//                               ..add(DoctorInfoEventSetId(id: arguments)),
//                         child: _getDoctorInfo(),
//                       ),
//                       //Patient info
//                       Padding(
//                         padding: EdgeInsets.only(
//                             bottom: 5, left: 20, right: 20, top: 30),
//                         child: Divider(
//                           color: DefaultTheme.GREY_TEXT,
//                           height: 0.1,
//                         ),
//                       ),
//                       Padding(
//                         padding:
//                             EdgeInsets.only(left: 20, right: 60, bottom: 20),
//                         child: Text(
//                           'Các thông tin dưới đây được gửi tới bác sĩ trong trạng thái chờ xét duyệt.',
//                           style: TextStyle(
//                               color: DefaultTheme.GREY_TEXT,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w400),
//                         ),
//                       ),
//                       //
//                       Padding(
//                         padding:
//                             EdgeInsets.only(left: 20, right: 20, bottom: 20),
//                         child: Text(
//                           'Thông tin cá nhân',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600, fontSize: 20),
//                         ),
//                       ),

//                       _makePatientInfo(),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             bottom: 5, left: 20, right: 20, top: 20),
//                         child: Divider(
//                           color: DefaultTheme.GREY_TEXT,
//                           height: 0.1,
//                         ),
//                       ),

//                       //following info
//                       Padding(
//                         padding: EdgeInsets.only(
//                             left: 20, right: 20, bottom: 20, top: 10),
//                         child: Text(
//                           'Thông tin theo dõi',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600, fontSize: 20),
//                         ),
//                       ),
//                       Padding(
//                         padding:
//                             EdgeInsets.only(bottom: 5, left: 20, right: 20),
//                         child: Text(
//                           'Ngày bắt đầu',
//                           style: TextStyle(
//                               color: DefaultTheme.BLACK_BUTTON,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16),
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 20, right: 20),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(6),
//                             color: DefaultTheme.GREY_BUTTON),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             Padding(
//                               padding: EdgeInsets.only(left: 20),
//                             ),
//                             Text(
//                               '${_startDate.split('-')[2]} tháng ${_startDate.split('-')[1]} năm ${_startDate.split('-')[0]}',
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.w400),
//                             ),
//                             Spacer(),
//                             ButtonHDr(
//                               label: 'Chọn',
//                               style: BtnStyle.BUTTON_FULL,
//                               image: Image.asset(
//                                   'assets/images/ic-choose-date.png'),
//                               width: 30,
//                               height: 40,
//                               labelColor: DefaultTheme.BLUE_REFERENCE,
//                               bgColor: DefaultTheme.TRANSPARENT,
//                               onTap: () {
//                                 _showDatePickerStart();
//                               },
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(right: 10),
//                             )
//                           ],
//                         ),
//                       ),
// //NEXT CONFIRM CONTRACT
//                       Padding(
//                           padding: EdgeInsets.only(
//                               left: 20, right: 20, bottom: 20, top: 30),
//                           child: ButtonHDr(
//                             label: 'Tiếp theo',
//                             onTap: () {
//                               // bool _isSend1st = false;
//                               // if (_isSend1st) {
//                               //   _views.clear();
//                               // }
//                               // _views.add(_startDate);
//                               // _views.add(_listDiseaseSelected);
//                               // _isSend1st = true;
//                               Navigator.of(context).pushNamed(
//                                   RoutesHDr.CONFIRM_CONTRACT_VIEW,
//                                   arguments: {
//                                     'REQUEST_OBJ':
//                                         requestContractProvider.getProvider,
//                                     'VIEWS_OBJ':
//                                         rContractViewProvider.getRProvider,
//                                   });
//                             },
//                           )),
//                     ],
//                   ),
//                 ),
//               ]),
//         ),
//       ),
//     );
//   }

//   //make patient information
//   _makePatientInfo() {
//     // int _patientIdShared = await _authenticateHelper.getPatientId();
//     if (_patientId != 0) {
//       return Padding(
//         padding: EdgeInsets.only(left: 20, right: 20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             //in right way loading
//             BlocProvider(
//               create: (context4) =>
//                   PatientBloc(patientRepository: patientRepository)
//                     ..add(PatientEventSetId(id: _patientId)),
//               child: BlocBuilder<PatientBloc, PatientState>(
//                 builder: (context4, state4) {
//                   if (state4 is PatientStateLoading) {
//                     return Container(
//                       margin: EdgeInsets.only(left: 20, right: 20),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(6),
//                           color: DefaultTheme.GREY_BUTTON),
//                       child: Center(
//                         child: SizedBox(
//                           width: 30,
//                           height: 30,
//                           child: Image.asset('assets/images/loading.gif'),
//                         ),
//                       ),
//                     );
//                   }
//                   if (state4 is PatientStateFailure) {
//                     return Container(
//                       margin: EdgeInsets.only(
//                           left: 20, right: 20, bottom: 10, top: 10),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: DefaultTheme.GREY_BUTTON),
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                             top: 10, bottom: 10, left: 20, right: 20),
//                         child: Text('Không thể tải thông tin cá nhân',
//                             style: TextStyle(
//                               color: DefaultTheme.GREY_TEXT,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             )),
//                       ),
//                     );
//                   }
//                   if (state4 is PatientStateSuccess) {
//                     if (state4.dto == null) {
//                       return Container(
//                         margin: EdgeInsets.only(
//                             left: 20, right: 20, bottom: 10, top: 10),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: DefaultTheme.GREY_BUTTON),
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                               top: 10, bottom: 10, left: 20, right: 20),
//                           child: Text('Không thể tải thông tin cá nhân',
//                               style: TextStyle(
//                                 color: DefaultTheme.GREY_TEXT,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               )),
//                         ),
//                       );
//                     }
//                     // state4.dto.career
//                     String _gender = '';
//                     if (state4.dto.gender == 'Nam') {
//                       _gender = 'Ông';
//                       _pGender = 'Nam';
//                     }
//                     if (state4.dto.gender == 'Nữ') {
//                       _gender = 'Bà';
//                       _pGender = 'Nữ';
//                     }
//                     // _views.add(state4.dto.gender);
//                     // _views.add(state4.dto.fullName);
//                     // _views.add(state4.dto.dateOfBirth);
//                     // _views.add(state4.dto.address);
//                     _pCareer = state4.dto.career;
//                     _pname = state4.dto.fullName;
//                     _pSdt = state4.dto.phoneNumber;
//                     _pBirthdate = state4.dto.dateOfBirth;
//                     _pAdd = state4.dto.address;
//                     return Container(
//                       padding: EdgeInsets.only(
//                           top: 20, bottom: 20, left: 20, right: 20),
//                       width: MediaQuery.of(context).size.width - 40,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: DefaultTheme.GREY_VIEW),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Row(
//                             children: [
//                               Container(
//                                 width: 120,
//                                 child: Text(
//                                   '$_gender',
//                                   style: TextStyle(
//                                     color: DefaultTheme.GREY_TEXT,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(left: 10),
//                               ),
//                               Container(
//                                 width: MediaQuery.of(context).size.width -
//                                     (80 + 120 + 10),
//                                 child: Text(
//                                   '${state4.dto.fullName}',
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 3,
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(bottom: 10),
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 width: 120,
//                                 child: Text(
//                                   'Số điện thoại',
//                                   style: TextStyle(
//                                     color: DefaultTheme.GREY_TEXT,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(left: 10),
//                               ),
//                               Container(
//                                 width: MediaQuery.of(context).size.width -
//                                     (80 + 120 + 10),
//                                 child: Text(
//                                   '${state4.dto.phoneNumber}',
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 3,
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(bottom: 10),
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 width: 120,
//                                 child: Text(
//                                   'Sinh ngày',
//                                   style: TextStyle(
//                                     color: DefaultTheme.GREY_TEXT,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(left: 10),
//                               ),
//                               Container(
//                                 width: MediaQuery.of(context).size.width -
//                                     (80 + 120 + 10),
//                                 child: Text(
//                                   '${_dateValidator.parseToDateView(state4.dto.dateOfBirth)}',
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 3,
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(bottom: 10),
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 width: 120,
//                                 child: Text(
//                                   'ĐC thường trú',
//                                   style: TextStyle(
//                                     color: DefaultTheme.GREY_TEXT,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(left: 10),
//                               ),
//                               Container(
//                                 width: MediaQuery.of(context).size.width -
//                                     (80 + 120 + 10),
//                                 child: (state4.dto.address == null)
//                                     ? Text(
//                                         'Chưa cập nhật',
//                                         style: TextStyle(
//                                           color: DefaultTheme.GREY_TEXT,
//                                           fontSize: 15,
//                                         ),
//                                       )
//                                     : Text(
//                                         '${state4.dto.address}',
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 3,
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 15,
//                                         ),
//                                       ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   return Container(
//                     margin: EdgeInsets.only(
//                         left: 20, right: 20, bottom: 10, top: 10),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: DefaultTheme.GREY_BUTTON),
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                           top: 10, bottom: 10, left: 20, right: 20),
//                       child: Text('Không thể tải thông tin cá nhân',
//                           style: TextStyle(
//                             color: DefaultTheme.GREY_TEXT,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           )),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             //
//             Padding(
//               padding: EdgeInsets.only(bottom: 20),
//             ),
//             //
//             //
//             //
//             //
//             (listDiseaseBox.isEmpty)
//                 ? Container()
//                 : Column(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.only(top: 30, bottom: 10),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Danh sách bệnh lý chia sẻ',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: listDiseaseBox.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return Container(
//                             margin: EdgeInsets.only(bottom: 10, top: 10),
//                             width: MediaQuery.of(context).size.width,
//                             decoration: BoxDecoration(
//                               color: DefaultTheme.GREY_VIEW,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.only(top: 20, left: 20),
//                                   margin: EdgeInsets.only(bottom: 10),
//                                   height: 40,
//                                   child: Text(
//                                     'Gói bệnh lý số ${index + 1}',
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w400),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.only(top: 0, left: 20),
//                                   height: 50,
//                                   margin: EdgeInsets.only(bottom: 0),
//                                   child: Text(
//                                     '${listDiseaseBox[index].diseaseName}',
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                                 Container(
//                                   width: MediaQuery.of(context).size.width,
//                                   height: 200,
//                                   child: ListView.builder(
//                                     //
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount:
//                                         listDiseaseBox[index].listMi.length,
//                                     itemBuilder:
//                                         (BuildContext context, int index2) {
//                                       return Stack(
//                                         children: [
//                                           Container(
//                                             width: 150,
//                                             height: 200,
//                                             margin: EdgeInsets.only(right: 10),
//                                             child: SizedBox(
//                                               width: 150,
//                                               height: 200,
//                                               child: (listDiseaseBox[index]
//                                                           .listMi[index2]
//                                                           .imageUrl !=
//                                                       null)
//                                                   ? Image.network(
//                                                       'http://45.76.186.233:8000/api/v1/Images?pathImage=${listDiseaseBox[index].listMi[index2].imageUrl}',
//                                                       fit: BoxFit.fill,
//                                                     )
//                                                   : Container(),
//                                             ),
//                                           ),
//                                           Positioned(
//                                             top: 0,
//                                             child: Container(
//                                               width: 150,
//                                               height: 200,
//                                               color: DefaultTheme.WHITE
//                                                   .withOpacity(0.2),
//                                             ),
//                                           ),
//                                           Positioned(
//                                             bottom: 0,
//                                             child: Container(
//                                               width: 150,
//                                               height: 50,
//                                               color: DefaultTheme.BLACK
//                                                   .withOpacity(0.7),
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.end,
//                                                 children: [
//                                                   Spacer(),
//                                                   Center(
//                                                     child: Text(
//                                                       '${listDiseaseBox[index].listMi[index2].miType}',
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           color: DefaultTheme
//                                                               .WHITE),
//                                                     ),
//                                                   ),
//                                                   Spacer(),
//                                                   Text(
//                                                     '${listDiseaseBox[index].listMi[index2].place}',
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: TextStyle(
//                                                         fontSize: 13,
//                                                         fontWeight:
//                                                             FontWeight.w400,
//                                                         color:
//                                                             DefaultTheme.WHITE),
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                         bottom: 5),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),

//             ///
//             ///
//             ///
//             ///
//             ///
//             ///
//             InkWell(
//               highlightColor: DefaultTheme.BLUE_REFERENCE,
//               borderRadius: BorderRadius.circular(6),
//               hoverColor: DefaultTheme.BLACK.withOpacity(0.3),
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   // color: DefaultTheme.BLUE_REFERENCE.withOpacity(0.8),
//                   border: Border.all(
//                     color: DefaultTheme.GREY_TOP_TAB_BAR,
//                     width: 0.75,
//                   ),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.only(left: 30),
//                     ),
//                     SizedBox(
//                       height: 30,
//                       child: Image.asset(
//                           'assets/images/ic-medical-instruction.png'),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 40),
//                     ),
//                     Text(
//                       'Chia sẻ bệnh lý',
//                       style: TextStyle(
//                         color: DefaultTheme.BLACK,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Spacer(),
//                   ],
//                 ),
//               ),
//               onTap: () {
//                 //
//                 _showShareMedical();
//               },
//             ),

//             //

//             Padding(
//               padding: EdgeInsets.only(bottom: 15),
//               child: Divider(
//                 height: 1,
//                 color: DefaultTheme.GREY_TOP_TAB_BAR,
//               ),
//             ), //
//             //
//             //
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 5, left: 10, top: 20),
//                   child: Text(
//                     'Ghi chú',
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                         color: DefaultTheme.BLACK_BUTTON,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.topLeft,
//                   height: 150,
//                   child: TextFieldHDr(
//                     placeHolder: 'Mô tả thêm các triệu chứng đang gặp',
//                     controller: _noteController,
//                     keyboardAction: TextInputAction.done,
//                     onChange: (text) {
//                       setState(() {
//                         _note = text;
//                       });
//                       // _views.add(_note);
//                     },
//                     style: TFStyle.TEXT_AREA,
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       );
//     }
//   }

//   _showShareMedical() {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: this.context,
//         backgroundColor: Colors.white.withOpacity(0),
//         builder: (context) {
//           //
//           return StatefulBuilder(
//             builder: (BuildContext context2, StateSetter setModalState) {
//               return BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                 child: Container(
//                   color: DefaultTheme.TRANSPARENT,
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 0.95,
//                     padding: EdgeInsets.only(left: 20, right: 20),
//                     decoration: BoxDecoration(
//                       color: DefaultTheme.WHITE,
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(10),
//                           topRight: Radius.circular(10)),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         //
//                         Container(
//                           padding: EdgeInsets.only(top: 10),
//                           width: MediaQuery.of(context).size.width,
//                           child: Row(
//                             children: <Widget>[
//                               Flexible(
//                                 child: TextFieldHDr(
//                                     label: 'Tìm kiếm',
//                                     placeHolder: 'Nhập mã bệnh lý',
//                                     controller: _searchDiseaseController,
//                                     keyboardAction: TextInputAction.done,
//                                     style: TFStyle.NO_BORDER),
//                               ),
//                               ButtonHDr(
//                                 style: BtnStyle.BUTTON_IMAGE,
//                                 imgHeight: 20,
//                                 onTap: () {},
//                                 image: Image.asset('assets/images/ic-find.png'),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Divider(
//                           height: 1,
//                           color: DefaultTheme.GREY_TOP_TAB_BAR,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(bottom: 10),
//                         ),
//                         Expanded(
//                           child: BlocProvider(
//                             create: (context2) => DiseaseListBloc(
//                                 diseaseRepository: diseaseRepository)
//                               ..add(
//                                   DiseaseListEventSetStatus(status: 'ACTIVE')),
//                             child:
//                                 BlocBuilder<DiseaseListBloc, DiseaseListState>(
//                                     builder: (context2, state2) {
//                               if (state2 is DiseaseListStateLoading) {
//                                 return Container(
//                                   margin: EdgeInsets.only(left: 20, right: 20),
//                                   child: Center(
//                                     child: SizedBox(
//                                       width: 120,
//                                       child: Image.asset(
//                                           'assets/images/loading.gif'),
//                                     ),
//                                   ),
//                                 );
//                               }
//                               if (state2 is DiseaseListStateFailure) {
//                                 return Container(
//                                   margin: EdgeInsets.only(
//                                       left: 20, right: 20, bottom: 10, top: 10),
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                         top: 10,
//                                         bottom: 10,
//                                         left: 20,
//                                         right: 20),
//                                     child: Text('Không thể tải',
//                                         style: TextStyle(
//                                           color: DefaultTheme.GREY_TEXT,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w500,
//                                         )),
//                                   ),
//                                 );
//                               }
//                               if (state2 is DiseaseListStateSuccess) {
//                                 if (state2.listDisease == null) {
//                                   return Container(
//                                     margin: EdgeInsets.only(
//                                         left: 20,
//                                         right: 20,
//                                         bottom: 10,
//                                         top: 10),
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5),
//                                         color: DefaultTheme.GREY_BUTTON),
//                                     child: Padding(
//                                       padding: EdgeInsets.only(
//                                           top: 10,
//                                           bottom: 10,
//                                           left: 20,
//                                           right: 20),
//                                       child: Text('Không thể tải',
//                                           style: TextStyle(
//                                             color: DefaultTheme.GREY_TEXT,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w500,
//                                           )),
//                                     ),
//                                   );
//                                 }
//                                 _listDisease = state2.listDisease;
//                               }
//                               return ListView.builder(
//                                   // shrinkWrap: true,
//                                   // physics: NeverScrollableScrollPhysics(),
//                                   itemCount: _listDisease.length,
//                                   itemBuilder:
//                                       (BuildContext buildContext, int index) {
//                                     return InkWell(
//                                       child: Container(
//                                         padding: EdgeInsets.all(10),
//                                         decoration: BoxDecoration(
//                                           color: DefaultTheme.GREY_VIEW,
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                           // border: Border.all(
//                                           //   color:
//                                           //       DefaultTheme.GREY_TOP_TAB_BAR,
//                                           //   width: 0.75,
//                                           // ),
//                                         ),
//                                         height: 60,
//                                         margin: EdgeInsets.only(bottom: 5),
//                                         child: Align(
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             '${_listDisease[index].diseaseId} - ${_listDisease[index].name}',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                         ),
//                                       ),
//                                       onTap: () {
//                                         //
//                                         setState(() {
//                                           idDiseaseSelected =
//                                               _listDisease[index].diseaseId;
//                                           nameDiseaseSelected =
//                                               _listDisease[index].name;
//                                         });
//                                         _medInsWithTypeListBloc.add(
//                                             MedInsWithTypeEventGetList(
//                                                 patientId: _patientId,
//                                                 diseaseId: idDiseaseSelected));
//                                         Navigator.of(context).pop();
//                                         _showShareMedicalStep2();
//                                       },
//                                     );
//                                   });

//                               ///
//                             }),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(bottom: 20),
//                         ),
//                         Container(
//                           child: Column(
//                             children: [
//                               //
//                               Padding(
//                                 padding: EdgeInsets.only(bottom: 10),
//                               ),
//                               Text(
//                                 'Chọn bệnh lý',
//                                 style: TextStyle(
//                                   color: DefaultTheme.BLACK,
//                                   fontSize: 25,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(bottom: 5),
//                               ),
//                               Text(
//                                 'Bước 1',
//                                 style: TextStyle(
//                                   color: DefaultTheme.GREY_TEXT,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(bottom: 30),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         });
//   }

//   _showShareMedicalStep2() {
//     // List<bool> isCheckedList = [];
//     // String _imgString = '';
//     // List<String> imgStrings = [];
//     // PickedFile _imgFile;
//     List<int> listMedicalInstructionIdsNewContract = [];
//     DiseaseBoxDTO boxDiseaseDTO = DiseaseBoxDTO();
//     List<MiBoxDTO> listMiBox = [];
//     String placeDisease = '';
//     Diseases dsDTO = Diseases();
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: this.context,
//         backgroundColor: Colors.white.withOpacity(0),
//         builder: (context) {
//           //
//           return StatefulBuilder(
//             builder: (BuildContext context2, StateSetter setModalState) {
//               return BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                 child: Container(
//                   color: DefaultTheme.TRANSPARENT,
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 0.95,
//                     padding: EdgeInsets.only(left: 20, right: 20),
//                     decoration: BoxDecoration(
//                       color: DefaultTheme.WHITE,
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(10),
//                           topRight: Radius.circular(10)),
//                     ),
//                     child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           //
//                           Padding(
//                             padding: EdgeInsets.only(top: 20),
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 width: 100,
//                                 child: Center(
//                                   child: Text(
//                                     '$idDiseaseSelected',
//                                     style: TextStyle(
//                                       color: DefaultTheme.BLACK,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 width: MediaQuery.of(context).size.width - 150,
//                                 child: Text(
//                                   '$nameDiseaseSelected',
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 2,
//                                   style: TextStyle(
//                                     color: DefaultTheme.BLACK,
//                                     fontSize: 16,
//                                     // fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(bottom: 20),
//                           ),

//                           Padding(
//                             padding: EdgeInsets.only(bottom: 15),
//                             child: Divider(
//                               height: 1,
//                               color: DefaultTheme.GREY_TOP_TAB_BAR,
//                             ),
//                           ),
//                           Expanded(
//                             child: BlocBuilder<MedInsWithTypeListBloc,
//                                 MedInsWithTypeState>(
//                               builder: (context, state) {
//                                 if (state is MedInsWithTypeStateLoading) {
//                                   return Container(
//                                     margin:
//                                         EdgeInsets.only(left: 20, right: 20),
//                                     child: Center(
//                                       child: SizedBox(
//                                         width: 120,
//                                         child: Image.asset(
//                                             'assets/images/loading.gif'),
//                                       ),
//                                     ),
//                                   );
//                                 }
//                                 if (state is MedInsWithTypeStateFailure) {
//                                   return Container(
//                                       width: MediaQuery.of(context).size.width,
//                                       child: Center(
//                                           child:
//                                               Text('Không thể tải danh sách')));
//                                 }
//                                 if (state is MedInsWithTypeStateSuccess) {
//                                   //
//                                   _medInswithType = state.listMedInsWithType;
//                                   countItemNewContract = 0;

//                                   for (int a = 0;
//                                       a < state.listMedInsWithType.length;
//                                       a++) {
//                                     placeDisease =
//                                         _medInswithType[a].healthRecordPlace;
//                                     //
//                                     List<MedicalInstructionTypes> xs = state
//                                         .listMedInsWithType[a]
//                                         .medicalInstructionTypes;
//                                     for (int b = 0; b < xs.length; b++) {
//                                       // xs[b].medicalInstructions.length;
//                                       countItemNewContract +=
//                                           xs[b].medicalInstructions.length;
//                                       print(
//                                           'COUNTING ITEMS VIEW ${countItemNewContract}');
//                                     }
//                                   } //   //
//                                   //   for (int b = 0; b < xs.length; b++) {
//                                   //     List<MedicalInstructions> ys =
//                                   //         xs[b].medicalInstructions;

//                                   //   }
//                                   // }
//                                   // countItemNewContract
//                                   //  _medInswithType[index].medicalInstructionTypes

//                                 }

//                                 return ListView.builder(
//                                     itemCount: _medInswithType.length,
//                                     itemBuilder:
//                                         (BuildContext buildContext, int index) {
//                                       //
//                                       String placehr = _medInswithType[index]
//                                           .healthRecordPlace;
//                                       return Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           //
//                                           Row(
//                                             children: <Widget>[
//                                               Container(
//                                                 width: 30,
//                                                 height: 50,
//                                                 child: Align(
//                                                   alignment:
//                                                       Alignment.bottomCenter,
//                                                   child: SizedBox(
//                                                       width: 30,
//                                                       height: 30,
//                                                       child: Image.asset(
//                                                           'assets/images/ic-map.png')),
//                                                 ),
//                                               ),
//                                               Container(
//                                                   width: 80,
//                                                   height: 50,
//                                                   child: Align(
//                                                     alignment:
//                                                         Alignment.bottomLeft,
//                                                     child: Text(
//                                                       'Nơi khám: ',
//                                                       style: TextStyle(
//                                                         color:
//                                                             DefaultTheme.BLACK,
//                                                         fontSize: 16,
//                                                       ),
//                                                     ),
//                                                   )),
//                                               Container(
//                                                 height: 50,
//                                                 width: MediaQuery.of(context)
//                                                         .size
//                                                         .width -
//                                                     40 -
//                                                     110,
//                                                 child: Align(
//                                                   alignment:
//                                                       Alignment.bottomLeft,
//                                                   child: Text(
//                                                     '${_medInswithType[index].healthRecordPlace}',
//                                                     style: TextStyle(
//                                                       color: DefaultTheme.BLACK,
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       fontSize: 16,
//                                                     ),
//                                                     maxLines: 2,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           for (MedicalInstructionTypes i
//                                               in _medInswithType[index]
//                                                   .medicalInstructionTypes)
//                                             Container(
//                                               width: MediaQuery.of(context)
//                                                   .size
//                                                   .width,
//                                               margin:
//                                                   EdgeInsets.only(bottom: 10),
//                                               // height: 80,
//                                               // decoration: BoxDecoration(
//                                               //   color: DefaultTheme.GREY_VIEW,
//                                               //   borderRadius:
//                                               //       BorderRadius.circular(5),
//                                               // ),
//                                               child: Column(
//                                                 children: <Widget>[
//                                                   Container(
//                                                     height: 250,
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                             .size
//                                                             .width,
//                                                     child: ListView.builder(
//                                                       // shrinkWrap: true,
//                                                       // physics:
//                                                       //     NeverScrollableScrollPhysics(),
//                                                       scrollDirection:
//                                                           Axis.horizontal,
//                                                       itemCount: i
//                                                           .medicalInstructions
//                                                           .length,
//                                                       itemBuilder:
//                                                           (BuildContext context,
//                                                               int index) {
//                                                         return Container(
//                                                           width: 150,
//                                                           height: 200,
//                                                           margin:
//                                                               EdgeInsets.only(
//                                                                   top: 10,
//                                                                   right: 10),
//                                                           // color: Colors.blue,
//                                                           child: Stack(
//                                                             children: <Widget>[
//                                                               //

//                                                               Container(
//                                                                 width: 150,
//                                                                 height: 250,
//                                                                 decoration: BoxDecoration(
//                                                                     border: Border.all(
//                                                                         color: DefaultTheme
//                                                                             .GREY_TOP_TAB_BAR,
//                                                                         width:
//                                                                             1)),
//                                                                 child: (i
//                                                                             .medicalInstructions[
//                                                                                 index]
//                                                                             .image !=
//                                                                         null)
//                                                                     ? SizedBox(
//                                                                         width:
//                                                                             150,
//                                                                         height:
//                                                                             250,
//                                                                         child: Image
//                                                                             .network(
//                                                                           'http://45.76.186.233:8000/api/v1/Images?pathImage=${i.medicalInstructions[index].image}',
//                                                                           fit: BoxFit
//                                                                               .fill,
//                                                                         ),
//                                                                       )
//                                                                     : (i.miTypeName.contains('Đơn thuốc') &&
//                                                                             i.medicalInstructions[index].medicalInstructionId !=
//                                                                                 null)
//                                                                         ? BlocProvider(
//                                                                             create: (context) => MedicalInstructionDetailBloc(medicalInstructionRepository: medicalInstructionRepository)
//                                                                               ..add(MedInsDetailEventGetById(id: i.medicalInstructions[index].medicalInstructionId)),
//                                                                             child:
//                                                                                 BlocBuilder<MedicalInstructionDetailBloc, MedInsDetailState>(
//                                                                               builder: (context, state) {
//                                                                                 //
//                                                                                 if (state is MedInsDetailStateLoading) {}
//                                                                                 if (state is MedInsDetailStateFailure) {}
//                                                                                 if (state is MedInsDetailStateSuccess) {
//                                                                                   //

//                                                                                   return Container(
//                                                                                     width: 150,
//                                                                                     height: 250,
//                                                                                     color: DefaultTheme.GREY_VIEW,
//                                                                                     padding: EdgeInsets.only(left: 5, right: 3, bottom: 35, top: 10),
//                                                                                     child: Column(
//                                                                                       children: [
//                                                                                         Text(
//                                                                                           '${state.dto.medicalInstructionType} từ hệ thống HDr',
//                                                                                           style: TextStyle(
//                                                                                             color: DefaultTheme.BLACK,
//                                                                                             fontWeight: FontWeight.w600,
//                                                                                             fontSize: 14,
//                                                                                           ),
//                                                                                         ),
//                                                                                         Spacer(),
//                                                                                         Center(
//                                                                                           child: Text(
//                                                                                             '${state.dto.diagnose}',
//                                                                                             style: TextStyle(
//                                                                                               fontSize: 16,
//                                                                                               fontWeight: FontWeight.w600,
//                                                                                               foreground: Paint()..shader = _normalHealthColors,
//                                                                                             ),
//                                                                                             textAlign: TextAlign.center,
//                                                                                           ),
//                                                                                         ),
//                                                                                         Spacer(),
//                                                                                         Text(
//                                                                                           'Kê ngày: ${_dateValidator.parseToDateView(state.dto.dateStarted).split(',')[0]}',
//                                                                                           style: TextStyle(
//                                                                                             color: DefaultTheme.GREY_TEXT,
//                                                                                             fontWeight: FontWeight.w600,
//                                                                                             fontSize: 11,
//                                                                                           ),
//                                                                                         ),
//                                                                                       ],
//                                                                                     ),
//                                                                                   );
//                                                                                 }
//                                                                                 return Container();
//                                                                               },
//                                                                             ),
//                                                                           )
//                                                                         : Center(
//                                                                             child:
//                                                                                 Text('Không có ảnh'),
//                                                                           ),
//                                                               ),
//                                                               Positioned(
//                                                                 bottom: 0,
//                                                                 child:
//                                                                     Container(
//                                                                   width: 150,
//                                                                   height: 30,
//                                                                   color: DefaultTheme
//                                                                       .WHITE
//                                                                       .withOpacity(
//                                                                           0.85),
//                                                                   child: Center(
//                                                                     child: Text(
//                                                                       '${i.miTypeName}',
//                                                                       overflow:
//                                                                           TextOverflow
//                                                                               .ellipsis,
//                                                                       maxLines:
//                                                                           1,
//                                                                       style: TextStyle(
//                                                                           fontWeight:
//                                                                               FontWeight.w500),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               //
//                                                               Positioned(
//                                                                 top: 0,
//                                                                 child:
//                                                                     Container(
//                                                                   width: 150,
//                                                                   height: 250,
//                                                                   color: DefaultTheme
//                                                                       .WHITE
//                                                                       .withOpacity(
//                                                                           0.2),
//                                                                 ),
//                                                               ),
//                                                               Positioned(
//                                                                   top: 0,
//                                                                   right: 0,
//                                                                   child:
//                                                                       // (checkingItem ==
//                                                                       //         false)
//                                                                       //     ?
//                                                                       InkWell(
//                                                                     child:
//                                                                         SizedBox(
//                                                                       width: 25,
//                                                                       height:
//                                                                           25,
//                                                                       child: Image
//                                                                           .asset(
//                                                                               'assets/images/ic-dot-unselect.png'),
//                                                                     ),
//                                                                     onTap: () {
//                                                                       if (!listMedicalInstructionIdsNewContract.contains(i
//                                                                           .medicalInstructions[
//                                                                               index]
//                                                                           .medicalInstructionId)) {
//                                                                         //
//                                                                         listMedicalInstructionIdsNewContract.add(i
//                                                                             .medicalInstructions[index]
//                                                                             .medicalInstructionId);
//                                                                         //

//                                                                         MiBoxDTO
//                                                                             miboxDTO =
//                                                                             MiBoxDTO(
//                                                                           imageUrl: i
//                                                                               .medicalInstructions[index]
//                                                                               .image,
//                                                                           miType:
//                                                                               i.miTypeName,
//                                                                           place:
//                                                                               placehr,
//                                                                         );
//                                                                         print(
//                                                                             'MI BOX DTO ${miboxDTO.toString()}');
//                                                                         //
//                                                                         listMiBox
//                                                                             .add(miboxDTO);
//                                                                         if (!listMedicalInstructionIdsNewContract
//                                                                             .isEmpty) {
//                                                                           dsDTO = Diseases(
//                                                                               diseaseId: idDiseaseSelected,
//                                                                               medicalInstructionIds: listMedicalInstructionIdsNewContract);
//                                                                         }
//                                                                       }

//                                                                       // print(
//                                                                       //     'SELECT ID ${i.medicalInstructions[index].medicalInstructionId}');
//                                                                       // print(
//                                                                       //     'LIST ID ${listMedicalInstructionIdsNewContract}');
//                                                                     },
//                                                                   )
//                                                                   // : InkWell(
//                                                                   //     child:
//                                                                   //         SizedBox(
//                                                                   //       width:
//                                                                   //           25,
//                                                                   //       height:
//                                                                   //           25,
//                                                                   //       child:
//                                                                   //           Image.asset('assets/images/ic-dot.png'),
//                                                                   //     ),
//                                                                   //     onTap:
//                                                                   //         () {},
//                                                                   //   ),
//                                                                   )
//                                                             ],
//                                                           ),
//                                                         );
//                                                       },
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),

//                                               // Row(
//                                               //   children: <Widget>[
//                                               //     Text('${i.miTypeName}'),
//                                               //     Spacer(),
//                                               // for(MedicalInstructions z in )
//                                               // for(MedicalInstructions z in i)Text(''),
//                                               //   ],
//                                               // ),
//                                             ),

//                                           Padding(
//                                               padding:
//                                                   EdgeInsets.only(bottom: 20)),
//                                         ],
//                                       );
//                                     });
//                               },
//                             ),
//                           ),
//                           Container(
//                             child: Column(
//                               children: [
//                                 //
//                                 Padding(
//                                   padding: EdgeInsets.only(bottom: 10),
//                                 ),
//                                 Text(
//                                   'Chọn phiếu y lệnh',
//                                   style: TextStyle(
//                                     color: DefaultTheme.BLACK,
//                                     fontSize: 25,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(bottom: 5),
//                                 ),
//                                 Text(
//                                   'Bước 2',
//                                   style: TextStyle(
//                                     color: DefaultTheme.GREY_TEXT,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(bottom: 10),
//                                 )
//                               ],
//                             ),
//                           ),

//                           Padding(
//                             padding: EdgeInsets.only(bottom: 15),
//                             child: ButtonHDr(
//                               onTap: () {
//                                 //
//                                 setState(() {
//                                   boxDiseaseDTO = DiseaseBoxDTO(
//                                     diseaseName:
//                                         '$idDiseaseSelected - $nameDiseaseSelected',
//                                     listMi: listMiBox,
//                                   );
//                                   //
//                                   if (!listMiBox.isEmpty) {
//                                     listDiseaseBox.add(boxDiseaseDTO);
//                                   }
//                                   if (listMedicalInstructionIdsNewContract
//                                           .length !=
//                                       0) {
//                                     listDiseasesNewContract.add(dsDTO);
//                                   }

//                                   print(
//                                       'LIST DISEASE NEW CONTRACT ${listDiseasesNewContract.toString()}\n');
//                                 });

//                                 Navigator.of(context).pop();
//                               },
//                               label: 'Xong',
//                               style: BtnStyle.BUTTON_BLACK,
//                             ),
//                           ),
//                         ]),
//                   ),
//                 ),
//               );
//             },
//           );
//         });
//   }

//   //FUNCTION GET DOCTOR BY DOCTOR ID
//   _getDoctorInfo() {
//     return BlocBuilder<DoctorInfoBloc, DoctorInfoState>(
//         builder: (context, state) {
//       if (state is DoctorInfoStateLoading) {
//         return Container(
//           margin: EdgeInsets.only(left: 20, right: 20),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(6),
//               color: DefaultTheme.GREY_BUTTON),
//           child: Center(
//             child: SizedBox(
//               width: 30,
//               height: 30,
//               child: Image.asset('assets/images/loading.gif'),
//             ),
//           ),
//         );
//       }
//       if (state is DoctorInfoStateFailure) {
//         return Container(
//           margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: DefaultTheme.GREY_BUTTON),
//           child: Padding(
//             padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
//             child: Text('Không tìm thấy bác sĩ',
//                 style: TextStyle(
//                   color: DefaultTheme.GREY_TEXT,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 )),
//           ),
//         );
//       }
//       if (state is DoctorInfoStateSuccess) {
//         if (state.dto == null) {
//           return Container(
//             margin: EdgeInsets.only(left: 20, right: 20),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(6),
//                 color: DefaultTheme.GREY_BUTTON),
//             child: Padding(
//               padding:
//                   EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
//               child: Text('Không tìm thấy bác sĩ',
//                   style: TextStyle(
//                     color: DefaultTheme.GREY_TEXT,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   )),
//             ),
//           );
//         }
//         _dname = state.dto.fullName;
//         _dplace = state.dto.workLocation;
//         _dSdt = state.dto.phone;
//         _dEmail = state.dto.email;
//         _dBirthDate = state.dto.dateOfBirth;
//         _dSpec = state.dto.specialization;
//         // _views.add(state.dto.fullName);
//         // _views.add(state.dto.workLocation);
//         // _views.add(state.dto.phone);
//         return Container(
//           margin: EdgeInsets.only(left: 20, right: 20),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(6),
//               color: DefaultTheme.GREY_BUTTON),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(top: 20),
//               ),
//               Row(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(left: 20),
//                     width: 120,
//                     child: Text(
//                       'Bác sĩ',
//                       style: TextStyle(
//                         color: DefaultTheme.GREY_TEXT,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 10),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width - (80 + 120 + 10),
//                     child: Text(
//                       '${state.dto.fullName}',
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 3,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 10),
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(left: 20),
//                     width: 120,
//                     child: Text(
//                       'Làm việc tại',
//                       style: TextStyle(
//                         color: DefaultTheme.GREY_TEXT,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 10),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width - (80 + 120 + 10),
//                     child: Text(
//                       '${state.dto.workLocation}',
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 3,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 10),
//               ),
//               Row(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(left: 20),
//                     width: 120,
//                     child: Text(
//                       'Chuyên khoa',
//                       style: TextStyle(
//                         color: DefaultTheme.GREY_TEXT,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 10),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width - (80 + 120 + 10),
//                     child: Text(
//                       '${state.dto.specialization}',
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 3,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 10),
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 30,
//                     margin: EdgeInsets.only(left: 20),
//                     width: 120,
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Chi tiết bác sĩ',
//                         style: TextStyle(
//                           color: DefaultTheme.GREY_TEXT,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 10),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width - (80 + 120 + 10),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         '${state.dto.details}',
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 3,
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: EdgeInsets.only(bottom: 20),
//               ),
//             ],
//           ),
//         );
//       }
//       return Container(
//         margin: EdgeInsets.only(left: 20, right: 20),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(6),
//             color: DefaultTheme.GREY_BUTTON),
//         child: Center(
//           child: Text('Không tìm thấy bác sĩ'),
//         ),
//       );
//     });
//   }

//   void _showDatePickerStart() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Center(
//           child: ClipRRect(
//             borderRadius: BorderRadius.all(Radius.circular(15)),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 width: MediaQuery.of(context).size.width - 20,
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 decoration: BoxDecoration(
//                   color: DefaultTheme.WHITE.withOpacity(0.6),
//                 ),
//                 child: Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Ngày bắt đầu',
//                           style: TextStyle(
//                             fontSize: 25,
//                             color: DefaultTheme.BLACK,
//                             decoration: TextDecoration.none,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: CupertinoDatePicker(
//                           mode: CupertinoDatePickerMode.date,
//                           minimumDate: DateTime.now(),
//                           onDateTimeChanged: (dateTime) {
//                             setState(() {
//                               _startDate = dateTime.toString().split(' ')[0];
//                             });
//                           }),
//                     ),
//                     ButtonHDr(
//                       style: BtnStyle.BUTTON_BLACK,
//                       label: 'Chọn',
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class ContractViewObj {
//   String dname = '';
//   String dplace = '';
//   String dSdt = '';
//   String dEmail = '';
//   String pname = '';
//   String pSdt = '';
//   String pGender = '';
//   String pCareer = '';
//   String pBirthdate = '';
//   String pAdd = '';
//   String dSpec = '';
//   List<DiseaseDTO> diseases = [];
//   String dBirthDate = '';
//   // List<MedicalInstructions> listMedInsChecked = [];
//   String note = '';
//   String sDate = '';
//   String duration = '';

//   ContractViewObj(
//       {this.dname,
//       this.dplace,
//       this.dSdt,
//       this.dEmail,
//       this.pname,
//       this.pSdt,
//       this.pGender,
//       this.pCareer,
//       this.dSpec,
//       this.pBirthdate,
//       this.diseases,
//       this.dBirthDate,
//       //  this.listMedInsChecked,
//       this.duration,
//       this.note,
//       this.pAdd,
//       this.sDate});
// }

// class RContractProvider extends ChangeNotifier {
//   ContractViewObj obj = new ContractViewObj(
//       pname: '',
//       dSdt: '',
//       dEmail: '',
//       diseases: [],
//       //   listMedInsChecked: [],
//       pGender: '',
//       dname: '',
//       dplace: '',
//       duration: '',
//       dBirthDate: '',
//       pCareer: '',
//       note: '',
//       dSpec: '',
//       pAdd: '',
//       pBirthdate: '',
//       pSdt: '',
//       sDate: '');

//   setProvider(
//       {String dname,
//       String dplace,
//       String dSdt,
//       String dEmail,
//       String pname,
//       String pCareer,
//       String pSdt,
//       String dBirthDate,
//       String pGender,
//       String dSpec,
//       String pBirthdate,
//       String pAdd,
//       List<DiseaseDTO> diseases,
//       // List<MedicalInstructions> listMedInsChecked,
//       String note,
//       String sDate,
//       String duration}) async {
//     this.obj.dname = dname;
//     this.obj.dplace = dplace;
//     this.obj.dSdt = dSdt;
//     this.obj.dEmail = dEmail;
//     this.obj.pname = pname;
//     this.obj.pSdt = pSdt;
//     this.obj.dSpec = dSpec;
//     this.obj.dBirthDate = dBirthDate;
//     this.obj.pCareer = pCareer;
//     this.obj.pGender = pGender;
//     this.obj.pBirthdate = pBirthdate;
//     this.obj.pAdd = pAdd;
//     this.obj.diseases = diseases;
//     //  this.obj.listMedInsChecked = listMedInsChecked;
//     this.obj.note = note;
//     this.obj.sDate = sDate;
//     this.obj.duration = duration;
//   }

//   ContractViewObj get getRProvider => obj;
// }

// class DiseaseBoxDTO {
//   String diseaseName;
//   List<MiBoxDTO> listMi;

//   DiseaseBoxDTO({this.diseaseName, this.listMi});
// }

// class MiBoxDTO {
//   String place;
//   String miType;
//   String imageUrl;

//   MiBoxDTO({this.place, this.miType, this.imageUrl});

//   @override
//   String toString() {
//     // TODO: implement toString
//     return 'place: $place - miType: $miType - imgUrl: $imageUrl';
//   }
// }
