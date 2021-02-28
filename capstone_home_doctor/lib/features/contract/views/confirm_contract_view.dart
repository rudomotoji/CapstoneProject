import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/contract_request_bloc.dart';

import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/contract_request_state.dart';
import 'package:capstone_home_doctor/models/disease_dto.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:flutter/material.dart';
import 'package:capstone_home_doctor/features/contract/views/request_contract_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ConfirmContract extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConfirmContract();
  }
}

class _ConfirmContract extends State<ConfirmContract>
    with WidgetsBindingObserver {
  ContractRepository requestContractRepository =
      ContractRepository(httpClient: http.Client());

  DateValidator _dateValidator = DateValidator();
  String _currentDate = DateTime.now().toString().split(' ')[0];
  String _dateInWeek = DateFormat('EEEE').format(DateTime.now());

  //
  bool _isAccept = false;

  _updateAcceptState() {
    setState(() {
      _isAccept = !_isAccept;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Object> arguments = ModalRoute.of(context).settings.arguments;
    RequestContractDTO _requestContract = arguments['REQUEST_OBJ'];
    ContractViewObj _componentViews = arguments['VIEWS_OBJ'];

    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          HeaderWidget(
            title: 'Xác nhận',
            isMainView: false,
            buttonHeaderType: ButtonHeaderType.BACK_HOME,
          ),
          Expanded(
            child: ListView(children: <Widget>[
              //
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: DefaultTheme.GREY_VIEW),
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                padding: EdgeInsets.only(top: 30, bottom: 30),
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'HỢP ĐỒNG THEO DÕI SỨC KHOẺ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${_dateValidator.parseDateInWeekToView(_dateInWeek)}, ngày ${_dateValidator.parseToDateView(_currentDate)}',
                          style: TextStyle(
                              color: DefaultTheme.GREY_TEXT,
                              fontSize: 15,
                              fontFamily: 'NewYork'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 30),
                      child: Text(
                        'Bên Bác Sĩ',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontFamily: 'NewYork'),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 130,
                          child: Text(
                            'Họ và tên:',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (40 + 120 + 20),
                          child: Text(
                            '${_componentViews.dname}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 130,
                          child: Text(
                            'Công tác tại:',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (40 + 120 + 20),
                          child: Text(
                            '${_componentViews.dplace}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 130,
                          child: Text(
                            'Điện thoại:',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (40 + 120 + 20),
                          child: Text(
                            '${_componentViews.dSdt}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 130,
                          child: Text(
                            'Email:',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (40 + 120 + 20),
                          child: Text(
                            '${_componentViews.dEmail}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 30),
                      child: Text(
                        'Bên Bệnh nhân',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontFamily: 'NewYork'),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 130,
                          child: Text(
                            'Họ và tên:',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (40 + 120 + 20),
                          child: Text(
                            '${_componentViews.pname}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 130,
                          child: Text(
                            'ĐC thường trú:',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (40 + 120 + 20),
                          child: Text(
                            '${_componentViews.pAdd}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 130,
                          child: Text(
                            'Ngày sinh:',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (40 + 120 + 20),
                          child: Text(
                            '${_dateValidator.parseToDateView(_componentViews.pBirthdate)}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 130,
                          child: Text(
                            'Giới tính:',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (40 + 120 + 20),
                          child: Text(
                            '${_componentViews.pGender}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 130,
                          child: Text(
                            'Điện thoại:',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (40 + 120 + 20),
                          child: Text(
                            '${_componentViews.pSdt}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      child: Divider(
                        color: DefaultTheme.GREY_TEXT,
                        height: 0.1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 100,
                          child: Text(
                            'Bệnh lý tim mạch:',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (130 + 20 + 10 + 20),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _componentViews.diseases.length,
                            itemBuilder:
                                (BuildContext buildContext, int index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50,
                                      child: Text(
                                        '${_componentViews.diseases[index].diseaseId}',
                                        style: TextStyle(
                                            color: DefaultTheme.BLACK,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'NewYork'),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          (130 + 20 + 10 + 20 + 60),
                                      child: Text(
                                        '${_componentViews.diseases[index].name}',
                                        style: TextStyle(
                                            color: DefaultTheme.BLACK,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'NewYork'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      child: Divider(
                        color: DefaultTheme.GREY_TEXT,
                        height: 0.1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 120,
                          child: Text(
                            'Mô tả thêm:',
                            style: TextStyle(
                                color: DefaultTheme.GREY_TEXT,
                                fontSize: 15,
                                fontFamily: 'NewYork'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (40 + 120 + 20),
                          child: (_componentViews.note == null ||
                                  _componentViews.note.isEmpty)
                              ? Text('Không có mô tả thêm nào',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'NewYork'))
                              : Text(
                                  '${_componentViews.note}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'NewYork'),
                                ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                      child: Text(
                          'Hai bên chấp thuận và cam kết làm đúng những điều khoản sau:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'NewYork')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 20),
                      child: Text(
                        'Điều 1: Thời hạn và nhiệm vụ hợp đồng',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'NewYork'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 30),
                      child: Text(
                        'Điều 2: Chế độ thăm khám và theo dõi',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'NewYork'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 30),
                      child: Text(
                        'Điều 3: Trách nhiệm của hai bên',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'NewYork'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => _updateAcceptState(),
                      borderRadius: BorderRadius.circular(40),
                      child: _isAccept
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: Image.asset('assets/images/ic-dot.png'),
                            )
                          : SizedBox(
                              width: 20,
                              height: 20,
                              child: Image.asset(
                                  'assets/images/ic-dot-unselect.png'),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Text(
                      'Tôi đồng ý với tất cả các điều khoản.',
                      style: TextStyle(
                        color: DefaultTheme.GREY_TEXT,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              (_isAccept == false)
                  ? Container(
                      margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                      height: 50,
                      decoration: BoxDecoration(
                          color: DefaultTheme.GREY_BUTTON,
                          borderRadius: BorderRadius.circular(10)),
                      child: Align(
                        alignment: Alignment.center,
                        heightFactor: 50,
                        child: Text('Gửi yêu cầu',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16)),
                      ),
                    )
                  : new Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: ButtonHDr(
                        label: 'Gửi yêu cầu',
                        style: BtnStyle.BUTTON_BLACK,
                        onTap: () {
                          if (_isAccept) {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                RoutesHDr.MAIN_HOME,
                                (Route<dynamic> route) => false);
                          }
                        },
                      ),
                    ),
            ]),
          ),
        ],
      ),
    ));
  }

  _sendRequest() {
    return BlocBuilder<RequestContractBloc, RequestContractState>(
      builder: (context, state) {
        if (state is RequestContractStateLoading) {}
        if (state is RequestContractStateFailure) {}
        if (state is RequestContractStateSuccess) {}
        return null;
      },
    );
  }
}
