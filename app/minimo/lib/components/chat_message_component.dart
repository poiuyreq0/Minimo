import 'package:flutter/material.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/time_stamp_util.dart';

import 'images/user_network_image_component.dart';

class ChatMessageComponent extends StatelessWidget {
  final int? otherUserId;
  final String otherUserNickname;
  final ChatMessageModel chatMessage;
  final bool isMine;
  final bool isShowFirst;
  final bool isShowTimeStamp;

  const ChatMessageComponent({
    required this.otherUserId,
    required this.otherUserNickname,
    required this.chatMessage,
    required this.isMine,
    required this.isShowFirst,
    required this.isShowTimeStamp,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isShowFirst ? const EdgeInsets.only(left: 8, right: 8, top: 4) : const EdgeInsets.symmetric(horizontal: 8.0),
      child: isMine ? _sentMessage(context) : _receivedMessage(context),
    );
  }

  Widget _sentMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!chatMessage.isRead)
              Text(
                '1',
                style: AppStyle.getLargeTextStyle(context, 10),
              ),
            if (isShowTimeStamp)
              Text(
                TimeStampUtil.getMessageTimeStamp(chatMessage.createdDate),
                style:AppStyle.getSmallTextStyle(context, 10),
              ),
          ],
        ),
        const SizedBox(width: 4),
        _content(context, true),
      ],
    );
  }

  Widget _receivedMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isShowFirst ? UserNetworkImageComponent(
              userId: otherUserId,
              size: 40,
              cache: true,
            ) : const SizedBox(
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isShowFirst)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      otherUserNickname,
                      style:AppStyle.getSmallTextStyle(context, 12),
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _content(context, false),
                    const SizedBox(width: 4),
                    if (isShowTimeStamp)
                      Text(
                        TimeStampUtil.getMessageTimeStamp(chatMessage.createdDate),
                        style:AppStyle.getSmallTextStyle(context, 10),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _content(BuildContext context, bool isMine) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12,),
      constraints: BoxConstraints(
        minHeight: 40,
        maxWidth: MediaQuery.sizeOf(context).width * 0.6,
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
        style: AppStyle.getMediumTextStyle(context, 15),
      ),
    );
  }
}
