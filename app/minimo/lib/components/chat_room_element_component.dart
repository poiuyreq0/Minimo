import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimo/components/user_network_image_component.dart';
import 'package:minimo/models/chat_room_model.dart';
import 'package:minimo/models/user_nickname_model.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/chat/chat_room_screen.dart';
import 'package:minimo/utils/time_stamp_util.dart';
import 'package:provider/provider.dart';
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
    final otherUser = getOtherUser(chatRoom.userNicknames);
    final otherUserId = otherUser.item1;
    final otherUserNickname = otherUser.item2;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ChatRoomScreen(id: chatRoom.id, userId: userId, otherUserNickname: otherUserNickname ?? '(알 수 없음)',),),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            UserNetworkImageComponent(
              userId: otherUserId,
              size: 55,
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
                    style: Theme.of(context).textTheme.displayLarge,
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
                        style: Theme.of(context).textTheme.displayMedium,
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
                      style: Theme.of(context).textTheme.displaySmall,
                    );
                  },
                ),
                // 안 읽은 메시지 개수 추가
              ],
            ),
          ],
        ),
      ),
    );
  }

  Tuple2<int?, String?> getOtherUser(List<UserNicknameModel> userNicknames) {
    for (UserNicknameModel userNickname in userNicknames) {
      if (userId != userNickname.id) {
        return Tuple2(userNickname.id, userNickname.nickname);
      }
    }
    return const Tuple2(null, null);
  }
}
