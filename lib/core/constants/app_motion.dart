import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

/// Every duration in the app. Nothing constructs a [Duration] inline.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 600);

  /// Route transitions (onboarding crossfade, paywall rise-and-fade).
  ///
  /// Also exposed in milliseconds because auto_route's `CustomRoute` takes an
  /// `int`, and `Duration.inMilliseconds` is an instance getter — it can't be
  /// used inside a `const` initializer.
  static const int routeTransitionMs = 280;
  static const Duration routeTransition =
      Duration(milliseconds: routeTransitionMs);

  /// How long the home screen's staggered entrance runs end to end.
  static const Duration homeEntrance = Duration(milliseconds: 900);

  /// Search input debounce — long enough to skip intermediate keystrokes,
  /// short enough that the grid still feels live.
  static const Duration searchDebounce = Duration(milliseconds: 250);
}

/// Curves and offsets, so no widget hardcodes an easing or a slide distance.
abstract final class AppMotion {
  /// Content enters from slightly below its resting position.
  static const Offset enterSlideOffset = Offset(0, 0.06);
  static const Offset restOffset = Offset.zero;

  static const Curve enter = Curves.easeOut;
  static const Curve routeTransition = Curves.easeOutCubic;
  static const Curve pageSwipe = Curves.easeOutCubic;
  static const Curve resize = Curves.easeOut;
}

/// The home screen's staggered entrance timeline.
///
/// All values are fractions (0-1) of [AppDurations.homeEntrance], which is
/// what [Interval] expects. Keeping them together makes the sequencing
/// readable as a timeline instead of a scatter of decimals across a build
/// method.
abstract final class AppStagger {
  /// Bounds of the controller's own timeline.
  static const double timelineStart = 0;
  static const double timelineEnd = 1;

  /// A window may not start exactly at [timelineEnd] — [Interval] asserts
  /// `begin < end`, so the last usable start sits just below it.
  static const double maxStart = 0.999;

  // Section entry points.
  static const double headerStart = 0;
  static const double bannerStart = 0.08;
  static const double questionsStart = 0.15;
  static const double categoriesStart = 0.25;

  // How long each element's own fade/slide lasts.
  static const double sectionSpan = 0.4;
  static const double cardSpan = 0.35;

  // Per-item delay inside a list, and the cap that stops a long list from
  // pushing the tail of the stagger past the end of the timeline.
  /// Lower bound when clamping a list index into a step count.
  static const int firstStep = 0;

  static const double questionStep = 0.06;
  static const int questionMaxSteps = 8;
  static const double categoryStep = 0.04;
  static const int categoryMaxSteps = 12;
}
