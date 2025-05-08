import 'package:dacn1/contants/global_variables.dart';
// import 'package:dacn1/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widget/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];

  Widget _buildMessage(Map<String, dynamic> message) {
    return MessageWidgetFactory.create(
      context: context,
      message: message,
      onSuggestionSelected: _sendMessage,
    );
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': text});
      _controller.clear();
    });

    _scrollToBottom();

    try {
      final res = await http.post(
        // Sửa dòng này - chọn 1 trong các tùy chọn dưới
        Uri.parse('http://192.168.1.5:5000/chat-api'), // Cho kết nối mạng LAN
        // Uri.parse('http://10.0.2.2:5000/chat-api'), // Cho Android emulator
        // Uri.parse('http://localhost:5000/chat-api'), // Cho iOS simulator
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': text}),
      );
      // log
      print('Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}'); // Log toàn bộ response

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        print(
          'Products data from API: ${data['products']}',
        ); // Thêm dòng này để debug
        debugPrint('API Response: ${json.encode(data)}'); // In toàn bộ response

        if (data['products'] != null) {
          debugPrint('First product details:');
          debugPrint('Name: ${data['products'][0]['name']}');
          debugPrint('Images: ${data['products'][0]['images']}');
          debugPrint('Price: ${data['products'][0]['price']}');
        }
        setState(() {
          messages.add({
            'role': 'bot',
            'message': data['message'] ?? '',
            'type': data['type'],
            'suggestions': data['suggestions'],
            'products': data['products'], // optional
          });
        });
        _scrollToBottom();
      } else {
        setState(() {
          messages.add({
            'role': 'bot',
            'text': '❌ Lỗi từ server: ${res.statusCode}',
          });
        });
        _scrollToBottom();
      }
    } catch (e) {
      setState(() {
        messages.add({
          'role': 'bot',
          'text': '⚠️ Không thể kết nối đến server: $e',
        });
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: const Text(
                  'Chatbot',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: false, // Changed to false for normal order
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

              itemCount: messages.length,
              // itemBuilder: (context, index) {
              //   final message = messages[index];
              //   final isUser = message['role'] == 'user';
              //   return Align(
              //     alignment:
              //         isUser ? Alignment.centerRight : Alignment.centerLeft,
              //     child: Container(
              //       margin: const EdgeInsets.symmetric(vertical: 5),
              //       padding: const EdgeInsets.all(12),
              //       constraints: BoxConstraints(
              //         maxWidth: MediaQuery.of(context).size.width * 0.7,
              //       ),
              //       decoration: BoxDecoration(
              //         color:
              //             isUser
              //                 ? Colors.grey[300]
              //                 : GlobalVariables.selectedNavBarColor,
              //         borderRadius: BorderRadius.only(
              //           topLeft: const Radius.circular(12),
              //           topRight: const Radius.circular(12),
              //           bottomLeft:
              //               isUser
              //                   ? const Radius.circular(12)
              //                   : const Radius.circular(0),
              //           bottomRight:
              //               isUser
              //                   ? const Radius.circular(0)
              //                   : const Radius.circular(12),
              //         ),
              //       ),
              //       child: Text(
              //         message['text'] ?? message['message'] ?? '',
              //         style: TextStyle(
              //           color: isUser ? Colors.black : Colors.white,
              //         ),
              //       ),
              //     ),
              //   );
              // },
              itemBuilder: (context, index) {
                return _buildMessage(
                  messages[index],
                ); // Đã dùng MessageWidgetFactory
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Message',
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _sendMessage(_controller.text),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(50),
//         child: AppBar(
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: GlobalVariables.appBarGradient,
//             ),
//           ),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 alignment: Alignment.topLeft,
//                 child: Image.asset(
//                   'assets/images/Tech_Zone.png',
//                   width:
//                       MediaQuery.of(context).size.width *
//                       0.4, // 40% chiều rộng màn hình
//                   height:
//                       MediaQuery.of(context).size.height *
//                       0.2, // 10% chiều cao màn hình
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.only(left: 15, right: 15),
//                 child: Text(
//                   'Chatbot',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 27.0),
//         child: Column(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     margin: EdgeInsets.only(
//                       left: MediaQuery.of(context).size.width / 2,
//                     ),
//                     alignment: Alignment.bottomRight,
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 225, 224, 224),
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                         bottomLeft: Radius.circular(10),
//                       ),
//                     ),
//                     child: Text(
//                       'hello',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     margin: EdgeInsets.only(
//                       right: MediaQuery.of(context).size.width / 3,
//                     ),
//                     alignment: Alignment.topLeft,
//                     decoration: BoxDecoration(
//                       color: GlobalVariables.selectedNavBarColor,
//                       borderRadius: BorderRadius.only(
//                         bottomRight: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                         topLeft: Radius.circular(10),
//                       ),
//                     ),
//                     child: Text(
//                       'hello',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Spacer(),
//             Material(
//               elevation: 5.0,
//               borderRadius: BorderRadius.circular(10),

//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                           left: 8.0,
//                           right: 8.0,
//                           top: 4.0,
//                           bottom: 4.0,
//                         ),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             border: InputBorder.none,

//                             hintText: 'Message',
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
