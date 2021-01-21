import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class ConfirmContract extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConfirmContract();
  }
}

class _ConfirmContract extends State<ConfirmContract>
    with WidgetsBindingObserver {
  String _qrString = '';
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> arguments = ModalRoute.of(context).settings.arguments;
    _qrString = arguments['QR_STRING'];
    return Scaffold(
      body: SafeArea(
        child: Column(children: <Widget>[
          HeaderWidget(
            title: 'Xác nhận hợp đồng',
          ),
          Text(
            '${_qrString}',
          ),
        ]),
      ),
    );
  }
}
