import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_content_model.freezed.dart';
part 'post_content_model.g.dart';

@freezed
class PostContentModel with _$PostContentModel{
  const factory PostContentModel({
    required String title,
    required String content,
  }) = _PostContentModel;

factory PostContentModel.fromJson(Map<String, dynamic> json) => _$PostContentModelFromJson(json);
}