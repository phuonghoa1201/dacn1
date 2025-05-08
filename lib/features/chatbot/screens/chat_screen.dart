import 'package:dacn1/features/chatbot/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:dacn1/contants/global_variables.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);


  @override
  State<ChatScreen> createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();


  void _sendMessage() async {
    final userInput = _controller.text.trim();
    if (userInput.isEmpty) return;


    setState(() {
      _messages.add({'role': 'user', 'text': userInput});
      _controller.clear();
      _isLoading = true;
    });


    try {
      final reply = await ChatService.sendMessage(userInput);


      // Bước 1: Hiển thị câu trả lời của bot (text)
      setState(() {
        _messages.add({'role': 'ai', 'text': reply});
        _isLoading = false;
      });


      final imageUrls = _extractImageUrls(reply);


      // Bước 2: Nếu có hình ảnh, sau 0.5 giây sẽ thêm hình ảnh vào tin nhắn
      if (imageUrls.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 500));  // đợi 0.5s


        // Thêm các tin nhắn ảnh (mỗi hình ảnh là một tin nhắn riêng biệt)
        for (var url in imageUrls) {
          setState(() {
            _messages.add({'role': 'ai_image', 'url': url});
          });
          await Future.delayed(const Duration(milliseconds: 300));  // mỗi ảnh cách nhau 0.3s
        }
      }


      // Auto scroll xuống dưới cùng
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      setState(() {
        _messages.add({'role': 'ai', 'text': 'Lỗi khi gửi tin nhắn: $e'});
        _isLoading = false;
      });
    }
  }


  // Hàm để tách các URL hình ảnh từ câu trả lời của bot
  List<String> _extractImageUrls(String text) {
    final regExp = RegExp(r'https?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+\.(jpg|jpeg|png|gif)');
    final matches = regExp.allMatches(text);


    return matches.map((match) => match.group(0) ?? '').toList();
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
            mainAxisAlignment: MainAxisAlignment.start, // Căn trái cho logo
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/Tech_Zone.png',
                  width: MediaQuery.of(context).size.width * 0.5, // 40% chiều rộng màn hình
                  height: MediaQuery.of(context).size.height * 0.2, // 10% chiều cao màn hình
                  fit: BoxFit.contain,
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
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final role = msg['role'];


                if (role == 'user') {
                  // Tin nhắn người dùng
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Đảm bảo tin nhắn và avatar nằm ở cuối dòng (bên phải)
                      children: [
                        // Tin nhắn người dùng
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 32.0), // Khoảng cách bên trái bằng độ dài của avatar bot (32 là kích thước avatar)
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(msg['text'] ?? ''),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Avatar người dùng nằm ở bên phải tin nhắn
                        CircleAvatar(
                          child: Icon(Icons.person, color: Colors.white),
                          backgroundColor: Colors.blue,
                        ),
                      ],
                    ),
                  );
                }
                else if (role == 'ai') {
                  // Tin nhắn bot (text)
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft, // Tin nhắn bot nằm bên trái
                      child: Row(
                        children: [
                          // Ảnh đại diện bot (icon tròn như người dùng)
                          const CircleAvatar(
                            child: Icon(Icons.support_agent, color: Colors.white), // Bot icon (chấm tròn)
                            backgroundColor: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 32.0), // Khoảng cách bên phải bằng độ dài của avatar người dùng
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(msg['text'] ?? ''),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                else if (role == 'ai_image') {
                  // Tin nhắn bot (ảnh)
                  final imageUrl = msg['url'] ?? '';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          width: MediaQuery.of(context).size.width * 0.7,  // Dùng MediaQuery để điều chỉnh kích thước
                          height: 200,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 100);
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink(); // Trường hợp không xác định
                }
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
