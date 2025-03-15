import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:minimo/enums/letter_state.dart';

part 'simple_letter_model.freezed.dart';
part 'simple_letter_model.g.dart';

@freezed
class SimpleLetterModel with _$SimpleLetterModel {
  const factory SimpleLetterModel({
    required int id,
    required String senderNickname,
    required String title,
  }) = _SimpleLetterModel;

  factory SimpleLetterModel.fromJson(Map<String, dynamic> json) => _$SimpleLetterModelFromJson(json);
}