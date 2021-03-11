import 'dart:io';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/utils/img_util.dart';

import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_bottom_sheet_field.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_chip_display.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_item.dart';
import 'package:capstone_home_doctor/commons/widgets/multiple_select_tag/multi_select_list_type.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_request_bloc.dart';

import 'package:capstone_home_doctor/features/contract/blocs/disease_list_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/doctor_info_bloc.dart';

import 'package:capstone_home_doctor/features/contract/events/disease_list_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_with_type_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_list_with_type_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_with_type_state.dart';
import 'package:capstone_home_doctor/models/med_ins_by_disease_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:capstone_home_doctor/features/contract/events/doctor_info_event.dart';

import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/repositories/disease_repository.dart';
import 'package:capstone_home_doctor/features/contract/repositories/doctor_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_request_state.dart';
import 'package:capstone_home_doctor/features/contract/states/disease_list_state.dart';
import 'package:capstone_home_doctor/features/contract/states/doctor_info_state.dart';
import 'package:capstone_home_doctor/features/information/blocs/patient_bloc.dart';
import 'package:capstone_home_doctor/features/information/events/patient_event.dart';
import 'package:capstone_home_doctor/features/information/repositories/patient_repository.dart';
import 'package:capstone_home_doctor/features/information/states/patient_state.dart';
import 'package:capstone_home_doctor/models/disease_dto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

final picker = ImagePicker();
String _medInsDefaultSelected = 'Chọn loại phiếu';
int indexSelectMedIns = 0;
final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
String _selectedHRType = '';
MedInsWithTypeListBloc _medInsWithTypeListBloc;

class RequestContract extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RequestContract();
  }
}

