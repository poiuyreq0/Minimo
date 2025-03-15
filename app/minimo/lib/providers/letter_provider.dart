import 'package:flutter/cupertino.dart';
import 'package:minimo/enums/letter_option.dart';
import 'package:minimo/enums/letter_state.dart';
import 'package:minimo/enums/user_role.dart';
import 'package:minimo/models/simple_letter_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/repositories/letter_repository.dart';

class LetterProvider extends ChangeNotifier {
  final LetterRepository letterRepository;
  List<LetterModel> lettersCache = [];
  bool homeScreenSelectorTrigger = true;
  bool letterListScreenNewLettersSelectorTrigger = true;
  bool letterListScreenPreviousLettersSelectorTrigger = true;
  bool letterDetailScreenSelectorTrigger = true;

  LetterProvider({
    required this.letterRepository,
  })  : super();

  void exitLetter() {
    _refreshLetterListScreenNewLettersSelector();
  }

  Future<void> sendLetter({
    required LetterModel letter,
  }) async {
    await letterRepository.sendLetter(letter: letter);
  }

  Future<Map<LetterOption, List<SimpleLetterModel>>> getSimpleLetters({
    required int userId,
    required int count,
  }) async {
    final resp = await letterRepository.getSimpleLetters(userId: userId, count: count);

    return resp;
  }

  Future<LetterModel> receiveLetter({
    required int receiverId,
    required LetterOption letterOption,
  }) async {
    final resp = await letterRepository.receiveLetter(receiverId: receiverId, letterOption: letterOption);

    _refreshHomeScreenSelector();
    return resp;
  }

  Future<void> returnLetter({
    required int letterId,
    required int userId,
    required UserRole userRole,
  }) async {
    await letterRepository.returnLetter(letterId: letterId, userId: userId, userRole: userRole);
  }

  Future<void> disconnectLetter({
    required int letterId,
    required int userId,
    required UserRole userRole,
  }) async {
    await letterRepository.disconnectLetter(letterId: letterId, userId: userId, userRole: userRole);
  }

  Future<void> connectLetter({
    required int letterId,
    required int userId,
    required UserRole userRole,
  }) async {
    await letterRepository.connectLetter(letterId: letterId, userId: userId, userRole: userRole);

    _refreshLetterDetailScreenSelector();
  }

  Future<List<LetterModel>> getLettersByUserWithPaging({
    required int userId,
    required UserRole userRole,
    required LetterState letterState,
    required int count,
    required bool isFirst,
  }) async {
    DateTime? lastDate;
    if (isFirst) {
      lastDate = null;
    } else {
      if (lettersCache.isEmpty) {
        lastDate = DateTime.now();
      } else {
        if (letterState == LetterState.CONNECTED) {
          lastDate = lettersCache.last.connectedDate!;
        } else if (userRole == UserRole.SENDER) {
          lastDate = lettersCache.last.createdDate!;
        } else {
          lastDate = lettersCache.last.receivedDate!;
        }
      }
    }

    final resp = await letterRepository.getLettersByUserWithPaging(userId: userId, userRole: userRole, letterState: letterState, count: count, lastDate: lastDate);
    if (isFirst) {
      lettersCache = resp;
    } else {
      lettersCache.addAll(resp);
      _refreshLetterListScreenPreviousLettersSelector();
    }

    return lettersCache;
  }

  Future<LetterModel> getLetterByUser({
    required int letterId,
    required int userId,
    required UserRole userRole,
  }) async {
    final resp = await letterRepository.getLetterByUser(letterId: letterId, userId: userId, userRole: userRole);
    return resp;
  }

  void refreshLetterListScreenNewLetters() {
    _refreshLetterListScreenNewLettersSelector();
  }

  void refreshLetterDetailScreen() {
    _refreshLetterDetailScreenSelector();
  }

  void _refreshHomeScreenSelector() {
    homeScreenSelectorTrigger = !homeScreenSelectorTrigger;
    notifyListeners();
  }

  void _refreshLetterListScreenNewLettersSelector() {
    letterListScreenNewLettersSelectorTrigger = !letterListScreenNewLettersSelectorTrigger;
    notifyListeners();
  }

  void _refreshLetterListScreenPreviousLettersSelector() {
    letterListScreenPreviousLettersSelectorTrigger = !letterListScreenPreviousLettersSelectorTrigger;
    notifyListeners();
  }

  void _refreshLetterDetailScreenSelector() {
    letterDetailScreenSelectorTrigger = !letterDetailScreenSelectorTrigger;
    notifyListeners();
  }

  void cleanCache() {
    lettersCache = [];
  }
}