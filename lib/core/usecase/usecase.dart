import 'package:equatable/equatable.dart';

import '../constants/api_constants.dart';
import '../network/result.dart';

/// A single piece of application business logic.
/// Call it like a function: `await getCategories(NoParams())`.
abstract class UseCase<Type, Params> {
  const UseCase();

  Future<Result<Type>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => const <Object?>[];
}

class PageParams extends Equatable {
  const PageParams({
    this.page = ApiConstants.defaultPage,
    this.pageSize = ApiConstants.defaultPageSize,
  });

  final int page;
  final int pageSize;

  @override
  List<Object?> get props => <Object?>[page, pageSize];
}
