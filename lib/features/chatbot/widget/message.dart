import 'package:dacn1/models/productcard.dart';
import 'package:flutter/material.dart';

import 'product_card.dart';

abstract class BaseMessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isUser;

  const BaseMessageWidget({
    Key? key,
    required this.message,
    required this.isUser,
  }) : super(key: key);

  Widget buildMessageBubble(BuildContext context, {required Widget child}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isUser
                  ? const Color.fromARGB(255, 219, 217, 217)
                  : const Color.fromARGB(255, 76, 148, 154),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft:
                isUser ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight:
                isUser ? const Radius.circular(0) : const Radius.circular(12),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: child,
      ),
    );
  }
}

class UserMessageWidget extends BaseMessageWidget {
  const UserMessageWidget({Key? key, required Map<String, dynamic> message})
    : super(key: key, message: message, isUser: true);

  @override
  Widget build(BuildContext context) {
    return buildMessageBubble(
      context,
      child: Text(
        message['text'] ?? message['message'] ?? '',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

class BotTextMessageWidget extends BaseMessageWidget {
  const BotTextMessageWidget({Key? key, required Map<String, dynamic> message})
    : super(key: key, message: message, isUser: false);

  @override
  Widget build(BuildContext context) {
    return buildMessageBubble(
      context,
      child: Text(
        message['message'] ?? message['text'] ?? '',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class ProductListMessageWidget extends BaseMessageWidget {
  const ProductListMessageWidget({
    Key? key,
    required Map<String, dynamic> message,
  }) : super(key: key, message: message, isUser: false);

  @override
  Widget build(BuildContext context) {
    final productList = List<Map<String, dynamic>>.from(
      message['products'] ?? [],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message['message'] != null && message['message'].isNotEmpty)
          BotTextMessageWidget(message: {'message': message['message']}),
        if (productList.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 240, // Tăng chiều cao để phù hợp
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              itemBuilder: (context, index) {
                try {
                  final product = Productcard.fromMap(productList[index]);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ProductCard(product: product),
                  );
                } catch (e) {
                  return const SizedBox(
                    width: 160,
                    height: 220,
                    child: Center(child: Text('Invalid product')),
                  );
                }
              },
            ),
          ),
        ],
      ],
    );
  }
}

class SuggestionsMessageWidget extends BaseMessageWidget {
  final Function(String) onSuggestionSelected;

  const SuggestionsMessageWidget({
    Key? key,
    required Map<String, dynamic> message,
    required this.onSuggestionSelected,
  }) : super(key: key, message: message, isUser: false);

  @override
  Widget build(BuildContext context) {
    final suggestions = List<String>.from(message['suggestions'] ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BotTextMessageWidget(message: {'message': message['message'] ?? ''}),
        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                suggestions.map((suggestion) {
                  return ActionChip(
                    label: Text(suggestion),
                    backgroundColor: const Color.fromARGB(255, 253, 253, 253),
                    onPressed: () => onSuggestionSelected(suggestion),
                  );
                }).toList(),
          ),
        ],
      ],
    );
  }
}

class MessageWidgetFactory {
  static Widget create({
    required Map<String, dynamic> message,
    required Function(String) onSuggestionSelected,
    required BuildContext context,
  }) {
    final isUser = message['role'] == 'user';
    final type = (message['type'] ?? '').toString().toLowerCase();

    if (isUser) {
      return UserMessageWidget(message: message);
    }

    switch (type) {
      case 'products':
        if (message['products'] is List) {
          return ProductListMessageWidget(message: message);
        }
        break;
      case 'suggestions':
        if (message['suggestions'] is List) {
          return SuggestionsMessageWidget(
            message: message,
            onSuggestionSelected: onSuggestionSelected,
          );
        }
        break;
    }

    return BotTextMessageWidget(message: message);
  }
}
