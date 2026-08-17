/// Screen-width thresholds, in logical pixels.
abstract final class AppBreakpoints {
  /// Below the design frame's own width — phones narrower than the mockup.
  static const double compact = 360;

  /// Tablet / foldable territory, where the category grid gains a column.
  static const double expanded = 600;
}

/// Bounds applied to text scaling.
abstract final class AppScale {
  /// Clamp on the *device* scale factor (design width / screen width), so
  /// type never becomes unreadable on a very small phone or comically large
  /// on a tablet.
  static const double minDeviceText = 0.85;
  static const double maxDeviceText = 1.2;

  /// Clamp on the *OS accessibility* text scale. The lower bound stops the
  /// system setting from shrinking text below the design size; the upper
  /// bound is Android's own "Largest" ceiling, and matches WCAG 1.4.4's
  /// request that text stay usable up to 200%.
  static const double minSystemText = 1;
  static const double maxSystemText = 2;

  /// Divisor used when centring an element on an edge (half of its size).
  static const double half = 2;
}
