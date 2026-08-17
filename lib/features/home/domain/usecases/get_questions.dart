import '../../../../core/network/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/question.dart';
import '../repositories/home_repository.dart';

class GetQuestions extends UseCase<List<Question>, NoParams> {
  const GetQuestions(this._repository);

  final HomeRepository _repository;

  @override
  Future<Result<List<Question>>> call(NoParams params) => _repository.getQuestions();
}
