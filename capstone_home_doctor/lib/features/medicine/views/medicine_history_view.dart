import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';

import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/prescription_list_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/events/prescription_list_event.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/prescription_repository.dart';
import 'package:capstone_home_doctor/features/schedule/states/prescription_list_state.dart';
import 'package:capstone_home_doctor/models/medical_instruction_dto.dart';
import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();
final DateValidator _dateValidator = DateValidator();
List<MedicalInstructionDTO> listPrescription = [];
PrescriptionRepository prescriptionRepository =
    PrescriptionRepository(httpClient: http.Client());
PrescriptionListBloc _prescriptionListBloc;

class MedicineHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MedicineHistory();
  }
}

class _MedicineHistory extends State<MedicineHistory>
    with WidgetsBindingObserver {
  int _patientId = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPatientId();
    _prescriptionListBloc = BlocProvider.of(context);
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      setState(() {
        _patientId = value;
      });
    });
    _prescriptionListBloc
        .add(PrescriptionListEventsetPatientId(patientId: _patientId));
  }

  @override
  Widget build(BuildContext context) {
    // _listPrescription.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderWidget(
              title: 'Danh sách đơn thuốc',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.NONE,
            ),
            BlocBuilder<PrescriptionListBloc, PrescriptionListState>(
              builder: (context, state) {
                if (state is PrescriptionListStateLoading) {
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

                if (state is PrescriptionListStateFailure) {
                  ///comment to install
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: Text('Hiện không có đơn thuốc.')));
                }
                if (state is PrescriptionListStateSuccess) {
                  listPrescription = state.listPrescription;
                  listPrescription.sort((a, b) =>
                      b.medicalInstructionId.compareTo(a.medicalInstructionId));
                  listPrescription.sort((a, b) => b
                      .medicationsRespone.dateFinished
                      .compareTo(a.medicationsRespone.dateFinished));

                  return (state.listPrescription.length == 0)
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text('Hiện không có đơn thuốc.'),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              itemCount: listPrescription.length,
                              itemBuilder:
                                  (BuildContext buildContext, int index) {
                                return Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          //line
                                          Container(
                                            width: 0.5,
                                            height: 95,
                                            color: DefaultTheme.GREY_TEXT,
                                          ),
                                          //icon in line
                                          SizedBox(
                                            width: 15,
                                            height: 15,
                                            child: Image.asset(
                                                'assets/images/ic-dot.png'),
                                          ),
                                          Container(
                                            width: 0.5,
                                            height: 95,
                                            color: DefaultTheme.GREY_TEXT,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 20),
                                            ),
                                            Container(
                                              height: 170,
                                              padding: EdgeInsets.only(top: 5),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: DefaultTheme
                                                        .GREY_TOP_TAB_BAR,
                                                    width: 0.5,
                                                  ),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 10,
                                                        color: DefaultTheme
                                                            .GREY_VIEW)
                                                  ]),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  70,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10, top: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                        'ĐƠN THUỐC ',
                                                        style: TextStyle(
                                                          color: DefaultTheme
                                                              .BLACK_BUTTON,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        'Chẩn đoán: ${listPrescription[index].diagnose}',
                                                        style: TextStyle(
                                                          color: DefaultTheme
                                                              .BLACK_BUTTON,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 7),
                                                    ),
                                                    Container(
                                                      height: 15,
                                                      child: Text(
                                                        'Ngày kê đơn: ${_dateValidator.parseToDateView(listPrescription[index].medicationsRespone.dateStarted)}',
                                                        style: TextStyle(
                                                            color: DefaultTheme
                                                                .GREY_TEXT,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 15,
                                                      child: Text(
                                                        'Đến ngày: ${_dateValidator.parseToDateView(listPrescription[index].medicationsRespone.dateFinished)}',
                                                        style: TextStyle(
                                                            color: DefaultTheme
                                                                .GREY_TEXT,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 15,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Trạng thái: ',
                                                            style: TextStyle(
                                                                color: DefaultTheme
                                                                    .GREY_TEXT,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          Text(
                                                            '${_checkStatus(listPrescription[index].medicationsRespone.status)}',
                                                            style: TextStyle(
                                                                color: listPrescription[
                                                                            index]
                                                                        .medicationsRespone
                                                                        .status
                                                                        .contains(
                                                                            'ACTIVE')
                                                                    ? DefaultTheme
                                                                        .SUCCESS_STATUS
                                                                    : DefaultTheme
                                                                        .RED_TEXT,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Divider(
                                                      height: 1,
                                                      color: DefaultTheme
                                                          .GREY_TOP_TAB_BAR,
                                                    ),
                                                    ButtonHDr(
                                                      style: BtnStyle
                                                          .BUTTON_IN_LIST,
                                                      label: 'Chi tiết',
                                                      labelColor: DefaultTheme
                                                          .BLACK_BUTTON
                                                          .withOpacity(0.8),
                                                      height: 30,
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            RoutesHDr
                                                                .MEDICAL_HISTORY_DETAIL,
                                                            arguments:
                                                                listPrescription[
                                                                        index]
                                                                    .medicalInstructionId);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  _showDetailPrescription(String healthRecordId) {
    //
  }

  String _checkStatus(String status) {
    switch (status) {
      case 'ACTIVE':
        return 'Đang sử dụng';
      case 'FINISH':
        return 'Đã hoàn thành';
      case 'CANCEL':
        return 'Đã dừng sử dụng';
      default:
        break;
    }
  }
}
