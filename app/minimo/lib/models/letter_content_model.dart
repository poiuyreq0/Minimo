import 'package:freezed_annotation/freezed_annotation.dart';

part 'letter_content_model.freezed.dart';
part 'letter_content_model.g.dart';

@freezed
class LetterContentModel with _$LetterContentModel {
  const factory LetterContentModel({
    required String title,
    required String content,
  }) = _LetterContentModel;

  factory LetterContentModel.fromJson(Map<String, dynamic> json) => _$LetterContentModelFromJson(json);
}