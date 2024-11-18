// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_role_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserRoleModel _$UserRoleModelFromJson(Map<String, dynamic> json) {
  return _UserRoleModel.fromJson(json);
}

/// @nodoc
mixin _$UserRoleModel {
  int get id => throw _privateConstructorUsedError;
  UserRole get userRole => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserRoleModelCopyWith<UserRoleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRoleModelCopyWith<$Res> {
  factory $UserRoleModelCopyWith(
          UserRoleModel value, $Res Function(UserRoleModel) then) =
      _$UserRoleModelCopyWithImpl<$Res, UserRoleModel>;
  @useResult
  $Res call({int id, UserRole userRole});
}

/// @nodoc
class _$UserRoleModelCopyWithImpl<$Res, $Val extends UserRoleModel>
    implements $UserRoleModelCopyWith<$Res> {
  _$UserRoleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userRole = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userRole: null == userRole
          ? _value.userRole
          : userRole // ignore: cast_nullable_to_non_nullable
              as UserRole,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserRoleModelImplCopyWith<$Res>
    implements $UserRoleModelCopyWith<$Res> {
  factory _$$UserRoleModelImplCopyWith(
          _$UserRoleModelImpl value, $Res Function(_$UserRoleModelImpl) then) =
      __$$UserRoleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, UserRole userRole});
}

/// @nodoc
class __$$UserRoleModelImplCopyWithImpl<$Res>
    extends _$UserRoleModelCopyWithImpl<$Res, _$UserRoleModelImpl>
    implements _$$UserRoleModelImplCopyWith<$Res> {
  __$$UserRoleModelImplCopyWithImpl(
      _$UserRoleModelImpl _value, $Res Function(_$UserRoleModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userRole = null,
  }) {
    return _then(_$UserRoleModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userRole: null == userRole
          ? _value.userRole
          : userRole // ignore: cast_nullable_to_non_nullable
              as UserRole,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRoleModelImpl implements _UserRoleModel {
  const _$UserRoleModelImpl({required this.id, required this.userRole});

  factory _$UserRoleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRoleModelImplFromJson(json);

  @override
  final int id;
  @override
  final UserRole userRole;

  @override
  String toString() {
    return 'UserRoleModel(id: $id, userRole: $userRole)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRoleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userRole, userRole) ||
                other.userRole == userRole));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userRole);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRoleModelImplCopyWith<_$UserRoleModelImpl> get copyWith =>
      __$$UserRoleModelImplCopyWithImpl<_$UserRoleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRoleModelImplToJson(
      this,
    );
  }
}

abstract class _UserRoleModel implements UserRoleModel {
  const factory _UserRoleModel(
      {required final int id,
      required final UserRole userRole}) = _$UserRoleModelImpl;

  factory _UserRoleModel.fromJson(Map<String, dynamic> json) =
      _$UserRoleModelImpl.fromJson;

  @override
  int get id;
  @override
  UserRole get userRole;
  @override
  @JsonKey(ignore: true)
  _$$UserRoleModelImplCopyWith<_$UserRoleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
