import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_nickname_model.freezed.dart';
part 'user_nickname_model.g.dart';

@freezed
class UserNicknameModel with _$UserNicknameModel {
  const factory UserNicknameModel({
    required int id,
    required String nickname,
  }) = _UserNicknameModel;

  factory UserNicknameModel.fromJson(Map<String, dynamic> json) => _$UserNicknameModelFromJson(json);
}