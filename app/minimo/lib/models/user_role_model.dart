import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:minimo/enums/user_role.dart';

part 'user_role_model.freezed.dart';
part 'user_role_model.g.dart';

@freezed
class UserRoleModel with _$UserRoleModel {
  const factory UserRoleModel({
    required int id,
    required UserRole userRole,
  }) = _UserRoleModel;

  factory UserRoleModel.fromJson(Map<String, dynamic> json) => _$UserRoleModelFromJson(json);
}