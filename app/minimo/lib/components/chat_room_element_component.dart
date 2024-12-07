import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimo/consts/user_role.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/models/chat_room_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/chat/chat_room_screen.dart';
import 'package:minimo/screens/home/letter_box/letter_detail_screen.dart';
import 'package:provider/provider.dart';

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
    final userNickname = context.read<UserProvider>().userCache!.nickname;
    final otherUserNickname = userNickname != chatRoom.userNicknames[0] ? chatRoom.userNicknames[0] : chatRoom.userNicknames[1];

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 64,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChatRoomScreen(id: chatRoom.id, userId: userId, otherUserNickname: otherUserNickname,),),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Row(
            children: [
              Expanded(
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
                    Builder(
                      builder: (context) {
                        late String result;
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
                      }
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (chatRoom.lastMessage != null)
                    Builder(
                      builder: (context) {
                        final current = DateTime.now();
                        final messageCreatedDate = chatRoom.lastMessage!.createdDate;
                        late String result;
                        if (current.year == messageCreatedDate.year && current.month == messageCreatedDate.month && current.day == messageCreatedDate.day) {
                          result = DateFormat('a hh:mm', 'ko_KR').format(messageCreatedDate);
                        } else if (current.year == messageCreatedDate.year && current.month == messageCreatedDate.month && current.day-1 == messageCreatedDate.day) {
                          result = '어제';
                        } else if (current.year == messageCreatedDate.year) {
                          result = DateFormat('M월 d일').format(messageCreatedDate);
                        } else {
                          result = DateFormat('yyyy-MM-dd').format(messageCreatedDate);
                        }

                        return Text(
                          result,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.displaySmall,
                        );
                      }
                    ),
                  // 안 읽은 메시지 개수 추가
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
