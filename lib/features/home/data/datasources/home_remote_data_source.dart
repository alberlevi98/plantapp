import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/api_list_response.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories({CancelToken? cancelToken});
  Future<List<QuestionModel>> getQuestions({CancelToken? cancelToken});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._client);

  final DioClient _client;

  @override
  Future<List<CategoryModel>> getCategories({CancelToken? cancelToken}) async {
    final dynamic body = await _client.get<dynamic>(
      ApiConstants.categories,
      cancelToken: cancelToken,
    );
    return ApiListResponse.parse<CategoryModel>(body, CategoryModel.fromJson);
  }

  @override
  Future<List<QuestionModel>> getQuestions({CancelToken? cancelToken}) async {
    final dynamic body = await _client.get<dynamic>(
      ApiConstants.questions,
      cancelToken: cancelToken,
    );
    return ApiListResponse.parse<QuestionModel>(body, QuestionModel.fromJson);
  }
}
