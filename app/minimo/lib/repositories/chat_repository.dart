import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimo/models/read_chat_model.dart';
import 'package:minimo/utils/date_picker_util.dart';
import 'package:minimo/utils/dio_util.dart';
import 'package:minimo/utils/url_util.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/models/chat_room_model.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatRepository {
  final _auth = FirebaseAuth.instance;
  final _dio = DioUtil.getDio();
  late StompClient stompClient;
  final _chatWebSocketUrl = UrlUtil.chatWebSocket;
  final _chatApiUrl = UrlUtil.chatApi;

  Future<void> enterChatRoom({
    required int roomId,
    required int userId,
    required Function(int, ChatMessageModel) updateChat,
    required Function(ReadChatModel) updateRead,
    required Function(int) updateReads,
  }) async {
    String? jwt = await _auth.currentUser!.getIdToken();

    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: _chatWebSocketUrl,
        stompConnectHeaders: {
          'Authorization': 'Bearer $jwt',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $jwt',
        },
        onConnect: (frame) => _onConnect(frame, roomId, userId, updateChat, updateRead, updateReads),
        onDisconnect: _onDisconnect,
      ),
    );

    stompClient.activate();
  }

  void _onConnect(StompFrame frame, int roomId, int userId, Function(int, ChatMessageModel) updateChat, Function(ReadChatModel) updateRead, Function(int) updateReads) {
    stompClient.subscribe(
      destination: '/topic/room/$roomId/send',
      callback: (frame) {
        final message = frame.body;
        if (message != null) {
          final chatMessage = ChatMessageModel.fromJson(jsonDecode(message));
          updateChat(userId, chatMessage);
        }
      },
    );
    stompClient.subscribe(
      destination: '/topic/room/$roomId/read',
      callback: (frame) {
        final readChat = frame.body;
        if (readChat != null) {
          final readChatModel = ReadChatModel.fromJson(jsonDecode(readChat));
          updateRead(readChatModel);
        }
      },
    );
    stompClient.subscribe(
      destination: '/topic/room/$roomId/enter',
      callback: (frame) {
        final id = frame.body;
        if (id != null) {
          final otherUserId = jsonDecode(id);
          if (userId != otherUserId) {
            updateReads(roomId);
          }
        }
      },
    );

    debugPrint('StompClient onConnect: 연결');
  }

  void _onDisconnect(StompFrame frame) {
    debugPrint('StompClient onDisconnect: 연결 해제');
  }

  void exitChatRoom() {
    stompClient.deactivate();
  }

  Future<int> sendMessage({
    required ChatMessageModel chatMessage,
  }) async {
    final resp = await _dio.post(
        '$_chatApiUrl/messages',
        data: chatMessage.toJson(),
    );

    return resp.data['messageId'];
  }

  Future<int> readMessage({
    required ReadChatModel readChat,
  }) async {
    final resp = await _dio.post(
      '$_chatApiUrl/messages/read',
      data: readChat.toJson(),
    );

    return resp.data['messageId'];
  }

  Future<List<ChatMessageModel>> getMessagesByRoom({
    required int roomId,
    required int userId,
    required int count,
    required DateTime? lastDate,
  }) async {
    final resp = await _dio.post(
      '$_chatApiUrl/rooms/$roomId/messages',
      queryParameters: {
        'userId': userId,
        'count': count,
        if (lastDate != null)
          'lastDate': lastDate.toIso8601String(),
      }
    );

    return resp.data.map<ChatMessageModel>(
        (message) => ChatMessageModel.fromJson(message)
    ).toList();
  }

  Future<List<ChatRoomModel>> getChatRoomsByUserWithPaging({
    required int userId,
    required int count,
    required DateTime? lastDate,
  }) async {
    final resp = await _dio.get(
      '$_chatApiUrl/rooms/user',
      queryParameters: {
        'userId': userId,
        'count': count,
        if (lastDate != null)
          'lastDate': lastDate.toIso8601String(),
      }
    );

    return resp.data.map<ChatRoomModel>(
        (chatRoom) => ChatRoomModel.fromJson(chatRoom)
    ).toList();
  }

  Future<int> disconnectChatRoom({
    required int roomId,
    required int userId,
  }) async {
    final resp = await _dio.post(
      '$_chatApiUrl/rooms/$roomId/disconnect',
      queryParameters: {
        'userId': userId,
      }
    );

    return resp.data['roomId'];
  }
}