import 'package:geolocator/geolocator.dart';

class LocationHelper {
  LocationHelper.init() {}

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (!serviceEnabled) {
      // return Future.error('Location services are disabled.');
    }
    if (permission == LocationPermission.deniedForever) {
      // return Future.error(
      //     'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // return Future.error(
        //     'Location permissions are denied (actual value: $permission).');
      }
    }
    return await Geolocator.getCurrentPosition();
  }
}

LocationHelper locationManager = LocationHelper.init();
