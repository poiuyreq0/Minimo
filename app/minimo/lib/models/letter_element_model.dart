import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:minimo/enums/letter_state.dart';

part 'letter_element_model.freezed.dart';
part 'letter_element_model.g.dart';

@freezed
class LetterElementModel with _$LetterElementModel {
  const factory LetterElementModel({
    required int id,
    required String senderNickname,
    required String title,
    LetterState? letterState,
  }) = _LetterElementModel;

  factory LetterElementModel.fromJson(Map<String, dynamic> json) => _$LetterElementModelFromJson(json);
}