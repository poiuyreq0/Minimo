import 'package:flutter/material.dart';
import 'package:minimo/consts/user_role.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/screens/home/letter_box/letter_detail_screen.dart';

class ChatRoomElementComponent extends StatelessWidget {
  final String otherUserNickname;
  final ChatMessageModel? chatMessage;

  const ChatRoomElementComponent({
    required this.otherUserNickname,
    this.chatMessage,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              otherUserNickname,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 2,),
            if (chatMessage != null)
              Text(
                chatMessage!.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.displayMedium,
              ),
          ],
        ),
      ),
    );
  }
}
