import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_ban_record_model.freezed.dart';
part 'user_ban_record_model.g.dart';

@freezed
class UserBanRecordModel with _$UserBanRecordModel {
  const factory UserBanRecordModel({
    required int id,
    required int targetId,
    required String targetNickname,
    required DateTime createdDate,
  }) = _UserBanRecordModel;

  factory UserBanRecordModel.fromJson(Map<String, dynamic> json) => _$UserBanRecordModelFromJson(json);
}