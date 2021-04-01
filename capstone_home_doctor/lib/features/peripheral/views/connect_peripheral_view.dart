import 'dart:math';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/peripheral/blocs/peripheral_bloc.dart';
import 'package:capstone_home_doctor/features/peripheral/events/peripheral_event.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repo.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repository.dart';
import 'package:capstone_home_doctor/features/peripheral/states/peripheral_state.dart';
import 'package:capstone_home_doctor/services/authen_helper.dart';
import 'package:capstone_home_doctor/services/peripheral_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:http/http.dart' as http;

PeripheralHelper peripheralHelper = PeripheralHelper();
PeripheralSeverRepository _peripheralSeverRepository =
    PeripheralSeverRepository(httpClient: http.Client());

final AuthenticateHelper _authenticateHelper = AuthenticateHelper();

class ConnectPeripheral extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConnectPeripheral();
  }
}

class _ConnectPeripheral extends State<ConnectPeripheral>
    with WidgetsBindingObserver {
  //
  PeripheralBloc _peripheralBloc;
  List<ScanResult> listScanned = [];
  int _patientId = 0;

  @override
  void initState() {
    super.initState();
    _peripheralBloc = BlocProvider.of(context);
    _getPatientId();
  }

  _getPatientId() async {
    await _authenticateHelper.getPatientId().then((value) {
      _patientId = value;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderWidget(
              title: 'Quét thiết bị',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            //
            Expanded(
              child: StreamBuilder<BluetoothState>(
                  stream: FlutterBlue.instance.state,
                  initialData: BluetoothState.unknown,
                  builder: (c, snapshot) {
                    final state = snapshot.data;
                    if (state == BluetoothState.on) {
                      listScanned = [];
                      _scanBluetoothDevice();
                      // FlutterBlue.instance
                      //     .startScan(timeout: Duration(seconds: 10));
                      return _availableBluetooth();
                    }
                    return _notAvailableBluetooth();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future _scanBluetoothDevice() async {
    listScanned = [];
    await _peripheralBloc.add(PeripheralEventScan());
  }

  Widget _availableBluetooth() {
    listScanned = [];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 50),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          width: MediaQuery.of(context).size.width - 40,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: DefaultTheme.GREY_BUTTON),
            child: RefreshIndicator(
              onRefresh: _scanBluetoothDevice,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    BlocBuilder<PeripheralBloc, PeripheralState>(
                      builder: (context, state) {
                        //
                        if (state is PeripheralStateLoading) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.45,
                            width: MediaQuery.of(context).size.width - 40,
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/images/loading.gif'),
                            ),
                          );
                        }
                        if (state is PeripheralStateFailure) {
                          //
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.45,
                              width: MediaQuery.of(context).size.width - 40,
                              child: Center(
                                child:
                                    Text('Không thể quét.\nVui lòng quét lại.'),
                              ));
                        }
                        if (state is PeripheralStateScanSuccess) {
                          listScanned = [];
                          for (ScanResult r in state.list) {
                            if (r.device.name.toUpperCase().contains('MI') ||
                                r.device.name
                                    .toUpperCase()
                                    .contains('GALAXY FIT')) {
                              listScanned.add(r);
                              print('device added: ${r.device.name}');
                            }
                          }

                          return (listScanned != null)
                              ? Container(
                                  padding: EdgeInsets.only(top: 20),
                                  height:
                                      MediaQuery.of(context).size.height * 0.45,
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: ListView.builder(
                                    itemCount: listScanned.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ButtonHDr(
                                        style: BtnStyle.BUTTON_IN_LIST,
                                        imgHeight: 50,
                                        label: listScanned[index].device.name,
                                        height: 100,
                                        image: Image.asset(_getImageDevice(
                                            listScanned[index].device.name)),
                                        onTap: () async {
                                          print(
                                              'id device when tap: ${listScanned[index].device.name}');
                                          print('TAPPED');
                                          //connect, update SharePreferenced, navigate
                                          _peripheralBloc.add(
                                              PeripheralEventConnectFirstTime(
                                                  scanResult:
                                                      listScanned[index]));

                                          await _authenticateHelper
                                              .getPatientId()
                                              .then((value) async {
                                            _patientId = value;
                                            print('_patient id? ${_patientId}');

                                            //R
                                            if (_patientId != 0) {
                                              await _peripheralSeverRepository
                                                  .updatePeripheralConnect(
                                                      _patientId, true)
                                                  .then(
                                                      (isConnectedSendingServer) async {
                                                print(
                                                    'is connected with sever? ${isConnectedSendingServer}');
                                                if (isConnectedSendingServer) {
                                                  print(
                                                      'update connected with server');
                                                  Navigator.of(context)
                                                      .pushNamed(RoutesHDr
                                                          .PERIPHERAL_SERVICE);
                                                }
                                              });
                                            }
                                          });
                                        },
                                      );
                                      // Container(
                                      //   width:
                                      //       MediaQuery.of(context).size.width -
                                      //           40,
                                      //   height: 60,
                                      //   margin: EdgeInsets.only(top: 5),
                                      //   color: Colors.red,
                                      //   child: Text(
                                      //       '${listScanned[index].device.name}'),
                                      // );
                                    },
                                  ),
                                )
                              : Container();
                        }
                        return Container();
                      },
                    ),
                    // StreamBuilder<List<ScanResult>>(
                    //   stream: FlutterBlue.instance.scanResults,
                    //   initialData: [],
                    //   builder: (c, snapshot) => Column(
                    //     children: snapshot.data.map((result) {
                    //       return ScannedList(
                    //           result: result,
                    //           onTap: () async {
                    //             result.device.connect();
                    //             Navigator.pushNamed(
                    //                 context, RoutesHDr.PERIPHERAL_SERVICE,
                    //                 arguments: {
                    //                   'PERIPHERAL_CONNECTED': result
                    //                 });
                    //           });
                    //     }).toList(),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'Chọn thiết bị',
            style: TextStyle(
              color: DefaultTheme.BLACK,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 40, left: 40, right: 40),
          child: Text(
            'Danh sách thiết bị đeo khả dụng',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: DefaultTheme.GREY_TEXT,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ButtonHDr(
          style: BtnStyle.BUTTON_FULL,
          image: Image.asset('assets/images/ic-reload.png'),
          label: 'Quét lại',
          onTap: () async {
            await _scanBluetoothDevice();
          },
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 30),
        ),
      ],

      // floatingActionButton: StreamBuilder<bool>(
      //   stream: FlutterBlue.instance.isScanning,
      //   initialData: false,
      //   builder: (c, snapshot) {
      //     if (snapshot.data) {
      //       return FloatingActionButton(
      //         child: Icon(Icons.stop),
      //         onPressed: () => FlutterBlue.instance.stopScan(),
      //         backgroundColor: Colors.red,
      //       );
      //     } else {
      //       return FloatingActionButton(
      //           child: Icon(Icons.search),
      //           onPressed: () => FlutterBlue.instance
      //               .startScan(timeout: Duration(seconds: 4)));
      //     }
      //   },
      // ),
    );
  }

  Widget _notAvailableBluetooth() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
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
          padding: EdgeInsets.only(top: 10, bottom: 40, left: 40, right: 40),
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
    );
  }

  _getImageDevice(String keyword) {
    DeviceHDr deviceType;
    if (keyword.contains('Mi Smart Band')) {
      deviceType = DeviceHDr.MI_BAND;
    } else if (keyword.contains('Amazfit')) {
      deviceType = DeviceHDr.AMAZFIT;
    } else if (keyword.contains('Galaxy Fit')) {
      deviceType = DeviceHDr.GALAXY_FE;
    } else {
      deviceType = DeviceHDr.UNKNOWN;
    }
    switch (deviceType) {
      case DeviceHDr.MI_BAND:
        return 'assets/images/img-mi-band.png';
        break;
      case DeviceHDr.AMAZFIT:
        return 'assets/images/img-amazfit.png';
        break;
      case DeviceHDr.GALAXY_FE:
        return 'assets/images/img-galaxy-fit-e.png';
        break;
      case DeviceHDr.UNKNOWN:
        return 'assets/images/img-unknown-device.png';
        break;
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        .copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<int>(
              stream: device.mtu,
              initialData: 0,
              builder: (c, snapshot) => ListTile(
                title: Text('MTU Size'),
                subtitle: Text('${snapshot.data} bytes'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => device.requestMtu(223),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
