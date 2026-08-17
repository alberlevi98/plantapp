/// The HTTP status codes this app reasons about.
///
/// `dart:io`'s `HttpStatus` is not available on web, so the handful of codes
/// the error mapper cares about are declared here instead of appearing as
/// bare integers in a `switch`.
abstract final class HttpStatus {
  /// Inclusive lower bound of the range treated as success.
  static const int ok = 200;

  /// Exclusive upper bound of that range.
  static const int multipleChoices = 300;

  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int internalServerError = 500;

  /// True when [code] is a 2xx.
  static bool isSuccess(int? code) =>
      code != null && code >= ok && code < multipleChoices;
}
