// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'letter_element_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LetterElementModel _$LetterElementModelFromJson(Map<String, dynamic> json) {
  return _LetterElementModel.fromJson(json);
}

/// @nodoc
mixin _$LetterElementModel {
  int get id => throw _privateConstructorUsedError;
  String get senderNickname => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  LetterState? get letterState => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LetterElementModelCopyWith<LetterElementModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LetterElementModelCopyWith<$Res> {
  factory $LetterElementModelCopyWith(
          LetterElementModel value, $Res Function(LetterElementModel) then) =
      _$LetterElementModelCopyWithImpl<$Res, LetterElementModel>;
  @useResult
  $Res call(
      {int id, String senderNickname, String title, LetterState? letterState});
}

/// @nodoc
class _$LetterElementModelCopyWithImpl<$Res, $Val extends LetterElementModel>
    implements $LetterElementModelCopyWith<$Res> {
  _$LetterElementModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderNickname = null,
    Object? title = null,
    Object? letterState = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      senderNickname: null == senderNickname
          ? _value.senderNickname
          : senderNickname // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      letterState: freezed == letterState
          ? _value.letterState
          : letterState // ignore: cast_nullable_to_non_nullable
              as LetterState?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LetterElementModelImplCopyWith<$Res>
    implements $LetterElementModelCopyWith<$Res> {
  factory _$$LetterElementModelImplCopyWith(_$LetterElementModelImpl value,
          $Res Function(_$LetterElementModelImpl) then) =
      __$$LetterElementModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id, String senderNickname, String title, LetterState? letterState});
}

/// @nodoc
class __$$LetterElementModelImplCopyWithImpl<$Res>
    extends _$LetterElementModelCopyWithImpl<$Res, _$LetterElementModelImpl>
    implements _$$LetterElementModelImplCopyWith<$Res> {
  __$$LetterElementModelImplCopyWithImpl(_$LetterElementModelImpl _value,
      $Res Function(_$LetterElementModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderNickname = null,
    Object? title = null,
    Object? letterState = freezed,
  }) {
    return _then(_$LetterElementModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      senderNickname: null == senderNickname
          ? _value.senderNickname
          : senderNickname // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      letterState: freezed == letterState
          ? _value.letterState
          : letterState // ignore: cast_nullable_to_non_nullable
              as LetterState?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LetterElementModelImpl implements _LetterElementModel {
  const _$LetterElementModelImpl(
      {required this.id,
      required this.senderNickname,
      required this.title,
      this.letterState});

  factory _$LetterElementModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LetterElementModelImplFromJson(json);

  @override
  final int id;
  @override
  final String senderNickname;
  @override
  final String title;
  @override
  final LetterState? letterState;

  @override
  String toString() {
    return 'LetterElementModel(id: $id, senderNickname: $senderNickname, title: $title, letterState: $letterState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LetterElementModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderNickname, senderNickname) ||
                other.senderNickname == senderNickname) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.letterState, letterState) ||
                other.letterState == letterState));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, senderNickname, title, letterState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LetterElementModelImplCopyWith<_$LetterElementModelImpl> get copyWith =>
      __$$LetterElementModelImplCopyWithImpl<_$LetterElementModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LetterElementModelImplToJson(
      this,
    );
  }
}

abstract class _LetterElementModel implements LetterElementModel {
  const factory _LetterElementModel(
      {required final int id,
      required final String senderNickname,
      required final String title,
      final LetterState? letterState}) = _$LetterElementModelImpl;

  factory _LetterElementModel.fromJson(Map<String, dynamic> json) =
      _$LetterElementModelImpl.fromJson;

  @override
  int get id;
  @override
  String get senderNickname;
  @override
  String get title;
  @override
  LetterState? get letterState;
  @override
  @JsonKey(ignore: true)
  _$$LetterElementModelImplCopyWith<_$LetterElementModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
