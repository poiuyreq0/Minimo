import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimo/components/user_network_image_component.dart';
import 'package:minimo/enums/user_role.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/utils/time_stamp_util.dart';
import 'package:provider/provider.dart';

class ChatMessageComponent extends StatelessWidget {
  final String otherUserNickname;
  final ChatMessageModel chatMessage;
  final bool isMine;
  final bool isShowFirst;
  final bool isShowTimeStamp;

  const ChatMessageComponent({
    required this.otherUserNickname,
    required this.chatMessage,
    required this.isMine,
    required this.isShowFirst,
    required this.isShowTimeStamp,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return isMine ? sentMessage(context) : receivedMessage(context, chatMessage.senderId);
  }

  Widget sentMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isShowTimeStamp)
            Text(
              TimeStampUtil.getMessageTimeStamp(chatMessage.createdDate),
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 10,
              ),
            ),
          const SizedBox(width: 4),
          content(context, true),
        ],
      ),
    );
  }

  Widget receivedMessage(BuildContext context, int otherUserId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isShowFirst ? UserNetworkImageComponent(
                userId: otherUserId,
                size: 36,
              ) : SizedBox(
                width: 36,
                height: 36,
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isShowFirst)
                    Text(
                      ' $otherUserNickname',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      content(context, false),
                      const SizedBox(width: 4),
                      if (isShowTimeStamp)
                        Text(
                          TimeStampUtil.getMessageTimeStamp(chatMessage.createdDate),
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget content(BuildContext context, bool isMine) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12,),
      constraints: BoxConstraints(
        minHeight: 40,
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: isShowFirst == true ? BorderRadius.only(
          topLeft: (isMine == true) ? const Radius.circular(20) : const Radius.circular(2),
          topRight: (isMine == true) ? const Radius.circular(2) : const Radius.circular(20),
          bottomLeft: const Radius.circular(20),
          bottomRight: const Radius.circular(20),
        ) : const BorderRadius.all(
          Radius.circular(20)
        ),
      ),
      child: Text(
        chatMessage.content,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
          fontSize: 15,
        ),
      ),
    );
  }
}
