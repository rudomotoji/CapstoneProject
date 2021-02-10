import 'dart:ui';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/utils/date_validator.dart';
import 'package:capstone_home_doctor/commons/widgets/artboard_button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/textfield_widget.dart';
import 'package:capstone_home_doctor/models/medicine_scheduling_dto.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:barcode_scan/barcode_scan.dart';

final List<MedicineSchedulingDTO> _listMedicine = [
  MedicineSchedulingDTO(
      name: 'Cefadroxil (Droxicef)',
      amount: '250mg',
      unit: 'viên',
      totalDay: 5,
      timePerDay: 2,
      howToUsing: 'Uống sau ăn',
      unitPerDay: 4),
  MedicineSchedulingDTO(
      name: 'Alpha chymotrypsin (Stratripsine)',
      amount: '4,2mg',
      unit: 'viên',
      totalDay: 5,
      timePerDay: 2,
      howToUsing: 'Uống sau ăn',
      unitPerDay: 4),
  MedicineSchedulingDTO(
      name: 'Metronidazol',
      amount: '250mg',
      unit: 'viên',
      totalDay: 5,
      timePerDay: 2,
      howToUsing: 'Uống sau ăn',
      unitPerDay: 4),
  MedicineSchedulingDTO(
      name: 'Paracetamol (Mypara)',
      amount: '500mg',
      unit: 'viên',
      totalDay: 5,
      timePerDay: null,
      howToUsing: 'Uống sủi bọt khi đau',
      unitPerDay: null),
  MedicineSchedulingDTO(
      name: 'Calci carbonat (CalciChew)',
      amount: '1.25g',
      unit: 'viên',
      totalDay: 5,
      timePerDay: 2,
      howToUsing: 'Uống sau ăn',
      unitPerDay: 2),
  MedicineSchedulingDTO(
      name: 'Vitamin C',
      amount: '100mg',
      unit: 'viên',
      totalDay: 5,
      timePerDay: 1,
      howToUsing: 'Uống sau ăn sáng',
      unitPerDay: 1),
];

final Shader _normalHealthColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_1,
    DefaultTheme.GRADIENT_2,
  ],
).createShader(new Rect.fromLTWH(10.0, 1.0, 100.0, 90.0));

final Shader _caledarColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_3,
    DefaultTheme.GRADIENT_4,
    DefaultTheme.GRADIENT_5,
  ],
).createShader(new Rect.fromLTWH(50, 1.0, 255.0, 255.0));

