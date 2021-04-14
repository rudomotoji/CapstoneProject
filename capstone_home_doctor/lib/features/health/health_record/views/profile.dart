import 'dart:convert';
import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/artboard_button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/health_record_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/hr_list_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/hr_list_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/views/create_health_record.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/health_record_helper.dart';
import 'package:capstone_home_doctor/services/noti_helper.dart';
import 'package:capstone_home_doctor/services/notifications_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

//
final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

class _ProfileTabState extends State<ProfileTab> with WidgetsBindingObserver {
  HealthRecordRepository healthRecordRepository =
      HealthRecordRepository(httpClient: http.Client());
  List<HealthRecordDTO> listHealthRecord = [];
  // List<HealthRecordDTO> listHealthRecordOld = [];
  // List<HealthRecordDTO> listHealthRecordSystem = [];
  // List<HealthRecordDTO> listHealthActived = [];
  DateValidator _dateValidator = DateValidator();
  HealthRecordListBloc _healthRecordListBloc;
  HealthRecordHelper _healthRecordHelper = HealthRecordHelper();

  List<TypeFilter> _listFilter = [];
  TypeFilter _valueFilter;
  int _patientId = 0;
  TabController controller;
  ScrollController _scrollController;

  Stream<ReceiveNotification> _notificationsStream;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _healthRecordListBloc = BlocProvider.of(context);
    _scrollController = ScrollController(initialScrollOffset: 0.0);

    getDataFromJSONFile();

    _notificationsStream = NotificationsBloc.instance.notificationsStream;
    _notificationsStream.listen((notification) {
      refreshListHR();
    });

