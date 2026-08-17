import 'package:equatable/equatable.dart';

import '../error/failure.dart';

/// A success/failure union used everywhere instead of throwing across layers.
///
/// Plain `sealed` class — no code generation, exhaustive `switch` for free.
/// (Same freezed-2.5-vs-3-syntax issue as [Failure]; see the note there.)
sealed class Result<T> extends Equatable {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = ResultFailure<T>;

  bool get isSuccess => this is Success<T>;

  T? get dataOrNull => switch (this) {
        Success<T>(:final T data) => data,
        ResultFailure<T>() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        ResultFailure<T>(:final Failure failure) => failure,
      };

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        Success<T>(:final T data) => onSuccess(data),
        ResultFailure<T>(:final Failure failure) => onFailure(failure),
      };
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  List<Object?> get props => <Object?>[data];
}

final class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => <Object?>[failure];
}
