import 'package:flutter/material.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/models/chat_room_model.dart';
import 'package:minimo/models/read_chat_model.dart';
import 'package:minimo/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository chatRepository;

  List<ChatRoomModel> chatRoomsCache = [];
  Map<int, List<ChatMessageModel>> chatMessagesCache = {};
  int? currentRoomIdCache;

  bool chatListScreenNewChatRoomsSelectorTrigger = true;
  bool chatListScreenPreviousChatRoomsSelectorTrigger = true;
  bool chatRoomScreenSelectorTrigger = true;

  ChatProvider({
    required this.chatRepository,
  })  : super();

  Future<List<ChatMessageModel>> enterChatRoom({
    required int roomId,
    required int userId,
    required int count,
  }) async {
    currentRoomIdCache = roomId;

    await chatRepository.enterChatRoom(roomId: roomId, userId: userId, updateChat: _updateChat, updateRead: _updateRead, updateReads: _updateReads);
    final resp = await getMessagesByRoomWithPaging(roomId: roomId, userId: userId, count: count, isFirst: true);

    return resp;
  }

  void exitChatRoom() {
    chatRepository.exitChatRoom();
    currentRoomIdCache = null;

    _refreshChatListScreenNewChatRoomsSelector();
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

  Future<List<ChatMessageModel>> getMessagesByRoomWithPaging({
    required int roomId,
    required int userId,
    required int count,
    required bool isFirst,
  }) async {
    DateTime? lastDate;
    if (isFirst) {
      lastDate = null;
    } else {
      if (chatMessagesCache[roomId]!.isEmpty) {
        lastDate = DateTime.now();
      } else {
        lastDate = chatMessagesCache[roomId]!.last.createdDate;
      }
    }

    final resp = await chatRepository.getMessagesByRoom(roomId: roomId, userId: userId, count: count, lastDate: lastDate);
    if (isFirst) {
      chatMessagesCache.update(
        roomId,
            (value) => resp,
        ifAbsent: () => resp,
      );
    } else {
      chatMessagesCache.update(
        roomId,
        (value) => [
          ...value,
          ...resp,
        ],
      );
      _refreshChatRoomScreenSelector();
    }

    return chatMessagesCache[roomId]!;
  }

  Future<List<ChatRoomModel>> getChatRoomsByUserWithPaging({
    required int userId,
    required int count,
    required bool isFirst,
  }) async {
    DateTime? lastDate;
    if (isFirst) {
      lastDate = null;
    } else {
      if (chatRoomsCache.isEmpty) {
        lastDate = DateTime.now();
      } else {
        lastDate = chatRoomsCache.last.lastMessage?.createdDate ?? chatRoomsCache.last.createdDate;
      }
    }

    final resp = await chatRepository.getChatRoomsByUserWithPaging(userId: userId, count: count, lastDate: lastDate);
    if (isFirst) {
      chatRoomsCache = resp;
    } else {
      chatRoomsCache.addAll(resp);
      _refreshChatListScreenPreviousChatRoomsSelector();
    }

    return chatRoomsCache;
  }

  Future<void> disconnectChatRoom({
    required int roomId,
    required int userId,
  }) async {
    await chatRepository.disconnectChatRoom(roomId: roomId, userId: userId,);
  }

  void refreshChatListScreenNewChatRooms() {
    _refreshChatListScreenNewChatRoomsSelector();
  }

  void _refreshChatListScreenNewChatRoomsSelector() {
    chatListScreenNewChatRoomsSelectorTrigger = !chatListScreenNewChatRoomsSelectorTrigger;
    notifyListeners();
  }

  void _refreshChatListScreenPreviousChatRoomsSelector() {
    chatListScreenPreviousChatRoomsSelectorTrigger = !chatListScreenPreviousChatRoomsSelectorTrigger;
    notifyListeners();
  }

  void _refreshChatRoomScreenSelector() {
    chatRoomScreenSelectorTrigger = !chatRoomScreenSelectorTrigger;
    notifyListeners();
  }

  void cleanCache() {
    chatRoomsCache = [];
    chatMessagesCache = {};
    currentRoomIdCache = null;
  }
}