class _RequestContract extends State<RequestContract>
    with WidgetsBindingObserver {
  String _startDate = DateTime.now().toString().split(' ')[0];
  int _licenseId = 1;
  var _noteController = TextEditingController();
  List<String> _diseaseIds = [];
  List<int> _medinsId = [];
  String _note = '';
  //for list
  List<Object> listMedicalShare = [];
  List<PickedFile> imageFiles = [];

  //
  int _dayOfTrackingValue = 30;
  String _dayOfTrackingView = '1 tháng';

  RequestContractDTO reqContractDTO;
  DoctorRepository doctorRepository =
      DoctorRepository(httpClient: http.Client());
  ContractRepository requestContractRepository =
      ContractRepository(httpClient: http.Client());
  DiseaseRepository diseaseRepository =
      DiseaseRepository(httpClient: http.Client());
  PatientRepository patientRepository =
      PatientRepository(httpClient: http.Client());
  MedicalInstructionRepository medicalInstructionRepository =
      MedicalInstructionRepository(httpClient: http.Client());
  //
  DateValidator _dateValidator = DateValidator();
  //
  int _patientId = 0;
  //
  String medInsType = '';

  TextEditingController _searchDiseaseController = TextEditingController();

  //view to move next
  String _dname = '';
  String _dplace = '';
  String _dSdt = '';
  String _pname = '';
  String _pSdt = '';
  String _pBirthdate = '';
  String _pAdd = '';
  String _dEmail = '';
  String _pGender = '';

  ///
  String idDiseaseSelected = '';
  String nameDiseaseSelected = '';

  //List<DiseaseDTO> _listDiseaseView = [];
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _getPatientId();
    _medInsWithTypeListBloc = BlocProvider.of(context);
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) async {
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

  List<DiseaseDTO> _listDisease = [];
  List<DiseaseDTO> _listDiseaseSelected = [];
  //
  List<MedInsByDiseaseDTO> _medInswithType = [];
  //List<MedInsByDiseaseDTO> _medInswithTypeSelected = [];
  //List<MedicalInstructionTypes> listMedInsChecked = [];
  List<int> listMedInsCheckedID = [];

  //
  bool isCheckedSelectedBox = false;

  _updateAcceptState() {
    setState(() {
      isCheckedSelectedBox = !isCheckedSelectedBox;
    });
  }

  @override
  Widget build(BuildContext context) {
    //

    //idDoctor
    String arguments = ModalRoute.of(context).settings.arguments;
    //
    final requestContractProvider =
        Provider.of<RequestContractDTOProvider>(context, listen: false);
    requestContractProvider.setProvider(
      doctorId: int.parse(arguments.trim()),
      patientId: _patientId,
      dateStarted: _startDate,
      licenseId: 1,
      note: _note,
      diseaseIds: _diseaseIds,
      medicalInstructionIds: listMedInsCheckedID,
    );

    final rContractViewProvider =
        Provider.of<RContractProvider>(context, listen: false);
    rContractViewProvider.setProvider(
        dname: _dname,
        dplace: _dplace,
        dSdt: _dSdt,
        dEmail: _dEmail,
        pname: _pname,
        pSdt: _pSdt,
        diseases: _listDiseaseSelected,
        //  listMedInsChecked: listMedInsChecked,
        duration: _dayOfTrackingView,
        note: _note,
        pGender: _pGender,
        pAdd: _pAdd,
        pBirthdate: _pBirthdate,
        sDate: _startDate);

    return MultiBlocProvider(
      providers: [
        BlocProvider<DoctorInfoBloc>(
          create: (BuildContext context) =>
              DoctorInfoBloc(doctorAPI: doctorRepository),
        ),
        BlocProvider<RequestContractBloc>(
          create: (BuildContext context) => RequestContractBloc(
              requestContractAPI: requestContractRepository),
        ),
        BlocProvider<DiseaseListBloc>(
          create: (BuildContext context) =>
              DiseaseListBloc(diseaseRepository: diseaseRepository),
        ),
        BlocProvider<PatientBloc>(
          create: (BuildContext context) =>
              PatientBloc(patientRepository: patientRepository),
        ),
        BlocProvider<MedInsWithTypeListBloc>(
          create: (BuildContext context) => MedInsWithTypeListBloc(
              medicalInstructionRepository: medicalInstructionRepository),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                HeaderWidget(
                  title: 'Yêu cầu hợp đồng',
                  isMainView: false,
                  buttonHeaderType: ButtonHeaderType.BACK_HOME,
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 30),
                        child: Text(
                          'Thông tin bác sĩ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      BlocProvider(
                        create: (context) =>
                            DoctorInfoBloc(doctorAPI: doctorRepository)
                              ..add(DoctorInfoEventSetId(id: arguments)),
                        child: _getDoctorInfo(),
                      ),
                      //Patient info
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 5, left: 20, right: 20, top: 30),
                        child: Divider(
                          color: DefaultTheme.GREY_TEXT,
                          height: 0.1,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20, right: 60, bottom: 20),
                        child: Text(
                          'Các thông tin dưới đây được gửi tới bác sĩ trong trạng thái chờ xét duyệt.',
                          style: TextStyle(
                              color: DefaultTheme.GREY_TEXT,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      //
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: Text(
                          'Thông tin cá nhân',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),

                      _makePatientInfo(),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 5, left: 20, right: 20, top: 20),
                        child: Divider(
                          color: DefaultTheme.GREY_TEXT,
                          height: 0.1,
                        ),
                      ),

                      //following info
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 10),
                        child: Text(
                          'Thông tin theo dõi',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: 5, left: 20, right: 20),
                        child: Text(
                          'Ngày bắt đầu',
                          style: TextStyle(
                              color: DefaultTheme.BLACK_BUTTON,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: DefaultTheme.GREY_BUTTON),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                            ),
                            Text(
                              '${_startDate.split('-')[2]} tháng ${_startDate.split('-')[1]} năm ${_startDate.split('-')[0]}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Spacer(),
                            ButtonHDr(
                              label: 'Chọn',
                              style: BtnStyle.BUTTON_FULL,
                              image: Image.asset(
                                  'assets/images/ic-choose-date.png'),
                              width: 30,
                              height: 40,
                              labelColor: DefaultTheme.BLUE_REFERENCE,
                              bgColor: DefaultTheme.TRANSPARENT,
                              onTap: () {
                                _showDatePickerStart();
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                            )
                          ],
                        ),
                      ),

                      Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, bottom: 20, top: 30),
                          child: ButtonHDr(
                            label: 'Tiếp theo',
                            onTap: () {
                              // bool _isSend1st = false;
                              // if (_isSend1st) {
                              //   _views.clear();
                              // }
                              // _views.add(_startDate);
                              // _views.add(_listDiseaseSelected);
                              // _isSend1st = true;
                              Navigator.of(context).pushNamed(
                                  RoutesHDr.CONFIRM_CONTRACT_VIEW,
                                  arguments: {
                                    'REQUEST_OBJ':
                                        requestContractProvider.getProvider,
                                    'VIEWS_OBJ':
                                        rContractViewProvider.getRProvider,
                                  });
                            },
                          )),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  //make patient information
  _makePatientInfo() {
    // int _patientIdShared = await _authenticateHelper.getPatientId();
    if (_patientId != 0) {
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //in right way loading
            BlocProvider(
              create: (context4) =>
                  PatientBloc(patientRepository: patientRepository)
                    ..add(PatientEventSetId(id: _patientId)),
              child: BlocBuilder<PatientBloc, PatientState>(
                builder: (context4, state4) {
                  if (state4 is PatientStateLoading) {
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
                  if (state4 is PatientStateFailure) {
                    return Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, bottom: 10, top: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: DefaultTheme.GREY_BUTTON),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 20),
                        child: Text('Không thể tải thông tin cá nhân',
                            style: TextStyle(
                              color: DefaultTheme.GREY_TEXT,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    );
                  }
                  if (state4 is PatientStateSuccess) {
                    if (state4.dto == null) {
                      return Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, bottom: 10, top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: DefaultTheme.GREY_BUTTON),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          child: Text('Không thể tải thông tin cá nhân',
                              style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      );
                    }
                    String _gender = '';
                    if (state4.dto.gender == 'Nam') {
                      _gender = 'Ông';
                      _pGender = 'Nam';
                    }
                    if (state4.dto.gender == 'Nữ') {
                      _gender = 'Bà';
                      _pGender = 'Nữ';
                    }
                    // _views.add(state4.dto.gender);
                    // _views.add(state4.dto.fullName);
                    // _views.add(state4.dto.dateOfBirth);
                    // _views.add(state4.dto.address);

                    _pname = state4.dto.fullName;
                    _pSdt = state4.dto.phoneNumber;
                    _pBirthdate = state4.dto.dateOfBirth;
                    _pAdd = state4.dto.address;
                    return Container(
                      padding: EdgeInsets.only(
                          top: 20, bottom: 20, left: 20, right: 20),
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: DefaultTheme.GREY_VIEW),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Container(
                                width: 120,
                                child: Text(
                                  '$_gender',
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
                                width: MediaQuery.of(context).size.width -
                                    (80 + 120 + 10),
                                child: Text(
                                  '${state4.dto.fullName}',
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
                              Container(
                                width: 120,
                                child: Text(
                                  'Số điện thoại',
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
                                width: MediaQuery.of(context).size.width -
                                    (80 + 120 + 10),
                                child: Text(
                                  '${state4.dto.phoneNumber}',
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
                              Container(
                                width: 120,
                                child: Text(
                                  'Sinh ngày',
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
                                width: MediaQuery.of(context).size.width -
                                    (80 + 120 + 10),
                                child: Text(
                                  '${_dateValidator.parseToDateView(state4.dto.dateOfBirth)}',
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
                              Container(
                                width: 120,
                                child: Text(
                                  'ĐC thường trú',
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
                                width: MediaQuery.of(context).size.width -
                                    (80 + 120 + 10),
                                child: (state4.dto.address == null)
                                    ? Text(
                                        'Chưa cập nhật',
                                        style: TextStyle(
                                          color: DefaultTheme.GREY_TEXT,
                                          fontSize: 15,
                                        ),
                                      )
                                    : Text(
                                        '${state4.dto.address}',
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
                        ],
                      ),
                    );
                  }

                  return Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: DefaultTheme.GREY_BUTTON),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      child: Text('Không thể tải thông tin cá nhân',
                          style: TextStyle(
                            color: DefaultTheme.GREY_TEXT,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  );
                },
              ),
            ),
            //
            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
            //
            //
            //
            //
            Container(),
            InkWell(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  // color: DefaultTheme.GREY_VIEW,
                  border: Border.all(
                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                    width: 0.75,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'Chia sẻ hồ sơ bệnh lý +',
                    style: TextStyle(
                      color: DefaultTheme.BLUE_REFERENCE,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              onTap: () {
                //
                _showShareMedical();
              },
            ),
            //
            //
            //
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 10, top: 20),
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
                    placeHolder: 'Mô tả thêm các triệu chứng đang gặp',
                    controller: _noteController,
                    keyboardAction: TextInputAction.done,
                    onChange: (text) {
                      setState(() {
                        _note = text;
                      });
                      // _views.add(_note);
                    },
                    style: TFStyle.TEXT_AREA,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }

  _showShareMedical() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: this.context,
        backgroundColor: Colors.white.withOpacity(0),
        builder: (context) {
          //
          return StatefulBuilder(
            builder: (BuildContext context2, StateSetter setModalState) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: DefaultTheme.TRANSPARENT,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: DefaultTheme.WHITE,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //
                          Divider(
                            height: 1,
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            child: TextFieldHDr(
                                label: 'Tìm kiếm',
                                placeHolder: 'Nhập mã bệnh lý',
                                controller: _searchDiseaseController,
                                keyboardAction: TextInputAction.done,
                                style: TFStyle.NO_BORDER),
                          ),
                          Divider(
                            height: 1,
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                          ),
                          Expanded(
                            child: BlocProvider(
                              create: (context2) => DiseaseListBloc(
                                  diseaseRepository: diseaseRepository)
                                ..add(DiseaseListEventSetStatus(
                                    status: 'ACTIVE')),
                              child: BlocBuilder<DiseaseListBloc,
                                      DiseaseListState>(
                                  builder: (context2, state2) {
                                if (state2 is DiseaseListStateLoading) {
                                  return Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
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
                                if (state2 is DiseaseListStateSuccess) {
                                  if (state2.listDisease == null) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          bottom: 10,
                                          top: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                return ListView.builder(
                                    // shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: _listDisease.length,
                                    itemBuilder:
                                        (BuildContext buildContext, int index) {
                                      return InkWell(
                                        onTap: () {
                                          //
                                          setState(() {
                                            idDiseaseSelected =
                                                _listDisease[index].diseaseId;
                                            nameDiseaseSelected =
                                                _listDisease[index].name;
                                          });
                                          _medInsWithTypeListBloc.add(
                                              MedInsWithTypeEventGetList(
                                                  patientId: _patientId,
                                                  diseaseId:
                                                      idDiseaseSelected));
                                          Navigator.of(context).pop();
                                          _showShareMedicalStep2();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            // color: DefaultTheme.GREY_VIEW,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            border: Border.all(
                                              color:
                                                  DefaultTheme.GREY_TOP_TAB_BAR,
                                              width: 0.75,
                                            ),
                                          ),
                                          height: 50,
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${_listDisease[index].diseaseId} - ${_listDisease[index].name}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      );
                                    });

                                ///
                              }),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                          ),
                          Container(
                            child: Column(
                              children: [
                                //
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                ),
                                Text(
                                  'Chọn bệnh lý',
                                  style: TextStyle(
                                    color: DefaultTheme.BLACK,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Bước 1',
                                  style: TextStyle(
                                    color: DefaultTheme.GREY_TEXT,
                                    fontSize: 16,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 50),
                                )
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(bottom: 15),
                          //   child: ButtonHDr(
                          //     onTap: () {
                          //       Navigator.of(context).pop();
                          //       _showShareMedicalStep2();
                          //     },
                          //     label: 'Tiếp theo',
                          //     style: BtnStyle.BUTTON_GREY,
                          //   ),
                          // ),
                        ]),
                  ),
                ),
              );
            },
          );
        });
  }

  _showShareMedicalStep2() {
    String _imgString = '';
    List<String> imgStrings = [];
    PickedFile _imgFile;
    showModalBottomSheet(
        isScrollControlled: true,
        context: this.context,
        backgroundColor: Colors.white.withOpacity(0),
        builder: (context) {
          //
          return StatefulBuilder(
            builder: (BuildContext context2, StateSetter setModalState) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: DefaultTheme.TRANSPARENT,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: DefaultTheme.WHITE,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 100,
                                child: Text(
                                  'Mã bệnh: ',
                                  style: TextStyle(
                                    color: DefaultTheme.GREY_TEXT,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                '$idDiseaseSelected',
                                style: TextStyle(
                                  color: DefaultTheme.BLACK,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 100,
                                child: Text(
                                  'Bệnh lý: ',
                                  style: TextStyle(
                                    color: DefaultTheme.GREY_TEXT,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Text(
                                  '$nameDiseaseSelected',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: DefaultTheme.BLACK,
                                    fontSize: 16,
                                    // fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                          ),
//
//FOR ADD MULTIPLE Image
                          // Container(
                          //   width: MediaQuery.of(context).size.width,
                          //   height: 120,
                          //   child: ListView(
                          //       // This next line does the trick.
                          //       scrollDirection: Axis.horizontal,
                          //       children: <Widget>[
                          //         // (_imgString == '')
                          //         //     ? Container()
                          //         //     : ClipRRect(
                          //         //         borderRadius:
                          //         //             BorderRadius.circular(10),
                          //         //         child: SizedBox(
                          //         //             width: 120,
                          //         //             height: 120,
                          //         //             child: ImageUltility
                          //         //                 .imageFromBase64String(
                          //         //                     _imgString)),
                          //         //       ),
                          //         // for (String i in imgStrings)
                          //         //   (i == null)
                          //         //       ? Container()
                          //         //       : Padding(
                          //         //           padding: EdgeInsets.only(left: 10),
                          //         //           child: ClipRRect(
                          //         //             borderRadius:
                          //         //                 BorderRadius.circular(10),
                          //         //             child: SizedBox(
                          //         //                 width: 120,
                          //         //                 height: 120,
                          //         //                 child: ImageUltility
                          //         //                     .imageFromBase64String(
                          //         //                         i)),
                          //         //           ),
                          //         //         ),

                          //         Padding(
                          //           padding: EdgeInsets.only(left: 10),
                          //         ),
                          //         InkWell(
                          //           child: Container(
                          //             width: 120,
                          //             height: 120,
                          //             decoration: BoxDecoration(
                          //               color: DefaultTheme.TRANSPARENT,
                          //               border: Border.all(
                          //                 color: DefaultTheme.GREY_TOP_TAB_BAR,
                          //                 width: 0.5,
                          //               ),
                          //               borderRadius: BorderRadius.circular(10),
                          //             ),
                          //             child: Center(
                          //               child: Text(
                          //                 'Thêm ảnh +',
                          //                 style: TextStyle(
                          //                     fontSize: 12,
                          //                     color:
                          //                         DefaultTheme.BLUE_REFERENCE),
                          //               ),
                          //             ),
                          //           ),
                          //           onTap: () async {
                          //             var pickedFile = await picker.getImage(
                          //                 source: ImageSource.gallery);
                          //             setModalState(() {
                          //               if (pickedFile != null) {
                          //                 //
                          //                 //  _imgFile = pickedFile;
                          //                 //
                          //                 _imgString =
                          //                     ImageUltility.base64String(
                          //                         File(pickedFile.path)
                          //                             .readAsBytesSync());
                          //                 imgStrings.add(_imgString);
                          //                 //imageFiles.add(_imgFile);
                          //               } else {
                          //                 print('No image selected.');
                          //               }
                          //             });
                          //           },
                          //         ),
                          //       ]),
                          // ),

                          //
                          // Spacer(),
                          Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Divider(
                              height: 1,
                              color: DefaultTheme.GREY_TOP_TAB_BAR,
                            ),
                          ),
                          Expanded(
                            child: BlocBuilder<MedInsWithTypeListBloc,
                                MedInsWithTypeState>(
                              builder: (context, state) {
                                if (state is MedInsWithTypeStateLoading) {
                                  return Container(
                                    width: 200,
                                    height: 200,
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                          'assets/images/loading.gif'),
                                    ),
                                  );
                                }
                                if (state is MedInsWithTypeStateFailure) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                          child:
                                              Text('Không thể tải danh sách')));
                                }
                                if (state is MedInsWithTypeStateSuccess) {
                                  //
                                  _medInswithType = state.listMedInsWithType;
                                }
                                return ListView.builder(
                                    itemCount: _medInswithType.length,
                                    itemBuilder:
                                        (BuildContext buildContext, int index) {
                                      //
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          //
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                width: 80,
                                                height: 30,
                                                child: Text(
                                                  'Nơi khám: ',
                                                  style: TextStyle(
                                                    color:
                                                        DefaultTheme.GREY_TEXT,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 30,
                                                child: Text(
                                                  '${_medInswithType[index].healthRecordPlace}',
                                                  style: TextStyle(
                                                    color: DefaultTheme.BLACK,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          for (MedicalInstructionTypes i
                                              in _medInswithType[index]
                                                  .medicalInstructionTypes)
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: DefaultTheme.GREY_VIEW,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Text('${i.miTypeName}'),
                                                  Spacer(),
                                                  // for(MedicalInstructions z in )
                                                  // for(MedicalInstructions z in i)Text(''),
                                                ],
                                              ),
                                            ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 20)),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                //
                                Text(
                                  'Chọn phiếu y lệnh',
                                  style: TextStyle(
                                    color: DefaultTheme.BLACK,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Bước 2',
                                  style: TextStyle(
                                    color: DefaultTheme.GREY_TEXT,
                                    fontSize: 16,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: ButtonHDr(
                              onTap: () {
                                //
                                Navigator.of(context).pop();
                              },
                              label: 'Xong',
                              style: BtnStyle.BUTTON_BLACK,
                            ),
                          ),
                        ]),
                  ),
                ),
              );
            },
          );
        });
  }

//
  // _showPopupChoosingMedInsList(List<MedicalInstructionByTypeDTO> list) {
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: this.context,
  //       backgroundColor: Colors.white.withOpacity(0),
  //       builder: (context) {
  //         return StatefulBuilder(
  //             builder: (BuildContext context2, StateSetter setModalState) {
  //           return BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
  //             child: Container(
  //               color: DefaultTheme.TRANSPARENT,
  //               child: Container(
  //                 height: 500,
  //                 padding: EdgeInsets.only(left: 20, right: 20),
  //                 decoration: BoxDecoration(
  //                   color: DefaultTheme.WHITE,
  //                   borderRadius: BorderRadius.circular(15),
  //                 ),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: <Widget>[
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Padding(
  //                           padding: EdgeInsets.only(top: 40, left: 0),
  //                           child: Text(
  //                             'Chia sẻ',
  //                             style: TextStyle(
  //                               color: DefaultTheme.BLACK,
  //                               fontSize: 20,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                         ),
  //                         Spacer(),
  //                         Container(
  //                           margin: EdgeInsets.only(left: 0, top: 40),
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(10),
  //                               color: DefaultTheme.GREY_VIEW),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               Padding(
  //                                 padding: EdgeInsets.only(left: 20),
  //                               ),
  //                               DropdownButton<MedicalInstructionByTypeDTO>(
  //                                 items: list
  //                                     .map((MedicalInstructionByTypeDTO value) {
  //                                   return new DropdownMenuItem<
  //                                       MedicalInstructionByTypeDTO>(
  //                                     value: value,
  //                                     child: new Text(
  //                                         value.medicalInstructionType),
  //                                   );
  //                                 }).toList(),
  //                                 hint: (medInsType == '')
  //                                     ? Text('Chọn loại phiếu')
  //                                     : Text('${medInsType}'),
  //                                 underline: Container(
  //                                   width: 0,
  //                                 ),
  //                                 onChanged: (_) {
  //                                   setModalState(() {
  //                                     medInsType = _.medicalInstructionType;
  //                                     indexSelectMedIns = list.indexOf(_);
  //                                     _selectedHRType = list[indexSelectMedIns]
  //                                         .medicalInstructionType;
  //                                   });
  //                                 },
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.only(right: 10),
  //                         ),
  //                       ],
  //                     ),

  //                     // (_selectedHRType == '')
  //                     //     ? Container(
  //                     //         height: 0,
  //                     //         width: 0,
  //                     //       )
  //                     //     : Container(
  //                     //         margin: EdgeInsets.only(top: 20, left: 0),
  //                     //         child: Text(
  //                     //           '${_selectedHRType}',
  //                     //           style: TextStyle(
  //                     //               fontSize: 22, fontWeight: FontWeight.w600),
  //                     //         ),
  //                     //       ),

  //                     // Text('${indexSelectMedIns}'),
  //                     Padding(
  //                       padding: EdgeInsets.only(top: 20),
  //                     ),
  //                     (indexSelectMedIns == null)
  //                         ? Container()
  //                         : ListView.builder(
  //                             shrinkWrap: true,
  //                             physics: NeverScrollableScrollPhysics(),
  //                             itemCount: list[indexSelectMedIns]
  //                                 .medicalInstructions
  //                                 .length,
  //                             itemBuilder:
  //                                 (BuildContext buildContext, int index) {
  //                               return Column(
  //                                 children: [
  //                                   Row(
  //                                     children: [
  //                                       Expanded(
  //                                         child: Container(
  //                                           margin: EdgeInsets.only(
  //                                               top: 5, bottom: 5),
  //                                           decoration: BoxDecoration(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                             color: DefaultTheme.GREY_VIEW,
  //                                           ),
  //                                           child: CheckboxListTile(
  //                                             title: Row(
  //                                               children: <Widget>[
  //                                                 Container(
  //                                                   width:
  //                                                       MediaQuery.of(context)
  //                                                               .size
  //                                                               .width -
  //                                                           158,
  //                                                   child: Text(
  //                                                     'Loại: ${list[indexSelectMedIns].medicalInstructionType}',
  //                                                     overflow:
  //                                                         TextOverflow.ellipsis,
  //                                                     maxLines: 2,
  //                                                   ),
  //                                                 ),
  //                                                 Spacer(),
  //                                                 SizedBox(
  //                                                   width: 30,
  //                                                   height: 40,
  //                                                   child: Image.network(
  //                                                     'http://45.76.186.233:8000/api/v1/Images?pathImage=${list[indexSelectMedIns].medicalInstructions[index].image}',
  //                                                     fit: BoxFit.fill,
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             value: list[indexSelectMedIns]
  //                                                 .medicalInstructions[index]
  //                                                 .check,
  //                                             onChanged: (bool newValue) {
  //                                               if (list.length > 0) {
  //                                                 BlocProvider.of<
  //                                                             MedInsWithTypeListBloc>(
  //                                                         context)
  //                                                     .add(
  //                                                   MedInsWithTypeSetChecking(
  //                                                     indexMedical:
  //                                                         indexSelectMedIns,
  //                                                     itemID: list[
  //                                                             indexSelectMedIns]
  //                                                         .medicalInstructions[
  //                                                             index]
  //                                                         .medicalInstructionId,
  //                                                     isCheck: newValue,
  //                                                     listMedical: list,
  //                                                   ),
  //                                                 );
  //                                               }
  //                                             },
  //                                             controlAffinity:
  //                                                 ListTileControlAffinity
  //                                                     .leading,
  //                                           ),
  //                                           //
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ],
  //                               );
  //                             }),
  //                     Spacer(),
  //                     Align(
  //                       alignment: Alignment.center,
  //                       child: ButtonHDr(
  //                         style: BtnStyle.BUTTON_BLACK,
  //                         label: 'Đồng ý',
  //                         onTap: () {
  //                           //
  //                           setState(() {
  //                             listMedInsChecked.clear();
  //                             listMedInsCheckedID.clear();
  //                             list.forEach((element) {
  //                               element.medicalInstructions.forEach((medical) {
  //                                 if (medical.check) {
  //                                   listMedInsChecked.add(medical);
  //                                   listMedInsCheckedID
  //                                       .add(medical.medicalInstructionId);
  //                                 }
  //                               });
  //                             });
  //                             print('listChecked: ${listMedInsChecked}');
  //                             print('listCheckedID: ${listMedInsCheckedID}');
  //                             _selectedHRType = '';
  //                             indexSelectMedIns = null;
  //                           });

  //                           Navigator.of(context).pop();
  //                         },
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.only(bottom: 20),
  //                     ),
  //                     //list selectBox
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         });
  //       });
  // }

  //validate state request
  _stateRequest() {
    return BlocBuilder<RequestContractBloc, RequestContractState>(
        builder: (context, state) {
      if (state is RequestContractStateLoading) {
        return _showDialogCustom('loading');
      }
      if (state is RequestContractStateFailure) {
        return _showDialogCustom('failed');
      }
      if (state is RequestContractStateSuccess) {
        if (state.isRequested == false) {
          return _showDialogCustom('failed');
        }
      }
      return _showDialogCustom('success');
    });
  }

  //show dialog
  _showDialogCustom(String status) {
    if (status == 'loading') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              //do for pop
              if (status != 'loading') {
                Navigator.of(context).pop();
              }
              return null;
            },
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: DefaultTheme.WHITE.withOpacity(0.6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                        ),
                        SizedBox(
                          child: Image.asset('assets/images/loading.gif'),
                          width: 80,
                          height: 80,
                        ),
                        Spacer(),
                        Text(
                          'Đang gửi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: DefaultTheme.BLACK,
                              fontSize: 15,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w400),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
    if (status == 'success') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              await Future.delayed(Duration(seconds: 3));
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(context, RoutesHDr.MAIN_HOME,
                  (Route<dynamic> route) => false);
              return null;
            },
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: DefaultTheme.WHITE.withOpacity(0.6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                        ),
                        SizedBox(
                          child: Image.asset('assets/images/ic-done.png'),
                          width: 80,
                          height: 80,
                        ),
                        Spacer(),
                        Text(
                          'Gửi yêu cầu thành công',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: DefaultTheme.BLACK,
                              fontSize: 15,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w400),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
    if (status == 'failed') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              await Future.delayed(Duration(seconds: 3));
              Navigator.of(context).pop;
            },
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: DefaultTheme.WHITE.withOpacity(0.6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                        ),
                        SizedBox(
                          child: Image.asset('assets/images/ic-failed.png'),
                          width: 80,
                          height: 80,
                        ),
                        Spacer(),
                        Text(
                          'Gửi yêu cầu thất bại',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: DefaultTheme.BLACK,
                              fontSize: 15,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w400),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  //FUNCTION GET DOCTOR BY DOCTOR ID
  _getDoctorInfo() {
    return BlocBuilder<DoctorInfoBloc, DoctorInfoState>(
        builder: (context, state) {
      if (state is DoctorInfoStateLoading) {
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
      if (state is DoctorInfoStateFailure) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: DefaultTheme.GREY_BUTTON),
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Text('Không tìm thấy bác sĩ',
                style: TextStyle(
                  color: DefaultTheme.GREY_TEXT,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
          ),
        );
      }
      if (state is DoctorInfoStateSuccess) {
        if (state.dto == null) {
          return Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: DefaultTheme.GREY_BUTTON),
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              child: Text('Không tìm thấy bác sĩ',
                  style: TextStyle(
                    color: DefaultTheme.GREY_TEXT,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          );
        }
        _dname = state.dto.fullName;
        _dplace = state.dto.workLocation;
        _dSdt = state.dto.phone;
        _dEmail = state.dto.email;

        // _views.add(state.dto.fullName);
        // _views.add(state.dto.workLocation);
        // _views.add(state.dto.phone);
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: DefaultTheme.GREY_BUTTON),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 120,
                    child: Text(
                      'Bác sĩ',
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
                    width: MediaQuery.of(context).size.width - (80 + 120 + 10),
                    child: Text(
                      '${state.dto.fullName}',
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
                padding: EdgeInsets.only(top: 5),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 120,
                    child: Text(
                      'Làm việc tại',
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
                    width: MediaQuery.of(context).size.width - (80 + 120 + 10),
                    child: Text(
                      '${state.dto.workLocation}',
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
                padding: EdgeInsets.only(bottom: 20),
              ),
            ],
          ),
        );
      }
      return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: DefaultTheme.GREY_BUTTON),
        child: Center(
          child: Text('Không tìm thấy bác sĩ'),
        ),
      );
    });
  }

  void _showDatePickerStart() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: DefaultTheme.WHITE.withOpacity(0.6),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ngày bắt đầu',
                          style: TextStyle(
                            fontSize: 25,
                            color: DefaultTheme.BLACK,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          minimumDate: DateTime.now(),
                          onDateTimeChanged: (dateTime) {
                            setState(() {
                              _startDate = dateTime.toString().split(' ')[0];
                            });
                          }),
                    ),
                    ButtonHDr(
                      style: BtnStyle.BUTTON_BLACK,
                      label: 'Chọn',
                      onTap: () {
                        Navigator.of(context).pop();
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
  }
}

