import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

/// Checks real network reachability before a request is even sent — no
/// extra package: a DNS lookup via `dart:io` is already in the SDK, and
/// checking actual reachability is arguably more accurate than an
/// interface-level check anyway (a device can show "connected to Wi-Fi"
/// while that Wi-Fi has no real internet — a captive portal, a router with
/// no uplink — and an interface-level check wouldn't catch that).
///
/// Without this, "no internet" often never surfaces as the right error at
/// all: the OS attempts the connection, gets no response, and Dio only
/// reports a *timeout* once `connectTimeout` elapses — not
/// `connectionError`. That produces the wrong [Failure] (a "server took too
/// long" message instead of "you appear to be offline"), and the user
/// waits out the full timeout to see it.
///
/// Registered first in [DioClient]'s interceptor list, so it short-circuits
/// before auth/retry/logging ever run.
class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor({
    this.probeHost = 'one.one.one.one',
    this.probeTimeout = const Duration(seconds: 3),
    // Short on purpose: HomeBloc fires getQuestions/getCategories together
    // via Future.wait (milliseconds apart), so this only needs to survive
    // that gap. It must stay well under RetryInterceptor's own backoff
    // (400ms/800ms) — otherwise a retry would read this stale cache
    // instead of re-checking, and never notice the connection came back.
    this.cacheFor = const Duration(milliseconds: 250),
  });

  /// A fast, highly-available host used only to test reachability —
  /// Cloudflare's DNS resolver, not the app's own API (the API being slow
  /// or down shouldn't be reported as "you're offline").
  final String probeHost;
  final Duration probeTimeout;

  /// How long a reachability result is trusted before re-checking. Without
  /// this, two requests fired together (HomeBloc's getQuestions and
  /// getCategories run in parallel) each pay their own DNS lookup — this
  /// lets the second one reuse the first's still-fresh answer instead.
  final Duration cacheFor;

  bool? _cachedOffline;
  DateTime? _cachedAt;

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    if (await _offline()) {
      // A rejected DioException of type connectionError — DioClient's
      // existing _mapError switch already maps this to NetworkException,
      // and RetryInterceptor already retries it, so nothing downstream
      // needs to change to recognize this.
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No internet connection.',
        ),
        true,
      );
      return;
    }

    handler.next(options);
  }

  Future<bool> _offline() async {
    final DateTime? checkedAt = _cachedAt;
    if (_cachedOffline != null &&
        checkedAt != null &&
        DateTime.now().difference(checkedAt) < cacheFor) {
      return _cachedOffline!;
    }

    final bool result = await _lookupOffline();
    _cachedOffline = result;
    _cachedAt = DateTime.now();
    return result;
  }

  Future<bool> _lookupOffline() async {
    try {
      final List<InternetAddress> result =
      await InternetAddress.lookup(probeHost).timeout(probeTimeout);
      return result.isEmpty || result.first.rawAddress.isEmpty;
    } on SocketException {
      return true;
    } on TimeoutException {
      return true;
    }
  }
}