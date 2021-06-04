import 'package:capstone_home_doctor/commons/routes/routes.dart';
import 'package:flutter/material.dart';

class SuccessNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                child: Image.asset('assets/images/vnpay.png'),
              ),
              Text('Successfully')
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: RaisedButton(
            color: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //   RoutesHDr.MAIN_HOME,
              //   (Route<dynamic> route) => false,
              // );

              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(
              'Done',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
