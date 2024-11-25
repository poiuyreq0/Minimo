import 'package:flutter/cupertino.dart';
import 'package:minimo/consts/letter_option.dart';
import 'package:minimo/consts/letter_state.dart';
import 'package:minimo/consts/user_role.dart';
import 'package:minimo/models/letter_element_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/models/user_role_model.dart';
import 'package:minimo/repositories/letter_repository.dart';

class LetterProvider extends ChangeNotifier {
  final LetterRepository letterRepository;

  Map<LetterOption, List<LetterElementModel>> _letterElementsCache = {};
  Map<LetterOption, List<LetterElementModel>> get letterElementsCache => _letterElementsCache;

  LetterProvider({
    required this.letterRepository,
  })  : super();

  Future<void> sendLetter({
    required LetterModel letterModel,
  }) async {
    await letterRepository.sendLetter(letterModel: letterModel);
  }

  Future<Map<LetterOption, List<LetterElementModel>>> getLettersByEveryOption({
    required int userId,
    required int count,
  }) async {
    final resp = await letterRepository.getLettersByEveryOption(userId: userId, count: count);
    _letterElementsCache = resp;

    return _letterElementsCache;
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

  Future<void> connectLetter({
    required int id,
    required UserRoleModel userRoleModel,
  }) async {
    await letterRepository.connectLetter(id: id, userRoleModel: userRoleModel);

    notifyListeners();
  }

  Future<void> disconnectLetter({
    required int id,
    required UserRoleModel userRoleModel,
  }) async {
    await letterRepository.disconnectLetter(id: id, userRoleModel: userRoleModel);

    notifyListeners();
  }

  Future<List<LetterModel>> getLetters({
    required UserRoleModel userRoleModel,
    required LetterState letterState,
  }) async {
    final resp = await letterRepository.getLetters(userRoleModel: userRoleModel, letterState: letterState);

    return resp;
  }

  void logout() {
    _letterElementsCache = {};
  }

  Future<int> getChatRoomId({
    required int id,
  }) async {
    final resp = await letterRepository.getChatRoomId(id: id);

    return resp;
  }
}