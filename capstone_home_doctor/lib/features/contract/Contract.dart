import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:barcode_scan/barcode_scan.dart';

class ContractPage extends StatefulWidget {
  @override
  _ContractPageState createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  @override
  void initState() {
    super.initState();
    this._signalRClient();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> _signalRClient() async {
    final connection = HubConnectionBuilder()
        .withUrl(
            '', //url connect
            HttpConnectionOptions(
              accessTokenFactory: () => Future.value('test'),
              client: IOClient(
                  HttpClient()..badCertificateCallback = (x, y, z) => true),
              logging: (level, message) => print(message),
            ))
        .build();

    await connection.start();

    connection.on(
      'ReceiveMessage',
      (message) {
        print(message.toString());
      },
    );

    await connection.invoke(
      'SendMessage',
      args: ['Bob', 'Says hi!'],
    ); //['tên người muốn gửi','nội dung gửi']
  }
}
