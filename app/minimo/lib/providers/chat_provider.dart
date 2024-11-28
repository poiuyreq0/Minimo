import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/repositories/chat_repository.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository chatRepository;

  Map<int, List<ChatMessageModel>> chatRoomsCache = {};
  late StompClient stompClient;
  late StompFrame stompFrame;

  ChatProvider({
    required this.chatRepository,
  })  : super();

  Future<void> enterChatRoom({
    required int roomId,
    required int userId,
  }) async {
    // await getMessages(roomId: roomId);

    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:8080/ws-chat',
        onConnect: (frame) => _onWebSocketConnect(frame, roomId, userId),
        onDisconnect: _onWebSocketDisconnect,
      ),
    );

    stompClient.activate();
  }

  void _onWebSocketConnect(StompFrame frame, int roomId, int userId) {
    stompClient.subscribe(
      destination: '/topic/room/$roomId',
      callback: (frame) {
        final message = frame.body;
        if (message != null) {
          final chatMessage = ChatMessageModel.fromJson(jsonDecode(message));
          if (userId != chatMessage.senderId) {
            _updateCache(chatMessage);
          }
        }
      },
    );
  }

  void _updateCache(ChatMessageModel chatMessage) {
    chatRoomsCache.update(
      chatMessage.roomId,
      (value) => [
        chatMessage,
        ...value,
      ]..sort((a, b) => b.timeStamp.compareTo(a.timeStamp),),
      ifAbsent: () => [chatMessage],
    );

    notifyListeners();
  }

  void _onWebSocketDisconnect(StompFrame frame) {
    debugPrint('_onWebSocketDisconnect: 연결 해제');
  }

  void exitChatRoom() {
    stompClient.deactivate();
  }

  void sendMessage({
    required ChatMessageModel chatMessage,
  }) {
    stompClient.send(
      destination: '/app/chat/sendMessage',
      body: jsonEncode(chatMessage.toJson()),
    );
    _updateCache(chatMessage);

    notifyListeners();
  }

  // Future<void> getMessages({
  //   required int roomId,
  // }) async {
  //   final resp = await chatRepository.getMessages(roomId: roomId);
  //
  //   chatRoomsCache.update(
  //     roomId,
  //         (value) => [
  //       ...value,
  //       ...resp
  //     ]..sort((a, b) => b.timeStamp.compareTo(a.timeStamp),),
  //     ifAbsent: () => [
  //       ...resp,
  //     ],
  //   );
  //
  //   notifyListeners();
  // }
}