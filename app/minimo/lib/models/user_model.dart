import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minimo/models/user_ban_record_model.dart';
import 'package:minimo/models/user_info_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel{
  const factory UserModel({
    required int id,
    required String email,
    required String nickname,
    required UserInfoModel userInfo,
    required int netNum,
    required int bottleNum,
    required bool isProfileImageSet,
    Map<int, UserBanRecordModel>? userBanRecordMap,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}