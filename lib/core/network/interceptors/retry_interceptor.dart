import 'package:dio/dio.dart';

import '../../constants/api_constants.dart';

/// Retries idempotent GET requests on transient connectivity errors.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.maxRetries = ApiConstants.maxRetries,
    this.backoffStep = ApiConstants.retryBackoffStep,
  }) : _dio = dio;

  final Dio _dio;
  final int maxRetries;

  /// Linear backoff unit — attempt n waits `backoffStep * n`.
  final Duration backoffStep;

  static const String _attemptKey = 'retry_attempt';
  static const String _idempotentMethod = 'GET';
  static const int _firstAttempt = 0;

  static const Set<DioExceptionType> _retryableTypes = <DioExceptionType>{
    DioExceptionType.connectionTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.sendTimeout,
  };

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final RequestOptions options = err.requestOptions;
    final int attempt = (options.extra[_attemptKey] as int?) ?? _firstAttempt;

    final bool shouldRetry = options.method.toUpperCase() == _idempotentMethod &&
        attempt < maxRetries &&
        _retryableTypes.contains(err.type);

    if (!shouldRetry) {
      handler.next(err);
      return;
    }

    final int nextAttempt = attempt + 1;
    options.extra[_attemptKey] = nextAttempt;
    await Future<void>.delayed(backoffStep * nextAttempt);

    try {
      final Response<dynamic> response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (error) {
      handler.next(error);
    }
  }
}
