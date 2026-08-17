import '../constants/http_status.dart';

/// Low-level exceptions thrown by the data layer.
/// They never cross into presentation — repositories map them to [Failure]s.
sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => '$runtimeType($statusCode): $message';
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection.']);
}

class TimeoutException extends AppException {
  const TimeoutException([super.message = 'The request timed out.']);
}

class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Session expired.'])
      : super(statusCode: HttpStatus.unauthorized);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found.'])
      : super(statusCode: HttpStatus.notFound);
}

class ParsingException extends AppException {
  const ParsingException([super.message = 'Unexpected response format.']);
}

class CancelledException extends AppException {
  const CancelledException([super.message = 'Request cancelled.']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Local storage failure.']);
}
