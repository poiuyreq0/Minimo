// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserInfoModelImpl _$$UserInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$UserInfoModelImpl(
      name: json['name'] as String?,
      mbti: $enumDecodeNullable(_$MbtiEnumMap, json['mbti']),
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
    );

Map<String, dynamic> _$$UserInfoModelImplToJson(_$UserInfoModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mbti': _$MbtiEnumMap[instance.mbti],
      'gender': _$GenderEnumMap[instance.gender],
      'birthday': instance.birthday?.toIso8601String(),
    };

const _$MbtiEnumMap = {
  Mbti.ENFJ: 'ENFJ',
  Mbti.ENFP: 'ENFP',
  Mbti.ENTJ: 'ENTJ',
  Mbti.ENTP: 'ENTP',
  Mbti.ESFJ: 'ESFJ',
  Mbti.ESFP: 'ESFP',
  Mbti.ESTJ: 'ESTJ',
  Mbti.ESTP: 'ESTP',
  Mbti.INFJ: 'INFJ',
  Mbti.INFP: 'INFP',
  Mbti.INTJ: 'INTJ',
  Mbti.INTP: 'INTP',
  Mbti.ISFJ: 'ISFJ',
  Mbti.ISFP: 'ISFP',
  Mbti.ISTJ: 'ISTJ',
  Mbti.ISTP: 'ISTP',
};

const _$GenderEnumMap = {
  Gender.MALE: 'MALE',
  Gender.FEMALE: 'FEMALE',
};
