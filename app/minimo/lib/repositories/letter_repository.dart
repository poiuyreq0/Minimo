import 'dart:io';

import 'package:dio/dio.dart';
import 'package:minimo/consts/letter_option.dart';
import 'package:minimo/consts/letter_state.dart';
import 'package:minimo/models/letter_element_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/models/user_role_model.dart';

class LetterRepository {
  final _dio = Dio();
  final _targetUrl = 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:8080/api/letters';

  Future<int> sendLetter({
    required LetterModel letterModel,
  }) async {
    final resp = await _dio.post(
      '$_targetUrl/send',
      data: letterModel.toJson(),
    );
    return resp.data['id'];
  }

  Future<Map<LetterOption, List<LetterElementModel>>> getLettersByEveryOption({
    required int userId,
    required int count,
  }) async {
    final resp = await _dio.get(
      '$_targetUrl/option/every',
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
        '$_targetUrl/receive',
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
      '$_targetUrl/$id/sink',
      data: userRoleModel.toJson(),
    );
    return resp.data['id'];
  }

  Future<int> returnLetter({
    required int id,
    required UserRoleModel userRoleModel,
  }) async {
    final resp = await _dio.post(
      '$_targetUrl/$id/return',
      data: userRoleModel.toJson(),
    );
    return resp.data['id'];
  }

  Future<int> connectLetter({
    required int id,
    required UserRoleModel userRoleModel,
  }) async {
    final resp = await _dio.post(
      '$_targetUrl/$id/connect',
      data: userRoleModel.toJson(),
    );
    return resp.data['id'];
  }

  Future<int> disconnectLetter({
    required int id,
    required UserRoleModel userRoleModel,
  }) async {
    final resp = await _dio.post(
      '$_targetUrl/$id/disconnect',
      data: userRoleModel.toJson(),
    );
    return resp.data['id'];
  }

  Future<List<LetterModel>> getLetters({
    required UserRoleModel userRoleModel,
    required LetterState letterState,
  }) async {
    final resp = await _dio.get(
        _targetUrl,
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