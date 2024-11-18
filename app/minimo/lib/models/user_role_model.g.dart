// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRoleModelImpl _$$UserRoleModelImplFromJson(Map<String, dynamic> json) =>
    _$UserRoleModelImpl(
      id: (json['id'] as num).toInt(),
      userRole: $enumDecode(_$UserRoleEnumMap, json['userRole']),
    );

Map<String, dynamic> _$$UserRoleModelImplToJson(_$UserRoleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userRole': _$UserRoleEnumMap[instance.userRole]!,
    };

const _$UserRoleEnumMap = {
  UserRole.SENDER: 'SENDER',
  UserRole.RECEIVER: 'RECEIVER',
};
