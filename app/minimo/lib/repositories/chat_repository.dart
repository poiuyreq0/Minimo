import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:minimo/models/read_chat_model.dart';
import 'package:minimo/utils/url_util.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/models/chat_room_model.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatRepository {
  final _dio = Dio();
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
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: _chatWebSocketUrl,
        onConnect: (frame) => _onConnect(frame, roomId, userId, updateChat, updateRead, updateReads),
        onDisconnect: _onDisconnect,
      ),
    );

    stompClient.activate();
  }

  void _onConnect(StompFrame frame, int roomId, int userId, Function(int, ChatMessageModel) updateChat, Function(ReadChatModel) updateRead, Function(int) updateReads) {
    stompClient.subscribe(
      destination: '/topic/room/$roomId',
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
        final otherUserId = frame.body;
        if (otherUserId != null) {
          final id = jsonDecode(otherUserId);
          if (userId != id) {
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
        '$_chatApiUrl/message/send',
        data: chatMessage.toJson(),
    );

    return resp.data['id'];
  }

  Future<void> readMessage({
    required ReadChatModel readChat,
  }) async {
    final resp = await _dio.post(
      '$_chatApiUrl/message/read',
      data: readChat.toJson(),
    );

    return resp.data['id'];
  }

  Future<List<ChatMessageModel>> readMessages({
    required int roomId,
    required int userId,
  }) async {
    final resp = await _dio.post(
      '$_chatApiUrl/room/$roomId',
      queryParameters: {
        'userId': userId,
      }
    );

    return resp.data.map<ChatMessageModel>(
        (message) => ChatMessageModel.fromJson(message)
    ).toList();
  }

  Future<int> checkChatRoomByUser({
    required int roomId,
    required int userId,
  }) async {
    final resp = await _dio.get(
      '$_chatApiUrl/room/$roomId/check',
      queryParameters: {
        'userId': userId,
      }
    );

    return resp.data['id'];
  }

  Future<List<ChatRoomModel>> getChatRoomsByUser({
    required int userId,
  }) async {
    final resp = await _dio.get(
      '$_chatApiUrl/room/user',
      queryParameters: {
        'userId': userId,
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
      '$_chatApiUrl/room/$roomId/disconnect',
      queryParameters: {
        'userId': userId,
      }
    );

    return resp.data['id'];
  }
}