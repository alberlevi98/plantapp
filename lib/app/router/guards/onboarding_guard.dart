import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

import '../../../core/storage/local_storage.dart';
import '../app_router.dart';

/// Sends returning users straight to the home flow.
/// This is what guarantees "users who complete onboarding do not re-enter it".
class OnboardingGuard extends AutoRouteGuard {
  const OnboardingGuard(this._storage);

  final LocalStorage _storage;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Debug/profile builds always show the full flow from Get Started,
    // regardless of the stored flag — so it can be replayed and navigated
    // back through freely while testing, without reinstalling or manually
    // clearing SharedPreferences between runs. Release builds (what
    // actually ships) keep the real "onboarding is one-time only" behavior.
    if (!kDebugMode && _storage.hasCompletedOnboarding) {
      router.replaceAll(<PageRouteInfo<dynamic>>[const HomeRoute()]);
      resolver.next(false);
      return;
    }
    resolver.next();
  }
}
