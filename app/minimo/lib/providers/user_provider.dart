import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository userRepository;
  String? _emailCache;
  String? get emailCache => _emailCache;
  UserModel? _userCache;
  UserModel? get userCache => _userCache;

  UserProvider({
    required this.userRepository,
  })  : super();

  Stream<User?> userChanges() async* {
    yield* _auth.userChanges();
  }

  Future<void> createUser({
    required UserModel userModel,
  }) async {
    _emailCache ??= _auth.currentUser!.email!;
    final user = userModel.copyWith(email: _emailCache!);
    final savedUserId = await userRepository.createUser(user: user);
    _userCache = user.copyWith(id: savedUserId);
  }

  Future<UserModel?> getUser() async {
    if (_userCache == null) {
      return null;
    }
    final resp = await userRepository.getUser(id: _userCache!.id);
    _userCache = resp;

    return _userCache;
  }

  Future<UserModel?> getUserByEmail() async {
    _emailCache ??= _auth.currentUser!.email;
    if (_emailCache == null) {
      return null;
    }
    final resp = await userRepository.getUserByEmail(email: _emailCache!);
    _userCache = resp;

    return _userCache;
  }

  Future<int> getHeartNum() async {
    final resp = await userRepository.getHeartNum(id: _userCache!.id);
    _userCache = _userCache!.copyWith(heartNum: resp);

    notifyListeners();
    return resp;
  }

  Future<void> updateUserInfo({
    required UserInfoModel userInfoModel,
  }) async {
    final updatedUserInfo = await userRepository.updateUserInfo(id: _userCache!.id, userInfoModel: userInfoModel);
    _userCache = _userCache!.copyWith(userInfo: updatedUserInfo);

    notifyListeners();
  }

  Future<void> updateNickname({
    required String nickname,
  }) async {
    final updatedUser = await userRepository.updateNickname(id: _userCache!.id, nickname: nickname);
    _userCache = updatedUser;

    notifyListeners();
  }

  Future<void> updatePassword({
    required String password,
    required String newPassword,
  }) async {
    // 파이어베이스 사용자 재인증
    final credential = EmailAuthProvider.credential(email: _emailCache!, password: password);
    await _auth.currentUser!.reauthenticateWithCredential(credential);

    // 파이어베이스 비밀번호 변경
    await _auth.currentUser!.updatePassword(newPassword);
  }

  Future<void> deleteUser({
    required String password,
  }) async {
    // 파이어베이스 사용자 재인증
    final credential = EmailAuthProvider.credential(email: _emailCache!, password: password);
    await _auth.currentUser!.reauthenticateWithCredential(credential);

    // 파이어베이스 회원 탈퇴
    await _auth.currentUser!.delete();

    await userRepository.deleteUser(id: _userCache!.id);
    logout();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _emailCache = null;
    _userCache = null;
  }
}