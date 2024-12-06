import 'package:flutter/material.dart';
import 'package:minimo/components/chat_room_element_component.dart';
import 'package:minimo/components/letter_element_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/consts/letter_state.dart';
import 'package:minimo/consts/user_role.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/models/chat_room_model.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/models/user_role_model.dart';
import 'package:minimo/providers/chat_provider.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel user = context.read<UserProvider>().userCache!;

    return SingleChildScrollView(
      child: Column(
        children: [
          const Divider(
            height: 0,
            indent: 16,
            endIndent: 16,
          ),
          const SizedBox(height: 8,),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return FutureBuilder<void>(
                future: chatProvider.getChatRooms(userId: user.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (chatProvider.chatListScreenCache.isEmpty) {
                    return Text(
                      '아직 채팅방이 없습니다.',
                      style: Theme.of(context).textTheme.titleSmall,
                    );
                  } else {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: chatProvider.chatListScreenCache.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel chatRoom = chatProvider.chatListScreenCache[index];
                        final otherUserNickname = user.nickname != chatRoom.userNicknames[0] ? chatRoom.userNicknames[0] : chatRoom.userNicknames[1];
                        return ChatRoomElementComponent(otherUserNickname: otherUserNickname, chatMessage: chatRoom.lastMessage,);
                      },
                    );
                  }
                },
              );
            }
          ),
        ],
      ),
    );
  }
}
