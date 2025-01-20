import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:minimo/models/chat_message_model.dart';
import 'package:minimo/models/user_nickname_model.dart';

part 'chat_room_model.freezed.dart';
part 'chat_room_model.g.dart';

@freezed
class ChatRoomModel with _$ChatRoomModel {
  const factory ChatRoomModel({
    required int id,
    required List<UserNicknameModel> userNicknames,
    ChatMessageModel? lastMessage,
    int? readNum,
    required DateTime createdDate,
  }) = _ChatRoomModel;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => _$ChatRoomModelFromJson(json);
}