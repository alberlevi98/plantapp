import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/plant_category.dart';
import 'image_url_converter.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Immutable DTO for `GET /getCategories`.
@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required int id,
    @Default('') String title,
    @ImageUrlConverter() @JsonKey(name: 'image') @Default('') String imageUrl,
    int? rank,
  }) = _CategoryModel;

  const CategoryModel._();

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  PlantCategory toEntity() => PlantCategory(
        id: id,
        title: title,
        imageUrl: imageUrl,
        rank: rank,
      );
}
