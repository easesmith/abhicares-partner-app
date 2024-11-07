
import 'package:abhicaresservice/functions/get_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/server_url.dart';

List order = [];
const serverUrl = ServerUrl.SERVER_URL;

class BookingNotifier extends StateNotifier<List> {
  BookingNotifier() : super(order);
  bool AddOrder(order) {
    state = [...state, order];
    print(state);
    return true;
  }

  Map? user;
  var curBookingId;

  Future<List> getBookinhHistory() async {
    try {
      user ??= await getUserData();
      final url =
          Uri.parse('$serverUrl/get-booking-history/${user!['userId']}');
      var response = await http.get(
        url,
      );
      var responseData = json.decode(response.body);
      return responseData;
    } catch (err) {
      print(err);
      return [];
    }
  }

  Future<List> getUpcomingorders() async {
    try {
      user ??= await getUserData();
      print(user);
      final url = Uri.parse('$serverUrl/get-upcoming-order/${user!['userId']}');
      var response = await http.get(
        url,
      );
      var responseData = json.decode(response.body);
      // print(responseData);
      return responseData['sellerOrders'];
    } catch (err) {
      print(err);
      return [];
    }
  }

  Future<List> getTodayBooking() async {
    try {
      user ??= await getUserData();
      print(user);
      final url = Uri.parse('$serverUrl/get-today-booking/${user!['userId']}');
      var response = await http.get(
        url,
      );
      var responseData = json.decode(response.body);
      // print(responseData);
      return responseData['sellerOrders'];
    } catch (err) {
      print(err);
      return [];
    }
  }

  Future<Map> getBooking({required String bookingId}) async {
    try {
      final url = Uri.parse('$serverUrl/get-booking/$bookingId');
      var response = await http.get(
        url,
      );
      var responseData = json.decode(response.body);
      return responseData['booking'];
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<Map> getRunningBooking() async {
    try {
      user ??= await getUserData();
      print(user);
      final url =
          Uri.parse('$serverUrl/get-running-booking/${user!['userId']}');
      var response = await http.get(
        url,
      );
      var responseData = json.decode(response.body);
      return responseData['sellerOrder'];
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<Map> startBooking({
    required String bookingId,
    required double lat,
    required double long,
  }) async {
    try {
      user ??= await getUserData();
      print(user);
      final url = Uri.parse('$serverUrl/start-booking');
      var response = await http.post(
        url,
        body: json.encode(
          {
            "id": bookingId,
            "lat": lat,
            "long": long,
          },
        ),
        headers: {
          'Content-type': 'application/json',
        },
      );
      var responseData = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("currentBooking", json.encode({'id': bookingId}));
      return responseData;
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<Map> reachedOnTheLocation({
    required String bookingId,
    required double lat,
    required double long,
  }) async {
    try {
      final url = Uri.parse('$serverUrl/reached-on-location');
      var response = await http.post(
        url,
        body: json.encode(
          {
            "id": bookingId,
            "lat": lat,
            "long": long,
          },
        ),
        headers: {
          'Content-type': 'application/json',
        },
      );
      var responseData = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("currentBooking", bookingId);
      prefs.remove('currentBooking');
      return responseData;
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<Map> completeBookingReq({
    required String bookingId,
  }) async {
    try {
      final url = Uri.parse('$serverUrl/complete-booking-request');
      var response = await http.post(
        url,
        body: json.encode(
          {
            "id": bookingId,
          },
        ),
        headers: {
          'Content-type': 'application/json',
        },
      );
      var responseData = json.decode(response.body);
      return responseData;
    } catch (err) {
      print(err);
      return {};
    }
  }
}

final bookingProvider =
    StateNotifierProvider<BookingNotifier, List>((ref) => BookingNotifier());
