import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/health/health_record/blocs/med_ins_detail_bloc.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_get_by_id_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/events/med_ins_list_event.dart';
import 'package:capstone_home_doctor/features/health/health_record/repositories/medical_instruction_repository.dart';
import 'package:capstone_home_doctor/features/health/health_record/states/med_ins_get_by_id_state.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class MedicalHistoryDetailView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MedicalHistoryDetailView();
  }
}

class _MedicalHistoryDetailView extends State<MedicalHistoryDetailView>
    with WidgetsBindingObserver {
  DateValidator _dateValidator = DateValidator();
  MedicalInstructionDTO _currentPrescription = MedicalInstructionDTO();
  int medicalInstructionId = 0;
  MedicalInstructionRepository medicalInstructionRepository =
      MedicalInstructionRepository(httpClient: http.Client());
  MedicalInstructionDetailBloc medicalInstructionDetailBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    medicalInstructionDetailBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    medicalInstructionId = ModalRoute.of(context).settings.arguments;
    _pullRefresh();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Chi tiết đơn thuốc',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: ListView(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  children: [
                    BlocBuilder<MedicalInstructionDetailBloc,
                        MedInsDetailState>(
                      builder: (context, state) {
                        if (state is MedInsDetailStateLoading) {
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
                        if (state is MedInsDetailStateFailure) {
                          return Container(
                            child:
                                Text('Không thể lấy được thông tin đơn thuốc!'),
                          );
                        }
                        if (state is MedInsDetailStateSuccess) {
                          _currentPrescription = state.dto;
                          return (_currentPrescription != null)
                              ? _getMedicineSchedule()
                              : Container();
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    medicalInstructionDetailBloc
        .add(MedInsDetailEventGetById(id: medicalInstructionId));
  }

  _getMedicineSchedule() {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 10),
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          color: DefaultTheme.GREY_VIEW,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                width: 140,
                child: Text(
                  'Kê đơn ngày:',
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
                width: MediaQuery.of(context).size.width - (40 + 120 + 20 + 30),
                child: Text(
                  '${_dateValidator.parseToDateView(_currentPrescription.medicationsRespone.dateStarted)}',
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
            padding: EdgeInsets.only(bottom: 5),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                width: 140,
                child: Text(
                  'Đến ngày:',
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
                width: MediaQuery.of(context).size.width - (40 + 120 + 20 + 30),
                child: Text(
                  '${_dateValidator.parseToDateView(_currentPrescription.medicationsRespone.dateFinished)}',
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
            padding: EdgeInsets.only(bottom: 5),
          ),
          //diagnose
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Divider(
              color: DefaultTheme.GREY_TEXT,
              height: 0.1,
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                width: 140,
                child: Text(
                  'Triệu chứng:',
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
                width: MediaQuery.of(context).size.width - (40 + 120 + 20 + 30),
                child: Text(
                  '${_currentPrescription.diagnose}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
          ),
          //dsach thuốc
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Danh sách thuốc',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    fontFamily: 'NewYork'),
              ),
            ),
          ),
          (_currentPrescription.medicationsRespone.medicationSchedules.length !=
                  0)
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _currentPrescription
                      .medicationsRespone.medicationSchedules.length,
                  itemBuilder: (BuildContext buildContext, int index) {
                    return Container(
                      color: DefaultTheme.GREY_VIEW,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //start list
                          if (index == 0)
                            (Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Divider(
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                height: 1,
                              ),
                            )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 5),
                                height: 16,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Text(
                                  '${_currentPrescription.medicationsRespone.medicationSchedules[index].medicationName} (${_currentPrescription.medicationsRespone.medicationSchedules[index].content})',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 16,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                      'Đơn vị: ${_currentPrescription.medicationsRespone.medicationSchedules[index].unit}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                          color: DefaultTheme.GREY_TEXT)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                              ),
                              Container(
                                width: 90,
                                child: Text(
                                  'Cách dùng',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: DefaultTheme.GREY_TEXT),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: MediaQuery.of(context).size.width -
                                    90 -
                                    40 -
                                    60,
                                child: Text(
                                  '${_currentPrescription.medicationsRespone.medicationSchedules[index].useTime}',
                                  textAlign: TextAlign.right,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: DefaultTheme.BLACK_BUTTON,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 30),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                          ),
                          (_currentPrescription.medicationsRespone
                                      .medicationSchedules[index].morning ==
                                  0)
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 30),
                                      ),
                                      Container(
                                        width: 90,
                                        child: Text(
                                          'Buổi sáng',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: DefaultTheme.GREY_TEXT),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                90 -
                                                40 -
                                                60,
                                        child: Text(
                                          '${_currentPrescription.medicationsRespone.medicationSchedules[index].morning} ${_currentPrescription.medicationsRespone.medicationSchedules[index].unit}',
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: DefaultTheme.BLACK_BUTTON,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 30),
                                      )
                                    ],
                                  ),
                                ),
                          (_currentPrescription.medicationsRespone
                                      .medicationSchedules[index].noon ==
                                  0)
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 30),
                                      ),
                                      Container(
                                        width: 90,
                                        child: Text(
                                          'Buổi trưa',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: DefaultTheme.GREY_TEXT),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                90 -
                                                40 -
                                                60,
                                        child: Text(
                                          '${_currentPrescription.medicationsRespone.medicationSchedules[index].noon} ${_currentPrescription.medicationsRespone.medicationSchedules[index].unit}',
                                          maxLines: 5,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: DefaultTheme.BLACK_BUTTON,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 30),
                                      )
                                    ],
                                  ),
                                ),
                          (_currentPrescription.medicationsRespone
                                      .medicationSchedules[index].afterNoon ==
                                  0)
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 30),
                                      ),
                                      Container(
                                        width: 90,
                                        child: Text(
                                          'Buổi chiều',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: DefaultTheme.GREY_TEXT),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                90 -
                                                40 -
                                                60,
                                        child: Text(
                                          '${_currentPrescription.medicationsRespone.medicationSchedules[index].afterNoon} ${_currentPrescription.medicationsRespone.medicationSchedules[index].unit}',
                                          maxLines: 5,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: DefaultTheme.BLACK_BUTTON,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 30),
                                      )
                                    ],
                                  ),
                                ),
                          (_currentPrescription.medicationsRespone
                                      .medicationSchedules[index].night ==
                                  0)
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 30),
                                      ),
                                      Container(
                                        width: 90,
                                        child: Text(
                                          'Buổi tối',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: DefaultTheme.GREY_TEXT),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                90 -
                                                40 -
                                                60,
                                        child: Text(
                                          '${_currentPrescription.medicationsRespone.medicationSchedules[index].night} ${_currentPrescription.medicationsRespone.medicationSchedules[index].unit}',
                                          maxLines: 5,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: DefaultTheme.BLACK_BUTTON,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 30),
                                      )
                                    ],
                                  ),
                                ),

                          //divider
                          if (index !=
                              _currentPrescription.medicationsRespone
                                      .medicationSchedules.length -
                                  1)
                            (Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Divider(
                                color: DefaultTheme.GREY_TOP_TAB_BAR,
                                height: 1,
                              ),
                            )),
                          if (index ==
                              _currentPrescription.medicationsRespone
                                      .medicationSchedules.length -
                                  1)
                            (Padding(
                              padding: EdgeInsets.only(top: 20),
                            )),
                        ],
                      ),
                    );
                  })
              : Container(),
          //
        ],
      ),
    );
  }
}
