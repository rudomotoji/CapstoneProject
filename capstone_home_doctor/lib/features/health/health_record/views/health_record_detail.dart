import 'dart:io';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/utils/img_util.dart';
import 'package:capstone_home_doctor/commons/utils/teseract_oct.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/health_record_detail_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_create_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_type_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/medical_scan_image_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/hr_detail_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_create_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_list_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_type_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/hr_detail_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_list_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_type_list_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/medical_scan_image_state.dart';
import 'package:capstone_home_doctor/features/health/medical_share/blocs/medical_share_bloc.dart';
import 'package:capstone_home_doctor/features/health/medical_share/events/medical_Share_event.dart';
import 'package:capstone_home_doctor/features/health/medical_share/states/medical_share_state.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/models/image_scanner_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/models/medical_instruction_type_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/health_record_helper.dart';
import 'package:capstone_home_doctor/services/medical_instruction_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:photo_view/photo_view.dart';

List<MedicalInstructionTypeDTO> _listMedInsType = [];
//   MedicalInstructionTypeDTO(id: 1, typeName: 'Phiếu khám bệnh'),
//   MedicalInstructionTypeDTO(id: 2, typeName: 'Bệnh án nội khoa'),
//   MedicalInstructionTypeDTO(id: 3, typeName: 'Phiếu xét nghiệm huyết học'),
//   MedicalInstructionTypeDTO(id: 4, typeName: 'Phiếu xét nghiệm hoá sinh máu'),
//   MedicalInstructionTypeDTO(id: 5, typeName: 'Phiếu chụp X-Quang'),
//   MedicalInstructionTypeDTO(id: 6, typeName: 'Phiếu siêu âm'),
//   MedicalInstructionTypeDTO(id: 7, typeName: 'Phiếu điện tim'),
//   MedicalInstructionTypeDTO(id: 8, typeName: 'Phiếu theo dõi chức năng sống'),
//   MedicalInstructionTypeDTO(id: 9, typeName: 'Phiếu chăm sóc'),
//   MedicalInstructionTypeDTO(id: 10, typeName: 'Hồ sơ khác'),
// ];
final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

class HealthRecordDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HealthRecordDetail();
  }
}

