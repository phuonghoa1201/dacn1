import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dacn1/contants/global_variables.dart';

class ChatService {
  static Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('$uri/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['reply'] ?? 'Không có phản hồi';
    } else {
      throw Exception('Lỗi máy chủ: ${response.statusCode}');
    }
  }
}
