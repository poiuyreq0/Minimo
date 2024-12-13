import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimo/components/bottom_text_form_component.dart';
import 'package:minimo/components/chat_message_component.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/providers/chat_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:minimo/utils/time_stamp_util.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatefulWidget {
  final int id;
  final int userId;
  final String otherUserNickname;

  const ChatRoomScreen({
    required this.id,
    required this.userId,
    required this.otherUserNickname,
    super.key
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late final TextEditingController textEditingController;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController(text: '',);
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = context.read<ChatProvider>();

    return PopScope(
      onPopInvoked: (didPop) {
        chatProvider.exitChatRoom();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(widget.otherUserNickname),
        ),
        body: FutureBuilder<List<ChatMessageModel>>(
          future: chatProvider.enterChatRoom(roomId: widget.id, userId: widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Selector<ChatProvider, List<ChatMessageModel>>(
                            selector: (context, chatProvider) => chatProvider.chatRoomScreenCache[widget.id]!,
                            builder: (BuildContext context, chatMessages, Widget? child) {
                              return ListView.separated(
                                reverse: true,
                                shrinkWrap: true,
                                itemCount: chatMessages.length,
                                itemBuilder: (context, index) {
                                  final userId = context.read<UserProvider>().userCache!.id;
                                  final isMine = userId == chatMessages[index].senderId;

                                  late final bool isShowTimeStamp;
                                  if (index == 0) {
                                    isShowTimeStamp = true;
                                  } else {
                                    final isSameNextMinute = TimeStampUtil.isSameMinute(chatMessages[index].createdDate, chatMessages[index-1].createdDate);
                                    final isSameNextUser = chatMessages[index].senderId == chatMessages[index-1].senderId;
                                    if (!isSameNextMinute) {
                                      isShowTimeStamp = true;
                                    } else if (!isSameNextUser) {
                                      isShowTimeStamp = true;
                                    } else {
                                      isShowTimeStamp = false;
                                    }
                                  }

                                  late final bool isShowFirst;
                                  if (index == chatMessages.length - 1) {
                                    isShowFirst = true;
                                  } else {
                                    final isSamePreviousMinute = TimeStampUtil.isSameMinute(chatMessages[index].createdDate, chatMessages[index+1].createdDate);
                                    final isSamePreviousUser = chatMessages[index].senderId == chatMessages[index+1].senderId;
                                    if (!isSamePreviousMinute) {
                                      isShowFirst = true;
                                    } else if (!isSamePreviousUser) {
                                      isShowFirst = true;
                                    } else {
                                      isShowFirst = false;
                                    }
                                  }

                                  return Column(
                                    children: [
                                      if (index == chatMessages.length - 1)
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                            TimeStampUtil.getRoomTimeStamp(chatMessages[index].createdDate),
                                            style: Theme.of(context).textTheme.displaySmall,
                                          ),
                                        ),
                                      ChatMessageComponent(
                                        otherUserNickname: widget.otherUserNickname,
                                        chatMessage: chatMessages[index],
                                        isMine: isMine,
                                        isShowFirst: isShowFirst,
                                        isShowTimeStamp: isShowTimeStamp,
                                      ),
                                      if (index == 0)
                                        const SizedBox(height: 6),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  late final bool isSameDay;
                                  if (index < chatMessages.length - 1) {
                                    isSameDay = TimeStampUtil.isSameDay(chatMessages[index].createdDate, chatMessages[index+1].createdDate);
                                  } else {
                                    isSameDay = false;
                                  }
                                  if (!isSameDay) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Center(
                                        child: Text(
                                          TimeStampUtil.getRoomTimeStamp(chatMessages[index].createdDate),
                                          style: Theme.of(context).textTheme.displaySmall,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox(height: 6);
                                  }
                                },
                                controller: scrollController,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  BottomTextFormComponent(
                    hintText: '메시지 입력',
                    controller: textEditingController,
                    onPressed: () {
                      onSendPressed(context);
                    },
                  ),
                ],
              );
            }
          }
        ),
      ),
    );
  }

  Future<void> onSendPressed(BuildContext context) async {
    ChatProvider chatProvider = context.read<ChatProvider>();

    final chatMessage = ChatMessageModel(
      id: 0,  // 임시 Id
      roomId: widget.id,
      senderId: widget.userId,
      content: textEditingController.text,
      createdDate: DateTime.now(),
    );

    try {
      chatProvider.sendMessage(chatMessage: chatMessage);
      textEditingController.text = '';

      // 스크롤 위치를 맨 아래로 이동
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

    } catch (e) {
      SnackBarUtil.showCommonErrorSnackBar(context);
    }
  }
}
