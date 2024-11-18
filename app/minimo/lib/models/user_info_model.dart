import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:minimo/consts/gender.dart';
import 'package:minimo/consts/mbti.dart';

part 'user_info_model.freezed.dart';
part 'user_info_model.g.dart';

@freezed
class UserInfoModel with _$UserInfoModel {
  const factory UserInfoModel({
    String? name,
    Mbti? mbti,
    Gender? gender,
    DateTime? birthday,
  }) = _UserInfoModel;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);
}