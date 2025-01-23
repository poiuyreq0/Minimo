import 'package:flutter/cupertino.dart';
import 'package:minimo/enums/letter_option.dart';
import 'package:minimo/enums/letter_state.dart';
import 'package:minimo/enums/user_role.dart';
import 'package:minimo/models/letter_element_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/repositories/letter_repository.dart';

class LetterProvider extends ChangeNotifier {
  final LetterRepository letterRepository;
  Map<LetterOption, List<LetterElementModel>> newLettersCache = {};
  bool homeScreenSelectorTrigger = true;
  bool letterListScreenSelectorTrigger = true;

  LetterProvider({
    required this.letterRepository,
  })  : super();

  Future<void> sendLetter({
    required LetterModel letter,
  }) async {
    await letterRepository.sendLetter(letter: letter);
  }

  // FutureBuilder
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

    _refreshHomeScreenSelector();
    return resp;
  }

  Future<void> sinkLetter({
    required int letterId,
  }) async {
    await letterRepository.sinkLetter(letterId: letterId);

    _refreshLetterListScreenSelector();
  }

  Future<void> returnLetter({
    required int letterId,
  }) async {
    await letterRepository.returnLetter(letterId: letterId);

    _refreshLetterListScreenSelector();
  }

  Future<void> disconnectLetter({
    required int letterId,
    required int userId,
    required UserRole userRole,
  }) async {
    await letterRepository.disconnectLetter(letterId: letterId, userId: userId, userRole: userRole);

    _refreshLetterListScreenSelector();
  }

  Future<int> connectLetter({
    required int letterId,
  }) async {
    final resp = await letterRepository.connectLetter(letterId: letterId);

    _refreshLetterListScreenSelector();
    return resp;
  }

  // FutureBuilder
  Future<List<LetterModel>> getLettersByUser({
    required int userId,
    required UserRole userRole,
    required LetterState letterState,
  }) async {
    final resp = await letterRepository.getLettersByUser(userId: userId, userRole: userRole, letterState: letterState);
    return resp;
  }

  Future<LetterModel> getLetterByUser({
    required int letterId,
  }) async {
    final resp = await letterRepository.getLetterByUser(letterId: letterId);
    return resp;
  }

  void _refreshHomeScreenSelector() {
    homeScreenSelectorTrigger = !homeScreenSelectorTrigger;
    notifyListeners();
  }

  void _refreshLetterListScreenSelector() {
    letterListScreenSelectorTrigger = !letterListScreenSelectorTrigger;
    notifyListeners();
  }

  void logout() {
    newLettersCache = {};
  }
}