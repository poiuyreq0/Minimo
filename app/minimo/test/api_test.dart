import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:minimo/enums/gender.dart';
import 'package:minimo/enums/letter_option.dart';
import 'package:minimo/enums/mbti.dart';
import 'package:minimo/models/letter_content_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/repositories/letter_repository.dart';
import 'package:minimo/repositories/user_repository.dart';

var userInfo = UserInfoModel(
  name: 'ㅁㄴㅁ',
  mbti: Mbti.ENFP,
  gender: Gender.MALE,
  birthday: DateTime.now(),
);
var user = UserModel(
  id: 0,
  email: 'asdf@gmail.com',
  nickname: "nickname",
  userInfo: userInfo,
  heartNum: 5,
);

var letterContent = LetterContentModel(
  title: 'title',
  content: 'content',
);
var letter = LetterModel(
  id: 0,
  senderId: 1,
  // receiverId: 2,
  // receiverNickname: 'nickname',
  letterContent: letterContent,
  userInfo: userInfo,
  letterOption: LetterOption.ALL,
);

void main() async {
  // user api test
  final UserRepository userRepository = UserRepository();

  try {
    final resp = await userRepository.createUser(user: user);
    debugPrint('createUser resp: $resp');
  } on DioException catch (e) {
    debugPrint('createUser: $e');
  }

  try {
    final resp = await userRepository.getUserByEmail(email: '');
    debugPrint('getUserByEmail resp: $resp');
  } on DioException catch (e) {
    debugPrint('getUserByEmail: $e');
  }

  // letter api test
  // final LetterRepository letterRepository = LetterRepository();
  //
  // try {
  //   final resp = await letterRepository.getLettersByEveryOption(userId: 2, count: 5);
  //   debugPrint('getLettersByEveryOption resp: $resp');
  // } on DioException catch (e) {
  //   debugPrint('getLettersByEveryOption: $e');
  // }
}