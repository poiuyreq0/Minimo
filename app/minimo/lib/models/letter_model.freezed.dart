// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'letter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LetterModel _$LetterModelFromJson(Map<String, dynamic> json) {
  return _LetterModel.fromJson(json);
}

/// @nodoc
mixin _$LetterModel {
  int get id => throw _privateConstructorUsedError;
  int? get senderId => throw _privateConstructorUsedError;
  String? get senderNickname => throw _privateConstructorUsedError;
  int? get receiverId => throw _privateConstructorUsedError;
  String? get receiverNickname => throw _privateConstructorUsedError;
  LetterContentModel get letterContent => throw _privateConstructorUsedError;
  LetterOption get letterOption => throw _privateConstructorUsedError;
  UserInfoModel? get userInfo => throw _privateConstructorUsedError;
  LetterState? get letterState => throw _privateConstructorUsedError;
  DateTime? get createdDate => throw _privateConstructorUsedError;
  DateTime? get receivedDate => throw _privateConstructorUsedError;
  DateTime? get connectedDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LetterModelCopyWith<LetterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LetterModelCopyWith<$Res> {
  factory $LetterModelCopyWith(
          LetterModel value, $Res Function(LetterModel) then) =
      _$LetterModelCopyWithImpl<$Res, LetterModel>;
  @useResult
  $Res call(
      {int id,
      int? senderId,
      String? senderNickname,
      int? receiverId,
      String? receiverNickname,
      LetterContentModel letterContent,
      LetterOption letterOption,
      UserInfoModel? userInfo,
      LetterState? letterState,
      DateTime? createdDate,
      DateTime? receivedDate,
      DateTime? connectedDate});

  $LetterContentModelCopyWith<$Res> get letterContent;
  $UserInfoModelCopyWith<$Res>? get userInfo;
}

/// @nodoc
class _$LetterModelCopyWithImpl<$Res, $Val extends LetterModel>
    implements $LetterModelCopyWith<$Res> {
  _$LetterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = freezed,
    Object? senderNickname = freezed,
    Object? receiverId = freezed,
    Object? receiverNickname = freezed,
    Object? letterContent = null,
    Object? letterOption = null,
    Object? userInfo = freezed,
    Object? letterState = freezed,
    Object? createdDate = freezed,
    Object? receivedDate = freezed,
    Object? connectedDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as int?,
      senderNickname: freezed == senderNickname
          ? _value.senderNickname
          : senderNickname // ignore: cast_nullable_to_non_nullable
              as String?,
      receiverId: freezed == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as int?,
      receiverNickname: freezed == receiverNickname
          ? _value.receiverNickname
          : receiverNickname // ignore: cast_nullable_to_non_nullable
              as String?,
      letterContent: null == letterContent
          ? _value.letterContent
          : letterContent // ignore: cast_nullable_to_non_nullable
              as LetterContentModel,
      letterOption: null == letterOption
          ? _value.letterOption
          : letterOption // ignore: cast_nullable_to_non_nullable
              as LetterOption,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      letterState: freezed == letterState
          ? _value.letterState
          : letterState // ignore: cast_nullable_to_non_nullable
              as LetterState?,
      createdDate: freezed == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      receivedDate: freezed == receivedDate
          ? _value.receivedDate
          : receivedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      connectedDate: freezed == connectedDate
          ? _value.connectedDate
          : connectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LetterContentModelCopyWith<$Res> get letterContent {
    return $LetterContentModelCopyWith<$Res>(_value.letterContent, (value) {
      return _then(_value.copyWith(letterContent: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserInfoModelCopyWith<$Res>? get userInfo {
    if (_value.userInfo == null) {
      return null;
    }

    return $UserInfoModelCopyWith<$Res>(_value.userInfo!, (value) {
      return _then(_value.copyWith(userInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LetterModelImplCopyWith<$Res>
    implements $LetterModelCopyWith<$Res> {
  factory _$$LetterModelImplCopyWith(
          _$LetterModelImpl value, $Res Function(_$LetterModelImpl) then) =
      __$$LetterModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int? senderId,
      String? senderNickname,
      int? receiverId,
      String? receiverNickname,
      LetterContentModel letterContent,
      LetterOption letterOption,
      UserInfoModel? userInfo,
      LetterState? letterState,
      DateTime? createdDate,
      DateTime? receivedDate,
      DateTime? connectedDate});

  @override
  $LetterContentModelCopyWith<$Res> get letterContent;
  @override
  $UserInfoModelCopyWith<$Res>? get userInfo;
}

/// @nodoc
class __$$LetterModelImplCopyWithImpl<$Res>
    extends _$LetterModelCopyWithImpl<$Res, _$LetterModelImpl>
    implements _$$LetterModelImplCopyWith<$Res> {
  __$$LetterModelImplCopyWithImpl(
      _$LetterModelImpl _value, $Res Function(_$LetterModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = freezed,
    Object? senderNickname = freezed,
    Object? receiverId = freezed,
    Object? receiverNickname = freezed,
    Object? letterContent = null,
    Object? letterOption = null,
    Object? userInfo = freezed,
    Object? letterState = freezed,
    Object? createdDate = freezed,
    Object? receivedDate = freezed,
    Object? connectedDate = freezed,
  }) {
    return _then(_$LetterModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as int?,
      senderNickname: freezed == senderNickname
          ? _value.senderNickname
          : senderNickname // ignore: cast_nullable_to_non_nullable
              as String?,
      receiverId: freezed == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as int?,
      receiverNickname: freezed == receiverNickname
          ? _value.receiverNickname
          : receiverNickname // ignore: cast_nullable_to_non_nullable
              as String?,
      letterContent: null == letterContent
          ? _value.letterContent
          : letterContent // ignore: cast_nullable_to_non_nullable
              as LetterContentModel,
      letterOption: null == letterOption
          ? _value.letterOption
          : letterOption // ignore: cast_nullable_to_non_nullable
              as LetterOption,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      letterState: freezed == letterState
          ? _value.letterState
          : letterState // ignore: cast_nullable_to_non_nullable
              as LetterState?,
      createdDate: freezed == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      receivedDate: freezed == receivedDate
          ? _value.receivedDate
          : receivedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      connectedDate: freezed == connectedDate
          ? _value.connectedDate
          : connectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LetterModelImpl implements _LetterModel {
  const _$LetterModelImpl(
      {required this.id,
      this.senderId,
      this.senderNickname,
      this.receiverId,
      this.receiverNickname,
      required this.letterContent,
      required this.letterOption,
      this.userInfo,
      this.letterState,
      this.createdDate,
      this.receivedDate,
      this.connectedDate});

  factory _$LetterModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LetterModelImplFromJson(json);

  @override
  final int id;
  @override
  final int? senderId;
  @override
  final String? senderNickname;
  @override
  final int? receiverId;
  @override
  final String? receiverNickname;
  @override
  final LetterContentModel letterContent;
  @override
  final LetterOption letterOption;
  @override
  final UserInfoModel? userInfo;
  @override
  final LetterState? letterState;
  @override
  final DateTime? createdDate;
  @override
  final DateTime? receivedDate;
  @override
  final DateTime? connectedDate;

  @override
  String toString() {
    return 'LetterModel(id: $id, senderId: $senderId, senderNickname: $senderNickname, receiverId: $receiverId, receiverNickname: $receiverNickname, letterContent: $letterContent, letterOption: $letterOption, userInfo: $userInfo, letterState: $letterState, createdDate: $createdDate, receivedDate: $receivedDate, connectedDate: $connectedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LetterModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderNickname, senderNickname) ||
                other.senderNickname == senderNickname) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.receiverNickname, receiverNickname) ||
                other.receiverNickname == receiverNickname) &&
            (identical(other.letterContent, letterContent) ||
                other.letterContent == letterContent) &&
            (identical(other.letterOption, letterOption) ||
                other.letterOption == letterOption) &&
            (identical(other.userInfo, userInfo) ||
                other.userInfo == userInfo) &&
            (identical(other.letterState, letterState) ||
                other.letterState == letterState) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            (identical(other.receivedDate, receivedDate) ||
                other.receivedDate == receivedDate) &&
            (identical(other.connectedDate, connectedDate) ||
                other.connectedDate == connectedDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      senderId,
      senderNickname,
      receiverId,
      receiverNickname,
      letterContent,
      letterOption,
      userInfo,
      letterState,
      createdDate,
      receivedDate,
      connectedDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LetterModelImplCopyWith<_$LetterModelImpl> get copyWith =>
      __$$LetterModelImplCopyWithImpl<_$LetterModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LetterModelImplToJson(
      this,
    );
  }
}

abstract class _LetterModel implements LetterModel {
  const factory _LetterModel(
      {required final int id,
      final int? senderId,
      final String? senderNickname,
      final int? receiverId,
      final String? receiverNickname,
      required final LetterContentModel letterContent,
      required final LetterOption letterOption,
      final UserInfoModel? userInfo,
      final LetterState? letterState,
      final DateTime? createdDate,
      final DateTime? receivedDate,
      final DateTime? connectedDate}) = _$LetterModelImpl;

  factory _LetterModel.fromJson(Map<String, dynamic> json) =
      _$LetterModelImpl.fromJson;

  @override
  int get id;
  @override
  int? get senderId;
  @override
  String? get senderNickname;
  @override
  int? get receiverId;
  @override
  String? get receiverNickname;
  @override
  LetterContentModel get letterContent;
  @override
  LetterOption get letterOption;
  @override
  UserInfoModel? get userInfo;
  @override
  LetterState? get letterState;
  @override
  DateTime? get createdDate;
  @override
  DateTime? get receivedDate;
  @override
  DateTime? get connectedDate;
  @override
  @JsonKey(ignore: true)
  _$$LetterModelImplCopyWith<_$LetterModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
