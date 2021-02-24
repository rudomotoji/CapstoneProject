import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/utils/arr_validator.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/models/prescription_dto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateFormat format = DateFormat("yyyy-MM-dd");
final DateValidator _dateValidator = DateValidator();
ArrayValidator _arrayValidator = ArrayValidator();
final List<PrescriptionDTO> _listPrescription = [
  PrescriptionDTO(
      doctorName: 'Nguyễn Lê Huy',
      dateFrom: '2021-02-04',
      dateTo: '2021-02-09',
      diseases: [
        'EX-1: Bệnh tim do tăng huyết áp',
        'EX-2: Bệnh tim do tăng huyết áp',
      ]),
  PrescriptionDTO(
      doctorName: 'Nguyễn Lê Huy',
      dateFrom: '2021-01-20',
      dateTo: '2021-02-01',
      diseases: [
        'EX-3: Thể bệnh tim khác',
        'EX-4: Bệnh tim do thiếu máu cục bộ',
      ]),
  PrescriptionDTO(
      doctorName: 'Nguyễn Văn A',
      dateFrom: '2020-12-10',
      dateTo: '2020-12-31',
      diseases: [
        'EX-5: Thể bệnh tim khác',
        'EX-6: Bệnh tim do thiếu máu cục bộ',
      ]),
];

class MedicineHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MedicineHistory();
  }
}

class _MedicineHistory extends State<MedicineHistory>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    _listPrescription.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderWidget(
              title: 'Lịch sử đơn thuốc',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _listPrescription.length,
                  itemBuilder: (BuildContext buildContext, int index) {
                    return Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              //line
                              Container(
                                width: 0.5,
                                height: 130,
                                color: DefaultTheme.GREY_TEXT,
                              ),
                              //icon in line
                              SizedBox(
                                width: 15,
                                height: 15,
                                child: Image.asset('assets/images/ic-dot.png'),
                              ),
                              Container(
                                width: 0.5,
                                height: 75,
                                color: DefaultTheme.GREY_TEXT,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 50),
                                ),
                                Container(
                                  height: 25,
                                  child: Text(
                                    'Ngày kê đơn: ${_dateValidator.parseToDateView(_listPrescription[index].dateFrom)}',
                                    style: TextStyle(
                                        color: DefaultTheme.BLACK_BUTTON,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  height: 140,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 10,
                                            color: DefaultTheme.GREY_VIEW)
                                      ]),
                                  width: MediaQuery.of(context).size.width - 70,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, top: 25, bottom: 25),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            'Bác sĩ: ${_listPrescription[index].doctorName}',
                                            style: TextStyle(
                                                color:
                                                    DefaultTheme.BLACK_BUTTON,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'NewYork'),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100,
                                          child: Text(
                                            'Bệnh án tim mạch\n ${_arrayValidator.parseArrToView(_listPrescription[index].diseases.toString())}',
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
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
            ),
          ],
        ),
      ),
    );
  }
}
