import '../../../../core/network/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/plant_category.dart';
import '../repositories/home_repository.dart';

class GetCategories extends UseCase<List<PlantCategory>, NoParams> {
  const GetCategories(this._repository);

  final HomeRepository _repository;

  @override
  Future<Result<List<PlantCategory>>> call(NoParams params) =>
      _repository.getCategories();
}
