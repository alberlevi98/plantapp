import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/question.dart';
import 'image_url_converter.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

/// Immutable DTO for `GET /getQuestions`.
@freezed
abstract class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required int id,
    @Default('') String title,
    String? subtitle,
    @ImageUrlConverter() @JsonKey(name: 'image_uri') @Default('') String imageUrl,
    String? uri,
    int? order,
  }) = _QuestionModel;

  const QuestionModel._();

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Question toEntity() => Question(
        id: id,
        title: title,
        subtitle: subtitle,
        imageUrl: imageUrl,
        uri: uri,
        order: order,
      );
}
