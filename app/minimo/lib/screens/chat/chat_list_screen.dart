import 'package:flutter/material.dart';
import 'package:minimo/components/ads/banner_ad_component.dart';
import 'package:minimo/components/chat_room_element_component.dart';
import 'package:minimo/models/chat_room_model.dart';
import 'package:minimo/providers/chat_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = context.read<ChatProvider>();
    final userId = context.read<UserProvider>().userCache!.id;

    return NotificationListener(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          if (scrollNotification.metrics.pixels >= scrollNotification.metrics.maxScrollExtent) {
            chatProvider.getChatRoomsByUserWithPaging(userId: userId, count: 20, isFirst: false);
          }
        }
        return false;
      },
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 8),
              BannerAdComponent(
                padding: 16,
              ),
              const SizedBox(height: 16),
              Selector<ChatProvider, bool>(
                selector: (context, chatProvider) => chatProvider.chatListScreenNewChatRoomsSelectorTrigger,
                builder: (context, _, child) {
                  return FutureBuilder<List<ChatRoomModel>>(
                    future: chatProvider.getChatRoomsByUserWithPaging(userId: userId, count: 20, isFirst: true),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      } else if (snapshot.data!.isEmpty) {
                        return Text(
                          '아직 채팅방이 없습니다.',
                          style: AppStyle.getHintTextStyle(context),
                        );
                      } else {
                        return Selector<ChatProvider, bool>(
                          selector: (context, chatProvider) => chatProvider.chatListScreenPreviousChatRoomsSelectorTrigger,
                          builder: (context, _, child) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return ChatRoomElementComponent(chatRoom: snapshot.data![index], userId: userId);
                              },
                            );
                          }
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
