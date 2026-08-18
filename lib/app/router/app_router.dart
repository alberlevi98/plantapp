import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_motion.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/get_started_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/paywall/presentation/pages/paywall_page.dart';
import 'guards/onboarding_guard.dart';

part 'app_router.gr.dart';

/// Declarative routing. The two flows from the brief are modelled explicitly:
/// the onboarding stack (Get Started -> Onboarding -> Paywall) and the home
/// flow, which replaces it entirely once onboarding is complete.
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this.onboardingGuard});

  final OnboardingGuard onboardingGuard;

  static const String getStartedPath = '/';
  static const String onboardingPath = '/onboarding';
  static const String paywallPath = '/paywall';
  static const String homePath = '/home';

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(
          page: GetStartedRoute.page,
          path: getStartedPath,
          initial: true,
          guards: <AutoRouteGuard>[onboardingGuard],
        ),
        CustomRoute<void>(
          page: OnboardingRoute.page,
          path: onboardingPath,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          duration: const Duration(milliseconds: AppDurations.routeTransitionMs),
        ),
        CustomRoute<void>(
          page: PaywallRoute.page,
          path: paywallPath,
          transitionsBuilder: _paywallTransitionsBuilder,
          duration: const Duration(milliseconds: AppDurations.routeTransitionMs),
        ),
        AutoRoute(page: HomeRoute.page, path: homePath),
      ];
}

/// Rise-and-fade used for Paywall: a small upward slide combined with an
/// opacity fade, so the sheet settles in rather than sliding the full
/// height of the screen.
Widget _paywallTransitionsBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final CurvedAnimation curved = CurvedAnimation(
    parent: animation,
    curve: AppMotion.routeTransition,
  );
  return FadeTransition(
    opacity: curved,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: AppMotion.enterSlideOffset,
        end: AppMotion.restOffset,
      ).animate(curved),
      child: child,
    ),
  );
}
