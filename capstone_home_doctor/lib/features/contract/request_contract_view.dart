import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestContract extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RequestContract();
  }
}

class _RequestContract extends State<RequestContract>
    with WidgetsBindingObserver {
  String _startDate = DateTime.now().toString().split(' ')[0];
  String _endDate = DateTime.now().toString().split(' ')[0];
  String _reason;
  RequestContractDTO reqContractDTO;

  DateTime _startDateValue = DateTime.now();
  DateTime _endDateValue = DateTime.now();
  var _noteController = TextEditingController();
  // _ConfirmContract({})
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String arguments = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              HeaderWidget(
                title: 'Xác nhận yêu cầu',
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
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: DefaultTheme.GREY_BUTTON),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 20, right: 20),
                            child: Text(
                              'Bác sĩ ${arguments}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, top: 5, bottom: 20, right: 20),
                            child: Text(
                              'Làm việc tại Bệnh viện ABC XYZ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 50),
                      child: Text(
                        'Thông tin hợp đồng',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
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
                                _showDatePickerStart();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 5, left: 20, right: 20, top: 10),
                      child: Text(
                        'Ngày kết thúc',
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
                            '${_endDate.split('-')[2]} tháng ${_endDate.split('-')[1]} năm ${_endDate.split('-')[0]}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
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
                                _showDatePickerEnd();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 5, left: 20, right: 20, top: 10),
                      child: Text(
                        'Ghi chú',
                        style: TextStyle(
                            color: DefaultTheme.BLACK_BUTTON,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      height: 200,
                      child: TextFieldHDr(
                        controller: _noteController,
                        onChange: (text) {
                          setState(() {
                            _reason = text;
                          });
                        },
                        style: TFStyle.TEXT_AREA,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 50),
                      child: ButtonHDr(
                        style: BtnStyle.BUTTON_BLACK,
                        label: 'Gửi yêu cầu',
                        onTap: () => _submitRequest(),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

//FUNCTION TO REQUEST CONTRACT HERE
  void _submitRequest() {
    if (_reason == null) {
      _reason = 'Nothing';
    }
    reqContractDTO = new RequestContractDTO(
        doctorId: '1',
        patientId: '1',
        dateStarted: _startDate,
        dateFinished: _endDate,
        reason: _reason);

    print('HERE IN VIEW: ${reqContractDTO.reason}');
    print('HERE IN VIEW: ${reqContractDTO.doctorId}');
    print('HERE IN VIEW: ${reqContractDTO.patientId}');
    print('HERE IN VIEW: ${reqContractDTO.dateStarted}');
    print('HERE IN VIEW: ${reqContractDTO.dateFinished}');
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
                    Expanded(
                      child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          minimumDate: DateTime.now(),
                          onDateTimeChanged: (dateTime) {
                            setState(() {
                              _startDateValue = dateTime;
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

  void _showDatePickerEnd() {
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
                    Expanded(
                      child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          minimumDate: DateTime.now(),
                          onDateTimeChanged: (dateTime) {
                            setState(() {
                              _endDateValue = dateTime;
                              _endDate = dateTime.toString().split(' ')[0];
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
