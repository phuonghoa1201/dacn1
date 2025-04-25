import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dacn1/contants/utils.dart';

// void httpErrorHandle({
//   required http.Response response,
//   required BuildContext context,
//   required VoidCallback onSuccess,
// }) {
//   switch (response.statusCode) {
//     case 200:
//       onSuccess();
//       break;
//     case 400:
//       showSnackBar(context, jsonDecode(response.body)['msg']);
//       break;
//     case 500:
//       showSnackBar(context, jsonDecode(response.body)['error']);
//       break;
//     default:
//       showSnackBar(context, response.body);
//   }
// }

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      final body = jsonDecode(response.body);
      showSnackBar(context, body['msg'] ?? 'Something went wrong');
      break;
    case 500:
      final body = jsonDecode(response.body);
      showSnackBar(
        context,
        body['error'] ?? body['msg'] ?? 'Internal server error',
      );
      break;
    default:
      showSnackBar(context, response.body);
  }
}
