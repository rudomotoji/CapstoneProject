import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/artboard_button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/health_record_list_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/hr_list_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/health_record_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/hr_list_state.dart';
import 'package:capstone_home_doctor/features/health/health_record/views/create_health_record.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/health_record_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:capstone_home_doctor/commons/constants/global.dart' as globals;

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
  DateValidator _dateValidator = DateValidator();
  HealthRecordListBloc _healthRecordListBloc;
  HealthRecordHelper _healthRecordHelper = HealthRecordHelper();

  List<TypeFilter> _listFilter = globals.listFilter;
  TypeFilter _valueFilter;
  //
  int _patientId = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _healthRecordListBloc = BlocProvider.of(context);

    setState(() {
      _valueFilter = _listFilter[2];
    });
    _getPatientId();
    refreshListHR();
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        //
        Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        ),
        ButtonArtBoard(
          title: 'Tạo hồ sơ sức khoẻ',
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
        ButtonArtBoard(
          title: 'Chia sẻ y lệnh',
          description:
              'Các phiếu y lệnh được chia sẻ giúp bác sĩ chẩn đoán tốt hơn',
          imageAsset: 'assets/images/ic-medical-instruction.png',
          onTap: () async {
            Navigator.of(context).pushNamed(RoutesHDr.MEDICAL_SHARE);
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Danh sách hồ sơ sức khoẻ',
                  style: TextStyle(
                    color: DefaultTheme.BLACK,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        'Loại:',
                        style: TextStyle(
                          color: DefaultTheme.BLACK,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
                      margin: EdgeInsets.only(left: 10),
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: DefaultTheme.GREY_VIEW),
                        child: DropdownButton<TypeFilter>(
                          value: _valueFilter,
                          items: _listFilter.map((TypeFilter value) {
                            return new DropdownMenuItem<TypeFilter>(
                              value: value,
                              child: new Text(
                                value.label,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            );
                          }).toList(),
                          dropdownColor: DefaultTheme.GREY_VIEW,
                          elevation: 1,
                          hint: Container(
                            width: 130,
                            child: Text(
                              'Chọn loại bệnh để chia sẻ (*):',
                              style: TextStyle(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          underline: Container(
                            width: 0,
                          ),
                          isExpanded: false,
                          onChanged: (res) async {
                            setState(() {
                              _valueFilter = res;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        //start of list
        _loadListHealthRecord(),
        //end of list
        Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
      ],
    );
  }

  _loadListHealthRecord() {
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
          listHealthRecord = state.listHealthRecord;
          if (null != listHealthRecord) {
            if (listHealthRecord.length > 1) {
              listHealthRecord
                  .sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
            }
          }

          return (state.listHealthRecord == null)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text('Kiểm tra lại đường truyền kết nối mạng'),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.listHealthRecord.length,
                  itemBuilder: (BuildContext buildContext, int index) {
                    if (_valueFilter != null) {
                      if (_valueFilter.value == 0) {
                        if (state.listHealthRecord[index].contractId != null) {
                          return _itemHealthRecord(
                              state.listHealthRecord[index]);
                        }
                      }
                      if (_valueFilter.value == 1) {
                        if (state.listHealthRecord[index].contractId == null) {
                          return _itemHealthRecord(
                              state.listHealthRecord[index]);
                        }
                      }
                      if (_valueFilter.value == 2) {
                        return _itemHealthRecord(state.listHealthRecord[index]);
                      }
                    } else {
                      return _itemHealthRecord(state.listHealthRecord[index]);
                    }
                  });
          //
        }
        return Container(
            width: MediaQuery.of(context).size.width,
            child: Center(child: Text('Không thể tải danh sách hồ sơ')));
      },
    );
  }

  Widget _itemHealthRecord(HealthRecordDTO dto) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 10),
      padding: EdgeInsets.only(left: 0, right: 10, top: 10, bottom: 10),
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
                              'Hồ sơ ${dto.place}',
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
                  Positioned(
                    width: 35,
                    height: 35,
                    top: -10,
                    right: 0,
                    child: ButtonHDr(
                      style: BtnStyle.BUTTON_IMAGE,
                      image: Image.asset('assets/images/ic-more.png'),
                      onTap: () {
                        _showMorePopup(dto.healthRecordId, dto.contractId);
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

  _showMorePopup(int healthRecordId, int contractID) {
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
                                      'Hồ sơ ${healthRecordId}',
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
                                  label: 'Chi tiết',
                                  height: 60,
                                  labelColor: DefaultTheme.BLUE_TEXT,
                                  style: BtnStyle.BUTTON_IN_LIST,
                                  onTap: () {
                                    _healthRecordHelper
                                        .setHealthReCordId(healthRecordId);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushNamed(
                                        RoutesHDr.HEALTH_RECORD_DETAIL);
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
}
