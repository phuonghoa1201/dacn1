import 'dart:convert';

import 'package:dacn1/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../contants/error_handling.dart';
import '../../../contants/global_variables.dart';
import '../../../contants/utils.dart';
import '../../../providers/user_providers.dart';

import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


import '../../../contants/error_handling.dart';
import '../../../contants/global_variables.dart';
import '../../../contants/utils.dart';
import '../../../models/product.dart';
import '../../../providers/user_providers.dart';


class HomeServices {
  /// Lấy danh sách sản phẩm theo category
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];


    try {
      final res = await http.get(
        Uri.parse('$uri/api/products?category=$category'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );


      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          List<dynamic> jsonData = jsonDecode(res.body);
          productList = jsonData.map((item) => Product.fromMap(item)).toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }


    return productList;
  }




  /// Lấy sản phẩm nổi bật
  Future<List<Product>> fetchFeaturedProducts({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print("TOKEN: ${userProvider.user.token}"); // In token ra kiểm tra


    List<Product> productList = [];


    try {
      final res = await http.get(
        Uri.parse('$uri/api/featured-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,  // Dùng lại header cũ
        },
      );


      // Debug headers và response status, body
      print("--- Debug headers ---");
      print({
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      print("--- Response status ---");
      print(res.statusCode);
      print("--- Response body ---");
      print(res.body);


      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          List<dynamic> data = jsonDecode(res.body);
          productList = data.map((item) => Product.fromMap(item)).toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }


    return productList;
  }






  /// Lấy sản phẩm Deal of the day
  Future<Product> fetchDealOfDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print("TOKEN: ${userProvider.user.token}");
    Product product = Product(
      name: '',
      description: '',
      quantity: 0,
      images: [],
      category: '',
      price: 0,
    );


    try {
      final res = await http.get(
        Uri.parse('$uri/api/deal-of-day'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );


      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Map<String, dynamic> data = jsonDecode(res.body);
          product = Product.fromMap(data);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }


    return product;
  }
}
