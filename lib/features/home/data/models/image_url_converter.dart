import 'package:freezed_annotation/freezed_annotation.dart';

/// The API returns image fields either as a plain URL string or as a nested
/// object (`{"url": "..."}` / `{"data": {"attributes": {"url": "..."}}}`).
/// This converter normalises all of those shapes to a single [String].
class ImageUrlConverter implements JsonConverter<String, dynamic> {
  const ImageUrlConverter();

  @override
  String fromJson(dynamic json) => _extract(json) ?? '';

  @override
  dynamic toJson(String object) => object;

  String? _extract(dynamic value) {
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      final Object? direct = value['url'] ?? value['uri'] ?? value['image_uri'];
      if (direct is String) return direct;
      return _extract(value['data'] ?? value['attributes']);
    }
    return null;
  }
}