class ContractViewObj {
  String dname = '';
  String dplace = '';
  String dSdt = '';
  String dEmail = '';
  String pname = '';
  String pSdt = '';
  String pGender = '';
  String pBirthdate = '';
  String pAdd = '';
  List<DiseaseDTO> diseases = [];
  // List<MedicalInstructions> listMedInsChecked = [];
  String note = '';
  String sDate = '';
  String duration = '';

  ContractViewObj(
      {this.dname,
      this.dplace,
      this.dSdt,
      this.dEmail,
      this.pname,
      this.pSdt,
      this.pGender,
      this.pBirthdate,
      this.diseases,
      //  this.listMedInsChecked,
      this.duration,
      this.note,
      this.pAdd,
      this.sDate});
}

class RContractProvider extends ChangeNotifier {
  ContractViewObj obj = new ContractViewObj(
      pname: '',
      dSdt: '',
      dEmail: '',
      diseases: [],
      //   listMedInsChecked: [],
      pGender: '',
      dname: '',
      dplace: '',
      duration: '',
      note: '',
      pAdd: '',
      pBirthdate: '',
      pSdt: '',
      sDate: '');

  setProvider(
      {String dname,
      String dplace,
      String dSdt,
      String dEmail,
      String pname,
      String pSdt,
      String pGender,
      String pBirthdate,
      String pAdd,
      List<DiseaseDTO> diseases,
      // List<MedicalInstructions> listMedInsChecked,
      String note,
      String sDate,
      String duration}) async {
    this.obj.dname = dname;
    this.obj.dplace = dplace;
    this.obj.dSdt = dSdt;
    this.obj.dEmail = dEmail;
    this.obj.pname = pname;
    this.obj.pSdt = pSdt;
    this.obj.pGender = pGender;
    this.obj.pBirthdate = pBirthdate;
    this.obj.pAdd = pAdd;
    this.obj.diseases = diseases;
    //  this.obj.listMedInsChecked = listMedInsChecked;
    this.obj.note = note;
    this.obj.sDate = sDate;
    this.obj.duration = duration;
  }

  ContractViewObj get getRProvider => obj;
}
