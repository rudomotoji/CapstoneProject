import 'dart:ui';
import 'package:capstone_home_doctor/services/medical_instruction_helper.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:capstone_home_doctor/services/notifications_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/health_record_detail_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_create_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/hr_detail_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_create_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_list_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/hr_detail_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_list_state.dart';
import 'package:capstone_home_doctor/features/health/medical_share/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/health/medical_share/events/medical_Share_event.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/health_record_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final MedicalInstructionHelper _medicalInstructionHelper =
    MedicalInstructionHelper();

class HealthRecordDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HealthRecordDetail();
  }
}

class _HealthRecordDetail extends State<HealthRecordDetail>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  DateValidator _dateValidator = DateValidator();
  HealthRecordHelper _healthRecordHelper = HealthRecordHelper();
  int _hrId = 0;
  final picker = ImagePicker();
  var uuid = Uuid();

  //
  int _indexTab = 0;

  TabController controller;

  HealthRecordRepository healthRecordRepository =
      HealthRecordRepository(httpClient: http.Client());
  MedicalInstructionRepository medicalInstructionRepository =
      MedicalInstructionRepository(httpClient: http.Client());

  HealthRecordDetailBloc _healthRecordDetailBloc;
  MedicalInstructionListBloc _medicalInstructionListBloc;
  MedInsCreateBloc _medInsCreateBloc;
  MedicalShareInsBloc _medicalShareInsBloc;

  // List<MedicalInstructionDTO> listMedicalIns = [];
  List<MedicalInsGroup> listGroupMedIns = [];
  HealthRecordDTO _healthRecordDTO;
  Stream<ReceiveNotification> _notificationsStream;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    // controller = new TabController(length: 1, vsync: this);

    // listMedicalIns = [];
    _healthRecordDetailBloc = BlocProvider.of(context);
    _medicalInstructionListBloc = BlocProvider.of(context);
    _medInsCreateBloc = BlocProvider.of(context);
    _medicalShareInsBloc = BlocProvider.of(context);
    getHRId();

    _notificationsStream = NotificationsBloc.instance.notificationsStream;
    _notificationsStream.listen((notification) {
      _pullRefresh();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _medicalShareInsBloc.add(MedicalShareInsEventInitial());
    _medInsCreateBloc.add(MedInsGetTextEventInitial());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _medicalInstructionHelper.getCheckToCreateOrList().then((check) async {
          //
          if (check) {
            ///CODE HERE FOR NAVIGATE
            ///
            int currentIndex = 2;
            Navigator.of(context).pushNamedAndRemoveUntil(
                RoutesHDr.MAIN_HOME, (Route<dynamic> route) => false,
                arguments: currentIndex);

            ///
            await _medicalInstructionHelper.updateCheckToCreateOrList(false);
          } else {
            Navigator.pop(context);
            await _medicalInstructionHelper.updateCheckToCreateOrList(false);
          }
        });
        return new Future(() => false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              HeaderWidget(
                title: 'Chi tiết hồ sơ',
                isMainView: false,
                buttonHeaderType: ButtonHeaderType.BACK_HOME,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          _indexTab = 0;
                        });
                      },
                      child: Container(
                          width: 150,
                          height: 40,
                          child: Center(
                            child: Text(
                              'Thông tin hồ sơ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: (_indexTab == 1)
                                      ? FontWeight.normal
                                      : FontWeight.w500,
                                  decoration: (_indexTab == 1)
                                      ? TextDecoration.underline
                                      : null),
                            ),
                          ),
                          decoration: (_indexTab == 1)
                              ? null
                              : BoxDecoration(
                                  boxShadow: [
                                      BoxShadow(
                                        color: DefaultTheme.GREY_TOP_TAB_BAR
                                            .withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: Offset(
                                            5, 3), // changes position of shadow
                                      ),
                                    ],
                                  color: DefaultTheme.GREY_VIEW,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))
                                  // border: Border.all(
                                  //     width: 1,
                                  //     color: DefaultTheme.GREY_TOP_TAB_BAR),
                                  )),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          _indexTab = 1;
                        });
                      },
                      child: Container(
                        width: 150,
                        height: 40,
                        child: Center(
                          child: Text(
                            'Danh sách y lệnh',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: (_indexTab == 0)
                                    ? FontWeight.normal
                                    : FontWeight.w500,
                                decoration: (_indexTab == 0)
                                    ? TextDecoration.underline
                                    : null),
                          ),
                        ),
                        decoration: (_indexTab == 0)
                            ? null
                            : BoxDecoration(
                                boxShadow: [
                                    BoxShadow(
                                      color: DefaultTheme.GREY_TOP_TAB_BAR
                                          .withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: Offset(
                                          -5, 3), // changes position of shadow
                                    ),
                                  ],
                                color: DefaultTheme.GREY_VIEW,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))
                                // border: Border.all(
                                //     width: 1,
                                //     color: DefaultTheme.GREY_TOP_TAB_BAR),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  child: ListView(
                    children: [
                      (_indexTab == 0)
                          ? Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 20, bottom: 20),
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 50),
                              decoration: BoxDecoration(
                                  color: DefaultTheme.GREY_VIEW,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              width: MediaQuery.of(context).size.width,
                              child: _buildHealthRecordInfo(),
                            )
                          : Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 20, bottom: 20),
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: DefaultTheme.GREY_VIEW),
                              width: MediaQuery.of(context).size.width,
                              child: buildTabbarViewHasContract(),
                            ),
                      // Container(
                      //   child: (_healthRecordDTO != null)
                      //       ? Container(
                      //           height:
                      //               MediaQuery.of(context).size.height * 0.85,
                      //           child: CustomScrollView(
                      //             physics: NeverScrollableScrollPhysics(),
                      //             slivers: [
                      //               buildSliverToBoxAdapterHeader(),
                      //               buildSliverAppBarCollepse(),
                      //               buildTabbarViewHasContract(),
                      //             ],
                      //           ),
                      //         )
                      //       : Container(
                      //           width: MediaQuery.of(context).size.width,
                      //           child: Center(
                      //             child: Text(
                      //               'Không thể tải danh sách hồ sơ',
                      //             ),
                      //           ),
                      //         ),
                      // ),
                    ],
                  ),
                  onRefresh: _pullRefresh,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: buttonAddMedicalIns(),
        floatingActionButtonLocation: (_healthRecordDTO == null)
            ? null
            : (_healthRecordDTO.contractStatus != null)
                ? FloatingActionButtonLocation.endDocked
                : FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  _buildHealthRecordInfo() {
    return (_healthRecordDTO == null || _healthRecordDTO.place == null)
        ? Container()
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    //
                    SizedBox(
                      width: 15,
                      child: Image.asset('assets/images/ic-map.png'),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 70,
                        child: Text('Nơi khám')),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width - 145,
                      child: Text(
                        '${_healthRecordDTO.place}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: DefaultTheme.GREY_TOP_TAB_BAR,
                height: 1,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    //
                    SizedBox(
                      width: 15,
                      child: Image.asset('assets/images/ic-calendar.png'),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 70,
                        child: Text('Ngày bắt đầu')),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width - 145,
                      child: Text(
                        (_healthRecordDTO.dateStarted == null)
                            ? ''
                            : '${_dateValidator.parseToDateView(_healthRecordDTO.dateStarted)}',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: DefaultTheme.GREY_TOP_TAB_BAR,
                height: 1,
              ),
              //
              Container(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    //
                    SizedBox(
                      width: 15,
                      child: Image.asset('assets/images/ic-add-disease.png'),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Bệnh lý có trong hồ sơ')),
                  ],
                ),
              ),
              _genderDiseases(),
              (_healthRecordDTO.description != null &&
                      _healthRecordDTO.description != '')
                  ? Divider(
                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                      height: 1,
                    )
                  : Container(),
              (_healthRecordDTO.description != null &&
                      _healthRecordDTO.description != '')
                  ? Container(
                      padding: EdgeInsets.only(bottom: 10, top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          //
                          SizedBox(
                            width: 15,
                            child: Image.asset('assets/images/ic-note.png'),
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 10),
                              width: 150,
                              child: Text('Thông tin thêm')),
                        ],
                      ),
                    )
                  : Container(),
              (_healthRecordDTO.description != null &&
                      _healthRecordDTO.description != '')
                  ? Container(
                      padding: EdgeInsets.only(left: 25),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        '${_healthRecordDTO.description}',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    )
                  : Container(),
            ],
          );
  }

  _genderDiseases() {
    //
    return (_healthRecordDTO == null ||
            _healthRecordDTO.diseases.length == 0 ||
            _healthRecordDTO.diseases == null)
        ? Container()
        : ListView.builder(
            itemCount: _healthRecordDTO.diseases.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                width: MediaQuery.of(context).size.width - 40,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 25),
                    ),
                    Container(
                        width: 50,
                        child: Text(
                            '${_healthRecordDTO.diseases[index].diseaseId}',
                            style: TextStyle(
                              color: DefaultTheme.BLUE_DARK,
                              fontWeight: FontWeight.w500,
                            ))),
                    Container(
                        width: MediaQuery.of(context).size.width - 135,
                        child: Text(
                            '${_healthRecordDTO.diseases[index].diseaseName}'))
                  ],
                ),
              );
            },
          );
  }

  buttonAddMedicalIns() {
    if (_healthRecordDTO == null) {
      return Container();
    } else if (_healthRecordDTO.contractStatus != null) {
      // if (_healthRecordDTO.contractStatus.contains('FINISHED') ||
      //     _healthRecordDTO.contractStatus.contains('LOCKED')) {
      //   return Container();
      // } else {
      //   return FloatingActionButton.extended(
      //     elevation: 3,
      //     label: Text('Y lệnh mới',
      //         style: TextStyle(color: DefaultTheme.BLUE_DARK)),
      //     backgroundColor: DefaultTheme.GREY_VIEW,
      //     icon: SizedBox(
      //       width: 20,
      //       height: 20,
      //       child: Image.asset('assets/images/ic-medical-instruction.png'),
      //     ),
      //     onPressed: () {
      //       Navigator.of(context)
      //           .pushNamed(RoutesHDr.CREATE_MEDICAL_INSTRUCTION,
      //               arguments: _healthRecordDTO.diseases)
      //           .then((value) async {
      //         await _pullRefresh();
      //       });
      //     },
      //   );
      // }

      return Container(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        margin: EdgeInsets.only(bottom: 10),
        height: 70,
        decoration: BoxDecoration(
          color: DefaultTheme.GREY_VIEW,
          //border: Border.all(color: DefaultTheme.GREY_TOP_TAB_BAR, width: 1),
          boxShadow: [
            BoxShadow(
              color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(2, 2), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(25),
        ),
        width: MediaQuery.of(context).size.width * 0.3,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //
              Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              InkWell(
                onTap: () async {
                  await _medicalInstructionHelper
                      .updateCreateHRFromDetail(true);
                  Navigator.of(context)
                      .pushNamed(RoutesHDr.CREATE_HEALTH_RECORD);
                },
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset('assets/images/ic-add-hr2.png')),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      Text('Hồ sơ mới', style: TextStyle(fontSize: 12))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
              ),
            ]),
      );
    } else {
      return Container(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          margin: EdgeInsets.only(bottom: 10),
          height: 70,
          decoration: BoxDecoration(
            color: DefaultTheme.GREY_VIEW,
            //border: Border.all(color: DefaultTheme.GREY_TOP_TAB_BAR, width: 1),
            boxShadow: [
              BoxShadow(
                color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(2, 2), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(50),
          ),
          width: MediaQuery.of(context).size.width * 0.72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              InkWell(
                onTap: () async {
                  await _medicalInstructionHelper
                      .updateCreateHRFromDetail(true);
                  Navigator.of(context)
                      .pushNamed(RoutesHDr.CREATE_HEALTH_RECORD);
                },
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset('assets/images/ic-add-hr2.png')),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      Text('Hồ sơ mới', style: TextStyle(fontSize: 12))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RoutesHDr.CREATE_MEDICAL_INSTRUCTION,
                          arguments: _healthRecordDTO.diseases)
                      .then((value) async {
                    await _pullRefresh();
                  });
                },
                child: Container(
                    child: Column(
                  children: [
                    SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset('assets/images/ic-add-mi2.png')),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    Text('Thêm y lệnh', style: TextStyle(fontSize: 12))
                  ],
                )),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              InkWell(
                onTap: () async {
                  Navigator.of(context)
                      .pushNamed(RoutesHDr.UPDATE_HEALTH_RECORD,
                          arguments: _hrId)
                      .then((value) => _pullRefresh());
                },
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset('assets/images/ic-edit-hr2.png')),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      Text('Sửa hồ sơ', style: TextStyle(fontSize: 12))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
              ),
            ],
          ));
      // return FloatingActionButton.extended(
      //   elevation: 3,
      //   label:
      //       Text('Y lệnh mới', style: TextStyle(color: DefaultTheme.BLUE_DARK)),
      //   backgroundColor: DefaultTheme.GREY_VIEW,
      //   icon: SizedBox(
      //     width: 20,
      //     height: 20,
      //     child: Image.asset('assets/images/ic-medical-instruction.png'),
      //   ),
      //   onPressed: () {
      //     Navigator.of(context)
      //         .pushNamed(RoutesHDr.CREATE_MEDICAL_INSTRUCTION,
      //             arguments: _healthRecordDTO.diseases)
      //         .then((value) async {
      //       await _pullRefresh();
      //     });
      //   },
      // );
    }
  }

  SliverAppBar buildSliverAppBarCollepse() {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: DefaultTheme.WHITE,
      title: TabBar(
        labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            foreground: Paint()..shader = _normalHealthColors),
        indicatorPadding: EdgeInsets.only(left: 20),
        unselectedLabelStyle:
            TextStyle(color: DefaultTheme.BLACK.withOpacity(0.6)),
        indicatorColor: Colors.white.withOpacity(0.0),
        controller: controller,
        tabs: [
          Tab(
            child: Container(
              height: 25,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Danh sách y lệnh',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter buildSliverToBoxAdapterHeader() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: DefaultTheme.GREY_VIEW,
                ),
                child: Column(
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
                            'Bệnh lý ',
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
                              (155 + 40 + 10),
                          child: Text(
                            (_healthRecordDTO.diseases.length > 0)
                                ? '${getDisease(_healthRecordDTO.diseases)}'
                                : '', //lấy tên bệnh lý
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
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
                      padding: EdgeInsets.only(
                        bottom: 10,
                        top: 10,
                        left: 30,
                        right: 30,
                      ),
                      child: Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 1,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        Container(
                          width: 125,
                          child: Text(
                            'Nơi khám ',
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
                              (155 + 40 + 10),
                          child: Text(
                            '${_healthRecordDTO.place}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10,
                        top: 10,
                        left: 30,
                        right: 30,
                      ),
                      child: Divider(
                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                        height: 1,
                      ),
                    ),
                    (_healthRecordDTO.description != '')
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              (_healthRecordDTO.description != null)
                                  ? Row(
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              (155 + 50),
                                          child: Text(
                                            '${_healthRecordDTO.description}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
              ),
              buttonUpdateHealthRecord(),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              Divider(
                color: DefaultTheme.GREY_TOP_TAB_BAR,
                height: 0.1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  buttonUpdateHealthRecord() {
    if (_healthRecordDTO.contractId != null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.only(left: 30, bottom: 5, top: 5),
          child: Text(
            'Tạo ngày ${_dateValidator.parseToDateView(_healthRecordDTO.dateCreated)}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: DefaultTheme.BLUE_DARK, fontSize: 13),
          ),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 30, bottom: 5, top: 5),
              child: Text(
                'Tạo ngày ${_dateValidator.parseToDateView(_healthRecordDTO.dateCreated)}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: DefaultTheme.BLUE_DARK, fontSize: 13),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              InkWell(
                splashColor: DefaultTheme.TRANSPARENT,
                highlightColor: DefaultTheme.TRANSPARENT,
                onTap: () async {
                  Navigator.of(context)
                      .pushNamed(RoutesHDr.UPDATE_HEALTH_RECORD,
                          arguments: _hrId)
                      .then((value) => _pullRefresh());
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: DefaultTheme.GREY_VIEW,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Cập nhật hồ sơ',
                        style: TextStyle(
                            color: DefaultTheme.BLUE_DARK, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget buildTabbarViewHasContract() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child:
          BlocBuilder<MedicalInstructionListBloc, MedicalInstructionListState>(
        builder: (context, state) {
          if (state is MedicalInstructionListStateLoading) {
            return Container(
              width: 200,
              height: 200,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('assets/images/loading.gif'),
              ),
            );
          }
          if (state is MedicalInstructionListStateFailed) {
            return Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Text('Kiểm tra lại đường truyền kết nối mạng')));
          }
          if (state is MedicalInstructionListStateSuccess) {
            if (state.listMedIns != null || state.listMedIns.isNotEmpty) {
              listGroupMedIns.clear();

              List<MedicalInsGroup> listGroupMed = [];
              for (var item in state.listMedIns) {
                List<MedicalInstructionDTO> _listMedIns = [];
                MedicalInsGroup _medicalGroupItem = null;
                _listMedIns.add(item);
                if (listGroupMed.length <= 0) {
                  _medicalGroupItem = new MedicalInsGroup(
                      type: item.medicalInstructionType,
                      medicalInstructionTypeId: item.medicalInstructionTypeId,
                      listMedicalIns: _listMedIns);
                } else {
                  bool flag = false;
                  for (var element in listGroupMed) {
                    if (element.medicalInstructionTypeId ==
                        item.medicalInstructionTypeId) {
                      flag = true;
                      element.listMedicalIns.add(item);
                    }
                  }
                  if (!flag) {
                    _medicalGroupItem = MedicalInsGroup(
                        type: item.medicalInstructionType,
                        medicalInstructionTypeId: item.medicalInstructionTypeId,
                        listMedicalIns: _listMedIns);
                  }
                  flag = false;
                }
                if (_medicalGroupItem != null) {
                  listGroupMed.add(_medicalGroupItem);
                  _medicalGroupItem = null;
                }
              }

              listGroupMedIns = listGroupMed;
            }
          }
          return
              // _medicalInsert(),
              _medicalShare();
        },
      ),
    );
  }

  Widget _medicalShare() {
    if (listGroupMedIns.length > 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: listGroupMedIns.length,
          itemBuilder: (BuildContext context, int index) {
            var itemGroup = listGroupMedIns[index];
            return ExpansionTile(
                tilePadding: EdgeInsets.only(left: 0, right: 0),
                title: Text('${itemGroup.type}'),
                trailing: Icon(Icons.expand_more),
                children: itemGroup.listMedicalIns.map((e) {
                  return _itemRow(e);
                }).toList());
          },
        ),
      );
    } else {
      return Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 25,
                  height: 25,
                  child:
                      Image.asset('assets/images/ic-medical-instruction.png')),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              Text('Chưa có phiếu nào trong hồ sơ')
            ],
          ),
        ),
      );
    }
  }

  Widget _itemRow(MedicalInstructionDTO dto) {
    DateTime dateCreated = DateFormat('yyyy-MM-dd').parse(dto.dateCreate);
    return Container(
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // height: 180,
                      decoration: BoxDecoration(color: Colors.white,
                          //  borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10, color: DefaultTheme.GREY_VIEW)
                          ]),
                      // width:
                      //     MediaQuery.of(context).size.width - 70,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 15, bottom: 10),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (dto?.image != null) {
                                  showFullDetailComponent(
                                      dto.image,
                                      dto.medicalInstructionType,
                                      _dateValidator.convertDateCreate(
                                          dto.dateCreate,
                                          'dd/MM/yyyy',
                                          'yyyy-MM-ddThh:mm:ss'),
                                      dto.diagnose);
                                } else {
                                  if (dto.medicalInstructionTypeId == 1) {
                                    Navigator.pushNamed(context,
                                            RoutesHDr.MEDICAL_HISTORY_DETAIL,
                                            arguments: dto.medicalInstructionId)
                                        .then((value) async {
                                      // await _pullRefresh();
                                    });
                                  } else if (dto.medicalInstructionTypeId ==
                                      8) {
                                    _showDetailVitalSign(
                                        dto.medicalInstructionId);
                                  } else if (dto.medicalInstructionTypeId ==
                                      10) {
                                    _showDetailAppointment(
                                        dto.medicalInstructionId);
                                  }
                                }
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    width: 0.5,
                                  ),
                                ),
                                child: (dto?.image == null)
                                    ? Container(
                                        width: (70 * 1.5),
                                        height: (70 * 1.5),
                                        color: DefaultTheme.GREY_TOP_TAB_BAR,
                                        child: checkImageNull(dto),
                                      )
                                    : Stack(
                                        children: [
                                          Container(
                                            width: (70 * 1.5),
                                            height: (70 * 1.5),
                                            color:
                                                DefaultTheme.GREY_TOP_TAB_BAR,
                                            child: checkImageNull(dto),
                                          ),
                                          Positioned(
                                            top: 0,
                                            child: Container(
                                                width: (70 * 1.5),
                                                height: (70 * 1.5),
                                                color: DefaultTheme
                                                    .GREY_TOP_TAB_BAR
                                                    .withOpacity(0.2),
                                                child: Center(
                                                  child: Text(
                                                    (dto?.image.length > 1)
                                                        ? '${dto?.image.length}+'
                                                        : '',
                                                    style: TextStyle(
                                                        color:
                                                            DefaultTheme.WHITE),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (dto.diagnose == null)
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 80,
                                              child: Text(
                                                'Chẩn đoán:',
                                                style: TextStyle(
                                                    color:
                                                        DefaultTheme.GREY_TEXT),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  250,
                                              child: Text(
                                                '${dto.diagnose}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                  (dto.description != null)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            //
                                            Container(
                                              width: 80,
                                              child: Text(
                                                'Ghi chú:',
                                                style: TextStyle(
                                                    color:
                                                        DefaultTheme.GREY_TEXT),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  250,
                                              child: Text(
                                                '${dto.description}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 160,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(dateCreated)}',
                                          style: TextStyle(
                                              color: DefaultTheme.BLACK,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 160,
                                    child: Text(
                                      'Bệnh lý: ${dto.diseases}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      style: TextStyle(
                                          color: DefaultTheme.BLACK,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                  ),
                                  (_healthRecordDTO.contractId == null)
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 2,
                                                  top: 2),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: checkColorStatus(
                                                    dto.status),
                                              ),
                                              child: Text(
                                                titleForStatusMI(dto.status),
                                                style: TextStyle(
                                                    color:
                                                        checkColorStatusForTitle(
                                                            dto.status),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                checkButtonMoreFuture(dto),
              ],
            ),
          ),
        ],
      ),
    );
  }

  checkButtonMoreFuture(MedicalInstructionDTO dto) {
    if (dto.status.contains('PATIENT') || dto.status.contains('PENDING')) {
      return Positioned(
        width: 35,
        height: 35,
        top: 7,
        right: 0,
        child: ButtonHDr(
          style: BtnStyle.BUTTON_IMAGE,
          image: Image.asset('assets/images/ic-more.png'),
          onTap: () {
            _showMorePopup(
                dto.medicalInstructionId, dto.medicalInstructionType);
          },
        ),
      );
    } else {
      return Container();
    }
  }

  checkImageNull(MedicalInstructionDTO dto) {
    int size = 20;
    if (dto.image == null) {
      if (dto.medicalInstructionTypeId == 1) {
        return Container(
          width: (size * 1.5),
          height: (size * 1.5),
          child: Image.asset('assets/images/ic-medicine.png'),
        );
      } else if (dto.medicalInstructionTypeId == 8) {
        return Container(
          width: (size * 1.5),
          height: (size * 1.5),
          child: Image.asset('assets/images/ic-health-selected.png'),
        );
      } else if (dto.medicalInstructionTypeId == 10) {
        return Container(
          width: (size * 1.5),
          height: (size * 1.5),
          child: Image.asset('assets/images/ic-calendar.png'),
        );
      } else {
        return Container(
            width: (size * 1.5),
            height: (size * 1.5),
            color: DefaultTheme.GREY_TOP_TAB_BAR);
      }
    } else {
      if (dto.image.length <= 0) {
        if (dto.medicalInstructionTypeId == 1) {
          return Container(
            width: (size * 1.5),
            height: (size * 1.5),
            child: Image.asset('assets/images/ic-medicine.png'),
          );
        } else if (dto.medicalInstructionTypeId == 8) {
          return Container(
            width: (size * 1.5),
            height: (size * 1.5),
            child: Image.asset('assets/images/ic-health-selected.png'),
          );
        } else if (dto.medicalInstructionTypeId == 10) {
          return Container(
            width: (size * 1.5),
            height: (size * 1.5),
            child: Image.asset('assets/images/ic-calendar.png'),
          );
        } else {
          return Container(
              width: (size * 1.5),
              height: (size * 1.5),
              color: DefaultTheme.GREY_TOP_TAB_BAR);
        }
      } else {
        return Image.network(
          'http://45.76.186.233:8000/api/v1/Images?pathImage=${dto?.image.first}',
          fit: BoxFit.fill,
        );
      }
    }
  }

  Future<void> _pullRefresh() async {
    await getHRId();
  }

  void _showDetailVitalSign(int medicalInstructionId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: 250,
                  height: 150,
                  decoration: BoxDecoration(
                    color: DefaultTheme.WHITE.withOpacity(0.7),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 130,
                        // height: 100,
                        child: Image.asset('assets/images/loading.gif'),
                      ),
                      // Spacer(),
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Vui lòng chờ chút',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: DefaultTheme.GREY_TEXT,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });

    medicalInstructionRepository
        .getMedicalInstructionById(medicalInstructionId)
        .then((value) {
      Navigator.pop(context);
      if (value != null) {
        if (value.vitalSignScheduleRespone != null) {
          var dateStarted = _dateValidator.convertDateCreate(
              value.vitalSignScheduleRespone.timeStared,
              'dd/MM/yyyy',
              "yyyy-MM-dd");
          var dateFinished = _dateValidator.convertDateCreate(
              value.vitalSignScheduleRespone.timeCanceled,
              'dd/MM/yyyy',
              "yyyy-MM-dd");

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width - 20,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        color: DefaultTheme.WHITE.withOpacity(0.6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                              ),
                              Text(
                                '${value.medicalInstructionType}',
                                style: TextStyle(
                                  fontSize: 30,
                                  decoration: TextDecoration.none,
                                  color: DefaultTheme.BLACK,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Divider(
                                  color: DefaultTheme.GREY_TEXT,
                                  height: 0.25,
                                ),
                                Padding(padding: EdgeInsets.only(top: 5)),
                                Text(
                                  'Người đặt: ${value.placeHealthRecord}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.none,
                                    color: DefaultTheme.GREY_TEXT,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: value.vitalSignScheduleRespone
                                        .vitalSigns.length,
                                    itemBuilder: (context, index) {
                                      var item = value.vitalSignScheduleRespone
                                          .vitalSigns[index];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Divider(
                                            color: DefaultTheme.GREY_TEXT,
                                            height: 0.25,
                                          ),
                                          Text(
                                            '${item.vitalSignType}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              decoration: TextDecoration.none,
                                              color: DefaultTheme.GREY_TEXT,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Chỉ số an toàn:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: DefaultTheme.GREY_TEXT,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                '${item.numberMin} - ${item.numberMax}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: DefaultTheme.GREY_TEXT,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Ngày bắt đầu: ${dateStarted}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              decoration: TextDecoration.none,
                                              color: DefaultTheme.GREY_TEXT,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            'Ngày Kết thúc: ${dateFinished}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              decoration: TextDecoration.none,
                                              color: DefaultTheme.GREY_TEXT,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                  ),
                                ),
                                Center(
                                  child: ButtonHDr(
                                    style: BtnStyle.BUTTON_BLACK,
                                    label: 'Chi tiết',
                                    onTap: () {
                                      Map<String, dynamic> arguments = {
                                        'healthRecordId': _hrId,
                                        'medicalInstructionId':
                                            medicalInstructionId,
                                        "timeStared": value
                                            .vitalSignScheduleRespone
                                            .timeStared,
                                        "timeCanceled": value
                                            .vitalSignScheduleRespone
                                            .timeCanceled,
                                      };
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context,
                                              RoutesHDr.VITAL_SIGN_CHART_DETAIL,
                                              arguments: arguments)
                                          .then((value) async {
                                        // await _pullRefresh();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          )
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
    });
  }

  void _showDetailAppointment(int medicalInstructionId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: 250,
                  height: 150,
                  decoration: BoxDecoration(
                    color: DefaultTheme.WHITE.withOpacity(0.7),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 130,
                        // height: 100,
                        child: Image.asset('assets/images/loading.gif'),
                      ),
                      // Spacer(),
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Vui lòng chờ',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: DefaultTheme.GREY_TEXT,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });

    medicalInstructionRepository
        .getMedicalInstructionById(medicalInstructionId)
        .then((value) {
      Navigator.pop(context);
      if (value != null) {
        print(value.appointmentDetail.appointmentId);
        if (value.appointmentDetail != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width - 20,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        color: DefaultTheme.WHITE.withOpacity(0.6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                              ),
                              Text(
                                '${value.medicalInstructionType}',
                                style: TextStyle(
                                  fontSize: 30,
                                  decoration: TextDecoration.none,
                                  color: DefaultTheme.BLACK,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Divider(
                                  color: DefaultTheme.GREY_TEXT,
                                  height: 0.25,
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  'Khám tại: ${value.placeHealthRecord}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.none,
                                    color: DefaultTheme.GREY_TEXT,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  'Thời gian khám: ${_dateValidator.convertDateCreate(value.appointmentDetail.dateExamination, 'dd/MM/yyyy', 'yyyy-MM-ddThh:mm:ss')}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.none,
                                    color: DefaultTheme.GREY_TEXT,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                (value.appointmentDetail.description != null)
                                    ? Text(
                                        'Mô tả: ${value.appointmentDetail.description}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          decoration: TextDecoration.none,
                                          color: DefaultTheme.GREY_TEXT,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      )
                                    : Container(),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                (value.appointmentDetail.note == null)
                                    ? Text(
                                        'Không có ghi chú',
                                        style: TextStyle(
                                          fontSize: 18,
                                          decoration: TextDecoration.none,
                                          color: DefaultTheme.GREY_TEXT,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      )
                                    : Text(
                                        'Ghi chú: ${value.appointmentDetail.note}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          decoration: TextDecoration.none,
                                          color: DefaultTheme.GREY_TEXT,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Center(
                                  child: ButtonHDr(
                                    style: BtnStyle.BUTTON_BLACK,
                                    label: 'Xong',
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          )
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
    });
  }

  showFullDetailComponent(
      List<String> imgs, String miName, String dateCreate, String dianose) {
    int positionImage = 0;
    bool isTappedOut = false;

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          //
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Material(
              child: InkWell(
                onTap: () {
                  setModalState(() {
                    isTappedOut = !isTappedOut;
                  });
                },
                child: (isTappedOut)
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: DefaultTheme.BLACK,
                        child: Stack(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            //
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: PhotoView(
                                customSize: Size(
                                    MediaQuery.of(context).size.width,
                                    MediaQuery.of(context).size.height),
                                imageProvider: NetworkImage(
                                    'http://45.76.186.233:8000/api/v1/Images?pathImage=${imgs[positionImage]}'),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: DefaultTheme.BLACK,
                        child: Stack(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            //
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: PhotoView(
                                customSize: Size(
                                    MediaQuery.of(context).size.width,
                                    MediaQuery.of(context).size.height),
                                imageProvider: NetworkImage(
                                    'http://45.76.186.233:8000/api/v1/Images?pathImage=${imgs[positionImage]}'),
                              ),
                            ),
                            (imgs.length > 1)
                                ? Positioned(
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        setModalState(() {
                                          if (positionImage == imgs.length) {
                                            positionImage = 0;
                                          } else if (positionImage <
                                              imgs.length - 1) {
                                            positionImage++;
                                          } else {
                                            positionImage = 0;
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.centerRight,
                                              end: Alignment.centerLeft,
                                              colors: [
                                                DefaultTheme.BLACK
                                                    .withOpacity(0.3),
                                                DefaultTheme.TRANSPARENT,
                                              ]),
                                        ),
                                        child: SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: Image.asset(
                                              'assets/images/ic-next.png'),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            (imgs.length > 1)
                                ? Positioned(
                                    left: 0,
                                    child: InkWell(
                                      onTap: () {
                                        setModalState(() {
                                          if (positionImage == 0) {
                                            positionImage = imgs.length - 1;
                                          } else {
                                            positionImage--;
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                DefaultTheme.BLACK
                                                    .withOpacity(0.3),
                                                DefaultTheme.TRANSPARENT,
                                              ]),
                                        ),
                                        child: SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: Image.asset(
                                              'assets/images/ic-prev.png'),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            (imgs != null)
                                ? Positioned(
                                    top: 25,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Text(
                                          '${positionImage + 1}/${imgs.length}',
                                          style: TextStyle(
                                              color: DefaultTheme.WHITE)),
                                    ),
                                  )
                                : Container(),
                            Positioned(
                              top: 20,
                              right: 10,
                              child: Container(
                                width: 30,
                                height: 30,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                        'assets/images/ic-close.png'),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                padding: EdgeInsets.only(left: 30, right: 30),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        DefaultTheme.TRANSPARENT,
                                        DefaultTheme.BLACK.withOpacity(0.9),
                                      ]),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    //

                                    Text(
                                      '$miName',
                                      style: TextStyle(
                                          color: DefaultTheme.WHITE,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                    ),
                                    Divider(
                                      color: DefaultTheme.WHITE,
                                      height: 1,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    (dianose == null)
                                        ? Text(
                                            '',
                                            style: TextStyle(
                                                color: DefaultTheme.WHITE,
                                                fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                          )
                                        : Text(
                                            'Chẩn đoán $dianose',
                                            style: TextStyle(
                                                color: DefaultTheme.WHITE,
                                                fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                          ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                    ),
                                    Text(
                                      'Ngày tạo $dateCreate',
                                      style: TextStyle(
                                          color: DefaultTheme.WHITE,
                                          fontSize: 15),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(bottom: 50),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            );
            //
          });
        });
  }

  _showMorePopup(int medicalInstructionId, String medicalInstructionTypeName) {
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
                      height: 200,
                      width: MediaQuery.of(context).size.width - 20,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 100,
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
                                    'Y lệnh: $medicalInstructionId - $medicalInstructionTypeName',
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
                                  label: 'Xoá',
                                  height: 60,
                                  labelColor: DefaultTheme.RED_TEXT,
                                  style: BtnStyle.BUTTON_IN_LIST,
                                  onTap: () async {
                                    bool delete = false;
                                    Navigator.of(context).pop();
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 25, sigmaY: 25),
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    top: 10,
                                                    right: 10),
                                                width: 250,
                                                height: 185,
                                                decoration: BoxDecoration(
                                                  color: DefaultTheme.WHITE
                                                      .withOpacity(0.7),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 10, top: 10),
                                                      child: Text(
                                                        'Cảnh báo',
                                                        style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          color: DefaultTheme
                                                              .BLACK,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          top: 15),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'Bạn có chắc chắn muốn xoá y lệnh khỏi hồ sơ này?',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            color: DefaultTheme
                                                                .GREY_TEXT,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Divider(
                                                      height: 1,
                                                      color: DefaultTheme
                                                          .GREY_TOP_TAB_BAR,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        FlatButton(
                                                          height: 40,
                                                          minWidth:
                                                              250 / 2 - 10.5,
                                                          child: Text('Không',
                                                              style: TextStyle(
                                                                  color: DefaultTheme
                                                                      .BLUE_TEXT)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        Container(
                                                          height: 40,
                                                          width: 0.5,
                                                          color: DefaultTheme
                                                              .GREY_TOP_TAB_BAR,
                                                        ),
                                                        FlatButton(
                                                          height: 40,
                                                          minWidth:
                                                              250 / 2 - 10.5,
                                                          child: Text('Có',
                                                              style: TextStyle(
                                                                  color: DefaultTheme
                                                                      .RED_TEXT)),
                                                          onPressed: () async {
                                                            //
                                                            Navigator.pop(
                                                                context);

                                                            await medicalInstructionRepository
                                                                .deleteMedicalInstruction(
                                                                    medicalInstructionId)
                                                                .then((value) {
                                                              if (value !=
                                                                  null) {
                                                                _pullRefresh();
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ],
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

  getHRId() async {
    await _healthRecordHelper.getHRId().then(
      (value) async {
        print('HR ID NOW $_hrId');

        setState(() {
          _hrId = value;
          if (_hrId != 0) {
            print('HR ID NOW $_hrId');
            _healthRecordDetailBloc.add(HealthRecordEventGetById(id: _hrId));
            _medicalInstructionListBloc
                .add(MedicalInstructionListEventGetList(hrId: _hrId));
          }

          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return Material(
                  color: DefaultTheme.TRANSPARENT,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                        child: Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: DefaultTheme.WHITE.withOpacity(0.8)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                //height: 200,
                                child: Image.asset('assets/images/loading.gif'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
            },
          );
        });

        await healthRecordRepository.getHealthRecordById(value).then((value) {
          Navigator.pop(context);
          setState(() {
            _healthRecordDTO = value;
          });
        });
      },
    );
  }

  String getDisease(List<Diseases> listDisease) {
    String str = '';
    for (var i = 0; i < listDisease.length; i++) {
      String diseaseStr =
          listDisease[i].diseaseId + ' - ' + listDisease[i].diseaseName;
      if (i == (listDisease.length - 1)) {
        str += '+ ' + diseaseStr;
      } else {
        str += '+ ' + diseaseStr + '\n';
      }
    }
    return str;
  }

  String titleForStatusMI(String status) {
    if (status.contains('DOCTOR')) {
      return 'Bác sĩ';
    } else if (status.contains('CONTRACT') || status.contains('SHARE')) {
      return 'Được chia sẻ';
    } else if (status.contains('PENDING')) {
      return 'Chờ duyệt';
    } else {
      return '';
    }
  }

  Color checkColorStatus(String status) {
    if (status.contains('DOCTOR')) {
      return DefaultTheme.GREY_VIEW;
    } else if (status.contains('CONTRACT') || status.contains('SHARE')) {
      return DefaultTheme.GREY_VIEW;
    } else {
      return DefaultTheme.ORANGE_TEXT;
    }
  }
}

Color checkColorStatusForTitle(String status) {
  if (status.contains('DOCTOR')) {
    return DefaultTheme.BLUE_DARK;
  } else if (status.contains('CONTRACT') || status.contains('SHARE')) {
    return DefaultTheme.BLUE_DARK;
  } else {
    return DefaultTheme.WHITE;
  }
}

final Shader _normalHealthColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_1,
    DefaultTheme.GRADIENT_2,
  ],
).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 90.0));

class MedicalInsGroup {
  String type;
  int medicalInstructionTypeId;
  List<MedicalInstructionDTO> listMedicalIns;
  MedicalInsGroup(
      {this.type, this.medicalInstructionTypeId, this.listMedicalIns});
}
