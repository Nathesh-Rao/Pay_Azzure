import 'package:axpertflutter/Utils/app_snackbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationUtils {
  static Future<String> getAddressFromLatLng(
      {required double latitude, required double longitude}) async {
    var output = '';
    await placemarkFromCoordinates(latitude, longitude).then((placemarks) {
      output = placemarks[0].toString();
    });
    return output;
  }

  static Future<String> getAddressFromPosition(
      {required Position position}) async {
    var output = '';
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((placemarks) {
      output = placemarks[0].toString();
    });
    return output;
  }

  static Future<Position?> getCurrentPosition() async {
    var pmsn = await Geolocator.checkPermission();

    if (pmsn == LocationPermission.always ||
        pmsn == LocationPermission.whileInUse) {
      var p = Geolocator.getCurrentPosition();
      return p;
    } else {
      AppSnackBar.showError("Enable Location",
          "Please enable location permission to complete the action");
    }
    return null;
  }
}
