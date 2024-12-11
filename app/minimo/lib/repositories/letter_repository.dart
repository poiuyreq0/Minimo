import 'dart:io';

import 'package:dio/dio.dart';
import 'package:minimo/utils/url_util.dart';
import 'package:minimo/enums/letter_option.dart';
import 'package:minimo/enums/letter_state.dart';
import 'package:minimo/models/letter_element_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/models/user_role_model.dart';

class LetterRepository {
  final _dio = Dio();
  final _letterApiUrl = UrlUtil.letterApi;

  Future<int> sendLetter({
    required LetterModel letterModel,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/send',
      data: letterModel.toJson(),
    );
    return resp.data['id'];
  }

  Future<Map<LetterOption, List<LetterElementModel>>> getEveryNewLetters({
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
      LetterOption.values.map<MapEntry<LetterOption, List<LetterElementModel>>>((letterOption) {
        final letters = resp.data[letterOption.name].map<LetterElementModel>(
                (letterElement) => LetterElementModel.fromJson(letterElement)
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
        data: {
          'receiverId': receiverId,
          'letterOption': letterOption.name,
        }
    );
    return LetterModel.fromJson(resp.data);
  }

  Future<int> sinkLetter({
    required int id,
    required UserRoleModel userRoleModel,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/$id/sink',
      data: userRoleModel.toJson(),
    );
    return resp.data['id'];
  }

  Future<int> returnLetter({
    required int id,
    required UserRoleModel userRoleModel,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/$id/return',
      data: userRoleModel.toJson(),
    );
    return resp.data['id'];
  }

  Future<int> disconnectLetter({
    required int id,
    required UserRoleModel userRoleModel,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/$id/disconnect',
      data: userRoleModel.toJson(),
    );
    return resp.data['id'];
  }

  Future<int> connectLetter({
    required int id,
    required UserRoleModel userRoleModel,
  }) async {
    final resp = await _dio.post(
      '$_letterApiUrl/$id/connect',
      data: userRoleModel.toJson(),
    );
    return resp.data['id'];
  }

  Future<List<LetterModel>> getLettersByUser({
    required UserRoleModel userRoleModel,
    required LetterState letterState,
  }) async {
    final resp = await _dio.get(
        '$_letterApiUrl/user',
        queryParameters: {
          'userId': userRoleModel.id,
          'userRole': userRoleModel.userRole.name,
          'letterState': letterState.name,
        }
    );

    return resp.data.map<LetterModel>(
            (letter) => LetterModel.fromJson(letter)
    ).toList();
  }
}