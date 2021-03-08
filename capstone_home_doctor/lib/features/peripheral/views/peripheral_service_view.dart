import 'dart:math';

import 'package:capstone_home_doctor/commons/constants/theme.dart';
import 'package:capstone_home_doctor/features/peripheral/repositories/peripheral_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class PeripheralService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PeripheralService();
  }
}

class _PeripheralService extends State<PeripheralService> {
  List<Object> listService = [];

  _getListServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((value) {
      listService.add(value);
      print('VALUE ${value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, ScanResult> arguments =
        ModalRoute.of(context).settings.arguments;
    ScanResult peripheral = arguments['PERIPHERAL_CONNECTED'];
    BluetoothDevice device = peripheral.device;
    _getListServices(device);
    // Stream<List<BluetoothService>> listService = device.services;
    // listService.forEach((service) {
    //   print('Service ${service}');
    // });
    //

    //
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text('DEVICE NAME: ${device.name}'),
            Text('DEVICE ID: ${device.id}'),
            Divider(
              height: 0.25,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  (listService != null || listService.length != 0)
                      ? ListView.builder(
                          itemCount: listService.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext buildContext, int index) {
                            return Container(
                                color: DefaultTheme.GREY_VIEW,
                                margin: EdgeInsets.only(bottom: 50),
                                child: Text('${listService[index]}\n'));
                          })
                      : Container(),
                ],
              ),
            ),

            //
            // StreamBuilder<List<BluetoothDevice>>(
            //   stream: Stream.periodic(Duration(seconds: 2))
            //       .asyncMap((_) => FlutterBlue.instance.connectedDevices),
            //   initialData: [],
            //   builder: (c, snapshot) => Column(
            //     children: snapshot.data
            //         .map((d) => ListTile(
            //               title: Text(d.name),
            //               subtitle: Text(d.id.toString()),
            //               trailing: StreamBuilder<BluetoothDeviceState>(
            //                 stream: d.state,
            //                 initialData: BluetoothDeviceState.connected,
            //                 builder: (c, snapshot) {
            //                   if (snapshot.data ==
            //                       BluetoothDeviceState.connected) {
            //                     return RaisedButton(
            //                       child: Text('OPEN'),
            //                       onPressed: () => Navigator.of(context).push(
            //                           MaterialPageRoute(
            //                               builder: (context) =>
            //                                   DeviceScreen(device: d))),
            //                     );
            //                   }
            //                   return Text(snapshot.data.toString());
            //                 },
            //               ),
            //             ))
            //         .toList(),
            //   ),
            // ),
            // //
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