    _getPatientId();
    refreshListHR();
  }

  Future<void> getDataFromJSONFile() async {
    final String response = await rootBundle.loadString('assets/global.json');

    if (response.contains('listFilter')) {
      final data = await json.decode(response);
      for (var item in data['listFilter']) {
        _listFilter.add(TypeFilter.fromJson(item));
      }
    }
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
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 1,
        child: Column(
          // height: MediaQuery.of(context).size.height * 0.7,
          children: <Widget>[
            HeaderWidget(
              title: 'Hồ sơ',
              isMainView: true,
              buttonHeaderType: ButtonHeaderType.AVATAR,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            ),
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  buildSliverToBoxAdapterHeader(),
                  buildSliverAppBarCollepse(),
                  buildTabbarViewHasContract(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter buildSliverToBoxAdapterHeader() {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonArtBoard(
            title: 'Tạo hồ sơ sức khỏe',
            description: 'Một hồ sơ sức khoẻ bao gồm nhiều y lệnh',
            imageAsset: 'assets/images/ic-health-record.png',
            onTap: () async {
              //MOVE TO CREATE HR AND CALL BACK REFRESH LIST
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          new CreateHealthRecord(refreshListHR))).then((value) {
                refreshListHR();
              });
              // Navigator.of(context).pushNamed(RoutesHDr.CREATE_HEALTH_RECORD);
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),
          // ButtonArtBoard(
          //   title: 'Chia sẻ y lệnh',
          //   description:
          //       'Các phiếu y lệnh được chia sẻ giúp bác sĩ chẩn đoán tốt hơn',
          //   imageAsset: 'assets/images/ic-medical-instruction.png',
          //   onTap: () async {
          //     Navigator.of(context).pushNamed(RoutesHDr.MEDICAL_SHARE);
          //   },
          // ),
          // Padding(
          //   padding: EdgeInsets.only(top: 10),
          // ),
        ],
      ),
    );
  }

  SliverAppBar buildSliverAppBarCollepse() {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: DefaultTheme.GREY_VIEW,
      title: TabBar(
        labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            foreground: Paint()..shader = _normalHealthColors),
        indicatorPadding: EdgeInsets.only(left: 20),
        unselectedLabelStyle:
            TextStyle(color: DefaultTheme.BLACK.withOpacity(0.6)),
        indicatorColor: DefaultTheme.TRANSPARENT,
        controller: controller,
        tabs: [
          Tab(
            child: Container(
              height: 25,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Danh sách hồ sơ',
                ),
              ),
            ),
          ),
          // Tab(
          //   child: Container(
          //     height: 25,
          //     child: Align(
          //       alignment: Alignment.centerLeft,
          //       child: Text(
          //         'Hồ sơ của hệ thống',
          //       ),
          //     ),
          //   ),
          // ),
          // Tab(
          //   child: Container(
          //     height: 25,
          //     child: Align(
          //       alignment: Alignment.centerLeft,
          //       child: Text(
          //         'Hồ sơ đang hoạt động',
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  SliverFillRemaining buildTabbarViewHasContract() {
    return SliverFillRemaining(
      child: BlocBuilder<HealthRecordListBloc, HRListState>(
        builder: (context, state) {
          if (state is HRListStateLoading) {
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
          if (state is HRListStateFailure) {
            return Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Text('Kiểm tra lại đường truyền kết nối mạng')));
          }
          if (state is HRListStateSuccess) {
            listHealthRecord = state.listHealthRecord;
            // listHealthRecordOld = [];
            // listHealthRecordSystem = [];
            // listHealthActived = [];
            if (null != listHealthRecord) {
              if (listHealthRecord.length > 1) {
                listHealthRecord
                    .sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
              }

              // for (var item in listHealthRecord) {
              //   if (item.status != null) {
              //     if (item.status == 'ACTIVE') {
              //       listHealthActived.add(item);
              //     }
              //   }

              //   if (item.contractId == null) {
              //     listHealthRecordOld.add(item);
              //     print(
              //         'THIS IS LENGTH OF OLD RECORD: ${listHealthRecordOld.length}');
              //   } else {
              //     listHealthRecordSystem.add(item);
              //     print(
              //         'THIS IS LENGTH OF SYSTEM RECORD: ${listHealthRecordSystem.length}');
              //   }
              // }
            }

            return Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TabBarView(
                controller: controller,
                children: <Widget>[
                  listOldHealthRecord(),
                  // listSystemHealthRecord(),
                  // listHealthRecordActived(),
                ],
              ),
            );
          }
          return Container(
              width: MediaQuery.of(context).size.width,
              child: Center(child: Text('Không thể tải danh sách hồ sơ')));
        },
      ),
    );
  }

  listOldHealthRecord() {
    if (listHealthRecord.length > 0) {
      return Container(
        // margin: EdgeInsets.only(bottom: 50),
        child: ListView.builder(
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: listHealthRecord.length,
          itemBuilder: (BuildContext buildContext, int index) {
            return _itemHealthRecord(listHealthRecord[index]);
          },
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Image.asset('assets/images/ic-health-record-u.png'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              Text('Bạn chưa có phiếu nào'),
            ],
          ),
        ),
      );
    }
  }

  // listHealthRecordActived() {
  //   if (listHealthActived.length > 0) {
  //     return Container(
  //       child: ListView.builder(
  //         shrinkWrap: true,
  //         // physics: NeverScrollableScrollPhysics(),
  //         itemCount: listHealthActived.length,
  //         itemBuilder: (BuildContext buildContext, int index) {
  //           return _itemHealthRecord(listHealthActived[index]);
  //         },
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       width: MediaQuery.of(context).size.width,
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             SizedBox(
  //               width: 50,
  //               height: 50,
  //               child: Image.asset('assets/images/ic-dashboard.png'),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(bottom: 20),
  //             ),
  //             Text('Bạn chưa có hồ sơ nào đang hoạt động'),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }

  // listSystemHealthRecord() {
  //   if (listHealthRecordSystem.length > 0) {
  //     return Container(
  //       // padding: EdgeInsets.only(bottom: 50),
  //       child: ListView.builder(
  //         // shrinkWrap: true,
  //         // physics: NeverScrollableScrollPhysics(),
  //         itemCount: listHealthRecordSystem.length,
  //         itemBuilder: (BuildContext buildContext, int index) {
  //           return _itemHealthRecord(listHealthRecordSystem[index]);
  //         },
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       width: MediaQuery.of(context).size.width,
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             SizedBox(
  //               width: 50,
  //               height: 50,
  //               child: Image.asset('assets/images/ic-dashboard.png'),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(bottom: 20),
  //             ),
  //             Text('Bạn chưa có phiếu nào'),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }

  Widget _itemHealthRecord(HealthRecordDTO dto) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 10, bottom: 10),
      padding: EdgeInsets.only(left: 0, right: 10, top: 10, bottom: 20),
      child: InkWell(
        onTap: () {
          _healthRecordHelper.setHealthReCordId(dto.healthRecordId);
          Navigator.of(context).pushNamed(RoutesHDr.HEALTH_RECORD_DETAIL);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20),
            ),
            SizedBox(
              width: 30,
              height: 50,
              child: Image.asset('assets/images/ic-health-record.png'),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
            ),
            Expanded(
              child: Stack(
                children: [
                  //
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      (dto.diseases == null)
                          ? Text(
                              'Hồ sơ',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          : Text(
                              'Hồ sơ tại ${dto.place}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                      Text(
                        'Bệnh lý: ${getDisease(dto.diseases)}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: DefaultTheme.BLACK_BUTTON, fontSize: 12),
                      ),
                      Text(
                        'Ngày tạo: ${_dateValidator.parseToDateView(dto.dateCreated)}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: DefaultTheme.GREY_TEXT, fontSize: 12),
                      ),
                    ],
                  ),
                  (dto.contractId != null)
                      ? Container()
                      : Positioned(
                          width: 35,
                          height: 35,
                          top: -10,
                          right: 0,
                          child: ButtonHDr(
                            style: BtnStyle.BUTTON_IMAGE,
                            image: Image.asset('assets/images/ic-more.png'),
                            onTap: () {
                              _showMorePopup(dto.healthRecordId, dto.contractId,
                                  dto.place);
                            },
                          ),
                        ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
            ),
          ],
        ),
      ),
    );
  }

  _showMorePopup(int healthRecordId, int contractID, String place) {
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
                                      'Hồ sơ tại ${place}',
                                      style: TextStyle(
                                          color: DefaultTheme.GREY_TEXT),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    )

                                    // : Text(
                                    //     'Hồ sơ ${disease}',
                                    //     style: TextStyle(
                                    //         color: DefaultTheme.GREY_TEXT),
                                    //     maxLines: 2,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     textAlign: TextAlign.center,
                                    //   ),
                                    ),
                                Spacer(),
                                Divider(
                                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                                  height: 0.5,
                                ),
                                ButtonHDr(
                                  label: 'Sửa',
                                  height: 60,
                                  labelColor: DefaultTheme.BLUE_TEXT,
                                  style: BtnStyle.BUTTON_IN_LIST,
                                  onTap: () {
                                    // _healthRecordHelper
                                    //     .setHealthReCordId(healthRecordId);
                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .pushNamed(
                                            RoutesHDr.UPDATE_HEALTH_RECORD,
                                            arguments: healthRecordId)
                                        .then((value) => refreshListHR());
                                  },
                                ),
                                // Divider(
                                //   color: DefaultTheme.GREY_TOP_TAB_BAR,
                                //   height: 0.5,
                                // ),
                                // ButtonHDr(
                                //   label: 'Xoá',
                                //   height: 60,
                                //   labelColor: DefaultTheme.RED_TEXT,
                                //   style: BtnStyle.BUTTON_IN_LIST,
                                //   onTap: () {
                                //     // _sqfLiteHelper
                                //     //     .deleteHealthRecord(healthRecordId);
                                //     // refreshListHR();
                                //     Navigator.of(context).pop();
                                //   },
                                // ),
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

  refreshListHR() async {
    await _getPatientId();
    if (_patientId != 0) {
      _healthRecordListBloc
          .add(HRListEventSetPersonalHRId(personalHealthRecordId: _patientId));
    }
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

class TypeFilter {
  String label;
  int value;
  TypeFilter({this.label, this.value});
  TypeFilter.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }
}

final Shader _normalHealthColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_1,
    DefaultTheme.GRADIENT_2,
  ],
).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 90.0));
