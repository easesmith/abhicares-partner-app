import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<Map> getUserData() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('user')) {
    final extractedUserData = json.decode(prefs.getString('user')!) as Map;
    return extractedUserData;
  } else {
    return {};
  }
}
