import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/doctor_info_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/doctor_info_event.dart';
import 'package:capstone_home_doctor/features/contract/repositories/doctor_repository.dart';
import 'package:capstone_home_doctor/features/contract/states/doctor_info_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

DoctorRepository doctorRepository = DoctorRepository(httpClient: http.Client());

class DoctorInformation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DoctorInformation();
  }
}

class _DoctorInformation extends State<DoctorInformation>
    with WidgetsBindingObserver {
  //
  int _idDoctor = 0;

  @override
  Widget build(BuildContext context) {
    //
    String arguments = ModalRoute.of(context).settings.arguments;
    _idDoctor = int.tryParse(arguments);
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [DefaultTheme.GRADIENT_1, DefaultTheme.GRADIENT_2]),
      ),
      child: Scaffold(
        backgroundColor: DefaultTheme.TRANSPARENT,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //
              HeaderWidget(
                title: 'Thông tin bác sĩ ',
                isMainView: false,
                buttonHeaderType: ButtonHeaderType.BACK_HOME,
              ),
              Expanded(
                child: BlocProvider(
                  create: (context) =>
                      DoctorInfoBloc(doctorAPI: doctorRepository)
                        ..add(DoctorInfoEventSetId(id: arguments)),
                  child: _getDoctorInfo(),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.only(left: 20, bottom: 30, top: 30),
                child: ButtonHDr(
                  style: BtnStyle.BUTTON_BLACK,
                  label: 'Yêu cầu hợp đồng',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, RoutesHDr.CONTRACT_SHARE_VIEW,
                        arguments: arguments);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

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
              width: 150,
              height: 150,
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
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Text('Không tìm thấy bác sĩ',
                style: TextStyle(
                  color: DefaultTheme.GREY_TEXT,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
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
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              child: Text('Không tìm thấy bác sĩ',
                  style: TextStyle(
                    color: DefaultTheme.GREY_TEXT,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          );
        }

        return Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: DefaultTheme.GREY_BUTTON),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                  //avt
                  SizedBox(
                    child: CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: Image.asset('assets/images/avatar-default.jpg'),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            width: 50,
                            child: Text(
                              'Bác sĩ',
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
                            width: MediaQuery.of(context).size.width - (200),
                            child: Text(
                              '${state.dto.fullName}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            width: 50,
                            child: Text(
                              'Email',
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
                            width: MediaQuery.of(context).size.width - (200),
                            child: Text(
                              '${state.dto.email}',
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
                    ],
                  ),

                  //
                ],
              ),
              //
              Padding(
                padding: EdgeInsets.only(bottom: 20, top: 10),
                child: Divider(
                  color: DefaultTheme.GREY_TOP_TAB_BAR,
                  height: 1,
                ),
              ),
              //

              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 120,
                    child: Text(
                      'Chuyên khoa',
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
                    width: MediaQuery.of(context).size.width - (80 + 120 + 10),
                    child: Text(
                      '${state.dto.specialization}',
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
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 120,
                    child: Text(
                      'Nơi làm việc',
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
                    width: MediaQuery.of(context).size.width - (80 + 120 + 10),
                    child: Text(
                      '${state.dto.workLocation}',
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
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 120,
                    child: Text(
                      'Đ/C phòng khám',
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
                    width: MediaQuery.of(context).size.width - (80 + 120 + 10),
                    child: Text(
                      '${state.dto.address}',
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
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 120,
                    child: Text(
                      'Số điện thoại',
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
                    width: MediaQuery.of(context).size.width - (80 + 120 + 10),
                    child: Text(
                      '${state.dto.phone}',
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
                padding: EdgeInsets.only(top: 10),
              ),
              //
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 120,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Kinh nghiệm',
                        style: TextStyle(
                          color: DefaultTheme.GREY_TEXT,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - (80 + 120 + 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${state.dto.details}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
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
          child: Text('Không tìm thấy bác sĩ'),
        ),
      );
    });
  }
}
