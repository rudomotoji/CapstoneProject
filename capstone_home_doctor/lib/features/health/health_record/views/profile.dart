import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/artboard_button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/features/health/health_record/views/create_health_record.dart';
import 'package:capstone_home_doctor/models/health_record_dto.dart';
import 'package:capstone_home_doctor/services/health_record_helper.dart';
import 'package:capstone_home_doctor/services/sqflite_helper.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with WidgetsBindingObserver {
  SQFLiteHelper _sqfLiteHelper = SQFLiteHelper();
  List<HealthRecordDTO> listHealthRecord;
  HealthRecordHelper _healthRecordHelper = HealthRecordHelper();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    listHealthRecord = [];
    refreshListHR();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (null != listHealthRecord) {
      if (listHealthRecord.length > 1) {
        listHealthRecord.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        //
        Padding(
          padding: EdgeInsets.only(top: 30, left: 20, right: 20),
        ),
        ButtonArtBoard(
          title: 'Thêm bệnh lý',
          description: 'Bệnh lý bao gồm các hồ sơ y lệnh',
          imageAsset: 'assets/images/ic-health-record.png',
          onTap: () async {
            //
            // Navigator.of(context).pushNamed(RoutesHDr.CREATE_HEALTH_RECORD);
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        new CreateHealthRecord(refreshListHR)));
          },
        ),

        Padding(
          padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Bệnh lý đang theo dõi',
              style: TextStyle(
                color: DefaultTheme.BLACK,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Danh sách bệnh lý',
              style: TextStyle(
                color: DefaultTheme.BLACK,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        (listHealthRecord.length == 0)
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Center(
                  child: Text('Chưa có hồ sơ nào'),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listHealthRecord.length,
                itemBuilder: (BuildContext buildContext, int index) {
                  return Container(
                    margin: EdgeInsets.only(left: 20, right: 10),
                    padding: EdgeInsets.only(
                        left: 0, right: 10, top: 10, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        //
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
                            child: Image.asset(
                                'assets/images/ic-health-record.png'),
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
                                    Text(
                                      'Bệnh lý: ${listHealthRecord[index].disease}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Ngày tạo: ${listHealthRecord[index].dateCreated.split(' ')[0].split("-")[2]}, tháng ${listHealthRecord[index].dateCreated.split(' ')[0].split("-")[1]}, năm ${listHealthRecord[index].dateCreated.split(' ')[0].split("-")[0]}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: DefaultTheme.GREY_TEXT,
                                          fontSize: 12),
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
                                    image: Image.asset(
                                        'assets/images/ic-more.png'),
                                    onTap: () {
                                      _showMorePopup(
                                          listHealthRecord[index]
                                              .healthRecordId,
                                          listHealthRecord[index].disease);
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
                }),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
        //       : ListView.builder(
        //           shrinkWrap: true,
        //           physics: NeverScrollableScrollPhysics(),
        //           itemCount: listHealthRecord.length,
        //           itemBuilder: (BuildContext buildContext, int index) {
        //             return Container(
        //               padding: EdgeInsets.only(left: 20, right: 20),
        //               child: Row(
        //                 children: <Widget>[
        //                   Column(
        //                     children: <Widget>[
        //                       //line
        //                       Container(
        //                         width: 0.5,
        //                         height: 65,
        //                         color: DefaultTheme.GREY_TEXT,
        //                       ),
        //                       //icon in line
        //                       //line
        //                       Container(
        //                         width: 60,
        //                         height: 60,
        //                         decoration: BoxDecoration(
        //                           borderRadius: BorderRadius.circular(10),
        //                           border: Border.all(
        //                             color: DefaultTheme.GREY_TOP_TAB_BAR,
        //                             width: 0.5,
        //                           ),
        //                           color: DefaultTheme.WHITE,
        //                         ),
        //                         child: Column(
        //                           mainAxisAlignment: MainAxisAlignment.center,
        //                           children: [
        //                             Text(
        //                               '${listHealthRecord[index].createdDate.split(' ')[0].split('-')[2]}',
        //                               style: TextStyle(
        //                                   color: DefaultTheme.RED_CALENDAR,
        //                                   fontSize: 15),
        //                             ),
        //                             Text(
        //                               ' th ${listHealthRecord[index].createdDate.split(' ')[0].split('-')[1]}',
        //                               style: TextStyle(
        //                                 fontSize: 12,
        //                                 color: DefaultTheme.BLACK_BUTTON,
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                       Container(
        //                         width: 0.5,
        //                         height: 65,
        //                         color: DefaultTheme.GREY_TEXT,
        //                       ),
        //                     ],
        //                   ),
        //                   Padding(
        //                     padding: EdgeInsets.only(left: 10),
        //                   ),
        //                   Expanded(
        //                     child: Stack(
        //                       children: <Widget>[
        //                         Column(
        //                           mainAxisAlignment: MainAxisAlignment.start,
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Container(
        //                               height: 180,
        //                               decoration: BoxDecoration(
        //                                   color: Colors.white,
        //                                   borderRadius: BorderRadius.circular(10),
        //                                   boxShadow: [
        //                                     BoxShadow(
        //                                         blurRadius: 10,
        //                                         color: DefaultTheme.GREY_VIEW)
        //                                   ]),
        //                               width:
        //                                   MediaQuery.of(context).size.width - 70,
        //                               child: Padding(
        //                                 padding: EdgeInsets.only(
        //                                     left: 10, top: 15, bottom: 10),
        //                                 child: Column(
        //                                   crossAxisAlignment:
        //                                       CrossAxisAlignment.start,
        //                                   children: <Widget>[
        //                                     Container(
        //                                       padding: EdgeInsets.only(right: 30),
        //                                       child: Text(
        //                                         'Loại hồ sơ: ${listHealthRecord[index].diseaseType}',
        //                                         overflow: TextOverflow.ellipsis,
        //                                         maxLines: 2,
        //                                         style: TextStyle(
        //                                           color:
        //                                               DefaultTheme.BLACK_BUTTON,
        //                                           fontSize: 15,
        //                                           fontWeight: FontWeight.w500,
        //                                         ),
        //                                       ),
        //                                     ),
        //                                     Padding(
        //                                       padding: EdgeInsets.only(top: 3),
        //                                     ),
        //                                     Text(
        //                                       '${listHealthRecord[index].createdDate.split(' ')[1].split(':')[0]}:${listHealthRecord[index].createdDate.split(' ')[1].split(':')[1]}',
        //                                       overflow: TextOverflow.ellipsis,
        //                                       maxLines: 2,
        //                                       style: TextStyle(
        //                                         color: DefaultTheme.GREY_TEXT,
        //                                         fontSize: 12,
        //                                         fontWeight: FontWeight.w400,
        //                                       ),
        //                                     ),
        //                                     Padding(
        //                                       padding: EdgeInsets.only(top: 10),
        //                                     ),
        //                                     ClipRRect(
        //                                       borderRadius:
        //                                           BorderRadius.circular(15),
        //                                       child: SizedBox(
        //                                           width: 80,
        //                                           height: 80,
        //                                           child: ImageUltility
        //                                               .imageFromBase64String(
        //                                                   listHealthRecord[index]
        //                                                       .imgage)),
        //                                     ),
        //                                     Padding(
        //                                       padding: EdgeInsets.only(top: 10),
        //                                     ),
        //                                   ],
        //                                 ),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                         Positioned(
        //                           width: 35,
        //                           height: 35,
        //                           top: 7,
        //                           right: 0,
        //                           child: ButtonHDr(
        //                             style: BtnStyle.BUTTON_IMAGE,
        //                             image:
        //                                 Image.asset('assets/images/ic-more.png'),
        //                             onTap: () {
        //                               _showMorePopup();
        //                             },
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             );
        //           },
        //         ),
      ],
    );
  }

  _showMorePopup(String healthRecordId, String disease) {
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
                                    'Bệnh lý ${disease}',
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
                                    _healthRecordHelper
                                        .setHealthReCordId(healthRecordId);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushNamed(
                                        RoutesHDr.HEALTH_RECORD_DETAIL,
                                        arguments: {'HR_ID': healthRecordId});
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
                                    _sqfLiteHelper
                                        .deleteHealthRecord(healthRecordId);
                                    refreshListHR();
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

  refreshListHR() {
    //getListHealthRecord(personal health record ID)

    _sqfLiteHelper.getListHealthRecord('1').then((hrs) {
      setState(() {
        listHealthRecord.clear();
        listHealthRecord.addAll(hrs);
      });
    });
  }
}
