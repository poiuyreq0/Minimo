import 'package:flutter/material.dart';
import 'package:minimo/components/bottom_text_form_component.dart';
import 'package:minimo/components/chat_message_component.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatefulWidget {
  final int id;

  const ChatRoomScreen({
    required this.id,
    super.key
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = context.read<ChatProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                debugPrint('asdf');
                FocusScope.of(context).unfocus();
              },
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Selector<ChatProvider, List<ChatMessageModel>?>(
                    selector: (context, chatProvider) => chatProvider.chatRoomsCache[widget.id],
                    builder: (BuildContext context, chatMessages, Widget? child) {
                      return ListView.separated(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: chatMessages != null ? chatMessages.length : 0,
                        itemBuilder: (context, index) {
                          return ChatMessageComponent(
                            chatMessage: chatMessages![index],
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 8,),
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
            onPressed: () {

            },
          ),
        ],
      ),
    );
  }

  // Future<void> onFieldSubmitted() async {
  //   addMessage();
  //
  //   // 스크롤 위치를 맨 아래로 이동 시킴
  //   _scrollController.animateTo(
  //     0,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  //
  //   textEditingController.text = '';
  // }
}
