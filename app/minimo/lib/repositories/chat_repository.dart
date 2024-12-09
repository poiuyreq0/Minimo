import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/models/chat_room_model.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatRepository {
  final _dio = Dio();
  late StompClient stompClient;
  // final _targetUrl = 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:8080';
  final _targetUrl = 'http://192.168.0.7:8080';

  Future<void> enterChatRoom({
    required int roomId,
    required int userId,
    required Function(ChatMessageModel) updateMessage,
  }) async {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: '$_targetUrl/ws-chat',
        onConnect: (frame) => _onConnect(frame, roomId, userId, updateMessage),
        onDisconnect: _onDisconnect,
      ),
    );

    stompClient.activate();
  }

  void _onConnect(StompFrame frame, int roomId, int userId, Function(ChatMessageModel) updateCache) {
    stompClient.subscribe(
      destination: '/topic/room/$roomId',
      callback: (frame) {
        final message = frame.body;
        if (message != null) {
          final chatMessage = ChatMessageModel.fromJson(jsonDecode(message));
          if (userId != chatMessage.senderId) {
            updateCache(chatMessage);
          }
        }
      },
    );
  }

  void _onDisconnect(StompFrame frame) {
    debugPrint('_onWebSocketDisconnect: 연결 해제');
  }

  void exitChatRoom() {
    stompClient.deactivate();
  }

  void sendMessage({
    required ChatMessageModel chatMessage,
  }) {
    stompClient.send(
      destination: '/app/chat/send',
      body: jsonEncode(chatMessage.toJson()),
    );
  }

  Future<List<ChatMessageModel>> getMessages({
    required int roomId,
  }) async {
    final resp = await _dio.get(
      '$_targetUrl/api/chat/room/$roomId',
    );

    return resp.data.map<ChatMessageModel>(
            (message) => ChatMessageModel.fromJson(message)
    ).toList();
  }

  Future<int> getChatRoomIdByLetterId({
    required int letterId,
  }) async {
    final resp = await _dio.get(
      '$_targetUrl/api/chat/room/letter',
      queryParameters: {
        'letterId': letterId,
      }
    );

    return resp.data['id'];
  }

  Future<List<ChatRoomModel>> getChatRooms({
    required int userId,
  }) async {
    final resp = await _dio.get(
      '$_targetUrl/api/chat/rooms',
      queryParameters: {
        'userId': userId,
      }
    );

    return resp.data.map<ChatRoomModel>(
        (chatRoom) => ChatRoomModel.fromJson(chatRoom)
    ).toList();
  }
}