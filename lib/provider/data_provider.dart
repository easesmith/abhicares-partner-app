import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../helper/server_url.dart';

Map cart = {};
const serverUrl = ServerUrl.SERVER_URL;

class DataNotifier extends StateNotifier<Map> {
  DataNotifier() : super(cart);

  Future<List> getServices(String id) async {
    try {
      print(state);
      final url = Uri.parse('$serverUrl/get-services/$id');
      var response = await http.get(
        url,
        // headers: {'Authorization': 'Bearer $token'},
      );
      var responseData = json.decode(response.body);
      print(responseData);
      return responseData['service'];
    } catch (err) {
      print(err);
      return [];
    }
  }
}

final DataProvider =
    StateNotifierProvider<DataNotifier, Map>((ref) => DataNotifier());
