import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minimo/enums/user_role.dart';
import 'package:minimo/utils/dio_util.dart';
import 'package:minimo/utils/url_util.dart';
import 'package:minimo/enums/letter_option.dart';
import 'package:minimo/enums/letter_state.dart';
import 'package:minimo/models/simple_letter_model.dart';
import 'package:minimo/models/letter_model.dart';

class LetterRepository {
  final _dio = DioUtil.getDio();
  final _letterApiUrl = UrlUtil.letterApi;

  Future<int> sendLetter({
    required LetterModel letter,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/letters',
      data: letter.toJson(),
    );
    return resp.data['letterId'];
  }

  Future<Map<LetterOption, List<SimpleLetterModel>>> getSimpleLetters({
    required int userId,
    required int count,
  }) async {
    final resp = await _dio.get(
      '$_letterApiUrl/letters/simple',
      queryParameters: {
        'userId': userId,
        'count': count,
      },
    );

    return Map.fromEntries(
      LetterOption.values.map<MapEntry<LetterOption, List<SimpleLetterModel>>>((letterOption) {
        final letters = resp.data[letterOption.name].map<SimpleLetterModel>(
                (simpleLetter) => SimpleLetterModel.fromJson(simpleLetter)
        ).toList();

        return MapEntry(letterOption, letters);
      }),
    );
  }

  Future<LetterModel> receiveLetter({
    required int receiverId,
    required LetterOption letterOption,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/letters/receive',
      queryParameters: {
        'receiverId': receiverId,
        'letterOption': letterOption.name,
      },
    );
    return LetterModel.fromJson(resp.data);
  }

  Future<int> returnLetter({
    required int letterId,
    required int userId,
    required UserRole userRole,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/letters/$letterId/return',
      queryParameters: {
        'userId': userId,
        'userRole': userRole.name,
      },
    );
    return resp.data['letterId'];
  }

  Future<int> disconnectLetter({
    required int letterId,
    required int userId,
    required UserRole userRole,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/letters/$letterId/disconnect',
      queryParameters: {
        'userId': userId,
        'userRole': userRole.name,
      },
    );
    return resp.data['letterId'];
  }

  Future<int> connectLetter({
    required int letterId,
    required int userId,
    required UserRole userRole,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/letters/$letterId/connect',
      queryParameters: {
        'userId': userId,
        'userRole': userRole.name,
      },
    );
    return resp.data['letterId'];
  }

  Future<List<LetterModel>> getLettersByUserWithPaging({
    required int userId,
    required UserRole userRole,
    required LetterState letterState,
    required int count,
    required DateTime? lastDate,
  }) async {
    final resp = await _dio.get(
      '$_letterApiUrl/letters/user',
      queryParameters: {
        'userId': userId,
        'userRole': userRole.name,
        'letterState': letterState.name,
        'count': count,
        if (lastDate != null)
          'lastDate': lastDate.toIso8601String(),
      },
    );

    return resp.data.map<LetterModel>(
            (letter) => LetterModel.fromJson(letter)
    ).toList();
  }

  Future<List<LetterModel>> getPreviousLettersByUser({
    required int userId,
    required UserRole userRole,
    required LetterState letterState,
    required DateTime lastDate,
    required int count,
  }) async {
    final resp = await _dio.get(
      '$_letterApiUrl/letters/user/previous',
      queryParameters: {
        'userId': userId,
        'userRole': userRole.name,
        'letterState': letterState.name,
        'lastDate': lastDate.toIso8601String(),
        'count': count,
      },
    );

    return resp.data.map<LetterModel>(
            (letter) => LetterModel.fromJson(letter)
    ).toList();
  }

  Future<LetterModel> getLetterByUser({
    required int letterId,
    required int userId,
    required UserRole userRole,
  }) async {
    final resp = await _dio.get(
      '$_letterApiUrl/letters/$letterId/user',
      queryParameters: {
        'userId': userId,
        'userRole': userRole.name,
      },
    );

    return LetterModel.fromJson(resp.data);
  }
}