class DashboardPage extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> with WidgetsBindingObserver {
  var _index = 0;
  var location;
  var _idDoctorController = TextEditingController();
  String _idDoctor = '';
  DateValidator _dateValidator = DateValidator();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        HeaderWidget(
          title: 'Trang chủ',
          isMainView: true,
          buttonHeaderType: ButtonHeaderType.AVATAR,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              '${_dateValidator.getDateTimeView()}',
              style: TextStyle(
                  color: DefaultTheme.GREY_TEXT,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(left: 20, right: 20),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset('assets/images/ic-calendar.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Text(
                    'Lịch',
                    style: TextStyle(
                      color: DefaultTheme.BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  ButtonHDr(
                    style: BtnStyle.BUTTON_TRANSPARENT,
                    label: 'Chi tiết',
                    labelColor: DefaultTheme.BLUE_REFERENCE,
                    width: 40,
                    onTap: () {
                      Navigator.of(context).pushNamed(RoutesHDr.SCHEDULE);
                    },
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 280,
                child: OverflowBox(
                    // alignment: Alignment.centerRight,
                    minWidth: MediaQuery.of(context).size.width,
                    maxWidth: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: _showCalendarOverview(),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                      height: 25,
                      child:
                          Image.asset('assets/images/ic-health-selected.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Text(
                      'Trạng thái',
                      style: TextStyle(
                        color: DefaultTheme.BLACK,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    ButtonHDr(
                      style: BtnStyle.BUTTON_TRANSPARENT,
                      label: 'Xem tổng quan',
                      labelColor: DefaultTheme.BLUE_REFERENCE,
                      width: 40,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              _showStatusOverview(),
              //
              _showSuggestionDashboard(),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Lần đo gần đây',
                  style: TextStyle(
                    color: DefaultTheme.BLACK,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              //_showLastMeasurement(),
            ],
          ),
        ),
      ],
    ));
  }

  rowMonitor() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: DefaultTheme.GREY_VIEW,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 20,
            margin: EdgeInsets.only(left: 9, top: 6, right: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: DefaultTheme.GREY_TEXT,
                    ),
                    child: Container(),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 13, top: 1),
                    child: Text(
                      "Huyết áp",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: DefaultTheme.GREY_TEXT,
                        fontFamily: "",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 1),
                    child: Text(
                      "12:30",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: DefaultTheme.GREY_TEXT,
                        fontFamily: "",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: 42, top: 1),
              child: Text(
                "120/81 mmHg",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: DefaultTheme.GREY_TEXT,
                  fontFamily: "",
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: 42),
              child: Text(
                "Chi tiết",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: DefaultTheme.GREY_TEXT,
                  fontFamily: "",
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  rowMedicalSchedule(String nameMedical, String time, String timeLoop) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 15,
            height: 15,
            margin: EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: DefaultTheme.GREY_TEXT,
            ),
            child: Container(),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              nameMedical,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: DefaultTheme.GREY_TEXT,
                fontFamily: "",
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Text(
              time,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: DefaultTheme.GREY_TEXT,
                fontFamily: "",
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            timeLoop,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: DefaultTheme.GREY_TEXT,
              fontFamily: "",
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  _showLastMeasurement() {}

  _showSuggestionDashboard() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Gợi ý',
              style: TextStyle(
                color: DefaultTheme.BLACK,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        ButtonArtBoard(
          title: 'Yêu cầu hợp đồng',
          description: 'Quét QR hoặc nhập ID kết nối với bác sĩ',
          imageAsset: 'assets/images/ic-contract.png',
          onTap: () async {
            _chooseStepContract();
          },
        ),
      ],
    );
  }

  _showCalendarOverview() {
    return SizedBox(
      height: 280,
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
        itemCount: 2,
        controller: PageController(viewportFraction: 0.9),
        onPageChanged: (int index) => setState(() => _index = index),
        itemBuilder: (_, i) {
          return Transform.scale(
            scale: i == _index ? 1 : 0.9,
            alignment: Alignment.centerLeft,
            child: Card(
                elevation: 3,
                shadowColor: DefaultTheme.GREY_TEXT,
                color: DefaultTheme.GREY_VIEW,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: (i == 0)
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 10, top: 20),
                            child: Text(
                              'Lịch dùng thuốc',
                              style: TextStyle(
                                  fontFamily: 'NewYork',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  foreground: Paint()..shader = _caledarColors),
                            ),
                          ),
                          Divider(
                            height: 0.1,
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          (_listMedicine.length == 0)
                              ? Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Hiện không có lịch dùng thuốc',
                                    style: TextStyle(
                                        color: DefaultTheme.GREY_TEXT),
                                  ),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                      itemCount: _listMedicine.length,
                                      itemBuilder: (BuildContext buildContext,
                                          int index) {
                                        return Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            220,
                                                    child: Text(
                                                      '${_listMedicine[index].name}',
                                                      style: TextStyle(
                                                          fontFamily: 'NewYork',
                                                          color: DefaultTheme
                                                              .BLACK,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  (_listMedicine[index]
                                                                  .unitPerDay !=
                                                              null ||
                                                          _listMedicine[index]
                                                                  .timePerDay !=
                                                              null)
                                                      ? Text(
                                                          '${_listMedicine[index].unitPerDay} viên/ ${_listMedicine[index].timePerDay} lần/ ngày',
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                            color: DefaultTheme
                                                                .GREY_TEXT,
                                                            fontSize: 15,
                                                          ),
                                                        )
                                                      : Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              250,
                                                          child: Text(
                                                            '${_listMedicine[index].howToUsing}',
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              color: DefaultTheme
                                                                  .GREY_TEXT,
                                                              fontSize: 15,
                                                            ),
                                                            maxLines: 5,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 10, top: 10),
                                                child: Divider(
                                                  color: DefaultTheme
                                                      .GREY_TOP_TAB_BAR,
                                                  height: 0.1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 10, top: 20),
                            child: Text(
                              'Lịch tái khám',
                              style: TextStyle(
                                  fontFamily: 'NewYork',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  foreground: Paint()..shader = _caledarColors),
                            ),
                          ),
                          Divider(
                            height: 0.1,
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Hiện không có lịch tái khám',
                              style: TextStyle(color: DefaultTheme.GREY_TEXT),
                            ),
                          ),
                        ],
                      )),
          );
        },
      ),
    );
  }

  _showStatusOverview() {
    //change color and text color if else status patient and call it
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: DefaultTheme.GREY_BUTTON,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Sinh hiệu bình thường',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        foreground: Paint()..shader = _normalHealthColors),
                  ),
                ),
              ],
            ),
            //
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 5),
              child: Divider(
                color: DefaultTheme.GREY_TOP_TAB_BAR,
                height: 0.1,
              ),
            ),
            Container(
              height: 100,
              child: Center(
                child: Text(
                  'Chưa có dữ liệu cho biểu đồ sinh hiệu',
                  style: TextStyle(
                    color: DefaultTheme.GREY_TEXT,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            //
            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopUpIDDoctor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/images/ic-id.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        Text(
                          'Bác sĩ',
                          style: TextStyle(
                            fontSize: 30,
                            decoration: TextDecoration.none,
                            color: DefaultTheme.BLACK,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 20),
                            child: Text(
                              'Mã định danh giúp bệnh nhân dễ dàng ghép nối với bác sĩ thông qua hợp đồng',
                              style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.none,
                                color: DefaultTheme.GREY_TEXT,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TEXT,
                            height: 0.25,
                          ),
                          Flexible(
                            child: TextFieldHDr(
                              style: TFStyle.NO_BORDER,
                              label: 'ID:',
                              controller: _idDoctorController,
                              keyboardAction: TextInputAction.done,
                              onChange: (text) {
                                setState(() {
                                  _idDoctor = text;
                                });
                              },
                            ),
                          ),
                          Divider(
                            color: DefaultTheme.GREY_TEXT,
                            height: 0.25,
                          ),
                        ],
                      ),
                    ),
                    ButtonHDr(
                      style: BtnStyle.BUTTON_BLACK,
                      label: 'Tiếp theo',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, RoutesHDr.CONFIRM_CONTRACT,
                            arguments: _idDoctor);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _chooseStepContract() {
    showModalBottomSheet(
        isScrollControlled: false,
        context: this.context,
        backgroundColor: Colors.white.withOpacity(0),
        builder: (context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(33.33),
                        // borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(33.33),
                        //     topRight: Radius.circular(33.33)),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // Padding(
                          //   padding: EdgeInsets.only(
                          //       top: MediaQuery.of(context).size.height * 0.05),
                          // ),
                          Spacer(),
                          Image.asset(
                            'assets/images/ic-contract.png',
                            height: MediaQuery.of(context).size.height * 0.20,
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(60, 20, 60, 0),
                            child: Text(
                              'Quét Mã QR hoặc nhập ID của bác sĩ để yêu cầu tạo hợp đồng',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ),
                          Spacer(),
                          ButtonHDr(
                            style: BtnStyle.BUTTON_BLACK,
                            label: 'Quét Mã QR',
                            onTap: () async {
                              String codeScanner = await BarcodeScanner.scan();
                              if (codeScanner != null) {
                                Navigator.of(context).pop();
                                Navigator.pushNamed(
                                    context, RoutesHDr.CONFIRM_CONTRACT,
                                    arguments: codeScanner);
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          ButtonHDr(
                            style: BtnStyle.BUTTON_GREY,
                            label: 'Nhập ID Bác sĩ',
                            onTap: () {
                              Navigator.of(context).pop();
                              _showPopUpIDDoctor();
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                    ),
                  ],
                ),
              ));
        });
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    var position = await Geolocator.getCurrentPosition();
    setState(() {
      location = position;
    });
  }
}
