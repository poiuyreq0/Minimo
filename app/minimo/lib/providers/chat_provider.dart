import 'package:flutter/material.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/models/chat_room_model.dart';
import 'package:minimo/models/read_chat_model.dart';
import 'package:minimo/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository chatRepository;
  Map<int, List<ChatMessageModel>> chatMessagesCache = {};
  int? currentRoomIdCache;
  bool chatListScreenSelectorTrigger = true;
  bool chatRoomScreenSelectorTrigger = true;

  ChatProvider({
    required this.chatRepository,
  })  : super();

  // FutureBuilder
  Future<List<ChatMessageModel>> enterChatRoom({
    required int roomId,
    required int userId,
  }) async {
    await chatRepository.enterChatRoom(roomId: roomId, userId: userId, updateChat: _updateChat, updateRead: _updateRead, updateReads: _updateReads);
    final resp = await getMessagesByRoom(roomId: roomId, userId: userId);

    return resp;
  }

  void exitChatRoom({
    required int userId,
  }) {
    chatRepository.exitChatRoom();
    currentRoomIdCache = null;

    _refreshChatListScreenSelector();
  }

  // 웹소켓: 누군가가 보낸 메시지를 받았을 때
  void _updateChat(int userId, ChatMessageModel chatMessage) {
    if (userId != chatMessage.senderId) {
      _readMessage(readChat: ReadChatModel(roomId: chatMessage.roomId, messageId: chatMessage.id));
    }

    chatMessagesCache.update(
      chatMessage.roomId,
      (value) => [
        chatMessage,
        ...value,
      ]..sort((a, b) => b.createdDate.compareTo(a.createdDate),),
      ifAbsent: () => [chatMessage],
    );

    _refreshChatRoomScreenSelector();
  }

  // 웹소켓: 상대방이 채팅 메시지를 읽었을 때
  void _updateRead(ReadChatModel readChat) {
    chatMessagesCache.update(
      readChat.roomId,
      (value) {
        final index = value.indexWhere((message) => message.id == readChat.messageId);
        if (index != -1) {
          value[index] = value[index].copyWith(isRead: true);
        }

        return [
          ...value,
        ];
      }
    );

    _refreshChatRoomScreenSelector();
  }

  // 웹소켓: 상대방이 채팅방에 입장하여 메시지를 읽었을 때
  void _updateReads(int roomId) {
    chatMessagesCache.update(
        roomId,
        (value) {
          for (int i = 0; i < value.length; i++) {
            if (!value[i].isRead) {
              int j = i;
              while (j < value.length && !value[j].isRead) {
                value[j] = value[j].copyWith(isRead: true);
                j++;
              }
              break;
            }
          }

          return [
            ...value,
          ];
        }
    );

    _refreshChatRoomScreenSelector();
  }

  // 메시지 전송 버튼을 눌렀을 때
  Future<void> sendMessage({
    required ChatMessageModel chatMessage,
  }) async {
    await chatRepository.sendMessage(chatMessage: chatMessage);
  }

  // 메시지를 읽었다는 것을 상대방에게 알릴 때
  void _readMessage({
    required ReadChatModel readChat,
  }) async {
    await chatRepository.readMessage(readChat: readChat);
  }

  // 채팅방 입장 시 메시지 가져오기
  // 후에 페이징 구현 필요
  Future<List<ChatMessageModel>> getMessagesByRoom({
    required int roomId,
    required int userId,
  }) async {
    final resp = await chatRepository.readMessages(roomId: roomId, userId: userId);

    chatMessagesCache.update(
      roomId,
      (value) => [
        ...resp,
      ]..sort((a, b) => b.createdDate.compareTo(a.createdDate),),
      ifAbsent: () => [
        ...resp,
      ]..sort((a, b) => b.createdDate.compareTo(a.createdDate),),
    );

    return chatMessagesCache[roomId]!;
  }

  Future<int> checkChatRoomByUser({
    required int roomId,
    required int userId,
  }) async {
    final resp = await chatRepository.checkChatRoomByUser(roomId: roomId, userId: userId);

    return resp;
  }

  // FutureBuilder
  Future<List<ChatRoomModel>> getChatRoomsByUser({
    required userId,
  }) async {
    final resp = await chatRepository.getChatRoomsByUser(userId: userId);

    return resp;
  }

  Future<void> disconnectChatRoom({
    required int roomId,
    required int userId,
  }) async {
    await chatRepository.disconnectChatRoom(roomId: roomId, userId: userId,);
  }

  void refreshChatListScreen() {
    _refreshChatListScreenSelector();
  }

  void _refreshChatListScreenSelector() {
    chatListScreenSelectorTrigger = !chatListScreenSelectorTrigger;
    notifyListeners();
  }

  void _refreshChatRoomScreenSelector() {
    chatRoomScreenSelectorTrigger = !chatRoomScreenSelectorTrigger;
    notifyListeners();
  }

  void logout() {
    chatMessagesCache = {};
    currentRoomIdCache = null;
  }
}