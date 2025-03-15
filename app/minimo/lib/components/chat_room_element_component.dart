import 'package:flutter/material.dart';
import 'package:minimo/components/images/user_network_image_component.dart';
import 'package:minimo/models/chat_room_model.dart';
import 'package:minimo/models/chat_room_user_model.dart';
import 'package:minimo/screens/chat/chat_room_screen.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/time_stamp_util.dart';
import 'package:tuple/tuple.dart';

class ChatRoomElementComponent extends StatelessWidget {
  final ChatRoomModel chatRoom;
  final int userId;

  const ChatRoomElementComponent({
    required this.chatRoom,
    required this.userId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final otherUser = _getOtherUser(chatRoom.userNicknames);
    final otherUserId = otherUser.item1;
    final otherUserNickname = otherUser.item2;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ChatRoomScreen(roomId: chatRoom.id, userId: userId, otherUserId: otherUserId, otherUserNickname: otherUserNickname ?? '(알 수 없음)',),),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            UserNetworkImageComponent(
              userId: otherUserId,
              size: 55,
              cache: false,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    otherUserNickname ?? '(알 수 없음)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.getLargeTextStyle(context, 16),
                  ),
                  const SizedBox(height: 5),
                  Builder(
                    builder: (context) {
                      late final String result;
                      if (chatRoom.lastMessage == null) {
                        result = '(대화 없음)';
                      } else {
                        result = chatRoom.lastMessage!.content;
                      }

                      return Text(
                        result,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.getMediumTextStyle(context, 14),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Builder(
                  builder: (context) {
                    late final String result;

                    if (chatRoom.lastMessage == null) {
                      result = TimeStampUtil.getElementTimeStamp(chatRoom.createdDate);
                    } else {
                      result = TimeStampUtil.getElementTimeStamp(chatRoom.lastMessage!.createdDate);
                    }

                    return Text(
                      result,
                      maxLines: 1,
                      style:AppStyle.getSmallTextStyle(context, 12),
                    );
                  },
                ),
                const SizedBox(
                  height: 4,
                ),
                if (chatRoom.readNum != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${chatRoom.readNum}',
                      maxLines: 1,
                      style:AppStyle.getSmallTextStyle(context, 12).copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Tuple2<int?, String?> _getOtherUser(List<ChatRoomUserModel> userNicknameModels) {
    if (userNicknameModels.length == 1) {
      return const Tuple2(null, null);
    }

    final otherNicknameModel = userId == userNicknameModels[0].id ? userNicknameModels[1] : userNicknameModels[0];
    return  Tuple2(otherNicknameModel.id, otherNicknameModel.nickname);
  }
}
