import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimo/enums/item.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final UserRepository userRepository;
  String? emailCache;
  UserModel? userCache;
  bool homeScreenSelectorTrigger = true;
  bool infoScreenSelectorTrigger = true;

  UserProvider({
    required this.userRepository,
  })  : super();

  Stream<User?> userChanges() async* {
    yield* _auth.userChanges();
  }

  // FutureBuilder
  // Auth Screen 신규 유저이면 null
  Future<UserModel?> getUserByEmail() async {
    emailCache ??= _auth.currentUser!.email;
    final resp = await userRepository.getUserByEmail(email: emailCache!);
    userCache = resp;

    return userCache;
  }

  Future<void> createUser({
    required UserModel user,
  }) async {
    final userWithEmail = user.copyWith(email: emailCache!);
    final resp = await userRepository.createUser(user: userWithEmail);
    userCache = user.copyWith(id: resp);
  }

  Future<void> getItemNum({
    required Item item,
  }) async {
    final resp = await userRepository.getItemNum(userId: userCache!.id, item: item);
    if (item == Item.NET) {
      userCache = userCache!.copyWith(netNum: resp);
    } else if (item == Item.BOTTLE) {
      userCache = userCache!.copyWith(bottleNum: resp);
    }

    notifyListeners();
  }

  Future<void> addItemNum({
    required Item item,
    required int amount,
  }) async {
    final resp = await userRepository.addItemNum(userId: userCache!.id, item: item, amount: amount);
    if (item == Item.NET) {
      userCache = userCache!.copyWith(netNum: resp);
    } else if (item == Item.BOTTLE) {
      userCache = userCache!.copyWith(bottleNum: resp);
    }

    notifyListeners();
  }

  Future<void> updateImage({
    required Uint8List imageBytes,
  }) async {
    await userRepository.updateImage(userId: userCache!.id, nickname: userCache!.nickname, imageBytes: imageBytes);
    userCache = userCache!.copyWith(isProfileImageSet: true);

    _refreshInfoScreenSelector();
  }

  Future<void> deleteImage() async {
    await userRepository.deleteImage(userId: userCache!.id);
    userCache = userCache!.copyWith(isProfileImageSet: false);

    _refreshInfoScreenSelector();
  }

  Future<void> updateUserInfo({
    required UserInfoModel userInfo,
  }) async {
    final resp = await userRepository.updateUserInfo(userId: userCache!.id, userInfo: userInfo);
    userCache = userCache!.copyWith(userInfo: resp);

    _refreshHomeScreenSelector();
    _refreshInfoScreenSelector();
  }

  void updateFcmToken({
    required String fcmToken,
  }) async {
    await userRepository.updateFcmToken(userId: userCache!.id, fcmToken: fcmToken);
  }

  Future<void> updateNickname({
    required String nickname,
  }) async {
    final resp = await userRepository.updateNickname(userId: userCache!.id, nickname: nickname);
    userCache = userCache!.copyWith(nickname: resp);

    _refreshInfoScreenSelector();
  }

  Future<void> updatePassword({
    required String password,
    required String newPassword,
  }) async {
    // 파이어베이스 사용자 재인증
    final credential = EmailAuthProvider.credential(email: emailCache!, password: password);
    await _auth.currentUser!.reauthenticateWithCredential(credential);

    // 파이어베이스 비밀번호 변경
    await _auth.currentUser!.updatePassword(newPassword);
  }

  Future<void> deleteUser({
    required String password,
  }) async {
    // 파이어베이스 사용자 재인증
    final credential = EmailAuthProvider.credential(email: emailCache!, password: password);
    await _auth.currentUser!.reauthenticateWithCredential(credential);

    // 파이어베이스 회원 탈퇴
    await _auth.currentUser!.delete();

    // 서버 데이터 삭제
    await userRepository.deleteUser(userId: userCache!.id);
    logout();
  }

  void _refreshHomeScreenSelector() {
    homeScreenSelectorTrigger = !homeScreenSelectorTrigger;
    notifyListeners();
  }

  void _refreshInfoScreenSelector() {
    infoScreenSelectorTrigger = !infoScreenSelectorTrigger;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    emailCache = null;
    userCache = null;
  }
}