import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class PeripheralService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PeripheralService();
  }
}

class _PeripheralService extends State<PeripheralService> {
  @override
  Widget build(BuildContext context) {
    Map<String, ScanResult> arguments =
        ModalRoute.of(context).settings.arguments;
    ScanResult peripheral = arguments['PERIPHERAL_CONNECTED'];
    BluetoothDevice device = peripheral.device;
    Stream<List<BluetoothService>> listService = device.services;
    listService.toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text('DEVICE NAME: ${device.name}'),
            Text('DEVICE ID: ${device.id}'),
            Divider(
              height: 0.25,
            ),
          ],
        ),
      ),
    );
  }
}
