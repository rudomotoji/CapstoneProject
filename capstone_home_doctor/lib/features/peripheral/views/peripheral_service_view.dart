import 'dart:async';
import 'dart:math';

import 'package:capstone_home_doctor/commons/constants/peripheral_services.dart';
import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
import 'package:capstone_home_doctor/features/peripheral/blocs/hr_bloc.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:workmanager/workmanager.dart';
import 'package:rxdart/subjects.dart';

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    return Future.value(true);
  });
}

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
  List<BluetoothService> listService = [];
  List<BluetoothCharacteristic> listCharacteristic = [];
  BluetoothCharacteristic hRMCharacteristic;
  String valueHR = '';
  //
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  var streamController = StreamController<List<ScanResult>>();
  List<ScanResult> _scanResults = [];
  //
  int tmpHR = 0;
  var characteristicController =
      StreamController<BluetoothCharacteristic>.broadcast();
  var deviceController = StreamController<BluetoothDevice>();
  var bpmController = BehaviorSubject<int>();

  // _getListServices(BluetoothDevice device) async {
  //   print('go into get list service');
  //   List<BluetoothService> services = await device.discoverServices();
  //   services.forEach((value) {
  //     listService.add(value);
  //     // //
  //     // print('VALUE ${value.uuid}');
  //     // print('VALUE in list ${listService}');
  //     // //
  //     if (value.uuid == PeripheralServices.SERVICE_HEART_RATE) {
  //       print('Contains HR Service');
  //       //listCharacteristic = value.characteristics;
  //       for (BluetoothCharacteristic characteristic in value.characteristics) {
  //         if (characteristic.uuid ==
  //             PeripheralCharacteristics.HEART_RATE_MEASUREMENT) {
  //           print('Contains HR Measurement chrs');
  //           setState(() {
  //             hRMCharacteristic = characteristic;
  //           });
  //         }
  //       }
  //       // if(value.characteristics.contains(PeripheralCharacteristics.HEART_RATE_MEASUREMENT)){

  //       // }
  //     }
  //   });
  // }

  // _getHeartRate(BluetoothDevice device) async {
  //   await _getListServices(device);
  //   print('go into get HR func');
  //   print(' hRMCharacteristic notifiying ${hRMCharacteristic.isNotifying}');
  //   await hRMCharacteristic.setNotifyValue(true);
  //   print(' hRMCharacteristic notifiying ${hRMCharacteristic.isNotifying}');
  //   hRMCharacteristic.value.listen((value) {
  //     if (value.isNotEmpty) {
  //       print('${value}');
  //       setState(() {
  //         valueHR = value[1].toString();
  //       });
  //     } else {
  //       print('Empty heart rate');
  //     }
  //   });
  // }

  void _scanDevice() async {
    // Start scanning
    await _flutterBlue.startScan(timeout: Duration(seconds: 8));

    _flutterBlue.scanResults.listen((scanResults) {
      _scanResults.clear();
      scanResults.forEach((scanResult) {
        /*if (scanResult.device.type == BluetoothDeviceType.le) {
          if (scanResult.device.name.contains('${MiBandService.name}')) {
            _scanResults.add(scanResult);
          }
        }*/
        if (scanResult.device.type == BluetoothDeviceType.le) {
          _scanResults.add(scanResult);
        }
      });
    });
    streamController.sink.add(_scanResults);
  }

  BluetoothCharacteristic _bluetoothCharacteristic;

  void _connectDevice(BluetoothDevice bluetoothDevice) async {
    deviceController.sink.add(bluetoothDevice);
    await bluetoothDevice.connect();

    List<BluetoothService> services = await bluetoothDevice.discoverServices();

    services.forEach((service) {
      if (service.uuid == PeripheralServices.SERVICE_HEART_RATE) {
        // Reads all characteristics
        var characteristics = service.characteristics;

        for (BluetoothCharacteristic c in characteristics) {
          // print('------HR Characteristic-------');
          // print('Properties : ${c.properties}');
          // print('UUID : ${c.uuid}');
          // print('Descriptors : ${c.descriptors}');
          if (c.uuid == PeripheralCharacteristics.HEART_RATE_MEASUREMENT) {
            characteristicController.sink.add(c);
          } else {
            _bluetoothCharacteristic = c;
          }
          print('\n\n');
        }
      }
    });
  }

  void _calHeartRate(BluetoothCharacteristic bluetoothCharacteristic) async {
    //print('blueeee: $_bluetoothCharacteristic');
    //await bluetoothCharacteristic.descriptors[0].write([0xB1, 0x64]);
    await bluetoothCharacteristic.setNotifyValue(true);
    print(
        'bluetoothCharacteristic set notify ${bluetoothCharacteristic.isNotifying}');
    bluetoothCharacteristic.value.listen((value) {
      if (value.isNotEmpty) {
        print('${value[0]}');
        tmpHR = value[1];
        hrBloc.hrSink.add(value[1]);
      } else {
        print('Empty bpm');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const oneSec = const Duration(minutes: 1);
    new Timer.periodic(oneSec, (Timer t) => hrBloc.updateHR(tmpHR));
  }

  @override
  Widget build(BuildContext context) {
    Map<String, ScanResult> arguments =
        ModalRoute.of(context).settings.arguments;
    ScanResult peripheral = arguments['PERIPHERAL_CONNECTED'];
    BluetoothDevice device = peripheral.device;
    print('device connect is ${device.name}');
    // _getListServices(device);
    _connectDevice(device);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text('DEVICE NAME: ${device.name}'),
            Text('DEVICE ID: ${device.id}'),
            Divider(
              height: 0.25,
            ),
            StreamBuilder<BluetoothCharacteristic>(
              stream: characteristicController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return FlatButton(
                      color: DefaultTheme.BLACK_BUTTON,
                      onPressed: () => _calHeartRate(snapshot.data),
                      child: Container(
                          width: 200,
                          height: 50,
                          child: Center(
                              child: Text(
                            'Test Heart Rate',
                            style: TextStyle(
                                fontSize: 30, color: DefaultTheme.WHITE),
                          ))));
                }
                return Container();
              },
            ),
            StreamBuilder<int>(
              stream: hrBloc.hrStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'BPM: ${snapshot.data}',
                    style: TextStyle(fontSize: 30, color: DefaultTheme.BLACK),
                  );
                }
                return Container();
              },
            ),
            // ButtonHDr(
            //   label: 'test hr',
            //   style: BtnStyle.BUTTON_BLACK,
            //   onTap: () {
            //     _getHeartRate(device);
            //   },
            // ),
            // Text('Heart Rate Value ${valueHR}'),
            // Expanded(
            //   child: ListView(
            //     children: <Widget>[
            //       ListView.builder(
            //           itemCount: listService.length,
            //           shrinkWrap: true,
            //           physics: NeverScrollableScrollPhysics(),
            //           itemBuilder: (BuildContext buildContext, int index) {
            //             return Container(
            //                 color: DefaultTheme.GREY_VIEW,
            //                 margin: EdgeInsets.only(bottom: 50),
            //                 child: Column(
            //                   children: [
            //                     // Text('${listService[index].uuid}\n'),
            //                     // ButtonHDr(
            //                     //   label: 'test hr',
            //                     //   style: BtnStyle.BUTTON_BLACK,
            //                     //   onTap: () {
            //                     //     _getHeartRate();
            //                     //   },
            //                     // ),

            //                     // Text(
            //                     //     '${listService[index].characteristics}\n'),
            //                   ],
            //                 ));
            //           }),
            //     ],
            //   ),
            // ),
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
    // TODO: implement build
    throw UnimplementedError();
  }
}
