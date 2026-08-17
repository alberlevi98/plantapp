import 'package:dio/dio.dart';

import '../../constants/http_status.dart';
import '../../storage/local_storage.dart';

/// Attaches the bearer token when one is stored.
/// The case API is public, but the hook is here so auth can be added without
/// touching call sites.
class AuthInterceptor extends Interceptor {
  const AuthInterceptor(this._storage);

  final LocalStorage _storage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String? token = _storage.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      _storage.clearAccessToken();
    }
    handler.next(err);
  }
}
