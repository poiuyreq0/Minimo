import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_user_model.freezed.dart';
part 'chat_room_user_model.g.dart';

@freezed
class ChatRoomUserModel with _$ChatRoomUserModel {
  const factory ChatRoomUserModel({
    required int id,
    required String nickname,
  }) = _ChatRoomUserModel;

  factory ChatRoomUserModel.fromJson(Map<String, dynamic> json) => _$ChatRoomUserModelFromJson(json);
}