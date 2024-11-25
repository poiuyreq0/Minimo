import 'package:flutter/material.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository chatRepository;

  Map<int, List<ChatMessageModel>> chatRoomsCache = {};

  ChatProvider({
    required this.chatRepository,
  })  : super();

  // Future<List<ChatMessageModel>> getChatMessages({
  //   required int id,
  // }) async {
  //   final resp = await chatRepository.getChatMessages(id: id);
  //
  //   _chatMessagesCache.update(
  //     id,
  //     (value) => [
  //       ...value,
  //
  //     ],
  //   );
  //
  //   return _chatMessagesCache[id];
  // }
}