import 'dart:math';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:capstone_home_doctor/features/peripheral/peripheral_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ConnectPeripheral extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConnectPeripheral();
  }
}

class _ConnectPeripheral extends State<ConnectPeripheral>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 30));
            return _availableBluetooth();
          }
          return _notAvailableBluetooth();
        });
  }

  Widget _availableBluetooth() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: 'Trở về',
              isMainView: false,
              buttonHeaderType: ButtonHeaderType.BACK_HOME,
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width - 40,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: DefaultTheme.GREY_BUTTON),
                child: RefreshIndicator(
                  onRefresh: () => FlutterBlue.instance
                      .startScan(timeout: Duration(seconds: 58)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        StreamBuilder<List<ScanResult>>(
                          stream: FlutterBlue.instance.scanResults,
                          initialData: [],
                          builder: (c, snapshot) => Column(
                            children: snapshot.data
                                .map(
                                  (result) => ScannedList(result: result),
                                )
                                .toList(),
                          ),
                        ),
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
              padding:
                  EdgeInsets.only(top: 10, bottom: 40, left: 40, right: 40),
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
              style: BtnStyle.BUTTON_BLACK,
              label: 'Quét lại',
              onTap: () {
                FlutterBlue.instance.stopScan();
                FlutterBlue.instance.startScan(timeout: Duration(seconds: 10));
              },
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
            ),
          ],
        ),
      ),
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderWidget(
              title: '',
              isMainView: true,
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
            ButtonHDr(
              style: BtnStyle.BUTTON_GREY,
              label: 'Tải lại',
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, RoutesHDr.CONNECT_PERIPHERAL);
              },
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
            )
          ],
        ),
      ),
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
