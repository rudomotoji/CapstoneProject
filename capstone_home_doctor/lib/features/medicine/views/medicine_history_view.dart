import 'package:capstone_home_doctor/commons/constants/theme.dart';

import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/schedule/blocs/prescription_list_bloc.dart';
import 'package:capstone_home_doctor/features/schedule/events/prescription_list_event.dart';
import 'package:capstone_home_doctor/features/schedule/repositories/prescription_repository.dart';
import 'package:capstone_home_doctor/features/schedule/states/prescription_list_state.dart';
import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

final DateValidator _dateValidator = DateValidator();
List<PrescriptionDTO> listPrescription = [];
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _prescriptionListBloc = BlocProvider.of(context);
    _prescriptionListBloc.add(PrescriptionListEventsetPatientId(patientId: 2));
  }

  @override
  Widget build(BuildContext context) {
    // _listPrescription.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderWidget(
              title: 'Lịch sử đơn thuốc',
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
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child:
                              Text('Kiểm tra lại đường truyền kết nối mạng')));
                }
                if (state is PrescriptionListStateSuccess) {
                  listPrescription = state.listPrescription;
                  listPrescription
                      .sort((a, b) => b.dateStarted.compareTo(a.dateStarted));

                  return (state.listPrescription.length == 0)
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child:
                                Text('Kiểm tra lại đường truyền kết nối mạng'),
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
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                    ),
                                                    Container(
                                                      height: 15,
                                                      child: Text(
                                                        'Ngày kê đơn: ${_dateValidator.parseToDateView(listPrescription[index].dateStarted)}',
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
                                                        'Đến ngày: ${_dateValidator.parseToDateView(listPrescription[index].dateFinished)}',
                                                        style: TextStyle(
                                                            color: DefaultTheme
                                                                .GREY_TEXT,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
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
                                                      label: 'Chi Tiết',
                                                      labelColor: DefaultTheme
                                                          .BLACK_BUTTON
                                                          .withOpacity(0.8),
                                                      height: 40,
                                                      onTap: () {},
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
}
