/// Onboarding-feature asset paths — covers Get Started, the onboarding
/// slides, and the shared brush-stroke decoration between them (they're all
/// one screen flow / one lib/features/onboarding folder).
abstract final class OnboardingAssets {
  static const String _getStarted = 'assets/images/get_started';
  static const String _onboarding = 'assets/images/onboarding';

  // Get Started screen — full-bleed background behind the whole screen,
  // plus the phone/plant artwork drawn on top of it.
  static const String getStartedBackground = '$_getStarted/background.png';
  static const String getStartedBackgroundDark = '$_getStarted/background_dark.png';
  static const String getStartedForeground = '$_getStarted/foreground.png';

  // Onboarding — background shared by both slides, plus one foreground
  // artwork per slide.
  static const String onboardingBackground = '$_onboarding/background.png';
  static const String onboardingScanForeground = '$_onboarding/scan_foreground.png';
  static const String onboardingCareForeground = '$_onboarding/care_foreground.png';
  // Prepared but not yet wired to Brightness — the light version above is
  // what's actually shown right now regardless of theme. Ask before using.
  static const String onboardingCareForegroundDark =
      '$_onboarding/care_foreground_dark.png';

  // The hand-drawn stroke under highlighted onboarding headline words.
  static const String brushUnderline = '$_onboarding/brush.png';
  static const String brushUnderlineWhite = '$_onboarding/brush_white.png';
}