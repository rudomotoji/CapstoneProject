import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReasonContractView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReasonContractView();
  }
}

class _ReasonContractView extends State<ReasonContractView>
    with WidgetsBindingObserver {
  TextEditingController _noteController = TextEditingController();
  String _startDate = DateTime.now().toString().split(' ')[0];
  String _note = '';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Map<String, Object> arguments = ModalRoute.of(context).settings.arguments;
    RequestContractDTO _requestContract = arguments['REQUEST_OBJ'];
    // print(
    //     '${_requestContract.medicalInstructionIds} \n ${_requestContract.diseaseIds}');
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //
            HeaderWidget(
              title: 'Yêu cầu hợp đồng',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  //CONTENT
                  Container(
                    decoration: BoxDecoration(
                      color: DefaultTheme.GREY_VIEW,
                    ),
                    child: Column(
                      children: <Widget>[
                        //
                      ],
                    ),
                  ),
                  //NOTE
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Padding(
                          padding:
                              EdgeInsets.only(bottom: 5, left: 10, top: 20),
                          child: Text(
                            'Ghi chú',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: DefaultTheme.BLACK_BUTTON,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.topLeft,
                        height: 150,
                        child: TextFieldHDr(
                          placeHolder:
                              'Mô tả thêm về mong muốn trong quá trình chăm khám của bác sĩ và chi tiết thêm các vấn đề bệnh lý (nếu có)',
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, left: 20, right: 20),
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
                          image:
                              Image.asset('assets/images/ic-choose-date.png'),
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
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 30),
              child: Column(
                children: <Widget>[
                  //
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 3, right: 3),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3, right: 3),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: DefaultTheme.GREY_TOP_TAB_BAR,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 3, right: 3),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      'Quyền lợi và nghĩa vụ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      'Bước 2',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: DefaultTheme.GREY_TEXT),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ButtonHDr(
                      style: BtnStyle.BUTTON_BLACK,
                      label: 'Tiếp theo',
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            RoutesHDr.CONTRACT_DRAFT_VIEW,
                            arguments: {
                              'REQUEST_OBJ': _requestContract,
                              'NOTE': _note,
                              'DATE_START': _startDate,
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),

            //
          ],
        ),
      ),
    );
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
