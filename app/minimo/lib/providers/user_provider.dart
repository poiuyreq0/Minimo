import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimo/enums/item.dart';
import 'package:minimo/enums/report_reason.dart';
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
  bool userBanListScreenSelectorTrigger = true;

  UserProvider({
    required this.userRepository,
  })  : super();

  Stream<User?> userChanges() async* {
    yield* _auth.userChanges();
  }

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
    await userRepository.updateUserInfo(userId: userCache!.id, userInfo: userInfo);
    userCache = userCache!.copyWith(userInfo: userInfo);

    _refreshHomeScreenSelector();
    _refreshInfoScreenSelector();
  }

  Future<void> updateNickname({
    required String nickname,
  }) async {
    await userRepository.updateNickname(userId: userCache!.id, nickname: nickname);
    userCache = userCache!.copyWith(nickname: nickname);

    _refreshInfoScreenSelector();
  }

  void updateFcmToken({
    required String fcmToken,
  }) async {
    await userRepository.updateFcmToken(userId: userCache!.id, fcmToken: fcmToken);
  }

  Future<void> deleteFcmToken() async {
    await userRepository.deleteFcmToken(userId: userCache!.id);
  }

  Future<void> banUser({
    required int targetId,
    required String targetNickname,
  }) async {
    final resp = await userRepository.banUser(userId: userCache!.id, targetId: targetId, targetNickname: targetNickname);
    userCache = userCache!.copyWith(userBanRecordMap: resp);
  }

  Future<void> unbanUser({
    required int targetId,
  }) async {
    final resp = await userRepository.unbanUser(userId: userCache!.id, targetId: targetId);
    userCache = userCache!.copyWith(userBanRecordMap: resp);

    _refreshUserBanListScreenSelector();
  }

  Future<void> reportUser({
    required int targetId,
    required ReportReason reportReason,
  }) async {
    await userRepository.reportUser(userId: userCache!.id, targetId: targetId, reportReason: reportReason);
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
    // 서버 데이터 삭제
    await userRepository.deleteUser(userId: userCache!.id);

    // 파이어베이스 사용자 재인증
    final credential = EmailAuthProvider.credential(email: emailCache!, password: password);
    await _auth.currentUser!.reauthenticateWithCredential(credential);

    // 파이어베이스 회원 탈퇴
    await _auth.currentUser!.delete();

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

  void _refreshUserBanListScreenSelector() {
    userBanListScreenSelectorTrigger = !userBanListScreenSelectorTrigger;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    cleanCache();
  }

  void cleanCache() {
    emailCache = null;
    userCache = null;
  }
}