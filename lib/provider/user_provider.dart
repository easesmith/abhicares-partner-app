import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/server_url.dart';

Map partner = {
  "userId": null,
  "phone": null,
  "name": null,
};

bool _userLogged = false;

const serverUrl = ServerUrl.SERVER_URL;

class userNotifier extends StateNotifier<Map> {
  userNotifier() : super(partner);

  bool get isAuth {
    return _userLogged;
  }

  Map get getUser {
    // tryAutoLogin();
    return partner;
  }

  Future<Map> signup({
    required String phone,
    required String name,
    required String legalName,
    required String gst,
    required String addressLine,
    required String pincode,
    required String state,
    required String city,
    required String catId,
    required List services,
  }) async {
    try {
      final url = Uri.parse('$serverUrl/create-seller');
      var response = await http.post(
        url,
        body: json.encode(
          {
            "phone": phone,
            "name": name,
            "legalName": legalName,
            "gstNumber": gst,
            "status": "in-review",
            "password": "password",
            "address": {
              "state": state,
              "addressLine": addressLine,
              "pincode": pincode,
              "city": city,
            },
            "categoryId": catId,
            "services": services,
          },
        ),
        headers: {
          'Content-type': 'application/json',
        },
      );
      if (response.statusCode == 403) {
        return {"error": "USEREXIST"};
      }
      var responseData = json.decode(response.body);
      print(responseData);
      partner['userId'] = responseData['seller']['_id'];
      partner['phone'] = responseData['seller']['phone'];
      partner['name'] = responseData['seller']['name'];
      partner['status'] = "offline";
      // state = {
      //   "userId": responseData['sller']['_id'],
      //   "phone": responseData['seller']['phone'],
      //   "name": responseData['seller']['name'],
      // };
      _userLogged = true;
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(partner);
      prefs.setString("user", userData);
      return responseData['seller'];
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<Map> loginOtp(String phone) async {
    try {
      print(phone);
      final url = Uri.parse('$serverUrl/login-otp');
      var response = await http.post(
        url,
        body: json.encode(
          {
            "phoneNumber": phone,
          },
        ),
        headers: {
          'Content-type': 'application/json',
          // 'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 404) {
        return {"error": "NOUSER"};
      }
      var responseData = json.decode(response.body);
      print(responseData);
      return state;
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<Map> login(String phone, pin) async {
    try {
      print(phone);
      final url = Uri.parse('$serverUrl/login');
      var response = await http.post(
        url,
        body: json.encode(
          {
            "phoneNumber": phone,
            "enteredOTP": pin,
          },
        ),
        headers: {
          'Content-type': 'application/json',
          // 'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 400) {
        return {"error": "Invalid Otp"};
      }
      var responseData = json.decode(response.body);
      print(responseData);
      partner['userId'] = responseData['partner']['_id'];
      partner['phone'] = responseData['partner']['phone'];
      partner['name'] = responseData['partner']['name'];
      partner['status'] = "offline";
      state = {
        "userId": responseData['partner']['_id'],
        "phone": responseData['partner']['phone'],
        "name": responseData['partner']['name'],
        "status": "offline"
      };
      _userLogged = true;
      partner = state;
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(partner);
      prefs.setString("user", userData);
      print('user login');
      print(prefs.get('user'));
      return state;
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<Map> getUserProfile() async {
    try {
      final url = Uri.parse('$serverUrl/get-partner/${partner['userId']}');
      var response = await http.get(
        url,
      );
      var responseData = json.decode(response.body);
      print(responseData);
      return responseData['partner'];
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<List> getuserTickets() async {
    try {
      final url = Uri.parse('$serverUrl/get-tickets/${partner['userId']}');
      var response = await http.get(
        url,
      );
      var responseData = json.decode(response.body);
      print(responseData);
      return responseData['tickets'];
    } catch (err) {
      print(err);
      return [];
    }
  }

  Future<Map> postRaiseTicket({
    required String issue,
    required String description,
  }) async {
    try {
      final url = Uri.parse('$serverUrl/raise-ticket');
      var response = await http.post(
        url,
        body: json.encode(
          {
            "issue": issue,
            "description": description,
            "userId": partner['userId'],
          },
        ),
        headers: {
          'Content-type': 'application/json',
          // 'Authorization': 'Bearer $token'
        },
      );
      var responseData = json.decode(response.body);
      print(responseData);
      return responseData;
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<void> logout() async {
    // user['userId'] = null;
    // user['phone'] = null;
    // user['name'] = null;
    final prefs = await SharedPreferences.getInstance();
    print(prefs.get('user'));
    prefs.remove('user');
    _userLogged = false;
    partner = {
      "userId": null,
      "phone": null,
      "name": null,
      "status": null,
    };
    print(prefs.get('user'));
    // final UserPr
    partner = state;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      final extractedUserData = json.decode(prefs.getString('user')!) as Map;
      _userLogged = true;
      partner = extractedUserData;
      state = partner;
      print("autoLogin $_userLogged");
      print(state);
      return true;
    } else {
      return false;
    }
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      final extractedUserData = json.decode(prefs.getString('user')!) as Map;
      _userLogged = true;
      partner = extractedUserData;
      state = partner;
      return true;
    } else {
      return false;
    }
  }

  ChangeStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      final extractedUserData = json.decode(prefs.getString('user')!) as Map;
      _userLogged = true;
      extractedUserData["status"] = status;
      partner = extractedUserData;
      state = partner;
      return true;
    } else {
      return false;
    }
  }
}

final UserProvider =
    StateNotifierProvider<userNotifier, Map>((ref) => userNotifier());

//  finalUserProvider.autoDispose((ref) async {
//                           return ref;
//                         });