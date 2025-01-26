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
      '$_letterApiUrl/send',
      data: letter.toJson(),
    );
    return resp.data['letterId'];
  }

  Future<Map<LetterOption, List<SimpleLetterModel>>> getEveryNewLetters({
    required int userId,
    required int count,
  }) async {
    final resp = await _dio.get(
      '$_letterApiUrl/new/every',
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
      '$_letterApiUrl/receive',
      queryParameters: {
        'receiverId': receiverId,
        'letterOption': letterOption.name,
      },
    );
    return LetterModel.fromJson(resp.data);
  }

  Future<int> sinkLetter({
    required int letterId,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/$letterId/sink',
    );
    return resp.data['letterId'];
  }

  Future<int> returnLetter({
    required int letterId,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/$letterId/return',
    );
    return resp.data['letterId'];
  }

  Future<int> disconnectLetter({
    required int letterId,
    required int userId,
    required UserRole userRole,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/$letterId/disconnect',
      queryParameters: {
        'userId': userId,
        'userRole': userRole.name,
      },
    );
    return resp.data['letterId'];
  }

  Future<int> connectLetter({
    required int letterId,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/$letterId/connect',
    );
    return resp.data['chatRoomId'];
  }

  Future<List<LetterModel>> getLettersByUser({
    required int userId,
    required UserRole userRole,
    required LetterState letterState,
  }) async {
    final resp = await _dio.get(
      '$_letterApiUrl/user',
      queryParameters: {
        'userId': userId,
        'userRole': userRole.name,
        'letterState': letterState.name,
      },
    );

    return resp.data.map<LetterModel>(
            (letter) => LetterModel.fromJson(letter)
    ).toList();
  }

  Future<LetterModel> getLetterByUser({
    required int letterId,
  }) async {
    final resp = await _dio.get(
      '$_letterApiUrl/$letterId/user',
    );

    return LetterModel.fromJson(resp.data);
  }
}