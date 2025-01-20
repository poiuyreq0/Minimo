import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:minimo/enums/item.dart';
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
    return resp.data['userId'];
  }

  Future<int> getItemNum({
    required int userId,
    required Item item,
  }) async {
    final resp = await _dio.get(
      '$_userApiUrl/$userId/item-num',
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
        '$_userApiUrl/$userId/item-num/add',
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
      '$_userApiUrl/$userId/update/image',
      data: imageForm,
    );

    return resp.data['userId'];
  }

  Future<int> deleteImage({
    required int userId,
  }) async {
    final resp = await _dio.delete(
      '$_userApiUrl/$userId/delete/image',
    );
    return resp.data['userId'];
  }

  Future<UserInfoModel> updateUserInfo({
    required int userId,
    required UserInfoModel userInfo,
  }) async {
    final resp = await _dio.post(
      '$_userApiUrl/$userId/update/user-info',
      data: userInfo.toJson(),
    );
    return UserInfoModel.fromJson(resp.data);
  }

  Future<String> updateNickname({
    required int userId,
    required String nickname,
  }) async {
    final resp = await _dio.post(
      '$_userApiUrl/$userId/update/nickname',
      data: {
        'nickname': nickname
      },
    );
    return resp.data['nickname'];
  }

  Future<int> updateFcmToken({
    required int userId,
    required String fcmToken,
  }) async {
    final resp = await _dio.post(
      '$_userApiUrl/$userId/update/fcm-token',
      data: {
        'token': fcmToken,
      },
    );
    return resp.data['userId'];
  }

  Future<int> deleteUser({
    required int userId,
  }) async {
    final resp = await _dio.delete(
      '$_userApiUrl/$userId',
    );
    return resp.data['userId'];
  }
}