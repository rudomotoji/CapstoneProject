import 'dart:ui';
import 'package:capstone_home_doctor/services/medical_instruction_helper.dart';
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

  TabController controller;

  HealthRecordRepository healthRecordRepository =
      HealthRecordRepository(httpClient: http.Client());
  MedicalInstructionRepository medicalInstructionRepository =
      MedicalInstructionRepository(httpClient: http.Client());

  HealthRecordDetailBloc _healthRecordDetailBloc;
  MedicalInstructionListBloc _medicalInstructionListBloc;
  MedInsCreateBloc _medInsCreateBloc;
  MedicalShareInsBloc _medicalShareInsBloc;

  List<MedicalInstructionDTO> listMedicalIns = [];
  List<MedicalInstructionDTO> listMedicalInsShared = [];
  HealthRecordDTO _healthRecordDTO = HealthRecordDTO(
      contractId: 0,
      dateCreated: '',
      description: '',
      // disease: '',
      // doctorName: '',
      healthRecordId: 0,
      personalHealthRecordId: 0,
      place: '');
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    controller = new TabController(length: 2, vsync: this);

    listMedicalIns = [];
    _healthRecordDetailBloc = BlocProvider.of(context);
    _medicalInstructionListBloc = BlocProvider.of(context);
    _medInsCreateBloc = BlocProvider.of(context);
    _medicalShareInsBloc = BlocProvider.of(context);
    getHRId();
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
                buttonHeaderType: ButtonHeaderType.BACK_HOME,
              ),
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
                            child: Text(
                                'Kiểm tra lại đường truyền kết nối mạng')));
                  }
                  if (state is HealthRecordDetailStateSuccess) {
                    if (state.healthRecordDTO != null) {
                      _healthRecordDTO = state.healthRecordDTO;
                    }

                    return RefreshIndicator(
                        child: (_healthRecordDTO.contractId == null)
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.80,
                                child: CustomScrollView(
                                  slivers: [
                                    buildSliverToBoxAdapterHeader(),
                                    buildTabbarViewNotContract(),
                                  ],
                                ),
                              )
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.80,
                                child: CustomScrollView(
                                  slivers: [
                                    buildSliverToBoxAdapterHeader(),
                                    buildSliverAppBarCollepse(),
                                    buildTabbarViewHasContract(),
                                  ],
                                ),
                              ),
                        onRefresh: _pullRefresh);
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
          // BlocBuilder<HealthRecordDetailBloc, HealthRecordDetailState>(
          //   builder: (context, state) {
          //     if (state is HealthRecordDetailStateLoading) {
          //       return Container(
          //         width: 200,
          //         height: 200,
          //         child: SizedBox(
          //           width: 100,
          //           height: 100,
          //           child: Image.asset('assets/images/loading.gif'),
          //         ),
          //       );
          //     }
          //     if (state is HealthRecordDetailStateFailure) {
          //       return Container(
          //           width: MediaQuery.of(context).size.width,
          //           child: Center(
          //               child: Text('Kiểm tra lại đường truyền kết nối mạng')));
          //     }
          //     if (state is HealthRecordDetailStateSuccess) {
          //       if (state.healthRecordDTO != null) {
          //         _healthRecordDTO = state.healthRecordDTO;
          //         }
          //     }
          //     return Container(
          //       width: MediaQuery.of(context).size.width,
          //       child: Center(
          //         child: Text(
          //           'Không thể tải danh sách hồ sơ',
          //         ),
          //       ),
          //     );
          //   },
          // ),
          Column(
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
                          width: MediaQuery.of(context).size.width - (155),
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
                                              (155),
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
                  style: TextStyle(color: DefaultTheme.BLACK, fontSize: 13),
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
                                color: DefaultTheme.GREY_TEXT, fontSize: 13),
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
                        Navigator.of(context)
                            .pushNamed(RoutesHDr.CREATE_MEDICAL_INSTRUCTION)
                            .then((value) {
                          _pullRefresh();
                        });
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
          ),
        ],
      ),
    );
  }

  SliverFillRemaining buildTabbarViewHasContract() {
    return SliverFillRemaining(
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
              listMedicalIns.clear();
              listMedicalInsShared.clear();
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

          return TabBarView(
            controller: controller,
            children: <Widget>[
              _medicalInsert(),
              _medicalShare(),
            ],
          );
        },
      ),
    );
  }

  SliverFillRemaining buildTabbarViewNotContract() {
    return SliverFillRemaining(
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
              listMedicalIns.clear();
              listMedicalInsShared.clear();
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

          return _medicalShare();
        },
      ),
    );
  }

  Widget _medicalInsert() {
    return (listMedicalIns.length != 0)
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
    //   },
    // );
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
    DateTime dateCreated = DateFormat('yyyy-MM-dd').parse(dto.dateCreate);
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
                                }
                                if (dto?.image != null) {
                                  _showFullImageDescription(
                                      dto?.image,
                                      dto.medicalInstructionType,
                                      '${DateFormat('dd/MM/yyyy').format(dateCreated)}');
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
                                  Text(
                                    'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(dateCreated)}',
                                    style: TextStyle(
                                        color: DefaultTheme.GREY_TEXT),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
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
                // Positioned(
                //   width: 35,
                //   height: 35,
                //   top: 7,
                //   right: 0,
                //   child: ButtonHDr(
                //     style: BtnStyle.BUTTON_IMAGE,
                //     image: Image.asset('assets/images/ic-more.png'),
                //     onTap: () {
                //       _showMorePopup();
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pullRefresh() async {
    getHRId();
  }

  _showFullImageDescription(String img, String miName, String dateCreate) {
    showDialog(
        barrierDismissible: false,
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
                          Text(
                            'Ngày tạo $dateCreate',
                            style: TextStyle(
                                color: DefaultTheme.WHITE, fontSize: 15),
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
              .add(MedicalInstructionListEventGetList(hrId: _hrId));
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
