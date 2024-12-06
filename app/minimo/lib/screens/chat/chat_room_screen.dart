import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimo/components/bottom_text_form_component.dart';
import 'package:minimo/components/chat_message_component.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/providers/chat_provider.dart';
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
  late final TextEditingController _textEditingController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController(text: '',);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
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
        body: FutureBuilder<void>(
          future: chatProvider.enterChatRoom(roomId: widget.id, userId: widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
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
                          child: Selector<ChatProvider, List<ChatMessageModel>?>(
                            selector: (context, chatProvider) => chatProvider.chatRoomScreenCache[widget.id],
                            builder: (BuildContext context, chatMessages, Widget? child) {
                              return ListView.separated(
                                reverse: true,
                                shrinkWrap: true,
                                itemCount: chatMessages != null ? chatMessages.length : 0,
                                itemBuilder: (context, index) {
                                  late final bool isShowTimeStamp;
                                  if (index > 0) {
                                    isShowTimeStamp = !(DateFormat('yyyy-MM-dd HH:mm').format(chatMessages![index].timeStamp) ==
                                        DateFormat('yyyy-MM-dd HH:mm').format(chatMessages[index-1].timeStamp));
                                  } else {
                                    isShowTimeStamp = true;
                                  }
                                  return Column(
                                    children: [
                                      if (index == chatMessages!.length - 1)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            DateFormat('yyyy년 M월 d일 EEEE', 'ko_KR').format(chatMessages[index].timeStamp),
                                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ChatMessageComponent(
                                          chatMessage: chatMessages[index],
                                          isShowTimeStamp: isShowTimeStamp
                                      ),
                                      if (index == 0 || isShowTimeStamp)
                                        const SizedBox(height: 8,),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  late final bool isSameTime;
                                  if (index < chatMessages!.length - 1) {
                                    isSameTime = DateFormat('yyyy-MM-dd').format(chatMessages[index].timeStamp) ==
                                        DateFormat('yyyy-MM-dd').format(chatMessages[index+1].timeStamp);
                                  } else {
                                    isSameTime = false;
                                  }
                                  if (!isSameTime) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          DateFormat('yyyy년 M월 d일 EEEE', 'ko_KR').format(chatMessages[index].timeStamp),
                                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox(height: 4,);
                                  }
                                },
                                controller: _scrollController,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  BottomTextFormComponent(
                    hintText: '메시지 입력',
                    controller: _textEditingController,
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
      content: _textEditingController.text,
      timeStamp: DateTime.now(),
    );

    try {
      chatProvider.sendMessage(chatMessage: chatMessage);
      _textEditingController.text = '';

      // 스크롤 위치를 맨 아래로 이동
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('요청 처리 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.'),
          )
      );
    }
  }
}
