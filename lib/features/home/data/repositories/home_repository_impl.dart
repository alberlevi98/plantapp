import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/network/result.dart';
import '../../domain/entities/plant_category.dart';
import '../../domain/entities/question.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({
    required HomeRemoteDataSource remote,
    required NetworkInfo networkInfo,
  })  : _remote = remote,
        _networkInfo = networkInfo;

  final HomeRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<List<PlantCategory>>> getCategories() => _guard(
        () async {
          final List<CategoryModel> models = await _remote.getCategories();
          return models.map((CategoryModel m) => m.toEntity()).toList(growable: false);
        },
      );

  @override
  Future<Result<List<Question>>> getQuestions() => _guard(
        () async {
          final List<QuestionModel> models = await _remote.getQuestions();
          final List<Question> questions =
              models.map((QuestionModel m) => m.toEntity()).toList()
                ..sort((Question a, Question b) => (a.order ?? 0).compareTo(b.order ?? 0));
          return questions;
        },
      );

  /// Single place where exceptions become [Failure]s.
  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    if (!await _networkInfo.isConnected) {
      return Result<T>.failure(const Failure.network());
    }
    try {
      return Result<T>.success(await action());
    } on AppException catch (error) {
      return Result<T>.failure(Failure.fromException(error));
    } on Object catch (error) {
      return Result<T>.failure(Failure.fromException(error));
    }
  }
}
