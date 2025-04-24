import 'dart:convert';

import 'package:dacn1/contants/global_variables.dart';
import 'package:dacn1/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../contants/error_handling.dart';
import '../../../contants/utils.dart';
import 'package:http/http.dart' as http;

import '../../../models/product.dart';
import '../../../providers/user_providers.dart';

class AddressServices {
  // String uri = GlobalVariables.uri;
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/save-user-address'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'address': address}),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            address: jsonDecode(res.body)['address'],
          );

          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get all the products
  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print("SENDING CART: ${jsonEncode(userProvider.user.cart)}");
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/order'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'cart': userProvider.user.cart,
          'address': address,
          'totalPrice': totalSum,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Your order has been placed!');
          User user = userProvider.user.copyWith(cart: []);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // void placeOrder({
  //   required BuildContext context,
  //   required String address,
  //   required double totalSum,
  // }) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);

  //   try {
  //     print('========= DEBUG ORDER =========');
  //     print(
  //       'Token: ${userProvider.user.token} (${userProvider.user.token.runtimeType})',
  //     );
  //     print('Address: $address (${address.runtimeType})');
  //     print('Total Sum: $totalSum (${totalSum.runtimeType})');

  //     for (var item in userProvider.user.cart) {
  //       print('Cart item: $item');
  //     }

  //     // Tạo bodyMap
  //     Map<String, dynamic> bodyMap = {
  //       'cart': userProvider.user.cart,
  //       'address': address,
  //       'totalPrice': totalSum,
  //     };

  //     // Encode JSON body
  //     String jsonBody = '';
  //     try {
  //       jsonBody = jsonEncode(bodyMap);
  //       print('Encoded JSON Body: $jsonBody');
  //     } catch (e, stackTrace) {
  //       print('❌ Error during jsonEncode: $e');
  //       print('❌ StackTrace: $stackTrace');
  //       showSnackBar(context, 'JSON Encode Error: $e');
  //       return; // Không gửi request nữa nếu encode lỗi
  //     }

  //     // Gửi request HTTP
  //     http.Response res = await http.post(
  //       Uri.parse('$uri/api/order'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'x-auth-token': userProvider.user.token,
  //       },
  //       body: jsonBody,
  //     );

  //     print('========= RESPONSE =========');
  //     print('Status Code: ${res.statusCode}');
  //     print('Body: ${res.body}');

  //     // Xử lý phản hồi HTTP
  //     httpErrorHandle(
  //       response: res,
  //       context: context,
  //       onSuccess: () {
  //         showSnackBar(context, 'Your order has been placed!');
  //         User user = userProvider.user.copyWith(cart: []);
  //         userProvider.setUserFromModel(user);
  //       },
  //     );
  //   } catch (e, stackTrace) {
  //     print('❌ HTTP Error: $e');
  //     print('❌ StackTrace: $stackTrace');
  //     showSnackBar(context, 'Lỗi gửi đơn hàng: $e');
  //   }
  // }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': product.id}),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}


// fix loiox