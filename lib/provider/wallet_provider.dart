import 'package:abhicaresservice/functions/get_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../helper/server_url.dart';

Map cart = {};
const serverUrl = ServerUrl.SERVER_URL;

class sellerWalletNotifier extends StateNotifier<Map> {
  sellerWalletNotifier() : super(cart);
  Map? user;

  Future<Map> getWallet() async {
    try {
      user ??= await getUserData();
      final url = Uri.parse('$serverUrl/get-wallet/${user!['userId']}');
      var response = await http.get(
        url,
      );
      var responseData = json.decode(response.body);
      print(responseData);
      return responseData;
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<Map> createCashout(
      {required int value, required String walletId}) async {
    try {
      final url = Uri.parse('$serverUrl/post-cashout');
      var response = await http.post(
        url,
        body: json.encode(
          {
            "id": walletId,
            "value": value,
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

  Future<List> getSellerCashout({required String id}) async {
    try {
      final url = Uri.parse('$serverUrl/get-cashout/$id');
      var response = await http.get(
        url,
      );
      var responseData = json.decode(response.body);
      print(responseData);
      return responseData['cashout'];
    } catch (err) {
      print(err);
      return [];
    }
  }

  // Future<String> changeQuantity(Map product, String type) async {
  //   var products = [];
  //   state["items"].forEach((prod) {
  //     if (prod["prodId"] == product["prodId"]) {
  //       if (type == "-") {
  //         if (prod['quantity'] > 1) {
  //           prod['quantity'] = prod['quantity'] - 1;
  //           products.add(prod);
  //         } else {
  //           return;
  //         }
  //         ;
  //       }
  //       if (type == "+") {
  //         prod['quantity'] = prod['quantity'] + 1;
  //         products.add(prod);
  //       }
  //     } else {
  //       products.add(prod);
  //     }
  //   });

  //   state = {
  //     "items": [...products],
  //     "totalValue": type == "-"
  //         ? state["totalValue"] - product['prod']['offerPrice']
  //         : state["totalValue"] + product['prod']['offerPrice'],
  //   };
  //   // state = [...state, product];
  //   return "true";
  // }

  // bool clearCart() {
  //   state = {"items": <CartProductModel>[], "totalValue": 0};
  //   return true;
  // }
}

final sellerWalletProvider = StateNotifierProvider<sellerWalletNotifier, Map>(
    (ref) => sellerWalletNotifier());
