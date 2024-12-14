import 'package:flutter/cupertino.dart';
import 'package:minimo/enums/letter_option.dart';
import 'package:minimo/enums/letter_state.dart';
import 'package:minimo/models/letter_element_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/models/user_role_model.dart';
import 'package:minimo/repositories/letter_repository.dart';

class LetterProvider extends ChangeNotifier {
  final LetterRepository letterRepository;
  Map<LetterOption, List<LetterElementModel>> newLettersCache = {};

  LetterProvider({
    required this.letterRepository,
  })  : super();

  Future<void> sendLetter({
    required LetterModel letterModel,
  }) async {
    await letterRepository.sendLetter(letterModel: letterModel);
  }

  Future<Map<LetterOption, List<LetterElementModel>>> getEveryNewLetters({
    required int userId,
    required int count,
  }) async {
    final resp = await letterRepository.getEveryNewLetters(userId: userId, count: count);
    newLettersCache = resp;

    return newLettersCache;
  }

  Future<LetterModel> receiveLetter({
    required int receiverId,
    required LetterOption letterOption,
  }) async {
    final resp = await letterRepository.receiveLetter(receiverId: receiverId, letterOption: letterOption);

    notifyListeners();
    return resp;
  }

  Future<void> sinkLetter({
    required int id,
    required UserRoleModel userRoleModel,
  }) async {
    await letterRepository.sinkLetter(id: id, userRoleModel: userRoleModel);

    notifyListeners();
  }

  Future<void> returnLetter({
    required int id,
    required UserRoleModel userRoleModel,
  }) async {
    await letterRepository.returnLetter(id: id, userRoleModel: userRoleModel);

    notifyListeners();
  }

  Future<void> disconnectLetter({
    required int id,
    required UserRoleModel userRoleModel,
  }) async {
    await letterRepository.disconnectLetter(id: id, userRoleModel: userRoleModel);

    notifyListeners();
  }

  Future<int> connectLetter({
    required int id,
    required UserRoleModel userRoleModel,
  }) async {
    final resp = await letterRepository.connectLetter(id: id, userRoleModel: userRoleModel);

    notifyListeners();
    return resp.chatRoomId!;
  }

  Future<List<LetterModel>> getLettersByUser({
    required UserRoleModel userRoleModel,
    required LetterState letterState,
  }) async {
    final resp = await letterRepository.getLettersByUser(userRoleModel: userRoleModel, letterState: letterState);
    return resp;
  }

  void logout() {
    newLettersCache = {};
  }
}