import 'package:flutter/material.dart';
import 'package:minimo/components/ads/banner_ad_component.dart';
import 'package:minimo/components/chat_room_element_component.dart';
import 'package:minimo/models/chat_room_model.dart';
import 'package:minimo/providers/chat_provider.dart';
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
    ChatProvider chatProvider = context.read<ChatProvider>();
    final userId = context.read<UserProvider>().userCache!.id;

    return SingleChildScrollView(
      child: Column(
        children: [
          // BannerAdComponent(
          //   padding: 16,
          // ),
          const SizedBox(height: 8),
          Selector<ChatProvider, bool>(
            selector: (context, chatProvider) => chatProvider.chatListScreenSelectorTrigger,
            builder: (context, _, child) {
              return FutureBuilder<List<ChatRoomModel>>(
                future: chatProvider.getChatRoomsByUser(userId: userId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return Text(
                      '아직 채팅방이 없습니다.',
                      style: Theme.of(context).textTheme.titleSmall,
                    );
                  } else {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ChatRoomElementComponent(chatRoom: snapshot.data![index], userId: userId);
                      },
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
