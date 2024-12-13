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

  Future<List<ChatMessageModel>> enterChatRoom({
    required int roomId,
    required int userId,
  }) async {
    await chatRepository.enterChatRoom(roomId: roomId, userId: userId, updateMessage: _updateMessage);
    final messages = await getMessages(roomId: roomId);
    return messages;
  }

  void exitChatRoom() {
    chatRepository.exitChatRoom();
  }

  void _updateMessage(ChatMessageModel chatMessage) {
    chatRoomScreenCache.update(
      chatMessage.roomId,
          (value) => [
        chatMessage,
        ...value,
      ]..sort((a, b) => b.createdDate.compareTo(a.createdDate),),
      ifAbsent: () => [chatMessage],
    );

    notifyListeners();
  }

  Future<List<ChatMessageModel>> getMessages({
    required int roomId,
  }) async {
    final resp = await chatRepository.getMessages(roomId: roomId);

    chatRoomScreenCache.update(
      roomId,
      (value) => [
        ...resp,
      ]..sort((a, b) => b.createdDate.compareTo(a.createdDate),),
      ifAbsent: () => [
        ...resp,
      ]..sort((a, b) => b.createdDate.compareTo(a.createdDate),),
    );

    return chatRoomScreenCache[roomId]!;
  }

  Future<int> getChatRoomIdByLetterId({
    required int letterId,
  }) async {
    final resp = await chatRepository.getChatRoomIdByLetterId(letterId: letterId);

    return resp;
  }

  Future<List<ChatRoomModel>> getChatRooms({
    required userId,
  }) async {
    final resp = await chatRepository.getChatRooms(userId: userId);
    chatListScreenCache = resp;

    return chatListScreenCache;
  }

  void sendMessage({
    required ChatMessageModel chatMessage,
  }) {
    chatRepository.sendMessage(chatMessage: chatMessage);
    _updateMessage(chatMessage);
  }
}