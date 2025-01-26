import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
class CommentModel with _$CommentModel{
  const factory CommentModel({
    required int id,
    int? postId,
    required int writerId,
    required String writerNickname,
    List<CommentModel>? comments,
    required String content,
    required int likeNum,
    required bool isLikeSet,
    required bool isVisible,
    required DateTime createdDate,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
}