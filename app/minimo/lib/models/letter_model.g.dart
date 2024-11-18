// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LetterModelImpl _$$LetterModelImplFromJson(Map<String, dynamic> json) =>
    _$LetterModelImpl(
      id: (json['id'] as num).toInt(),
      senderId: (json['senderId'] as num?)?.toInt(),
      senderNickname: json['senderNickname'] as String?,
      receiverId: (json['receiverId'] as num?)?.toInt(),
      receiverNickname: json['receiverNickname'] as String?,
      letterContent: LetterContentModel.fromJson(
          json['letterContent'] as Map<String, dynamic>),
      letterOption: $enumDecode(_$LetterOptionEnumMap, json['letterOption']),
      userInfo: json['userInfo'] == null
          ? null
          : UserInfoModel.fromJson(json['userInfo'] as Map<String, dynamic>),
      letterState:
          $enumDecodeNullable(_$LetterStateEnumMap, json['letterState']),
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      receivedDate: json['receivedDate'] == null
          ? null
          : DateTime.parse(json['receivedDate'] as String),
      connectedDate: json['connectedDate'] == null
          ? null
          : DateTime.parse(json['connectedDate'] as String),
    );

Map<String, dynamic> _$$LetterModelImplToJson(_$LetterModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'senderNickname': instance.senderNickname,
      'receiverId': instance.receiverId,
      'receiverNickname': instance.receiverNickname,
      'letterContent': instance.letterContent.toJson(),
      'letterOption': _$LetterOptionEnumMap[instance.letterOption]!,
      'userInfo': instance.userInfo?.toJson(),
      'letterState': _$LetterStateEnumMap[instance.letterState],
      'createdDate': instance.createdDate?.toIso8601String(),
      'receivedDate': instance.receivedDate?.toIso8601String(),
      'connectedDate': instance.connectedDate?.toIso8601String(),
    };

const _$LetterOptionEnumMap = {
  LetterOption.ALL: 'ALL',
  LetterOption.NAME: 'NAME',
  LetterOption.MBTI: 'MBTI',
  LetterOption.GENDER: 'GENDER',
  LetterOption.NONE: 'NONE',
};

const _$LetterStateEnumMap = {
  LetterState.NONE: 'NONE',
  LetterState.SENT: 'SENT',
  LetterState.LOCKED: 'LOCKED',
  LetterState.CONNECTED: 'CONNECTED',
};
