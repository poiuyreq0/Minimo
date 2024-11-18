// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter_element_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LetterElementModelImpl _$$LetterElementModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LetterElementModelImpl(
      id: (json['id'] as num).toInt(),
      senderNickname: json['senderNickname'] as String,
      title: json['title'] as String,
      letterState:
          $enumDecodeNullable(_$LetterStateEnumMap, json['letterState']),
    );

Map<String, dynamic> _$$LetterElementModelImplToJson(
        _$LetterElementModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderNickname': instance.senderNickname,
      'title': instance.title,
      'letterState': _$LetterStateEnumMap[instance.letterState],
    };

const _$LetterStateEnumMap = {
  LetterState.NONE: 'NONE',
  LetterState.SENT: 'SENT',
  LetterState.LOCKED: 'LOCKED',
  LetterState.CONNECTED: 'CONNECTED',
};
