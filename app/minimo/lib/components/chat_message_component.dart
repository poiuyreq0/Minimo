import 'package:flutter/material.dart';
import 'package:minimo/models/chat_message_model.dart';

class ChatMessageComponent extends StatelessWidget {
  final ChatMessageModel chatMessage;

  const ChatMessageComponent({
    required this.chatMessage,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
