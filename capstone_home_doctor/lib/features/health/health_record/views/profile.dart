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
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
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
  MedicalInstructionRepository medicalInstructionRepository =
      MedicalInstructionRepository(httpClient: http.Client());
  List<HealthRecordDTO> listHealthRecord = [];
  List<HealthRecordDTO> listHealthRecordSystem = [];
  List<HealthRecordDTO> listHealthRecordOther = [];

  DateValidator _dateValidator = DateValidator();
  HealthRecordListBloc _healthRecordListBloc;
  HealthRecordHelper _healthRecordHelper = HealthRecordHelper();

  List<TypeFilter> _listFilter = [];
  TypeFilter _valueFilter;
  int _patientId = 0;
  TabController controller;
  ScrollController _scrollController;
  int _listIndex = 0;

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
              buttonHeaderType: ButtonHeaderType.CREATE_HEALTH_RECORD,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                child: Text(
                    'Mỗi hồ sơ sức khoẻ bao gồm nhiều phiếu y lệnh. Phiếu y lệnh là một chỉ định, một lệnh bằng văn bản được ghi trong bệnh án và các giấy tờ y tế mang tính pháp lý.'),
              ),
            ),
            _buildHeader(),
            _buildTab(),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  //

                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  _buildDescription(_listIndex),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  _buildListHealthRecord(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTab() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _listIndex = 0;
              });
            },
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
              height: 40,
              decoration: (_listIndex == 0)
                  ? BoxDecoration(
                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                      borderRadius: BorderRadius.circular(30),
                    )
                  : BoxDecoration(
                      border: Border.all(
                          width: 1, color: DefaultTheme.GREY_TOP_TAB_BAR),
                      color: DefaultTheme.WHITE,
                      borderRadius: BorderRadius.circular(30),
                    ),
              child: Center(
                child: Text('Tất cả',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: (_listIndex == 0)
                            ? FontWeight.w500
                            : FontWeight.normal,
                        color: DefaultTheme.BLACK,
                        fontSize: 16)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _listIndex = 1;
              });
            },
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
              height: 40,
              decoration: (_listIndex == 1)
                  ? BoxDecoration(
                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                      borderRadius: BorderRadius.circular(30),
                    )
                  : BoxDecoration(
                      border: Border.all(
                          width: 1, color: DefaultTheme.GREY_TOP_TAB_BAR),
                      color: DefaultTheme.WHITE,
                      borderRadius: BorderRadius.circular(30),
                    ),
              child: Center(
                child: Text('Từ hệ thống',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: (_listIndex == 1)
                            ? FontWeight.w500
                            : FontWeight.normal,
                        color: DefaultTheme.BLACK,
                        fontSize: 16)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _listIndex = 2;
              });
            },
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
              height: 40,
              decoration: (_listIndex == 2)
                  ? BoxDecoration(
                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                      borderRadius: BorderRadius.circular(30),
                    )
                  : BoxDecoration(
                      border: Border.all(
                          width: 1, color: DefaultTheme.GREY_TOP_TAB_BAR),
                      color: DefaultTheme.WHITE,
                      borderRadius: BorderRadius.circular(30),
                    ),
              child: Center(
                child: Text('Khác',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: (_listIndex == 2)
                            ? FontWeight.w500
                            : FontWeight.normal,
                        color: DefaultTheme.BLACK,
                        fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      margin: EdgeInsets.only(bottom: 10, top: 20),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            child: Text(
              'Danh sách hồ sơ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  _buildDescription(int index) {
    if (index == 0) {
      return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: DefaultTheme.GREY_TOP_TAB_BAR, width: 1),
        ),
        child: Center(
          child: Text(
              'Danh sách bao gồm tất cả các hồ sơ sức khoẻ từ hệ thống và hồ sơ mà bạn đã thêm trước đó.'),
        ),
      );
    } else if (index == 1) {
      return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: DefaultTheme.GREY_TOP_TAB_BAR, width: 1),
        ),
        child: Center(
          child: Text(
              'Danh sách bao gồm các hồ sơ sức khoẻ được tạo từ bác sĩ trong hệ thống.'),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: DefaultTheme.GREY_TOP_TAB_BAR, width: 1),
        ),
        child: Center(
          child: Text(
              'Danh sách bao gồm các hồ sơ sức khoẻ mà bạn đã thêm trước đó.'),
        ),
      );
    }
  }

  Widget _buildListHealthRecord() {
    return BlocBuilder<HealthRecordListBloc, HRListState>(
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
          //
          if (state.listHealthRecord.isNotEmpty &&
              state.listHealthRecord != null) {
            state.listHealthRecord
                .sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
            if (_listIndex == 0) {
              return _renderList(state.listHealthRecord);
            } else if (_listIndex == 1) {
              return _renderList(state.listHealthRecord
                  .where((item) => item.contractId != null)
                  .toList());
            } else {
              return _renderList(state.listHealthRecord
                  .where((item) => item.contractId == null)
                  .toList());
            }
          } else {
            return Container(child: Text('Không có hồ sơ nào'));
          }

          //

          // if (null != listHealthRecord && listHealthRecord.isNotEmpty) {
          //   if (listHealthRecord.length > 1) {
          //     listHealthRecord
          //         .sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
          //   }
          // } else {
          //   return Container(child: Text('Không có hồ sơ nào'));
          // }
        }
        return Container(
            width: MediaQuery.of(context).size.width,
            child: Center(child: Text('Không thể tải danh sách hồ sơ')));
      },
    );
  }

  _renderList(List<HealthRecordDTO> list) {
    if (list.isNotEmpty && list != null) {
      return Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (BuildContext buildContext, int index) {
            return _itemHealthRecord(list[index]);
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
              Text('Không có hồ sơ nào.'),
            ],
          ),
        ),
      );
    }
  }

  Widget _itemHealthRecord(HealthRecordDTO dto) {
    return Container(
      decoration: BoxDecoration(
          color: DefaultTheme.GREY_VIEW,
          borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
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
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                            height: 10,
                            child:
                                Image.asset('assets/images/ic-add-disease.png'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Text('Bệnh lý:',
                              style: TextStyle(
                                  color: DefaultTheme.BLUE_DARK, fontSize: 15)),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      _genderDisease(dto.diseases),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                      Text(
                        'Ngày tạo: ${_dateValidator.parseToDateView(dto.dateCreated)}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: DefaultTheme.GREY_TEXT, fontSize: 13),
                      ),
                    ],
                  ),
                  (dto.contractId != null)
                      ? Container()
                      : Positioned(
                          width: 35,
                          height: 35,
                          top: -10,
                          right: -10,
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

  _genderDisease(List<Diseases> list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            margin: EdgeInsets.only(bottom: 3),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(30),
            //   color: DefaultTheme.BLUE_DARK.withOpacity(0.4),
            // ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  child: Text('${list[index].diseaseId}'),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 200,
                  child: Text('${list[index].diseaseName}'),
                ),
              ],
            ));
      },
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
                      height: 260,
                      width: MediaQuery.of(context).size.width - 20,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 160,
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
                                    // refreshListHR();
                                    Navigator.of(context).pop();
                                    // medicalInstructionRepository.getListMedicalInstruction(healthRecordId).then((value) {
                                    //   if(value!=null||value.isNotEmpty){

                                    //   }
                                    // });
                                    //
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
                                                          'Trong hồ sơ có thể đang chứa các phiếu y lệnh\n Bạn có chắc chắn muốn xóa hồ sơ này hay không!',
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
                                                            showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Center(
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(5)),
                                                                    child:
                                                                        BackdropFilter(
                                                                      filter: ImageFilter.blur(
                                                                          sigmaX:
                                                                              25,
                                                                          sigmaY:
                                                                              25),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            300,
                                                                        height:
                                                                            300,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color: DefaultTheme.WHITE.withOpacity(0.8)),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 200,
                                                                              height: 200,
                                                                              child: Image.asset('assets/images/loading.gif'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                            healthRecordRepository
                                                                .deleteHealthRecord(
                                                                    healthRecordId)
                                                                .then(
                                                                    (res) async {
                                                              Navigator.pop(
                                                                  context);
                                                              await refreshListHR();
//                                                               if (res) {

//                                                               } else {
// //
//                                                               }
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
      String diseaseStr =
          listDisease[i]['diseaseId'] + ' - ' + listDisease[i]['diseaseName'];
      if (i == (listDisease.length - 1)) {
        str += diseaseStr;
      } else {
        str += diseaseStr + '\n';
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
