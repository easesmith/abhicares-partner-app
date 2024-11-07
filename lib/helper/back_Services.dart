import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:abhicaresservice/helper/server_url.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const serverUrl = ServerUrl.SERVER_URL;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  Timer.periodic(const Duration(seconds: 15), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
            title: "Abhicares", content: "service running");
      }
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    final prefs = await SharedPreferences.getInstance();
    String bookingId;
    if (prefs.containsKey('currentBooking')) {
      bookingId =
          json.decode(prefs.getString('currentBooking')!)['id'] as String;
    } else {
      service.stopSelf();
      return;
    }
    final url = Uri.parse('$serverUrl/update-live-location');
    await http.post(
      url,
      body: json.encode(
        {
          "id": bookingId,
          "lat": currentPosition.latitude,
          "long": currentPosition.longitude,
        },
      ),
      headers: {
        'Content-type': 'application/json',
      },
    );
    print('background service running');
    service.invoke('update');
  });
}
