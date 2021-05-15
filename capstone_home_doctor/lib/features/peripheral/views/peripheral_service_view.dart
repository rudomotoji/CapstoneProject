import 'dart:math';
import 'dart:ui';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';

import 'package:capstone_home_doctor/features/peripheral/blocs/peripheral_bloc.dart';
import 'package:capstone_home_doctor/features/peripheral/events/peripheral_event.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repo.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repository.dart';
import 'package:capstone_home_doctor/features/peripheral/states/peripheral_state.dart';
import 'package:capstone_home_doctor/features/peripheral/views/connect_peripheral_view.dart';

import 'package:capstone_home_doctor/features/vital_sign/repositories/vital_sign_repository.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';

//
final Shader _normalHealthColors = LinearGradient(
  colors: <Color>[
    DefaultTheme.GRADIENT_1,
    DefaultTheme.GRADIENT_2,
  ],
).createShader(new Rect.fromLTWH(30.0, 1.0, 50.0, 200.0));

final PeripheralHelper _peripheralHelper = PeripheralHelper();
final VitalSignRepository _vitalSignRepository = VitalSignRepository();
final PeripheralRepository _peripheralRepository = PeripheralRepository();

// final PeripheralServices _peripheralServices = PeripheralServices();
// final PeripheralCharacteristics _peripheralCharacteristics = PeripheralCharacteristics();

class PeripheralService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PeripheralService();
  }
}