class _HealthRecordDetail extends State<HealthRecordDetail>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  //
  var _dianoseController = TextEditingController();
  var _startDateController = TextEditingController();
  var _endDateController = TextEditingController();

  String dropdownValue = 'One';
  String _selectedHRType = '';
  String _note = '';
  //
  DateValidator _dateValidator = DateValidator();
  HealthRecordHelper _healthRecordHelper = HealthRecordHelper();
  int _hrId = 0;
  final picker = ImagePicker();
  PickedFile _imgFile;
  int _medInsTypeId;
  var uuid = Uuid();
  //patient Id
  int _patientId = 0;

  String _dataGenerated = '';
  String titleCompare = '';

  TabController controller;

  HealthRecordRepository healthRecordRepository =
      HealthRecordRepository(httpClient: http.Client());
  MedicalInstructionRepository medicalInstructionRepository =
      MedicalInstructionRepository(httpClient: http.Client());

  HealthRecordDetailBloc _healthRecordDetailBloc;
  MedicalInstructionListBloc _medicalInstructionListBloc;
  MedInsTypeListBloc _medInsTypeListBloc;
  MedInsCreateBloc _medInsCreateBloc;
  MedicalShareInsBloc _medicalShareInsBloc;

  MedInsScanTextBloc _medicalScanText;
  List<MedicalInstructionDTO> listMedicalIns = [];
  List<MedicalInstructionDTO> listMedicalInsShared = [];
  final MedicalInstructionHelper _medicalInstructionHelper =
      MedicalInstructionHelper();
  HealthRecordDTO _healthRecordDTO = HealthRecordDTO(
      contractId: 0,
      dateCreated: '',
      description: '',
      // disease: '',
      // doctorName: '',
      healthRecordId: 0,
      personalHealthRecordId: 0,
      place: '');
  //
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    controller = new TabController(length: 2, vsync: this);

    listMedicalIns = [];
    _healthRecordDetailBloc = BlocProvider.of(context);
    _medicalInstructionListBloc = BlocProvider.of(context);
    _medInsTypeListBloc = BlocProvider.of(context);
    _medInsCreateBloc = BlocProvider.of(context);
    _medicalScanText = BlocProvider.of(context);
    _medicalShareInsBloc = BlocProvider.of(context);
    _getPatientId();
    getHRId();
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
    WidgetsBinding.instance.addObserver(this);
    _medicalShareInsBloc.add(MedicalShareInsEventInitial());
    _medInsCreateBloc.add(MedInsGetTextEventInitial());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              HeaderWidget(
                title: 'Chi tiết hồ sơ',
                isMainView: false,
                buttonHeaderType: ButtonHeaderType.NONE,
              ),
              Container(
                height: MediaQuery.of(context).size.height - 90,
                child: CustomScrollView(
                  slivers: [
                    buildSliverToBoxAdapterHeader(),
                    buildSliverAppBarCollepse(),
                    buildTabbarView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar buildSliverAppBarCollepse() {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: DefaultTheme.WHITE,
      title: TabBar(
          labelStyle: TextStyle(
              fontSize: 14,
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
                    'Hồ sơ của hợp đồng',
                  ),
                ),
              ),
            ),
            Tab(
              child: Container(
                height: 25,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hồ sơ được chia sẻ',
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  SliverToBoxAdapter buildSliverToBoxAdapterHeader() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          BlocBuilder<HealthRecordDetailBloc, HealthRecordDetailState>(
            builder: (context, state) {
              if (state is HealthRecordDetailStateLoading) {
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
              if (state is HealthRecordDetailStateFailure) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text('Kiểm tra lại đường truyền kết nối mạng')));
              }
              if (state is HealthRecordDetailStateSuccess) {
                if (state.healthRecordDTO != null) {
                  _healthRecordDTO = state.healthRecordDTO;
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: DefaultTheme.GREY_VIEW,
                        ),
                        child: Column(
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
                                  width:
                                      MediaQuery.of(context).size.width - (155),
                                  child: Text(
                                    (_healthRecordDTO.diseases.length > 0)
                                        ? '${getDisease(_healthRecordDTO.diseases)}'
                                        : '', //lấy tên bệnh lý
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
                                  width:
                                      MediaQuery.of(context).size.width - (155),
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
                            (_healthRecordDTO.description != '')
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      (_healthRecordDTO.description != null)
                                          ? Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                ),
                                                Container(
                                                  width: 125,
                                                  child: Text(
                                                    'Ghi chú',
                                                    style: TextStyle(
                                                      color: DefaultTheme
                                                          .GREY_TEXT,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      (155),
                                                  child: Text(
                                                    '${_healthRecordDTO.description}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
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
                      Container(
                        padding: EdgeInsets.only(left: 20, bottom: 5, top: 5),
                        child: Text(
                          'Tạo ngày ${_dateValidator.parseToDateView(_healthRecordDTO.dateCreated)}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: DefaultTheme.BLACK, fontSize: 13),
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
                                  padding: EdgeInsets.only(
                                      top: 30, left: 20, bottom: 0),
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
                                setState(() {
                                  titleCompare = '';
                                  _imgFile = null;
                                });
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
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Divider(
                          color: DefaultTheme.GREY_TOP_TAB_BAR,
                          height: 0.1,
                        ),
                      ),
                    ],
                  );
                }
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    'Không thể tải danh sách hồ sơ',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  SliverFillRemaining buildTabbarView() {
    return SliverFillRemaining(
      child: TabBarView(
        controller: controller,
        children: <Widget>[
          _medicalInsert(),
          _medicalShare(),
        ],
      ),
    );
  }

  Widget _medicalInsert() {
    return BlocBuilder<MedicalInstructionListBloc, MedicalInstructionListState>(
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
            for (var medicalIns in state.listMedIns) {
              if (medicalIns.status != null) {
                if (medicalIns.status.contains('DOCTOR')) {
                  listMedicalIns.add(medicalIns);
                } else {
                  listMedicalInsShared.add(medicalIns);
                }
              }
            }
          }
        }
        return (listMedicalIns != null || !listMedicalIns.isEmpty)
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listMedicalIns.length,
                itemBuilder: (BuildContext buildContext, int index) {
                  return _itemRow(listMedicalIns[index]);
                })
            : Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text('Không có hồ sơ nào'),
                ),
              );
      },
    );
  }

  Widget _medicalShare() {
    return (listMedicalInsShared.length != 0)
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: listMedicalInsShared.length,
            itemBuilder: (BuildContext context, int index) {
              print(index);
              return _itemRow(listMedicalInsShared[index]);
            },
          )
        : Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Text('Bạn chưa chia sẻ thêm phiếu nào'),
          );
  }

  Widget _itemRow(MedicalInstructionDTO dto) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
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
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
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
                                if (dto.medicationsRespone != null) {
                                  Navigator.pushNamed(
                                      context, RoutesHDr.MEDICAL_HISTORY_DETAIL,
                                      arguments: dto.medicalInstructionId);
                                } else {
                                  _showFullImageDescription(dto?.image, '', '');
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
                                    ? Container()
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: Image.network(
                                              'http://45.76.186.233:8000/api/v1/Images?pathImage=${dto?.image}'),
                                        ),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${dto.medicalInstructionType}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      //
                                      Container(
                                        width: 80,
                                        child: Text(
                                          'Chẩn đoán:',
                                          style: TextStyle(
                                              color: DefaultTheme.GREY_TEXT),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                220,
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
                                                  220,
                                              child: Text(
                                                '${dto.description}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
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
                    image: Image.asset('assets/images/ic-more.png'),
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
  }

  // Widget _itemMedInsShared(MedicalInstructionDTO medicalInsShared) {
  //   print('${medicalInsShared.medicalInstructionType}');
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     color: DefaultTheme.WHITE,
  //     child: Column(
  //       children: [
  //         Divider(
  //           color: DefaultTheme.GREY_TOP_TAB_BAR,
  //           height: 1,
  //         ),
  //         Container(
  //           width: MediaQuery.of(context).size.width,
  //           padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
  //           color: DefaultTheme.WHITE,
  //           child: Row(
  //             children: [
  //               SizedBox(
  //                 width: 20,
  //                 height: 20,
  //                 child:
  //                     Image.asset('assets/images/ic-medical-instruction.png'),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(left: 10),
  //               ),
  //               Text(
  //                 '${medicalInsShared.medicalInstructionType}',
  //                 textAlign: TextAlign.left,
  //                 style:
  //                     TextStyle(fontSize: 15, color: DefaultTheme.BLACK_BUTTON),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Container(
  //           width: MediaQuery.of(context).size.width,
  //           height: 200,
  //           child: ListView(
  //             scrollDirection: Axis.horizontal,
  //             children: [
  //               Container(
  //                 height: 200,
  //                 child: ListView.builder(
  //                   scrollDirection: Axis.horizontal,
  //                   shrinkWrap: true,
  //                   physics: NeverScrollableScrollPhysics(),
  //                   itemCount: medicalInsShared.medicalInstructions.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     return Container(
  //                       height: 200,
  //                       width: 150,
  //                       margin: EdgeInsets.only(left: 10),
  //                       child: (medicalInsShared
  //                                   .medicalInstructions[index].image !=
  //                               null)
  //                           ? InkWell(
  //                               onTap: () {
  //                                 if (medicalInsShared. !=
  //                                     null) {
  //                                   Navigator.pushNamed(context,
  //                                       RoutesHDr.MEDICAL_HISTORY_DETAIL,
  //                                       arguments: medicalInsShared
  //                                           .medicalInstructions[index]
  //                                           .medicalInstructionId);
  //                                 } else {
  //                                   _showFullImageDescription(
  //                                       medicalInsShared
  //                                           .medicalInstructions[index].image,
  //                                       '',
  //                                       '');
  //                                 }
  //                               },
  //                               child: Stack(
  //                                 children: [
  //                                   //
  //                                   SizedBox(
  //                                     width: 150,
  //                                     height: 200,
  //                                     child: Image.network(
  //                                         'http://45.76.186.233:8000/api/v1/Images?pathImage=${medicalInsShared.medicalInstructions[index].image}'),
  //                                   ),
  //                                   Positioned(
  //                                     bottom: 0,
  //                                     child: Container(
  //                                       width: 150,
  //                                       height: 100,
  //                                       padding: EdgeInsets.only(bottom: 10),
  //                                       decoration: BoxDecoration(
  //                                         gradient: LinearGradient(
  //                                             begin: Alignment.topCenter,
  //                                             end: Alignment.bottomCenter,
  //                                             colors: [
  //                                               DefaultTheme.TRANSPARENT,
  //                                               DefaultTheme.BLACK
  //                                                   .withOpacity(0.9),
  //                                             ]),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             )
  //                           : Container(
  //                               width: 150,
  //                               height: 200,
  //                               color:
  //                                   DefaultTheme.RED_CALENDAR.withOpacity(0.2),
  //                             ),
  //                     );
  //                   },
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> _pullRefresh() async {
    getHRId();
  }

  _showFullImageDescription(String img, String miName, String dateCreate) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //
          return Material(
            child: Container(
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
                      customSize: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height),
                      imageProvider: NetworkImage(
                          'http://45.76.186.233:8000/api/v1/Images?pathImage=${img}'),
                    ),
                  ),
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
                          child: Image.asset('assets/images/ic-close.png'),
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
                      height: MediaQuery.of(context).size.height * 0.4,
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
                          // Text(
                          //   'Ngày tạo $dateCreate',
                          //   style: TextStyle(
                          //       color: DefaultTheme.WHITE, fontSize: 15),
                          // ),

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
          );
          //
        });
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

