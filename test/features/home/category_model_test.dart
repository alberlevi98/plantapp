import 'package:flutter_test/flutter_test.dart';
import 'package:plantapp/core/error/exceptions.dart';
import 'package:plantapp/features/home/data/models/api_list_response.dart';
import 'package:plantapp/features/home/data/models/category_model.dart';

void main() {
  group('CategoryModel', () {
    test('parses an image given as a plain string', () {
      final CategoryModel model = CategoryModel.fromJson(<String, dynamic>{
        'id': 1,
        'title': 'Ferns',
        'image': 'https://example.com/fern.png',
      });

      expect(model.imageUrl, 'https://example.com/fern.png');
      expect(model.toEntity().title, 'Ferns');
    });

    test('parses an image given as a nested object', () {
      final CategoryModel model = CategoryModel.fromJson(<String, dynamic>{
        'id': 2,
        'title': 'Palms',
        'image': <String, dynamic>{'url': 'https://example.com/palm.png'},
      });

      expect(model.imageUrl, 'https://example.com/palm.png');
    });

    test('falls back to an empty url when the field is missing', () {
      final CategoryModel model =
          CategoryModel.fromJson(<String, dynamic>{'id': 3, 'title': 'Vines'});
      expect(model.imageUrl, isEmpty);
    });
  });

  group('ApiListResponse', () {
    test('accepts a bare list', () {
      final List<CategoryModel> result = ApiListResponse.parse<CategoryModel>(
        <dynamic>[
          <String, dynamic>{'id': 1, 'title': 'Ferns'},
        ],
        CategoryModel.fromJson,
      );
      expect(result, hasLength(1));
    });

    test('accepts a data-wrapped list', () {
      final List<CategoryModel> result = ApiListResponse.parse<CategoryModel>(
        <String, dynamic>{
          'data': <dynamic>[
            <String, dynamic>{'id': 1, 'title': 'Ferns'},
          ],
        },
        CategoryModel.fromJson,
      );
      expect(result, hasLength(1));
    });

    test('throws ParsingException on an unexpected shape', () {
      expect(
        () => ApiListResponse.parse<CategoryModel>(42, CategoryModel.fromJson),
        throwsA(isA<ParsingException>()),
      );
    });
  });
}
