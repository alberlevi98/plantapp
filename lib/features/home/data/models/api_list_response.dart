import '../../../../core/error/exceptions.dart';

/// Normalises the two envelope shapes the case API uses: a bare JSON array,
/// or an object with the collection under `data`.
abstract final class ApiListResponse {
  static List<T> parse<T>(
      dynamic body,
      T Function(Map<String, dynamic> json) fromJson,
      ) {
    final List<dynamic> raw = switch (body) {
      final List<dynamic> list => list,
      final Map<String, dynamic> map when map['data'] is List =>
      map['data'] as List<dynamic>,
      final Map<String, dynamic> map when map['result'] is List =>
      map['result'] as List<dynamic>,
      _ => throw const ParsingException('Expected a list in the response body.'),
    };

    try {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(fromJson)
          .toList(growable: false);
    } on Object catch (_) {
      throw const ParsingException('A list item did not match the expected model.');
    }
  }
}