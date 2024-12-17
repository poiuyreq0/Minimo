import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimo/components/bottom_text_form_component.dart';
import 'package:minimo/components/chat_message_component.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/providers/chat_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/utils/dialog_util.dart';
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
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == '나가기') {
                  DialogUtil.showCustomDialog(
                    context: context,
                    content: '채팅방을 나가면 다시 들어올 수 없습니다.\n정말 나가시겠습니까?',
                    positiveText: '나가기',
                    onPositivePressed: () {
                      try {
                        chatProvider.disconnectChatRoom(roomId: widget.id, userId: widget.userId);

                        Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                        );
                        SnackBarUtil.showCustomSnackBar(context, '채팅방을 나갔습니다.');

                      } catch (e) {
                        SnackBarUtil.showCommonErrorSnackBar(context);
                      }
                    },
                    negativeText: '취소',
                    onNegativePressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem<String>(
                    value: '나가기',
                    child: Text(
                      '나가기',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: FutureBuilder<List<ChatMessageModel>>(
          future: chatProvider.enterChatRoom(roomId: widget.id, userId: widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
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
                          child: Consumer<ChatProvider>(
                            builder: (BuildContext context, chatProvider, Widget? child) {
                              final chatMessages = chatProvider.chatMessagesByChatRoomCache[widget.id]!;

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
      isRead: false,  // 임시 isRead
      createdDate: DateTime.now(),
    );

    try {
      await chatProvider.sendMessage(chatMessage: chatMessage);
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
