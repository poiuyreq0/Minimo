import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChatMessageComponent extends StatelessWidget {
  final ChatMessageModel chatMessage;
  final bool isShowTimeStamp;

  const ChatMessageComponent({
    required this.chatMessage,
    required this.isShowTimeStamp,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    int userId = context.read<UserProvider>().userCache!.id;

    return userId == chatMessage.senderId ? sentMessage(context) : receivedMessage(context);
  }

  Widget sentMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isShowTimeStamp)
            Text(
              DateFormat('HH:mm').format(chatMessage.timeStamp),
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 10,
              ),
            ),
          const SizedBox(width: 8,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12,),
            constraints: BoxConstraints(
              minHeight: 40,
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(2),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              chatMessage.content,
              style:  Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget receivedMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12,),
            constraints: BoxConstraints(
              minHeight: 40,
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              chatMessage.content,
              style:  Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8,),
          if (isShowTimeStamp)
            Text(
              DateFormat('HH:mm').format(chatMessage.timeStamp),
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }
}
