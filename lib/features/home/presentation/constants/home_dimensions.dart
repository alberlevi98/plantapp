/// Layout tokens that only the home screen uses.
/// Anything shared with another feature belongs in `core/constants` instead.
abstract final class HomeDimensions {
  // --- Header -------------------------------------------------------------
  /// Height of the decorative header artwork behind the greeting.
  static const double headerImageHeight = 175;

  /// Height of the greeting + search block drawn on top of that artwork.
  static const double headerContentHeight = 175;

  /// Distance from the top of the screen to the greeting.
  static const double headerTopOffset = 48;

  /// Gap between the search glyph and the input field.
  static const double searchIconGap = 10;

  // --- Category card ------------------------------------------------------
  /// How far in from the left edge the plant artwork starts, leaving room
  /// for the title beside it.
  static const double categoryImageLeftInset = 40;

  /// Title column width — the point where a long category name wraps.
  static const double categoryTitleWidth = 92;

  /// The artwork deliberately bleeds past the card's bottom-right corner.
  static const double categoryImageBleed = 24;

  // --- Category grid ------------------------------------------------------
  static const int gridColumnsCompact = 2;
  static const int gridColumnsExpanded = 3;

  /// Cards are square.
  static const double categoryAspectRatio = 1;

  // --- Question carousel --------------------------------------------------
  static const double questionSpacing = 10;
  static const double questionCaptionHeight = 60;
  static const double questionCaptionHorizontalPadding = 14;
  static const double questionCaptionVerticalPadding = 10;

  // --- Premium banner -----------------------------------------------------
  /// The trailing chevron sits closer to the edge than the leading icon.
  static const double premiumBannerTrailingInset = 10;
  static const double premiumChevronSize = 24;

  // --- Tab bar ------------------------------------------------------------
  static const double scanButtonSize = 66;
  static const double tabIconSize = 26;
  static const double tabIconLabelSpacing = 5;
  static const double tabItemTopSpacing = 10;
}

/// Non-layout home constants.
abstract final class HomeConstants {
  /// Tab selected when the screen opens.
  static const int initialTabIndex = 0;

  /// Boundaries of the time-of-day greeting, in 24-hour clock hours.
  static const int morningEndsHour = 12;
  static const int afternoonEndsHour = 18;
}
