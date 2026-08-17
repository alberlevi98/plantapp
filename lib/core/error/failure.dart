import 'package:equatable/equatable.dart';

import 'exceptions.dart';

/// Presentation-facing error type. Blocs expose these, never raw exceptions.
///
/// A plain Dart 3 `sealed` class: `switch` over it is exhaustive without any
/// code generation, and [Equatable] gives value equality for tests. This
/// used to be a `@freezed` class, but the `sealed class X with _$X` syntax
/// it relied on is freezed 3.x — this project pins freezed ^2.5.7, so it
/// failed to build. Rewriting it in plain Dart also means this core,
/// cross-cutting type no longer depends on build_runner at all.
sealed class Failure extends Equatable {
  const Failure(this.message);

  const factory Failure.network([String message]) = NetworkFailure;
  const factory Failure.timeout([String message]) = TimeoutFailure;
  const factory Failure.server(String message, {int? statusCode}) = ServerFailure;
  const factory Failure.unauthorized([String message]) = UnauthorizedFailure;
  const factory Failure.notFound([String message]) = NotFoundFailure;
  const factory Failure.parsing([String message]) = ParsingFailure;
  const factory Failure.cache([String message]) = CacheFailure;
  const factory Failure.unknown([String message]) = UnknownFailure;

  final String message;

  /// Maps a data-layer exception onto its presentation counterpart.
  factory Failure.fromException(Object error) => switch (error) {
        NetworkException(:final String message) => Failure.network(message),
        TimeoutException(:final String message) => Failure.timeout(message),
        UnauthorizedException(:final String message) => Failure.unauthorized(message),
        NotFoundException(:final String message) => Failure.notFound(message),
        ParsingException(:final String message) => Failure.parsing(message),
        CacheException(:final String message) => Failure.cache(message),
        CancelledException(:final String message) => Failure.unknown(message),
        ServerException(:final String message, :final int? statusCode) =>
          Failure.server(message, statusCode: statusCode),
        _ => const Failure.unknown(),
      };

  /// Copy shown to the user: what happened, and what to do about it.
  String get displayMessage => switch (this) {
        NetworkFailure() =>
          'You appear to be offline. Check your connection and try again.',
        TimeoutFailure() => 'The server took too long to answer. Try again.',
        UnauthorizedFailure() => 'Your session expired. Sign in again to continue.',
        NotFoundFailure() => 'We could not find what you were looking for.',
        ParsingFailure() => 'We received an unexpected response. Try again shortly.',
        CacheFailure() => 'We could not read your saved data.',
        ServerFailure(:final String message) => message,
        UnknownFailure(:final String message) => message,
      };

  bool get isRetryable => switch (this) {
        NetworkFailure() || TimeoutFailure() || ServerFailure() || UnknownFailure() => true,
        UnauthorizedFailure() || NotFoundFailure() || ParsingFailure() || CacheFailure() =>
          false,
      };

  @override
  List<Object?> get props => <Object?>[message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'The request took too long.']);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => <Object?>[message, statusCode];
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Session expired.']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Nothing found here.']);
}

final class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'We could not read the response.']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not read local data.']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong.']);
}
