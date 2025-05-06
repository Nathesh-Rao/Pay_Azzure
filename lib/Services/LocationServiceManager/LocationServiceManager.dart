import 'dart:convert';

import 'package:axpertflutter/Utils/FirebaseHandler/FirebaseMessagesHandler.dart';
// import 'package:background_location_tracker/background_location_tracker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationServiceManager {
  saveLocationDataToSharedPref(String lat, String long) async {
    try {
      var sharedPref = await SharedPreferences.getInstance();
      await sharedPref.reload();
      await sharedPref.remove("lat");
      await sharedPref.remove("long");
      await sharedPref.setString("lat", lat);
      await sharedPref.setString("long", long);
      print("Data Saved: $lat, $long");
      // try {
      //   await LogService.initLogs();
      //   await LogService.writeLog(tag: "Save Location", subtag: "Save Location", message: "Data Saved: $lat, $long");
      // } catch (e) {}
      sharedPref = await SharedPreferences.getInstance();
      await sharedPref.reload();
      String outerDataStr = await sharedPref.getString("outerData") ?? "{}";
      Map outerData = jsonDecode(outerDataStr);
      // print("outer Data ${outerDataStr}");
      List outerKeyList = outerData.keys.toList();
      print("List ${outerKeyList}");
      for (var keyField in outerKeyList) {
        Map inner = outerData[keyField];
        String lastApiCall = inner['lastApiCall'] ?? "0";
        String interval = inner['interval'] ?? "0";
        String dataString = inner['lastData'] ?? "";
        if (dataString != "" && interval != "0") {
          Map data = jsonDecode(dataString);
          if (lastApiCall == "0") {
            inner['lastApiCall'] = DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now());
            sharedPref = await SharedPreferences.getInstance();
            await sharedPref.reload();
            await sharedPref.setString("outerData", jsonEncode(outerData));
            await sharedPref.reload();
            await getLocationAndCallApi(data, lat, long);
            // await Future.delayed(Duration(seconds: 20));
          } else {
            var dt = DateFormat("dd-MM-yyyy HH:mm:ss").parse(lastApiCall);
            var diff = DateTime.now().difference(dt).inMinutes;
            print("Time difference ${diff} minutes; interval ${interval}; last call ${lastApiCall}; Identifier ${keyField}");
            if (diff >= int.parse(interval)) {
              lastApiCall = "-1";
              inner['lastApiCall'] = DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now());
              sharedPref = await SharedPreferences.getInstance();
              await sharedPref.reload();
              await sharedPref.setString("outerData", jsonEncode(outerData));
              await sharedPref.reload();
              await getLocationAndCallApi(data, lat, long);
              // await Future.delayed(Duration(seconds: 20));
            }
          }
        }
      }
      // String lastApiCall = await sharedPref.getString("lastApiCall") ?? "0";
      // String interval = await sharedPref.getString("interval") ?? "0";
      // String dataString = await sharedPref.getString("lastData") ?? "";
      //
      // // print("LastCall $lastApiCall interval $interval, data $data");
      //
      // if (dataString != "" && interval != "0") {
      //   //store and retrieve
      //   // Map data = jsonDecode(dataString);
      //   if (lastApiCall == "0") {
      //     sharedPref = await SharedPreferences.getInstance();
      //     await sharedPref.reload();
      //     await sharedPref.setString("lastApiCall", DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now()));
      //     await getLocationAndCallApi(data, lat, long);
      //   } else {
      //     var dt = DateFormat("dd-MM-yyyy HH:mm:ss").parse(lastApiCall);
      //     var diff = DateTime.now().difference(dt).inMinutes;
      //     print("Time difference ${diff} minutes");
      //     if (diff >= int.parse(interval)) {
      //       lastApiCall = "-1";
      //       sharedPref = await SharedPreferences.getInstance();
      //       await sharedPref.reload();
      //       await sharedPref.setString("lastApiCall", DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now()));
      //       await getLocationAndCallApi(data, lat, long);
      //     }
      //   }
      //   await Future.delayed(Duration(seconds: 20));
      // }
    } catch (e) {
      print("error: ${e.toString()}");
    }

    // await LogService.writeLog(tag: "Save Location", subtag: "Saved to Shared Pref", message: "Lat: $lat, Long: $long");
    // await box.put("lat", data['latitude']);
    // await box.put("long", data['longitude']);
    // print("lat: ${Const.latitude} and long: ${Const.longitude}");
  }
}

// @pragma('vm:entry-point')
// void backgroundCallback() async {
//   BackgroundLocationTrackerManager.handleBackgroundUpdated(
//     (BackgroundLocationUpdateData data) async {
//       print("update");
//       await LocationServiceManager().saveLocationDataToSharedPref(data.lat.toString(), data.lon.toString());
//     },
//   );
// }

// initLocationService() async {
//   await BackgroundLocationTrackerManager.initialize(
//     backgroundCallback,
//     config: const BackgroundLocationTrackerConfig(
//       loggingEnabled: true,
//       androidConfig: AndroidConfig(
//         notificationIcon: 'explore',
//         trackingInterval: Duration(seconds: 5),
//         distanceFilterMeters: null,
//       ),
//       iOSConfig: IOSConfig(
//         activityType: ActivityType.FITNESS,
//         distanceFilterMeters: null,
//         restartAfterKill: true,
//       ),
//     ),
//   );
// }

// Future startLocationTracking() async {
//   try {
//     await BackgroundLocationTrackerManager.startTracking();
//     print("startd");
//     // LogService.writeLog(tag: "Service Started", subtag: "Service Started", message: "Service Started");
//   } catch (e) {
//     print("error: ${e.toString()}");
//     // LogService.writeLog(tag: "Error in Starting Service", subtag: "Error in Starting Service", message: "Error in Starting Service");
//   }
// }

// Future stopLocationTracking(String identifier) async {
//   try {
//     var pref = await SharedPreferences.getInstance();
//     await pref.reload();
//     String val = await pref.getString("outerData") ?? "{}";
//     Map outerData = jsonDecode(val);
//     if (outerData.containsKey(identifier)) outerData.remove(identifier);
//     if (outerData.length == 0 || identifier.toUpperCase() == "ALL") {
//       await BackgroundLocationTrackerManager.stopTracking();
//       await pref.remove("outerData");
//       // LogService.writeLog(tag: "Service Stopped", subtag: "Service Stopped", message: "Service Stopped");
//     } else {
//       val = jsonEncode(outerData);
//       await pref.setString("outerData", val);
//     }
//   } catch (e) {
//     // LogService.writeLog(tag: "Error in Stopping Service", subtag: "Error in Stopping Service", message: "Error in Stopping Service ${e}");
//   }
// }
