import 'package:flutter/material.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/models/chat_room_model.dart';
import 'package:minimo/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository chatRepository;
  List<ChatRoomModel> chatListScreenCache = [];
  Map<int, List<ChatMessageModel>> chatRoomScreenCache = {};

  ChatProvider({
    required this.chatRepository,
  })  : super();

  Future<void> enterChatRoom({
    required int roomId,
    required int userId,
  }) async {
    await getMessages(roomId: roomId);
    chatRepository.enterChatRoom(roomId: roomId, userId: userId, updateCache: _updateCache);
  }

  void exitChatRoom() {
    chatRepository.exitChatRoom();
  }

  void sendMessage({
    required ChatMessageModel chatMessage,
  }) {
    chatRepository.sendMessage(chatMessage: chatMessage);
    _updateCache(chatMessage);
  }

  void _updateCache(ChatMessageModel chatMessage) {
    chatRoomScreenCache.update(
      chatMessage.roomId,
      (value) => [
        chatMessage,
        ...value,
      ]..sort((a, b) => b.timeStamp.compareTo(a.timeStamp),),
      ifAbsent: () => [chatMessage],
    );

    notifyListeners();
  }

  Future<void> getMessages({
    required int roomId,
  }) async {
    final resp = await chatRepository.getMessages(roomId: roomId);

    chatRoomScreenCache.update(
      roomId,
      (value) => [
        ...resp,
      ]..sort((a, b) => b.timeStamp.compareTo(a.timeStamp),),
      ifAbsent: () => [
        ...resp,
      ],
    );

    notifyListeners();
  }

  Future<int> getChatRoomIdByLetterId({
    required int letterId,
  }) async {
    final resp = await chatRepository.getChatRoomIdByLetterId(letterId: letterId);

    return resp;
  }

  Future<void> getChatRooms({
    required userId,
  }) async {
    debugPrint("getChatRooms before: $chatListScreenCache");

    final resp = await chatRepository.getChatRooms(userId: userId);

    chatListScreenCache = resp;

    debugPrint("getChatRooms: $chatListScreenCache");
  }
}