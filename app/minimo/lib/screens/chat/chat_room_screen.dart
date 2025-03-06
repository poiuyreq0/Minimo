import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimo/components/bottom_text_form_component.dart';
import 'package:minimo/components/chat_message_component.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/providers/chat_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/dialog_util.dart';
import 'package:minimo/utils/notification_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:minimo/utils/time_stamp_util.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatefulWidget {
  final int roomId;
  final int userId;
  final int? otherUserId;
  final String otherUserNickname;

  const ChatRoomScreen({
    required this.roomId,
    required this.userId,
    required this.otherUserId,
    required this.otherUserNickname,
    super.key
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late final TextEditingController textEditingController;
  late final ScrollController scrollController;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    NotificationUtil.cancelNotification(widget.roomId, 'chat');

    textEditingController = TextEditingController(text: '',);
    scrollController = ScrollController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = context.read<ChatProvider>();

    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          chatProvider.exitChatRoom();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.otherUserNickname),
          actions: [
            PopupMenuButton<String>(
              padding: const EdgeInsets.all(16),
              onSelected: (value) {
                if (value == '나가기') {
                  DialogUtil.showCustomDialog(
                    context: context,
                    title: '채팅방 나가기',
                    content: '나간 채팅방은 다시 들어올 수 없습니다.\n정말 나가시겠습니까?',
                    positiveText: '나가기',
                    onPositivePressed: () async {
                      try {
                        await chatProvider.disconnectChatRoom(roomId: widget.roomId, userId: widget.userId);

                        Navigator.of(context).popUntil(
                          (route) => route.isFirst,
                        );
                        SnackBarUtil.showCustomSnackBar(context, '채팅방을 나갔습니다.');

                      } catch (e) {
                        Navigator.of(context).pop();
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
                      style: AppStyle.getLittleButtonTextStyle(context, isPositive: false),
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: FutureBuilder<List<ChatMessageModel>>(
          future: chatProvider.enterChatRoom(roomId: widget.roomId, userId: widget.userId, count: 50),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            } else if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                DialogUtil.showCustomDialog(
                  context: context,
                  title: '채팅방',
                  content: '사라진 채팅방입니다.',
                  negativeText: '닫기',
                  onNegativePressed: () {
                    Navigator.of(context)..pop()..pop();
                  },
                );
              });
              return const SizedBox.shrink();
            } else {
              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        focusNode.unfocus();
                      },
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification) {
                            if (scrollNotification.metrics.pixels >= scrollNotification.metrics.maxScrollExtent) {
                              chatProvider.getMessagesByRoomWithPaging(roomId: widget.roomId, userId: widget.userId, count: 50, isFirst: false);
                            }
                          }
                          return false;
                        },
                        child: Selector<ChatProvider, bool>(
                          selector: (context, chatProvider) => chatProvider.chatRoomScreenSelectorTrigger,
                          builder: (context, _, child) {
                            // createdDate 내림차순 리스트를 오름차순으로 바꿈으로써 최신 메시지를 뒤(아래)로 이동
                            final chatMessages = chatProvider.chatMessagesCache[widget.roomId]!..reversed.toList();

                            return Align(
                              alignment: Alignment.topCenter,
                              child: ListView.separated(
                                controller: scrollController,
                                reverse: true,  // 스크롤 방향만 변환
                                shrinkWrap: true,
                                itemCount: chatMessages.length,
                                itemBuilder: (context, index) {
                                  final isMine = widget.userId == chatMessages[index].senderId;

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
                                            style:AppStyle.getSmallTextStyle(context, 12),
                                          ),
                                        ),
                                      ChatMessageComponent(
                                        otherUserId: widget.otherUserId,
                                        otherUserNickname: widget.otherUserNickname,
                                        chatMessage: chatMessages[index],
                                        isMine: isMine,
                                        isShowFirst: isShowFirst,
                                        isShowTimeStamp: isShowTimeStamp,
                                      ),
                                      if (index == 0)
                                        const SizedBox(height: 10),
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
                                      padding: const EdgeInsets.only(left: 16, right: 16, top: 36, bottom: 16),
                                      child: Center(
                                        child: Text(
                                          TimeStampUtil.getRoomTimeStamp(chatMessages[index].createdDate),
                                          style:AppStyle.getSmallTextStyle(context, 12),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox(height: 6);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  BottomTextFormComponent(
                    focusNode: focusNode,
                    hintText: '메시지 입력',
                    controller: textEditingController,
                    onPressed: () {
                      _onSendPressed(context);
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

  Future<void> _onSendPressed(BuildContext context) async {
    ChatProvider chatProvider = context.read<ChatProvider>();

    final chatMessage = ChatMessageModel(
      id: 0,  // 임시 id
      roomId: widget.roomId,
      senderId: widget.userId,
      content: textEditingController.text,
      isRead: false,  // 임시 isRead
      createdDate: DateTime.now(),  // 임시 createdDate
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
