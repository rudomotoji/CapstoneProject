import 'package:capstone_home_doctor/commons/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  var location;

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Row(
    //     children: [
    //       FlatButton(
    //         child: Text('get location'),
    //         onPressed: () {
    //           _determinePosition();
    //         },
    //       ),
    //       location != null
    //           ? Text(location.latitude.toString() +
    //               ' - ' +
    //               location.longitude.toString())
    //           : Text(''),
    //     ],
    //   ),
    // );
    return SafeArea(
        child: Column(
      children: [],
    ));
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    var position = await Geolocator.getCurrentPosition();
    setState(() {
      location = position;
    });
  }
}
