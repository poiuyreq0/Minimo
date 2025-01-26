import 'package:flutter/material.dart';
import 'package:minimo/models/post_model.dart';
import 'package:minimo/utils/dio_util.dart';
import 'package:minimo/utils/url_util.dart';

class PostRepository {
  final _dio = DioUtil.getDio();
  final _postApiUrl = UrlUtil.postApi;

  Future<int> createPost({
    required PostModel post,
  }) async {
    final resp = await _dio.post(
      _postApiUrl,
      data: post.toJson(),
    );

    return resp.data['postId'];
  }

  Future<List<PostModel>> getPosts({
    required DateTime lastDate,
  }) async {
    final resp = await _dio.get(
      '$_postApiUrl/paging',
      queryParameters: {
        'lastDate': lastDate.toIso8601String(),
      }
    );

    return resp.data.map<PostModel>(
        (post) => PostModel.fromJson(post)
    ).toList();
  }
}