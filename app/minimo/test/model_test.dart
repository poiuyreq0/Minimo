import 'package:flutter/material.dart';
import 'package:minimo/enums/gender.dart';
import 'package:minimo/enums/letter_option.dart';
import 'package:minimo/enums/mbti.dart';
import 'package:minimo/models/letter_content_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/models/user_model.dart';

void main () {
  debugPrint('User Json----------------------------------------');
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
  var userJson = user.toJson();
  debugPrint(userJson.toString());

  debugPrint('Letter Json----------------------------------------');
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
  var jsonLetter = letter.toJson();
  debugPrint(jsonLetter.toString());

  debugPrint('----------------------------------------');
}