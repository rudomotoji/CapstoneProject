import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/features/background/repositories/background_repository.dart';
import 'package:capstone_home_doctor/features/contract/repositories/contract_repository.dart';
import 'package:capstone_home_doctor/features/global/repositories/system_repository.dart';
import 'package:capstone_home_doctor/models/date_request_dto.dart';
import 'package:capstone_home_doctor/models/req_contract_dto.dart';
import 'package:capstone_home_doctor/services/contract_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final ContractHelper _contractHelper = ContractHelper();
final ContractRepository contractRepository =
    ContractRepository(httpClient: http.Client());
final DateValidator _dateValidator = DateValidator();
final BackgroundRepository _backgroundRepository =
    BackgroundRepository(httpClient: http.Client());
final SystemRepository _systemRepository =
    SystemRepository(httpClient: http.Client());

class ReasonContractView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReasonContractView();
  }
}

class _ReasonContractView extends State<ReasonContractView>
    with WidgetsBindingObserver {
  //DateRequestDTO dateRequestDTO = DateRequestDTO(id: '1', dateAfter: 0);

  //
  TextEditingController _noteController = TextEditingController();
  String _startDate =
      DateTime.now().add(Duration(days: 0)).toString().split(' ')[0];

  int dateAfterFromServer = 0;
  String dateView = 'Chọn ngày';
  String _note = '';
  String _availableDay = '';
  int date = 0;
  bool isCalendarChange = false;

  DateTime curentDateNow = new DateFormat('yyyy-MM-dd')
      .parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  int year = 0;
  int month = 0;
  DateTime time;
  DateTime tTime;
  int tDate = 0;
  int tMonth = 0;
  int tYear = 0;
  bool isOKDate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDateRequestFromServer();
    _getAvailableDay();
    _getTimeSystem();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getTimeSystem() async {
    await _systemRepository.getTimeSystem().then((value) async {
      /////
      // await _timeSystemHelper.setTimeSystem(value);
      if (!mounted) return;
      setState(() {
        curentDateNow = new DateFormat('yyyy-MM-dd').parse(
            DateFormat('yyyy-MM-dd').format(DateTime.parse(
                value.split('"')[1].split('"')[0].split('T')[0])));
      });
    });
  }

  _getDateRequestFromServer() async {
    await _backgroundRepository.getDateRequest().then((dateDTO) async {
      setState(() {
        if (dateDTO != null) {
          //
          dateAfterFromServer = dateDTO.dateAfter;
          _startDate = new DateTime.now()
              .add(Duration(days: dateDTO.dateAfter))
              .toString()
              .split(' ')[0];
        }
      });
    });
  }

  _getAvailableDay() async {
    await _contractHelper.getAvailableDay().then((value) {
      if (value != '') {
        setState(() {
          _availableDay = value;

          print('$value');
          date = int.tryParse(value.split('/')[0]);
          month = int.tryParse(value.split('/')[1]);
          year = int.tryParse(value.split('/')[2]);
          time = DateTime(year, month, date);
          tTime = DateTime(year, month, date).add(Duration(days: 1));
          tDate = int.tryParse(tTime.toString().split(' ')[0].split('-')[2]);
          tMonth = int.tryParse(tTime.toString().split(' ')[0].split('-')[1]);
          tYear = int.tryParse(tTime.toString().split(' ')[0].split('-')[0]);
        });
      } else {
        //

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Map<String, Object> arguments = ModalRoute.of(context).settings.arguments;
    RequestContractDTO _requestContract = arguments['REQUEST_OBJ'];
    print('${_requestContract.diseaseHealthRecordIds} \n}');
    for (DiseaseMedicalInstructions x
        in _requestContract.diseaseMedicalInstructions) {
      print('${x.diseaseId}--${x.medicalInstructionIds}');
    }
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
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: DefaultTheme.GREY_VIEW,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //
                        Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 30, bottom: 10),
                          child: Text(
                            'Quyền lợi',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Text(
                            '1. Hệ thống hỗ trợ lưu trữ hồ sơ bệnh án của bệnh nhân chỉ để phục vụ cho việc khám chữa bệnh.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Text(
                            '2. Hệ thống đảm bảo theo dõi các chỉ số sức khỏe, sinh hiệu của bệnh nhân để bác sĩ đưa ra các y lệnh cần thiết trong quá trình khám chữa bệnh và những thông tin này sẽ được đảm bảo tính riêng tư trong suốt thời hạn hợp đồng.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Text(
                            '3. Hệ thống đưa ra các cảnh báo nguy hiểm khi có các chỉ số sinh hiệu bất thường đến bệnh nhân và bác sĩ. Bác sĩ sẽ có trách nhiệm đánh giá các chỉ số này',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Text(
                            '4. Hệ thống đưa ra các nhắc nhở về lịch uống thuốc, lịch đo sinh hiệu hằng ngày căn cứ trên y lệnh của bác sĩ.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Text(
                            '5. Hệ thống đảm bảo việc giao tiếp giữa bệnh nhân và bác sĩ dựa trên nhắn tin hay gọi điện trực tuyến. Nhật kí trao đổi sẽ được ghi lại để làm bằng chứng cho những bất cập sau này.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Text(
                            '6. Bác sĩ đảm bảo lịch hẹn thăm khám, kiểm tra và cập nhật đơn thuốc với bệnh nhân căn cứ trên hợp đồng đã kí.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        // Container(
                        //   padding:
                        //       EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        //   child: Text(
                        //     '7. Bác sĩ đảm bảo kiểm tra và cập nhật đơn thuốc vào mỗi tuần.',
                        //     style: TextStyle(
                        //       fontStyle: FontStyle.italic,
                        //       fontSize: 15,
                        //     ),
                        //   ),
                        // ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 30, bottom: 10),
                          child: Text(
                            'Nghĩa vụ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Text(
                            '1. Bệnh nhân yêu cầu phải kết nối với thiết bị đồng hồ thông minh có tính năng theo dõi sinh hiệu để được hưởng các quyền lợi ở mục 2 và mục 3.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Text(
                            '2. Bệnh nhân cần có trách nhiệm thực hiện các yêu cầu cần thiết và chia sẻ các y lệnh mà bác sĩ yêu cầu trong suốt quá trình khám chữa bệnh.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Text(
                            '3. Bệnh nhân đảm bảo việc thực hiện đầy đủ các y lệnh mà bác sĩ đưa ra trong suốt quá trình.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                        ),
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
                  (_availableDay == '')
                      ? Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 5, left: 30, right: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Ngày bắt đầu hợp đồng mong muốn',
                                        style: TextStyle(
                                            color: DefaultTheme.BLACK_BUTTON,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '*',
                                        style: TextStyle(
                                            color: DefaultTheme.RED_CALENDAR,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 5, left: 30, right: 30),
                                child: Text(
                                  'Ngày bắt đầu hợp đồng nên cách ngày gửi yêu cầu $dateAfterFromServer ngày.',
                                  style: TextStyle(
                                      color: DefaultTheme.BLACK_BUTTON,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    dateView = 'Chọn ngày';
                                    if (dateAfterFromServer != 0) {
                                      _startDate = curentDateNow
                                          .add(Duration(
                                              days: dateAfterFromServer))
                                          .toString()
                                          .split(' ')[0];
                                    }
                                  });
                                  _showDatePickerStart(_requestContract);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: DefaultTheme.GREY_BUTTON),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                      ),
                                      Text(
                                        // '${_startDate.split('-')[2]} tháng ${_startDate.split('-')[1]} năm ${_startDate.split('-')[0]}',
                                        '$dateView',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: DefaultTheme.BLACK),
                                      ),
                                      Spacer(),
                                      ButtonHDr(
                                        style: BtnStyle.BUTTON_IMAGE,
                                        image: Image.asset(
                                            'assets/images/ic-calendar.png'),
                                        width: 30,
                                        height: 40,
                                        labelColor: DefaultTheme.BLUE_DARK,
                                        bgColor: DefaultTheme.TRANSPARENT,
                                        onTap: () {
                                          setState(() {
                                            dateView = 'Chọn ngày';
                                            if (dateAfterFromServer != 0) {
                                              _startDate = curentDateNow
                                                  .add(Duration(
                                                      days:
                                                          dateAfterFromServer))
                                                  .toString()
                                                  .split(' ')[0];
                                            }
                                          });
                                          _showDatePickerStart(
                                              _requestContract);
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 5, left: 20, right: 20),
                                child: Text(
                                  'Ngày bắt đầu hợp đồng mong muốn',
                                  style: TextStyle(
                                      color: DefaultTheme.BLACK_BUTTON,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 5, left: 20, right: 30),
                                child: Text(
                                  'Thời gian phù hợp để gửi yêu cầu hợp đồng là sau ngày ${int.tryParse(_availableDay.split('/')[0])} tháng ${int.tryParse(_availableDay.split('/')[1])}, ${int.tryParse(_availableDay.split('/')[2])}.',
                                  style: TextStyle(
                                      color: DefaultTheme.RED_CALENDAR,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _showDatePickerStart2();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: DefaultTheme.GREY_BUTTON),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                      ),
                                      Text(
                                        '${tDate} tháng ${tMonth} năm ${tYear}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Spacer(),
                                      ButtonHDr(
                                        style: BtnStyle.BUTTON_IMAGE,
                                        image: Image.asset(
                                            'assets/images/ic-calendar.png'),
                                        width: 30,
                                        height: 40,
                                        labelColor: DefaultTheme.BLUE_DARK,
                                        bgColor: DefaultTheme.TRANSPARENT,
                                        onTap: () {
                                          _showDatePickerStart2();
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                      )
                                    ],
                                  ),
                                ),
                              ),
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

                  (isOKDate)
                      ? Container(
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
                        )
                      : Container(),
                ],
              ),
            ),

            //
          ],
        ),
      ),
    );
  }

  void _showDatePickerStart(RequestContractDTO dto) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: DefaultTheme.TRANSPARENT,
          child: Center(
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
                            initialDateTime: curentDateNow
                                .add(Duration(days: dateAfterFromServer)),
                            onDateTimeChanged: (dateTime) {
                              setState(() {
                                _startDate = dateTime.toString().split(' ')[0];
                                dateView = _dateValidator.parseToDateView2(
                                    dateTime.toString().split(' ')[0]);
                              });
                            }),
                      ),
                      ButtonHDr(
                        style: BtnStyle.BUTTON_BLACK,
                        label: 'Chọn',
                        onTap: () async {
                          setState(() {
                            if (dateView == 'Chọn ngày') {
                              dateView =
                                  _dateValidator.parseToDateView2(_startDate);
                            }
                          });
                          print('date view now: $dateView');
                          Navigator.of(context).pop();
                          _checkDateAvailable(
                              dto.patientId, dto.doctorId, _startDate);
                        },
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

  _checkDateAvailable(int patientId, int doctorId, String date) {
    String x = DateTime.now()
        .add(Duration(days: dateAfterFromServer))
        .toString()
        .split(' ')[0];
    DateTime _dateToCheck = new DateTime(int.tryParse(x.split('-')[0]),
        int.tryParse(x.split('-')[1]), int.tryParse(x.split('-')[2]));
    setState(() {
      //
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Material(
              color: DefaultTheme.TRANSPARENT,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: 250,
                      height: 160,
                      decoration: BoxDecoration(
                        color: DefaultTheme.WHITE.withOpacity(0.7),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 130,
                            // height: 100,
                            child: Image.asset('assets/images/loading.gif'),
                          ),
                          // Spacer(),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Đang kiểm tra',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: DefaultTheme.GREY_TEXT,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });

      Future.delayed(const Duration(seconds: 3), () async {
        //
        print('go into this delayed');
        print('patientId $patientId');
        print('doctorId $doctorId');
        print('date $date');

        await contractRepository
            .checkContractToCreate2(doctorId, patientId, date)
            .then((isOK) async {
          _contractHelper.isAcceptable().then((value) {
            //
            DateTime dateCompare = new DateTime(
                int.tryParse(date.split('-')[0]),
                int.tryParse(date.split('-')[1]),
                int.tryParse(date.split('-')[2]));

            print('date time compare: $dateCompare');
            print('date time to check: $_dateToCheck');
            if (value == true) {
              if (dateCompare.isAfter(_dateToCheck) ||
                  dateCompare.isAtSameMomentAs(_dateToCheck)) {
                setState(() {
                  isOKDate = true;
                });
              } else {
                Navigator.of(context).pop();
                return showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Material(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                width: 250,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: DefaultTheme.WHITE.withOpacity(0.7),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.only(bottom: 10, top: 10),
                                      child: Text(
                                        'Chọn ngày khác',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: DefaultTheme.BLACK,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Vui lòng chọn ngày bắt đầu hợp đồng theo quy định.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: DefaultTheme.GREY_TEXT,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Divider(
                                      height: 1,
                                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    ),
                                    ButtonHDr(
                                      height: 40,
                                      style: BtnStyle.BUTTON_TRANSPARENT,
                                      label: 'OK',
                                      labelColor: DefaultTheme.BLUE_TEXT,
                                      onTap: () {
                                        setState(() {
                                          dateView = 'Chọn ngày';
                                          isOKDate = false;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        color: DefaultTheme.TRANSPARENT);
                  },
                );
              }
              Navigator.of(context).pop();
            } else {
              //
              String msg = '';
              _contractHelper.getMsgCheckingContract().then((value) async {
                msg = value;
                print('msg $value');
                if (msg.contains('Vui lòng gửi yêu cầu sau ngày')) {
                  Navigator.of(context).pop();
                  return showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return Material(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                width: 250,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: DefaultTheme.WHITE.withOpacity(0.7),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.only(bottom: 10, top: 10),
                                      child: Text(
                                        'Chọn ngày khác',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: DefaultTheme.BLACK,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$msg',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: DefaultTheme.GREY_TEXT,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Divider(
                                      height: 1,
                                      color: DefaultTheme.GREY_TOP_TAB_BAR,
                                    ),
                                    ButtonHDr(
                                      height: 40,
                                      style: BtnStyle.BUTTON_TRANSPARENT,
                                      label: 'OK',
                                      labelColor: DefaultTheme.BLUE_TEXT,
                                      onTap: () {
                                        setState(() {
                                          dateView = 'Chọn ngày';
                                          isOKDate = false;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        color: DefaultTheme.TRANSPARENT,
                      );
                    },
                  );
                }
              });
            }
          });

          //
        });
      });
    });
  }

  void _showDatePickerStart2() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: Center(
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
                            initialDateTime: tTime,
                            onDateTimeChanged: (dateTime) {
                              setState(() {
                                _startDate = dateTime.toString().split(' ')[0];
                                dateView = _dateValidator.parseToDateView2(
                                    dateTime.toString().split(' ')[0]);
                                date = int.tryParse(_startDate.split('-')[2]);
                                month = int.tryParse(_startDate.split('-')[1]);
                                year = int.tryParse(_startDate.split('-')[0]);
                              });
                            }),
                      ),
                      ButtonHDr(
                        style: BtnStyle.BUTTON_BLACK,
                        label: 'Chọn',
                        onTap: () {
                          setState(() {
                            if (dateView == 'Chọn ngày') {
                              dateView =
                                  _dateValidator.parseToDateView2(_startDate);
                            }
                          });
                          print('date view now: $dateView');
                          Navigator.of(context).pop();
                          _checkDateAvailable2(date, month, year, time);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          color: DefaultTheme.TRANSPARENT,
        );
      },
    );
  }

  _checkDateAvailable2(int date, int month, int year, DateTime currentTime) {
    setState(() {
      //
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Material(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: 250,
                        height: 160,
                        decoration: BoxDecoration(
                          color: DefaultTheme.WHITE.withOpacity(0.7),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              width: 130,
                              // height: 100,
                              child: Image.asset('assets/images/loading.gif'),
                            ),
                            // Spacer(),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Đang kiểm tra',
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: DefaultTheme.GREY_TEXT,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                color: DefaultTheme.TRANSPARENT);
          });

      Future.delayed(const Duration(seconds: 3), () async {
        //
        DateTime checkDate = DateTime(year, month, date);
        if (checkDate.isBefore(currentTime.add(Duration(days: 1)))) {
          Navigator.of(context).pop();
          return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return Material(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        width: 250,
                        height: 180,
                        decoration: BoxDecoration(
                          color: DefaultTheme.WHITE.withOpacity(0.7),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(bottom: 20, top: 10),
                              child: Text(
                                'Chọn ngày khác',
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: DefaultTheme.BLACK,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Ngày bắt đầu hợp đồng mong muốn phải sau ngày yêu cầu của hệ thống.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: DefaultTheme.GREY_TEXT,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Divider(
                              height: 1,
                              color: DefaultTheme.GREY_TOP_TAB_BAR,
                            ),
                            ButtonHDr(
                              height: 40,
                              style: BtnStyle.BUTTON_TRANSPARENT,
                              label: 'OK',
                              labelColor: DefaultTheme.BLUE_TEXT,
                              onTap: () {
                                setState(() {
                                  dateView = 'Chọn ngày';
                                  isOKDate = false;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                color: DefaultTheme.TRANSPARENT,
              );
            },
          );
        } else {
          setState(() {
            isOKDate = true;
          });
          Navigator.of(context).pop();
        }
      });
    });
  }
}
