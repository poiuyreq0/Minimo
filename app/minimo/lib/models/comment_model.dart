import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
class CommentModel with _$CommentModel{
  const factory CommentModel({
    required int id,
    required int postId,
    int? parentCommentId,
    required int writerId,
    required String writerNickname,
    required String content,
    required int likeNum,
    required bool isVisible,
    required DateTime createdDate,
    required bool isLikeSet,
    List<CommentModel>? comments,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
}