/// Home-feature asset paths.
abstract final class HomeAssets {
  static const String _home = 'assets/images/home';
  static const String _tabIcons = 'assets/images/home/tab_icons';

  static const String headerBackground = '$_home/header_background.png';
  // Prepared but not yet wired to Brightness — same status as
  // OnboardingAssets.onboardingCareForegroundDark. Ask before using.
  static const String headerBackgroundDark = '$_home/header_background_dark.png';
  static const String mailIcon = '$_home/mail_icon.png';
  static const String nextIcon = '$_home/next_icon.png';


  // Plant-detail badges — all three currently point at the same generic
  // placeholder file; each needs its own icon before shipping.
  static const String badgeSpray = '$_home/object.png';
  static const String badgeSun = '$_home/object.png';
  static const String badgeWater = '$_home/object.png';

  // Bottom tab bar
  static const String tabHomeIcon = '$_tabIcons/home_icon.png';
  static const String tabDiagnoseIcon = '$_tabIcons/diagnose_icon.png';
  static const String tabMyGardenIcon = '$_tabIcons/my_garden_icon.png';
  static const String tabProfileIcon = '$_tabIcons/profile_icon.png';
  static const String tabScanIcon = '$_tabIcons/scan_icon.png';
}