/// Endpoints and transport tuning supplied with the recruitment case.
///
/// NOTE: the base host was OCR-garbled in the PDF (`jtg6beeeta` vs
/// `jtq6bessta`). Confirm the exact host from the original brief before
/// running against the live API — only [baseUrl] needs to change.
abstract final class ApiConstants {
  static const String baseUrl = 'https://dummy-api-jtg6bessta-ey.a.run.app';
  static const String categories = '/getCategories';
  static const String questions = '/getQuestions';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);

  /// How many times a failed idempotent GET is retried.
  static const int maxRetries = 2;

  /// Linear backoff: attempt n waits `retryBackoffStep * n`.
  static const Duration retryBackoffStep = Duration(milliseconds: 400);

  /// Defaults for paginated endpoints (none in this case, but the params
  /// object exists so page size isn't invented at each call site later).
  static const int defaultPage = 1;
  static const int defaultPageSize = 20;
}
