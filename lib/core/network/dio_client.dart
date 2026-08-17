import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../constants/http_status.dart';
import '../error/exceptions.dart';
import '../storage/local_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/connectivity_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// Thin wrapper around [Dio] that owns configuration, cancellation and the
/// translation of transport errors into [AppException]s.
class DioClient {
  DioClient({Dio? dio, required LocalStorage storage}) : _dio = dio ?? Dio() {
    _dio
      ..options = BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        responseType: ResponseType.json,
        headers: const <String, String>{'Accept': 'application/json'},
        // We validate status codes ourselves so 4xx/5xx reach [_mapError].
        validateStatus: HttpStatus.isSuccess,
      )
      ..interceptors.addAll(<Interceptor>[
        // First: reject fast (real connectivity check) rather than let a
        // genuinely offline request sit until Dio's own connectTimeout —
        // see ConnectivityInterceptor's doc comment for why that matters.
        ConnectivityInterceptor(),
        AuthInterceptor(storage),
        RetryInterceptor(dio: _dio, maxRetries: ApiConstants.maxRetries),
        LoggingInterceptor(),
      ]);
  }

  final Dio _dio;

  Dio get raw => _dio;

  Future<T> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
      }) async {
    try {
      final Response<T> response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      final T? data = response.data;
      if (data == null) throw const ParsingException('Empty response body.');
      return _decodeIfNeeded<T>(data);
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  Future<T> post<T>(
      String path, {
        Object? body,
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
      }) async {
    try {
      final Response<T> response = await _dio.post<T>(
        path,
        data: body,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      final T? data = response.data;
      if (data == null) throw const ParsingException('Empty response body.');
      return _decodeIfNeeded<T>(data);
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  /// The API sometimes serves JSON with a `text/plain` content type, which
  /// stops Dio's own transformer from auto-decoding it — `response.data`
  /// comes back as the raw JSON string instead of a `List`/`Map`. Decode it
  /// ourselves in that case.
  T _decodeIfNeeded<T>(T data) {
    if (data is String) {
      try {
        return jsonDecode(data) as T;
      } on FormatException {
        // Not actually JSON — return as-is and let the caller's own
        // parsing/model layer report the mismatch.
        return data;
      }
    }
    return data;
  }

  /// Maps a transport error onto the app's own exception vocabulary.
  ///
  /// Written as an expression switch with a `_` fallback rather than one
  /// `case` per enum value: dio adds new [DioExceptionType]s between minor
  /// versions, and an unmatched one must still degrade to a plain server
  /// error the UI can show — never an `UnimplementedError` thrown at the
  /// user mid-request.
  AppException _mapError(DioException error) => switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout =>
    const TimeoutException(),
    DioExceptionType.connectionError => const NetworkException(),
    DioExceptionType.cancel => const CancelledException(),
    DioExceptionType.badCertificate =>
    const ServerException('Could not verify the server certificate.'),
    DioExceptionType.badResponse => _mapStatusCode(error),
    _ => const ServerException('Unexpected network error.'),
  };

  AppException _mapStatusCode(DioException error) {
    final int? code = error.response?.statusCode;
    final String message = _messageFromBody(error.response?.data) ??
        'The server responded with ${code ?? 'an error'}.';

    return switch (code) {
      HttpStatus.unauthorized ||
      HttpStatus.forbidden =>
          UnauthorizedException(message),
      HttpStatus.notFound => NotFoundException(message),
      HttpStatus.internalServerError => ServerException(
        'The service is unavailable. Try again shortly.',
        statusCode: code,
      ),
      _ => ServerException(message, statusCode: code),
    };
  }

  String? _messageFromBody(dynamic body) {
    if (body is Map<String, dynamic>) {
      final Object? message = body['message'] ?? body['error'];
      if (message is String && message.isNotEmpty) return message;
    }
    return null;
  }
}