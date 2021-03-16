import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/contract/blocs/doctor_info_bloc.dart';
import 'package:capstone_home_doctor/features/contract/events/doctor_info_event.dart';
import 'package:capstone_home_doctor/features/contract/states/doctor_info_state.dart';
import 'package:capstone_home_doctor/models/doctor_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicalShare extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MedicalShare();
  }
}

class _MedicalShare extends State<MedicalShare> with WidgetsBindingObserver {
  List<DoctorDTO> listDoctors = [
    DoctorDTO(
        doctorId: 1,
        accountId: 2,
        username: "huynl",
        fullName: "Nguyễn Lê Huy",
        workLocation: "BV quận 9",
        experience: null,
        specialization: "Tim mạch",
        address: "Quận 9 , tp HCM",
        details:
            "30 năm kinh nghiệm trong việc khám chữa bệnh tim mạch. Top 10 bác sĩ giỏi của cả nước. ",
        phone: "987654321",
        email: "huynl@gmail.com",
        dateOfBirth: "0001-01-01T00:00:00"),
    DoctorDTO(
        doctorId: 2,
        accountId: 2,
        username: "huynl",
        fullName: "Nguyễn nhan",
        workLocation: "BV quận 9",
        experience: null,
        specialization: "Tim mạch",
        address: "Quận 9 , tp HCM",
        details:
            "30 năm kinh nghiệm trong việc khám chữa bệnh tim mạch. Top 10 bác sĩ giỏi của cả nước. ",
        phone: "987654321",
        email: "huynl@gmail.com",
        dateOfBirth: "0001-01-01T00:00:00"),
  ];
  DoctorDTO dropdownValue;
  DoctorInfoBloc _doctorInfoBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _doctorInfoBloc = BlocProvider.of(context);
    _doctorInfoBloc.add(DoctorInfoEventGetDoctors());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Chia sẻ bệnh án',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.NONE,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: ListView(
                  children: [
                    BlocBuilder<DoctorInfoBloc, DoctorInfoState>(
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
                            margin: EdgeInsets.only(
                                left: 20, right: 20, bottom: 10, top: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: DefaultTheme.GREY_BUTTON),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 20, right: 20),
                              child: Text(
                                  'Không tìm thấy bác sĩ bạn có thế chia sẻ',
                                  style: TextStyle(
                                    color: DefaultTheme.GREY_TEXT,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                          );
                        }
                        if (state is DoctorInfoStateSuccess) {
                          setState(() {
                            listDoctors = state.listDoctors;
                          });
                        }
                        return Container();
                      },
                    ),
                    _selectDoctor()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectDoctor() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            color: DefaultTheme.GREY_VIEW,
            borderRadius: BorderRadius.circular(6)),
        child: DropdownButton<DoctorDTO>(
          value: dropdownValue,
          items: listDoctors.map((DoctorDTO value) {
            return new DropdownMenuItem<DoctorDTO>(
              value: value,
              child: new Text(
                value.fullName,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            );
          }).toList(),
          dropdownColor: DefaultTheme.GREY_VIEW,
          elevation: 1,
          hint: Container(
            width: MediaQuery.of(context).size.width - 84,
            child: Text(
              'Chọn bác sĩ muốn chia sẻ (*):',
              style: TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          underline: Container(
            width: 0,
          ),
          isExpanded: false,
          onChanged: (res) {
            setState(() {
              dropdownValue = res;
            });
          },
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    _doctorInfoBloc.add(DoctorInfoEventGetDoctors());
  }
}
