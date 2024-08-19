import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location_package;

class LocationService {
  final location_package.Location _location = location_package.Location();
  final Map _rMap = {"hasError": true, "eMsg": "default eMsg"};
  String _rAddress = "Default city, Default state, Default country";
  bool _isLocationServiceEnabled = false;

  Future<Map<dynamic, dynamic>> getAddress({required double lat, required double lon}) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

    if (placemarks.isNotEmpty) {
      Placemark data = placemarks.first;
      // rAddress = "${data.subAdminArea}, ${data.adminArea}, ${data.countryName}";
      if (kDebugMode) {
        print(data.toString());
      }
      _rAddress = "${data.subLocality}, ${data.locality}, ${data.administrativeArea}";
      _rMap.remove("hasError");
      _rMap.remove("eMsg");
      _rMap.addAll({"hasError": false});
      _rMap.addAll({"data": _rAddress});

      return Future.value(_rMap);
    } else {
      _rMap.remove("hasError");
      _rMap.remove("eMsg");
      _rMap.addAll({"hasError": false});
      _rMap.addAll({"eMgs": "No data available"});
      return Future.value(_rMap);
    }
  }

  Future<Map<dynamic, dynamic>> getLocationPermission() async {
    location_package.PermissionStatus permissionGranted;

    _isLocationServiceEnabled = await _location.serviceEnabled();
    if (!_isLocationServiceEnabled) {
      _isLocationServiceEnabled = await _location.requestService();
      if (!_isLocationServiceEnabled) {
        _rMap.remove("hasError");
        _rMap.remove("eMsg");
        _rMap.addAll({"hasError": true});
        _rMap.addAll({"eMsg": "Location should be enabled to save the data.\n Try switching on the location"});
        return Future.value(_rMap);
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == location_package.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != location_package.PermissionStatus.granted) {
        _rMap.remove("hasError");
        _rMap.remove("eMsg");
        _rMap.addAll({"hasError": true});
        _rMap.addAll({"eMsg": "Location permission be provided for the app to save the data \n Try switching on the location"});
        return Future.value(_rMap);
      }
    }

    await _location.getLocation().then((value) {
      _rMap.remove("hasError");
      _rMap.remove("eMsg");
      _rMap.addAll({"hasError": false});
      _rMap.addAll({
        "data": {"latitude": value.latitude ?? 11.1085, "longitude": value.longitude ?? 77.3411}
      });
      return Future.value(_rMap);
    }).onError((error, stackTrace) {
      _rMap.remove("hasError");
      _rMap.remove("eMsg");
      _rMap.addAll({"hasError": true});
      _rMap.addAll({"eMsg": error.toString()});
      return Future.value(_rMap);
    });
    return Future.value(_rMap);
  }
}
