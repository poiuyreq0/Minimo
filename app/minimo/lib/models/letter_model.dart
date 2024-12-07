import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:minimo/consts/letter_option.dart';
import 'package:minimo/consts/letter_state.dart';

import 'letter_content_model.dart';
import 'user_info_model.dart';

part 'letter_model.freezed.dart';
part 'letter_model.g.dart';

@freezed
class LetterModel with _$LetterModel {
  const factory LetterModel({
    required int id,
    int? senderId,
    String? senderNickname,
    int? receiverId,
    String? receiverNickname,
    required LetterContentModel letterContent,
    required LetterOption letterOption,
    UserInfoModel? userInfo,
    LetterState? letterState,
    DateTime? createdDate,
    DateTime? receivedDate,
    DateTime? connectedDate,
  }) = _LetterModel;

  factory LetterModel.fromJson(Map<String, dynamic> json) => _$LetterModelFromJson(json);
}