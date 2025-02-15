import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:minimo/enums/item.dart';
import 'package:minimo/enums/report_reason.dart';
import 'package:minimo/models/user_ban_record_model.dart';
import 'package:minimo/utils/url_util.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/models/user_model.dart';

import '../utils/dio_util.dart';

class UserRepository {
  final Dio _dio = DioUtil.getDio();
  final String _userApiUrl = UrlUtil.userApi;

  Future<UserModel?> getUserByEmail({
    required String email,
  }) async {
    final resp = await _dio.get(
      '$_userApiUrl/users/email',
      queryParameters: {
        'email': email,
      },
    );

    if (resp.data == '') {
      return null;
    }
    return UserModel.fromJson(resp.data);
  }

  Future<int> createUser({
    required UserModel user,
  }) async {
    final resp = await _dio.post(
      '$_userApiUrl/users',
      data: user.toJson(),
    );
    return resp.data['userId'];
  }

  Future<int> getItemNum({
    required int userId,
    required Item item,
  }) async {
    final resp = await _dio.get(
      '$_userApiUrl/users/$userId/item-num',
      queryParameters: {
        'item': item.name,
      }
    );
    return resp.data['itemNum'];
  }

  Future<int> addItemNum({
    required int userId,
    required Item item,
    required int amount,
  }) async {
    final resp = await _dio.post(
        '$_userApiUrl/users/$userId/item-num/add',
        queryParameters: {
          'item': item.name,
          'amount': amount,
        }
    );
    return resp.data['itemNum'];
  }

  Future<int> updateImage({
    required int userId,
    required String nickname,
    required Uint8List imageBytes,
  }) async {
    FormData imageForm = FormData.fromMap({
      'image': MultipartFile.fromBytes(
        imageBytes,
        filename: '$nickname.jpg',
        contentType: MediaType('image', 'jpg'),
      ),
    });

    final resp = await _dio.post(
      '$_userApiUrl/users/$userId/image/update',
      data: imageForm,
    );

    return resp.data['userId'];
  }

  Future<int> deleteImage({
    required int userId,
  }) async {
    final resp = await _dio.delete(
      '$_userApiUrl/users/$userId/image',
    );
    return resp.data['userId'];
  }

  Future<int> updateUserInfo({
    required int userId,
    required UserInfoModel userInfo,
  }) async {
    final resp = await _dio.post(
      '$_userApiUrl/users/$userId/user-info/update',
      data: userInfo.toJson(),
    );
    return resp.data['userId'];
  }

  Future<int> updateNickname({
    required int userId,
    required String nickname,
  }) async {
    final resp = await _dio.post(
      '$_userApiUrl/users/$userId/nickname/update',
      queryParameters: {
        'nickname': nickname
      },
    );
    return resp.data['userId'];
  }

  Future<int> updateFcmToken({
    required int userId,
    required String fcmToken,
  }) async {
    final resp = await _dio.post(
      '$_userApiUrl/users/$userId/fcm-token/update',
      data: {
        'token': fcmToken,
      },
    );
    return resp.data['userId'];
  }

  Future<int> deleteFcmToken({
    required int userId,
  }) async {
    final resp = await _dio.delete(
      '$_userApiUrl/users/$userId/fcm-token',
    );
    return resp.data['userId'];
  }

  Future<Map<int, UserBanRecordModel>> banUser({
    required int userId,
    required int targetId,
    required String targetNickname,
  }) async {
    final resp = await _dio.post(
      '$_userApiUrl/users/$userId/ban',
      queryParameters: {
        'targetId': targetId,
        'targetNickname': targetNickname,
      },
    );

    return Map.fromEntries(
      resp.data.keys.map<MapEntry<int, UserBanRecordModel>>((targetId) {
        return MapEntry(int.parse(targetId), UserBanRecordModel.fromJson(resp.data[targetId]));
      })
    );
  }

  Future<Map<int, UserBanRecordModel>> unbanUser({
    required int userId,
    required int targetId,
  }) async {
    final resp = await _dio.post(
      '$_userApiUrl/users/$userId/unban',
      queryParameters: {
        'targetId': targetId,
      },
    );

    return Map.fromEntries(
        resp.data.keys.map<MapEntry<int, UserBanRecordModel>>((targetId) {
          return MapEntry(int.parse(targetId), UserBanRecordModel.fromJson(resp.data[targetId]));
        })
    );
  }

  Future<int> reportUser({
    required int userId,
    required int targetId,
    required ReportReason reportReason,
  }) async {
    final resp = await _dio.post(
      '$_userApiUrl/users/$userId/report',
      queryParameters: {
        'targetId': targetId,
        'reportReason': reportReason.name,
      },
    );

    return resp.data['userId'];
  }

  Future<int> deleteUser({
    required int userId,
  }) async {
    final resp = await _dio.delete(
      '$_userApiUrl/users/$userId',
    );
    return resp.data['userId'];
  }
}