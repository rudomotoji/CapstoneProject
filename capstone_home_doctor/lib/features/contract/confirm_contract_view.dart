import 'package:capstone_home_doctor/commons/widgets/button_widget.dart';
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
  String _qrString;
  // _ConfirmContract({})
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
    String arguments = ModalRoute.of(context).settings.arguments;
    // Object x = ModalRoute.of(context).settings.arguments;
    // String code = x['QRCODE'] as String;

    print('WHAT Code MEANS? $arguments');
    // print('AVAILABLE CHECK ${check}');
    // this._qrString = arguments['QRCODE'];
    // print('IN CONFIRM PAGE ${this._qrString}');
    return Scaffold(
      body: SafeArea(
        child: Column(children: <Widget>[
          HeaderWidget(
            title: 'Xác nhận hợp đồng',
            isMainView: false,
            buttonHeaderType: ButtonHeaderType.BACK_HOME,
          ),
          Text(
            '${arguments}',
          ),
          // ButtonHDr(
          //   label: 'Xác nhận',
          //   onTap: () {},
          //   style: BtnStyle.BUTTON_BLACK,
          // ),
          // ButtonHDr(
          //   label: 'Huỷ',
          //   onTap: () {},
          //   style: BtnStyle.BUTTON_GREY,
          // ),
        ]),
      ),
    );
  }
}
