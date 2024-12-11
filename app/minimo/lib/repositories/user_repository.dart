import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minimo/utils/url_util.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/models/user_model.dart';

class UserRepository {
  final Dio _dio = Dio();
  final String _userApiUrl = UrlUtil.userApi;

  UserRepository() {
    _dio.interceptors.add(InterceptorsWrapper(
        onError: (error, handler) {
          if (error.response?.statusCode == HttpStatus.notFound) {
            handler.resolve(Response(
              requestOptions: error.requestOptions,
              data: null,
              statusCode: HttpStatus.notFound,
            ));
          } else {
            handler.next(error);
          }
        }
    ));
  }

  Future<UserModel?> getUser({
    required int id,
  }) async {
    final resp = await _dio.get(
      '$_userApiUrl/$id',
    );

    if (resp.data == null) {
      return null;
    }
    return UserModel.fromJson(resp.data);
  }

  Future<UserModel?> getUserByEmail({
    required String email,
  }) async {
    final resp = await _dio.get(
      '$_userApiUrl/email',
      queryParameters: {
        'email': email,
      },
    );

    if (resp.data == null) {
      return null;
    }
    return UserModel.fromJson(resp.data);
  }

  Future<int> createUser({
    required UserModel user,
  }) async {
    final resp = await _dio.post(
      _userApiUrl,
      data: user.toJson(),
    );
    return resp.data['id'];
  }

  Future<int> getHeartNum({
    required int id,
  }) async {
    final resp = await _dio.get(
      '$_userApiUrl/$id/heart-num',
    );
    return resp.data;
  }

  Future<int> updateImage({
    required int id,
    required XFile image,
  }) async {
    FormData imageData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path, filename: image.name),
    });

    final resp = await _dio.post(
      '$_userApiUrl/$id/update/image',
      data: imageData,
    );
    return resp.data['id'];
  }

  Future<UserInfoModel> updateUserInfo({
    required int id,
    required UserInfoModel userInfoModel,
  }) async {
    final resp = await _dio.post(
      '$_userApiUrl/$id/update/user-info',
      data: userInfoModel.toJson(),
    );
    return UserInfoModel.fromJson(resp.data);
  }

  Future<UserModel> updateNickname({
    required int id,
    required String nickname,
  }) async {
    final resp = await _dio.post(
      '$_userApiUrl/$id/update/nickname',
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
      '$_userApiUrl/$id',
    );
    return resp.data['id'];
  }
}