import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';

import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/doctor_info_bloc.dart';
import 'package:capstone_home_doctor/features/contract/blocs/request_contract_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/doctor_info_event.dart';
import 'package:capstone_home_doctor/features/contract/events/request_contract_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/doctor_repository.dart';
import 'package:capstone_home_doctor/features/contract/repositories/request_contract_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/doctor_info_state.dart';
import 'package:capstone_home_doctor/features/contract/states/request_contract_state.dart';

import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
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
  int _dayOfTrackingValue = 7;
  String _dayOfTrackingView = '1 tuần';
  var _noteController = TextEditingController();
  String _reason = '';
  RequestContractDTO reqContractDTO;
  DoctorRepository doctorRepository =
      DoctorRepository(httpClient: http.Client());
  RequestContractRepository requestContractRepository =
      RequestContractRepository(httpClient: http.Client());

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
    //idDoctor
    String arguments = ModalRoute.of(context).settings.arguments;
    //
    final requestContractProvider =
        Provider.of<RequestContractDTOProvider>(context, listen: false);
    requestContractProvider.setProvider(
        doctorId: int.parse(arguments.trim()),
        patientId: 2,
        dateStarted: _startDate,
        dayOfTracking: _dayOfTrackingValue,
        reason: _reason);

    return MultiBlocProvider(
      providers: [
        BlocProvider<DoctorInfoBloc>(
          create: (BuildContext context) =>
              DoctorInfoBloc(doctorAPI: doctorRepository),
        ),
        BlocProvider<RequestContractBloc>(
          create: (BuildContext context) => RequestContractBloc(
              requestContractAPI: requestContractRepository),
        ),
      ],
      child: Scaffold(
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
                      BlocProvider(
                        create: (context) =>
                            DoctorInfoBloc(doctorAPI: doctorRepository)
                              ..add(DoctorInfoEventSetId(id: arguments)),
                        child: _getDoctorInfo(),
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
                        padding:
                            EdgeInsets.only(bottom: 5, left: 20, right: 20),
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
                          'Theo dõi liên tục',
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
                              '${_dayOfTrackingView}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Spacer(),
                            ButtonHDr(
                              label: 'Chọn',
                              style: BtnStyle.BUTTON_FULL,
                              image:
                                  Image.asset('assets/images/ic-dropdown.png'),
                              width: 30,
                              height: 40,
                              labelColor: DefaultTheme.BLUE_REFERENCE,
                              bgColor: DefaultTheme.TRANSPARENT,
                              onTap: () {
                                _showDatePickerEnd();
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 30),
                            )
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
                          keyboardAction: TextInputAction.done,
                          onChange: (text) {
                            setState(() {
                              _reason = text;
                            });
                          },
                          style: TFStyle.TEXT_AREA,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: ButtonHDr(
                            style: BtnStyle.BUTTON_BLACK,
                            label: 'Gửi yêu cầu',
                            onTap: () {
                              BlocProvider.of<RequestContractBloc>(context).add(
                                  RequestContractEventSend(
                                      dto:
                                          requestContractProvider.getProvider));
                              // _showDialogCustom('success');
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RoutesHDr.MAIN_HOME,
                                  (Route<dynamic> route) => false);
                            }),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  //validate state request
  _stateRequest() {
    return BlocBuilder<RequestContractBloc, RequestContractState>(
        builder: (context, state) {
      if (state is RequestContractStateLoading) {
        return _showDialogCustom('loading');
      }
      if (state is RequestContractStateFailure) {
        return _showDialogCustom('failed');
      }
      if (state is RequestContractStateSuccess) {
        if (state.isRequested == false) {
          return _showDialogCustom('failed');
        }
      }
      return _showDialogCustom('success');
    });
  }

  //show dialog
  _showDialogCustom(String status) {
    if (status == 'loading') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              //do for pop
              if (status != 'loading') {
                Navigator.of(context).pop();
              }
              return null;
            },
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: DefaultTheme.WHITE.withOpacity(0.6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                        ),
                        SizedBox(
                          child: Image.asset('assets/images/loading.gif'),
                          width: 80,
                          height: 80,
                        ),
                        Spacer(),
                        Text(
                          'Đang gửi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: DefaultTheme.BLACK,
                              fontSize: 15,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w400),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
    if (status == 'success') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              await Future.delayed(Duration(seconds: 3));
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(context, RoutesHDr.MAIN_HOME,
                  (Route<dynamic> route) => false);
              return null;
            },
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: DefaultTheme.WHITE.withOpacity(0.6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                        ),
                        SizedBox(
                          child: Image.asset('assets/images/ic-done.png'),
                          width: 80,
                          height: 80,
                        ),
                        Spacer(),
                        Text(
                          'Gửi yêu cầu thành công',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: DefaultTheme.BLACK,
                              fontSize: 15,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w400),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
    if (status == 'failed') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              await Future.delayed(Duration(seconds: 3));
              Navigator.of(context).pop;
            },
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: DefaultTheme.WHITE.withOpacity(0.6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                        ),
                        SizedBox(
                          child: Image.asset('assets/images/ic-failed.png'),
                          width: 80,
                          height: 80,
                        ),
                        Spacer(),
                        Text(
                          'Gửi yêu cầu thất bại',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: DefaultTheme.BLACK,
                              fontSize: 15,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w400),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  //FUNCTION GET DOCTOR BY DOCTOR ID
  _getDoctorInfo() {
    return BlocBuilder<DoctorInfoBloc, DoctorInfoState>(
        builder: (context, state) {
      if (state is DoctorInfoStateLoading) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: DefaultTheme.GREY_BUTTON),
          child: Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: Image.asset('assets/images/loading.gif'),
            ),
          ),
        );
      }
      if (state is DoctorInfoStateFailure) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: DefaultTheme.GREY_BUTTON),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text('Failed to find Doctor',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ),
        );
      }
      if (state is DoctorInfoStateSuccess) {
        if (state.dto == null) {
          return Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: DefaultTheme.GREY_BUTTON),
            child: Center(
              child: Text('Failed to find Doctor'),
            ),
          );
        }
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: DefaultTheme.GREY_BUTTON),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                child: Text(
                  'Bác sĩ: ${state.dto.fullName}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 20, top: 5, bottom: 20, right: 20),
                child: Text(
                  'Làm việc tại ${state.dto.workLocation}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      }
      return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: DefaultTheme.GREY_BUTTON),
        child: Center(
          child: Text('Failed to find Doctor'),
        ),
      );
    });
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
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ngày bắt đầu',
                          style: TextStyle(
                            fontSize: 20,
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Theo dõi liên tục',
                          style: TextStyle(
                            fontSize: 20,
                            color: DefaultTheme.BLACK,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 50,
                        scrollController:
                            FixedExtentScrollController(initialItem: 0),
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text('1 tuần'),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text('1 tháng'),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text('3 tháng'),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text('6 tháng'),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text('1 năm'),
                          ),
                        ],
                        onSelectedItemChanged: (value) {
                          setState(() {
                            if (value == 0) {
                              _dayOfTrackingView = '1 tuần';
                              _dayOfTrackingValue = 7;
                            }
                            if (value == 1) {
                              _dayOfTrackingView = '1 tháng';
                              _dayOfTrackingValue = 30;
                            }
                            if (value == 2) {
                              _dayOfTrackingView = '3 tháng';
                              _dayOfTrackingValue = 90;
                            }
                            if (value == 3) {
                              _dayOfTrackingView = '6 tháng';
                              _dayOfTrackingValue = 180;
                            }
                            if (value == 4) {
                              _dayOfTrackingView = '1 năm';
                              _dayOfTrackingValue = 365;
                            }
                          });
                        },
                      ),
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
