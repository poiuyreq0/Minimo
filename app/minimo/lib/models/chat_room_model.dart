import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:minimo/models/chat_message_model.dart';

part 'chat_room_model.freezed.dart';
part 'chat_room_model.g.dart';

@freezed
class ChatRoomModel with _$ChatRoomModel {
  const factory ChatRoomModel({
    required int id,
    required List<String> userNicknames,
    ChatMessageModel? lastMessage,
  }) = _ChatRoomModel;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => _$ChatRoomModelFromJson(json);
}