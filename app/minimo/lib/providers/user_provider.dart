import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository userRepository;
  String? emailCache;
  UserModel? userCache;

  UserProvider({
    required this.userRepository,
  })  : super();

  Stream<User?> userChanges() async* {
    yield* _auth.userChanges();
  }

  Future<UserModel?> getUser() async {
    final resp = await userRepository.getUser(id: userCache!.id);
    userCache = resp;

    return userCache;
  }

  // Auth Screen 신규 유저이면 null
  Future<UserModel?> getUserByEmail() async {
    emailCache ??= _auth.currentUser!.email;
    final resp = await userRepository.getUserByEmail(email: emailCache!);
    userCache = resp;

    return userCache;
  }

  Future<void> createUser({
    required UserModel userModel,
  }) async {
    final user = userModel.copyWith(email: emailCache!);
    final savedUserId = await userRepository.createUser(user: user);
    userCache = user.copyWith(id: savedUserId);
  }

  Future<int> getHeartNum() async {
    final resp = await userRepository.getHeartNum(id: userCache!.id);
    userCache = userCache!.copyWith(heartNum: resp);

    notifyListeners();
    return resp;
  }

  Future<void> updateImage({
    required XFile image,
  }) async {
    await userRepository.updateImage(id: userCache!.id, image: image);

    notifyListeners();
  }

  Future<void> updateUserInfo({
    required UserInfoModel userInfoModel,
  }) async {
    final updatedUserInfo = await userRepository.updateUserInfo(id: userCache!.id, userInfoModel: userInfoModel);
    userCache = userCache!.copyWith(userInfo: updatedUserInfo);

    notifyListeners();
  }

  Future<void> updateNickname({
    required String nickname,
  }) async {
    final updatedUser = await userRepository.updateNickname(id: userCache!.id, nickname: nickname);
    userCache = updatedUser;

    notifyListeners();
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
    await userRepository.deleteUser(id: userCache!.id);
    logout();
  }

  Future<void> logout() async {
    await _auth.signOut();
    emailCache = null;
    userCache = null;
  }
}