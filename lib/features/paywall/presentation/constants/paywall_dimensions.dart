/// Layout tokens that only the paywall uses.
abstract final class PaywallDimensions {
  // --- Feature strip ------------------------------------------------------
  static const double featureCardWidth = 155;
  static const double featureListViewHeight = 124;
  static const double featureCardIconSize = 36;

  // --- Plan tiles ---------------------------------------------------------
  static const double planTileHeight = 63;
  static const double planTilePadding = 14;

  /// The "Save 50%" corner badge.
  static const double badgeHorizontalPadding = 10;

  /// Diameter of the selection dot.
  static const double radioDotSize = 24;

  /// The filled centre is a third of the dot.
  static const double radioDotInnerRatio = 1 / 3;

  // --- Chrome -------------------------------------------------------------
  /// Diameter of the circular close button's visible disc. Its tap target is
  /// grown separately to Material's 48dp minimum.
  static const double closeButtonSize = 24;

  /// Inset of that button from the top-right corner of the screen.
  static const double closeButtonInset = 16;

  /// Gap between the trial disclaimer and the legal links below it.
  static const double disclaimerToLinksSpacing = 6;
}

/// Non-layout paywall constants.
abstract final class PaywallConstants {
  /// The plan preselected when the paywall opens — the yearly one, which the
  /// design highlights with the "Save 50%" badge.
  static const int initialPlanIndex = 1;
}
