import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Request/response logging. Silent in release builds.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '--> ${options.method} ${options.uri}',
        name: 'http',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '<-- ${response.statusCode} ${response.requestOptions.uri}',
        name: 'http',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        'xxx ${err.response?.statusCode ?? err.type.name} ${err.requestOptions.uri}',
        name: 'http',
        error: err.message,
      );
    }
    handler.next(err);
  }
}
