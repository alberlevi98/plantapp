/// Alpha values used with `Color.withValues(alpha: ...)`.
///
/// Named by role so a designer's "make the disabled state a bit lighter"
/// is one edit, and so `0.168` never appears in a widget with no explanation.
abstract final class AppOpacity {
  static const double transparent = 0;
  static const double full = 1;

  // Text
  static const double textSecondary = 0.7;
  static const double textDisabled = 0.25;

  // Chrome
  static const double tabBarBorder = 0.1;
  static const double disabledButton = 0.4;

  // Paywall
  /// The green wash behind the selected plan tile (Figma: 16.8%).
  static const double selectedPlanWash = 0.168;

  /// The unselected radio dot's white fill.
  static const double radioDotIdle = 0.08;

  /// "Terms • Privacy • Restore" sits at half strength on the dark surface.
  static const double paywallLegalLinks = 0.5;
}
