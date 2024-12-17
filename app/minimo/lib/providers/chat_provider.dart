import 'package:flutter/material.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/models/chat_room_model.dart';
import 'package:minimo/models/read_chat_model.dart';
import 'package:minimo/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository chatRepository;
  List<ChatRoomModel> chatRoomsCache = [];
  Map<int, List<ChatMessageModel>> chatMessagesByChatRoomCache = {};

  ChatProvider({
    required this.chatRepository,
  })  : super();

  Future<List<ChatMessageModel>> enterChatRoom({
    required int roomId,
    required int userId,
  }) async {
    await chatRepository.enterChatRoom(roomId: roomId, userId: userId, updateChat: _updateChat, updateRead: _updateRead, updateReads: _updateReads);
    final messages = await readMessages(roomId: roomId, userId: userId);
    return messages;
  }

  void exitChatRoom() {
    chatRepository.exitChatRoom();
  }

  // 상대방이 채팅 메시지를 보낼 시
  void _updateChat(int userId, ChatMessageModel chatMessage) {
    if (userId != chatMessage.senderId) {
      readMessage(readChat: ReadChatModel(roomId: chatMessage.roomId, messageId: chatMessage.id));
    }

    chatMessagesByChatRoomCache.update(
      chatMessage.roomId,
      (value) => [
        chatMessage,
        ...value,
      ]..sort((a, b) => b.createdDate.compareTo(a.createdDate),),
      ifAbsent: () => [chatMessage],
    );

    notifyListeners();
  }

  // 상대방이 채팅 메시지를 읽을 시
  void _updateRead(ReadChatModel readChat) {
    chatMessagesByChatRoomCache.update(
      readChat.roomId,
      (value) {
        final index = value.indexWhere((message) => message.id == readChat.messageId);
        if (index != -1) {
          value[index] = value[index].copyWith(isRead: true);
        }

        return value;
      }
    );

    notifyListeners();
  }

  // 상대방이 채팅방을 입장할 시
  void _updateReads(int roomId) {
    chatMessagesByChatRoomCache.update(
        roomId,
        (value) {
          for (int i = 0; i < value.length; i++) {
            if (!value[i].isRead) {
              int j = i;
              while (!value[j].isRead) {
                value[j] = value[j].copyWith(isRead: true);
                j++;
              }
              break;
            }
          }

          return value;
        }
    );

    notifyListeners();
  }

  Future<void> sendMessage({
    required ChatMessageModel chatMessage,
  }) async {
    await chatRepository.sendMessage(chatMessage: chatMessage);
  }

  void readMessage({
    required ReadChatModel readChat,
  }) async {
    await chatRepository.readMessage(readChat: readChat);
  }

  // 채팅방 입장 시 메시지 가져오기
  // 후에 페이징 구현 필요
  Future<List<ChatMessageModel>> readMessages({
    required int roomId,
    required int userId,
  }) async {
    final resp = await chatRepository.readMessages(roomId: roomId, userId: userId);

    chatMessagesByChatRoomCache.update(
      roomId,
      (value) => [
        ...resp,
      ]..sort((a, b) => b.createdDate.compareTo(a.createdDate),),
      ifAbsent: () => [
        ...resp,
      ]..sort((a, b) => b.createdDate.compareTo(a.createdDate),),
    );

    return chatMessagesByChatRoomCache[roomId]!;
  }

  Future<int> checkChatRoomByUser({
    required int roomId,
    required int userId,
  }) async {
    final resp = await chatRepository.checkChatRoomByUser(roomId: roomId, userId: userId);

    return resp;
  }

  Future<List<ChatRoomModel>> getChatRoomsByUser({
    required userId,
  }) async {
    final resp = await chatRepository.getChatRoomsByUser(userId: userId);
    chatRoomsCache = resp;

    return chatRoomsCache;
  }

  Future<void> disconnectChatRoom({
    required int roomId,
    required int userId,
  }) async {
    chatRepository.disconnectChatRoom(roomId: roomId, userId: userId,);

    notifyListeners();
  }
}