//popup create new medical instruction
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
                                      'Thêm y lệnh',
                                      style: TextStyle(
                                        color: DefaultTheme.BLACK,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    margin: EdgeInsets.only(left: 0, top: 40),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
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

                                        BlocBuilder<MedInsTypeListBloc,
                                            MedInsTypeState>(
                                          builder: (context, state) {
                                            if (state
                                                is MedInsTypeStateLoading) {
                                              return Container(
                                                width: 40,
                                                height: 40,
                                                child: SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: Image.asset(
                                                      'assets/images/loading.gif'),
                                                ),
                                              );
                                            }
                                            if (state
                                                is MedInsTypeStateFailure) {
                                              return Container(
                                                width: 30,
                                                child: Text('Lỗi'),
                                              );
                                            }
                                            if (state
                                                is MedInsTypeStateSuccess) {
                                              _listMedInsType =
                                                  state.listMedInsType;
                                              // return Text('OK');
                                              return DropdownButton<
                                                  MedicalInstructionTypeDTO>(
                                                items: _listMedInsType.map(
                                                    (MedicalInstructionTypeDTO
                                                        value) {
                                                  return new DropdownMenuItem<
                                                      MedicalInstructionTypeDTO>(
                                                    value: value,
                                                    child: new Text(value.name),
                                                  );
                                                }).toList(),
                                                hint: Text('Chọn loại phiếu'),
                                                underline: Container(
                                                  width: 0,
                                                ),
                                                isExpanded: false,
                                                onChanged: (_) {
                                                  setModalState(() {
                                                    _medInsTypeId = _
                                                        .medicalInstructionTypeId;
                                                    _selectedHRType = _.name;
                                                    print('${_selectedHRType}');
                                                  });
                                                },
                                              );
                                              //
                                            }
                                            return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child:
                                                    Center(child: Text('Lỗi')));
                                          },
                                        ),

                                        //
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Spacer(),
                              (_selectedHRType == '')
                                  ? Container()
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.only(top: 10, left: 0),
                                          child: Text(
                                            '${_selectedHRType}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        // Container(
                                        //   padding: EdgeInsets.only(
                                        //       left: 0, right: 0, top: 5),
                                        //   child: Text(
                                        //     'Thuộc hồ sơ ${_healthRecordDTO.disease}',
                                        //     overflow: TextOverflow.ellipsis,
                                        //     maxLines: 1,
                                        //     style: TextStyle(
                                        //       fontSize: 15,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Divider(
                                  height: 0.1,
                                  color: DefaultTheme.GREY_LIGHT,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    Text('Chẩn đoán*'),
                                    Container(
                                      height: 100,
                                      child: TextFieldHDr(
                                        controller: _dianoseController,
                                        placeHolder: 'Nhập tên bệnh lý',
                                        style: TFStyle.TEXT_AREA,
                                        keyboardAction: TextInputAction.done,
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
                                padding: EdgeInsets.only(top: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 5),
                                      child: Text(
                                        'Ngày*',
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
                              Expanded(
                                child: ListView(children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 80,
                                    child: TextFieldHDr(
                                        placeHolder:
                                            'Mô tả thêm các vấn đề khác',
                                        style: TFStyle.TEXT_AREA,
                                        keyboardAction: TextInputAction.done,
                                        onChange: (text) {
                                          setState(() {
                                            _note = text;
                                          });
                                          setModalState(() {
                                            _note = text;
                                          });
                                        }),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                  ),
                                  (_imgFile != null)
                                      ? BlocBuilder<MedInsScanTextBloc,
                                              MedInsScanTextState>(
                                          builder: (context, state) {
                                          if (state
                                              is MedInsScanTextStateLoading) {
                                            return Container(
                                              width: 50,
                                              height: 50,
                                              child: SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Image.asset(
                                                    'assets/images/loading.gif'),
                                              ),
                                            );
                                          }
                                          if (state
                                              is MedInsScanTextStateFailure) {
                                            return Container();
                                          }
                                          if (state
                                              is MedInsScanTextStateSuccess) {
                                            if (state.data.title != null) {
                                              titleCompare = state.data.title;
                                              _dianoseController.text =
                                                  state.data.symptom;
                                              var percentCompare =
                                                  _selectedHRType
                                                      .toLowerCase()
                                                      .similarityTo(titleCompare
                                                          .toLowerCase());
                                              if (percentCompare > 0.7) {
                                                return Container();
                                              } else {
                                                if (_selectedHRType == "") {
                                                  return Container(
                                                      height: 35,
                                                      child: Text(
                                                          'Bạn chưa chọn loại phiếu',
                                                          style: TextStyle(
                                                            color: DefaultTheme
                                                                .RED_TEXT,
                                                            fontSize: 20,
                                                          )));
                                                } else {
                                                  return Container(
                                                      height: 35,
                                                      child: Text(
                                                          'Bạn có chắc đây là $_selectedHRType',
                                                          style: TextStyle(
                                                            color: DefaultTheme
                                                                .RED_TEXT,
                                                            fontSize: 20,
                                                          )));
                                                }
                                              }
                                            } else {
                                              Container(
                                                  height: 35, child: Text(''));
                                            }
                                          }
                                        })
                                      : Container(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (_imgString == '')
                                          ? InkWell(
                                              child: Container(
                                                width: 120,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  color:
                                                      DefaultTheme.TRANSPARENT,
                                                  border: Border.all(
                                                    color: DefaultTheme
                                                        .GREY_TOP_TAB_BAR,
                                                    width: 0.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
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
                                                        source: ImageSource
                                                            .gallery);
                                                setModalState(() {
                                                  if (pickedFile != null) {
                                                    //
                                                    setState(() {
                                                      _imgFile = pickedFile;
                                                      _imgString = ImageUltility
                                                          .base64String(File(
                                                                  pickedFile
                                                                      .path)
                                                              .readAsBytesSync());
                                                    });
                                                    if (_imgFile.path != null ||
                                                        _imgFile.path != '') {
                                                      _medicalScanText.add(
                                                          MedInsGetTextEventSend(
                                                              imagePath:
                                                                  _imgFile
                                                                      .path));
                                                    }
                                                    // _imgFile = pickedFile;
                                                    // _imgString =
                                                    //     ImageUltility.base64String(
                                                    //         File(pickedFile.path)
                                                    //             .readAsBytesSync());

                                                    // gửi hình ảnh lên để detech phiếu khám bệnh

                                                    ///
                                                    ///

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
                                                  BorderRadius.circular(10),
                                              child: SizedBox(
                                                  width: 120,
                                                  height: 120,
                                                  child: ImageUltility
                                                      .imageFromBase64String(
                                                          _imgString)),
                                            ),
                                    ],
                                  ),
                                ]),
                              ),
                              ButtonHDr(
                                width: MediaQuery.of(context).size.width - 40,
                                style: BtnStyle.BUTTON_BLACK,
                                label: 'Thêm',
                                onTap: () async {
                                  if (_patientId != 0) {
                                    MedicalInstructionDTO medInsDTO =
                                        MedicalInstructionDTO(
                                      medicalInstructionTypeId: _medInsTypeId,
                                      healthRecordId: _hrId,
                                      patientId: _patientId,
                                      description: _note,
                                      diagnose: _dianoseController.text,
                                      dateStarted: _startDate,
                                      dateFinished: _startDate,
                                      imageFile: _imgFile,
                                    );

                                    setState(() {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 25, sigmaY: 25),
                                                child: Container(
                                                  width: 300,
                                                  height: 300,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: DefaultTheme.WHITE
                                                          .withOpacity(0.8)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 200,
                                                        height: 200,
                                                        child: Image.asset(
                                                            'assets/images/loading.gif'),
                                                      ),
                                                      Text(
                                                        'Đang tạo...',
                                                        style: TextStyle(
                                                            color: DefaultTheme
                                                                .GREY_TEXT,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            decoration:
                                                                TextDecoration
                                                                    .none),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    });
                                    _medInsCreateBloc.add(
                                        MedInsCreateEventSend(dto: medInsDTO));
                                    Navigator.of(context).pop();

                                    Future.delayed(Duration(seconds: 3), () {
                                      _medicalInstructionHelper
                                          .getMedicalInsCreate()
                                          .then((value) {
                                        if (value) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 25, sigmaY: 25),
                                                    child: Container(
                                                      width: 200,
                                                      height: 200,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: DefaultTheme
                                                              .WHITE
                                                              .withOpacity(
                                                                  0.8)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 100,
                                                            height: 100,
                                                            child: Image.asset(
                                                                'assets/images/ic-checked.png'),
                                                          ),
                                                          Text(
                                                            'Tạo thành công',
                                                            style: TextStyle(
                                                                color: DefaultTheme
                                                                    .GREY_TEXT,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            _getPatientId();
                                            getHRId();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          });
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 25, sigmaY: 25),
                                                    child: Container(
                                                      width: 200,
                                                      height: 200,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: DefaultTheme
                                                              .WHITE
                                                              .withOpacity(
                                                                  0.8)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 100,
                                                            height: 100,
                                                            child: Image.asset(
                                                                'assets/images/ic-failed.png'),
                                                          ),
                                                          Text(
                                                            'Không thể tạo y lệnh, vui lòng tạo lại',
                                                            style: TextStyle(
                                                                color: DefaultTheme
                                                                    .GREY_TEXT,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            Navigator.of(context).pop();
                                          });
                                        }
                                      });
                                    });
                                  }
                                  // print(
                                  //     'HR ID when prepare submit is ${_healthRecordDTO.healthRecordId}');
                                  // print('${_imgString.length}');
                                  // print(
                                  //     'INDEX SELECTED IS ALSO ID TYPE ${indexSelectMedIns.toString()}');

                                  // _insertMedicalInstruction(medInsDTO);
                                  // refreshListMedicalIns();
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
    await _healthRecordHelper.getHRId().then(
      (value) {
        print('HR ID IN SHARED_PR ${value}');
        setState(() {
          _hrId = value;
        });
        if (_hrId != 0) {
          _healthRecordDetailBloc.add(HealthRecordEventGetById(id: _hrId));
          _medicalInstructionListBloc
              .add(MedicalInstructionListEventGetList(hrId: 9058));
          _medInsTypeListBloc.add(MedInsTypeEventGetList(status: 'active'));
        }
      },
    );
  }

  String getDisease(List<dynamic> listDisease) {
    String str = '';
    for (var i = 0; i < listDisease.length; i++) {
      if (i == (listDisease.length - 1)) {
        str += listDisease[i]['diseaseName'];
      } else {
        str += listDisease[i]['diseaseName'] + '\n';
      }
    }
    return str;
  }
}

final Shader _normalHealthColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_1,
    DefaultTheme.GRADIENT_2,
  ],
).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 90.0));
