import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment_model.dart';
import 'post_content_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel{
  const factory PostModel({
    required int id,
    required int writerId,
    required String writerNickname,
    List<CommentModel>? comments,
    required PostContentModel postContent,
    required int likeNum,
    bool? isLikeSet,
    required int commentNum,
    required DateTime createdDate,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
}