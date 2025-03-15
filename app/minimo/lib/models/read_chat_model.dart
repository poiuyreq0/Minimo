import 'package:freezed_annotation/freezed_annotation.dart';

part 'read_chat_model.freezed.dart';
part 'read_chat_model.g.dart';

@freezed
class ReadChatModel with _$ReadChatModel {
  const factory ReadChatModel({
    required int roomId,
    required int messageId,
  }) = _ReadChatModel;

  factory ReadChatModel.fromJson(Map<String, dynamic> json) => _$ReadChatModelFromJson(json);
}