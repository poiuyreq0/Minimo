import 'dart:io';

import 'package:dio/dio.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/models/user_model.dart';

class UserRepository {
  final Dio _dio = Dio();
  final String _targetUrl = 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:8080/api/users';

  Future<int> createUser({
    required UserModel user,
  }) async {
    final resp = await _dio.post(
      _targetUrl,
      data: user.toJson(),
    );
    return resp.data['id'];
  }

  Future<UserModel> getUser({
    required int id,
  }) async {
    final resp = await _dio.get(
      '$_targetUrl/$id',
    );
    return UserModel.fromJson(resp.data);
  }

  Future<UserModel> getUserByEmail({
    required String email,
  }) async {
    final resp = await _dio.get(
      '$_targetUrl/email',
      queryParameters: {
        'email': email,
      },
    );
    return UserModel.fromJson(resp.data);
  }

  Future<int> getHeartNum({
    required int id,
  }) async {
    final resp = await _dio.get(
      '$_targetUrl/$id/heart-num',
    );
    return resp.data['heartNum'];
  }

  Future<UserInfoModel> updateUserInfo({
    required int id,
    required UserInfoModel userInfoModel,
  }) async {
    final resp = await _dio.post(
      '$_targetUrl/$id/update/user-info',
      data: userInfoModel.toJson(),
    );
    return UserInfoModel.fromJson(resp.data);
  }

  Future<UserModel> updateNickname({
    required int id,
    required String nickname,
  }) async {
    final resp = await _dio.post(
      '$_targetUrl/$id/update/nickname',
      data: {
        'nickname': nickname
      },
    );
    return UserModel.fromJson(resp.data);
  }

  Future<int> deleteUser({
    required int id,
  }) async {
    final resp = await _dio.delete(
      '$_targetUrl/$id',
    );
    return resp.data['id'];
  }
}