class _PeripheralService extends State<PeripheralService>
    with WidgetsBindingObserver {
  //
  PeripheralBloc _peripheralBloc;
  BatteryDeviceBloc _batteryDeviceBloc;
  int batteryValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _peripheralBloc = BlocProvider.of(context);
    _batteryDeviceBloc = BlocProvider.of(context);
    _getPeripheralId();
  }

  Future _getPeripheralId() async {
    await _peripheralHelper.getPeripheralId().then((value) async {
      if (value != '') {
        _peripheralBloc.add(PeripheralEventFindById(id: value));
        _batteryDeviceBloc.add(BatteryEventGet(peripheralId: value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RoutesHDr.MAIN_HOME,
          (Route<dynamic> route) => false,
        );
        return new Future(() => false);
      },
      child: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.turningOn) {
              _getPeripheralId();
            }
            if (state == BluetoothState.on) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        DefaultTheme.GRADIENT_1,
                        DefaultTheme.GRADIENT_2
                      ]),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Scaffold(
                    backgroundColor: DefaultTheme.BLACK.withOpacity(0.8),
                    body: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          HeaderWidget(
                            title: '',
                            isMainView: false,
                            buttonHeaderType: ButtonHeaderType.BACK_HOME,
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: _getPeripheralId,
                              child: ListView(
                                children: [
                                  //

                                  BlocBuilder<PeripheralBloc, PeripheralState>(
                                    builder: (context, state) {
                                      if (state is PeripheralStateLoading) {
                                        //
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.45,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Image.asset(
                                                'assets/images/loading.gif'),
                                          ),
                                        );
                                      }
                                      if (state is PeripheralStateFailure) {
                                        return Container(
                                          child:
                                              Text('Chưa có thiết bị kết nối'),
                                        );
                                      }

                                      if (state
                                          is PeripheralStateFindByIdSuccess) {
                                        if (state.device != null) {
                                          print(
                                              'state device name is ${state.device}');
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Thiết bị ghép nối',
                                                style: TextStyle(
                                                    color: DefaultTheme
                                                        .GREY_TOP_TAB_BAR,
                                                    fontSize: 16),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                              ),
                                              Text(
                                                '${state.device.name}',
                                                style: TextStyle(
                                                    color: DefaultTheme.WHITE,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 25),
                                              ),
                                              (state.device.name.contains('Mi'))
                                                  ? SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 300,
                                                      child: Image.asset(
                                                          'assets/images/ic-mi-band.png'),
                                                    )
                                                  : Container(),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 20),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    40,
                                                padding: EdgeInsets.only(
                                                    left: 20, right: 20),
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: DefaultTheme
                                                          .GREY_TEXT
                                                          .withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: Offset(0,
                                                          1), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: DefaultTheme.DARK_VIEW,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text('Trạng thái',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: DefaultTheme
                                                                .WHITE)),
                                                    Spacer(),
                                                    Text('Đang kết nối',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: DefaultTheme
                                                                .BLUE_TEXT)),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 20),
                                              ),
                                              BlocBuilder<BatteryDeviceBloc,
                                                      PeripheralState>(
                                                  builder: (context, state) {
                                                if (state
                                                    is PeripheralStateLoading) {
                                                  return Container(
                                                    height: 60,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            40,
                                                    child: SizedBox(
                                                      width: 60,
                                                      height: 60,
                                                      child: Image.asset(
                                                          'assets/images/loading.gif'),
                                                    ),
                                                  );
                                                }
                                                if (state
                                                    is PeripheralStateFailure) {}
                                                if (state
                                                    is BatteryStateSuccess) {
                                                  print(
                                                      'state value?? ${state.value}');
                                                  return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            40,
                                                    padding: EdgeInsets.only(
                                                        left: 20, right: 20),
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: DefaultTheme
                                                              .GREY_TEXT
                                                              .withOpacity(0.5),
                                                          spreadRadius: 1,
                                                          blurRadius: 5,
                                                          offset: Offset(0,
                                                              1), // changes position of shadow
                                                        ),
                                                      ],
                                                      color: DefaultTheme
                                                          .DARK_VIEW,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text('Phần trăm pin',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                    DefaultTheme
                                                                        .WHITE)),
                                                        Spacer(),
                                                        CircularPercentIndicator(
                                                          radius: 50.0,
                                                          lineWidth: 10.0,
                                                          animation: true,
                                                          percent: (state
                                                                      .value !=
                                                                  null)
                                                              ? (state.value /
                                                                  100)
                                                              : 0,
                                                          center: Text(
                                                            "${state.value}",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    DefaultTheme
                                                                        .WHITE),
                                                          ),
                                                          backgroundColor:
                                                              DefaultTheme
                                                                  .GREY_TOP_TAB_BAR,
                                                          circularStrokeCap:
                                                              CircularStrokeCap
                                                                  .round,
                                                          linearGradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topRight,
                                                              end: Alignment
                                                                  .bottomLeft,
                                                              colors: [
                                                                DefaultTheme
                                                                    .GRADIENT_1,
                                                                DefaultTheme
                                                                    .GRADIENT_2
                                                              ]),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                                return Container();
                                              }),
                                              //
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 20),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    40,
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 10,
                                                    top: 15),
                                                // height: 60,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: DefaultTheme
                                                          .GREY_TEXT
                                                          .withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: Offset(0,
                                                          1), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: DefaultTheme.DARK_VIEW,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    //
                                                    Text(
                                                        'Thiết bị hỗ trợ đo sinh hiệu',
                                                        style: TextStyle(
                                                            color: DefaultTheme
                                                                .WHITE,
                                                            fontSize: 18)),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 20),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        //
                                                        SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: Image.asset(
                                                              'assets/images/ic-heart-rate.png'),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 15),
                                                        ),
                                                        Text('Nhịp tim',
                                                            style: TextStyle(
                                                                color:
                                                                    DefaultTheme
                                                                        .WHITE)),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 20, bottom: 10),
                                                      child: Divider(
                                                        color: DefaultTheme
                                                            .GREY_TOP_TAB_BAR,
                                                        height: 1,
                                                      ),
                                                    ),
                                                    Text(
                                                        'Các sinh hiệu khác không được hỗ trợ với thiết bị đeo của bạn. Dùng các thiết bị đo chuyên dụng khác, sau đó nhập dữ liệu vào các mục sinh hiệu.',
                                                        style: TextStyle(
                                                            color: DefaultTheme
                                                                .WHITE)),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 20),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  //
                                                  _showDisconnectDialog();
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      40,
                                                  padding: EdgeInsets.only(
                                                      left: 20, right: 20),
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: DefaultTheme
                                                            .GREY_TEXT
                                                            .withOpacity(0.5),
                                                        spreadRadius: 1,
                                                        blurRadius: 5,
                                                        offset: Offset(0,
                                                            1), // changes position of shadow
                                                      ),
                                                    ],
                                                    color:
                                                        DefaultTheme.DARK_VIEW,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Huỷ kết nối',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: DefaultTheme
                                                              .RED_CALENDAR),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 30),
                                              ),
                                            ],
                                          );
                                        }
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
                  ),
                ),
              );
            }
            return _notAvailableBluetooth();
          }),
    );
  }

  Widget _notAvailableBluetooth() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Chi tiết thiết bị',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                height: MediaQuery.of(context).size.height - 500,
                child: Image.asset('assets/images/img-bluetooth.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Bluetooth không khả dụng',
                style: TextStyle(
                  color: DefaultTheme.BLACK,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 40, left: 40, right: 40),
              child: Text(
                'Bật kết nối bluetooth trong cài đặt để thực hiện ghép nối',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DefaultTheme.GREY_TEXT,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
            )
          ],
        ),
      ),
    );
  }

  _showDisconnectDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: DefaultTheme.WHITE.withOpacity(0),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                  width: 250,
                  height: 185,
                  decoration: BoxDecoration(
                    color: DefaultTheme.DARK_VIEW2.withOpacity(0.7),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        child: Text(
                          'Huỷ ghép nối',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: DefaultTheme.WHITE,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Hệ thống sẽ không ghi nhận nhịp tim của bạn khi huỷ ghép nối với thiết bị ngoại vi.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: DefaultTheme.WHITE,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            height: 40,
                            minWidth: 250 / 2 - 10.5,
                            child: Text('Đóng',
                                style:
                                    TextStyle(color: DefaultTheme.BLUE_TEXT)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Container(
                            height: 40,
                            width: 0.5,
                            color: DefaultTheme.GREY_TOP_TAB_BAR,
                          ),
                          FlatButton(
                            height: 40,
                            minWidth: 250 / 2 - 10.5,
                            child: Text('Huỷ kết nối',
                                style: TextStyle(
                                    color: DefaultTheme.RED_CALENDAR)),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _peripheralHelper
                                  .getPeripheralId()
                                  .then((value) async {
                                await _peripheralRepository
                                    .disconnectDevice(value);
                              });

                              await peripheralHelper.updatePeripheralChecking(
                                  false, '');

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                RoutesHDr.MAIN_HOME,
                                (Route<dynamic> route) => false,
                              );
                              //////
                              //////
                            },
                          ),
                        ],
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

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () async {
                      await c.write(_getRandomBytes(), withoutResponse: true);
                      await c.read();
                    },
                    onNotificationPressed: () async {
                      await c.setNotifyValue(!c.isNotifying);
                      await c.read();
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write(_getRandomBytes()),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
