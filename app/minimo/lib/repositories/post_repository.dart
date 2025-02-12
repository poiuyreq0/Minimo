import 'package:flutter/material.dart';
import 'package:minimo/models/comment_model.dart';
import 'package:minimo/models/like_model.dart';
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
      '$_postApiUrl/posts',
      data: post.toJson(),
    );

    return resp.data['postId'];
  }

  Future<void> deletePost({
    required int postId,
  }) async {
    final resp = await _dio.delete(
      '$_postApiUrl/posts/$postId',
    );

    return resp.data['postId'];
  }

  Future<int> sendComment({
    required CommentModel comment,
  }) async {
    final resp = await _dio.post(
      '$_postApiUrl/comments',
      data: comment.toJson(),
    );

    return resp.data['commentId'];
  }

  Future<int> deleteComment({
    required int commentId,
  }) async {
    final resp = await _dio.delete(
      '$_postApiUrl/comments/$commentId',
    );

    return resp.data['commentId'];
  }

  Future<List<PostModel>> getPostsWithPaging({
    required int userId,
    required int count,
    required DateTime? lastDate,
    required bool isPostMine,
    required bool isCommentMine,
  }) async {
    final resp = await _dio.get(
      '$_postApiUrl/posts',
      queryParameters: {
        'userId': userId,
        'count': count,
        if (lastDate != null)
          'lastDate': lastDate.toIso8601String(),
        'isPostMine': isPostMine,
        'isCommentMine': isCommentMine,
      }
    );

    return resp.data.map<PostModel>(
        (post) => PostModel.fromJson(post)
    ).toList();
  }

  Future<PostModel> getPost({
    required int postId,
    required int userId,
  }) async {
    final resp = await _dio.get(
        '$_postApiUrl/posts/$postId',
        queryParameters: {
          'userId': userId,
        }
    );

    return PostModel.fromJson(resp.data);
  }

  Future<LikeModel> updatePostLikeNum({
    required int postId,
    required int userId,
  }) async {
    final resp = await _dio.post(
        '$_postApiUrl/posts/$postId/like',
        queryParameters: {
          'userId': userId,
        }
    );

    return LikeModel.fromJson(resp.data);
  }

  Future<LikeModel> updateCommentLikeNum({
    required int commentId,
    required int userId,
  }) async {
    final resp = await _dio.post(
        '$_postApiUrl/comments/$commentId/like',
        queryParameters: {
          'userId': userId,
        }
    );

    return LikeModel.fromJson(resp.data);
  }
}