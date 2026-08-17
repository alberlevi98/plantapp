import '../../../../core/network/result.dart';
import '../entities/plant_category.dart';
import '../entities/question.dart';

/// Domain-owned contract. The data layer implements it; the domain layer never
/// depends on Dio, JSON or any package detail.
abstract interface class HomeRepository {
  Future<Result<List<PlantCategory>>> getCategories();
  Future<Result<List<Question>>> getQuestions();
}
