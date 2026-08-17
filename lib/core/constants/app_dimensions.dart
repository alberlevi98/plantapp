/// Spacing, sizing, radius and border tokens.
///
/// This file is the single source of truth for every *number* that affects
/// layout. Widgets must never contain a raw numeric literal — they read a
/// token from here (or from their own feature's `<feature>_dimensions.dart`)
/// and scale it through `context.w/h/r`.
///
/// All values are expressed in the design units of the Figma frame
/// ([AppDimensions.designWidth] x [AppDimensions.designHeight]).
abstract final class AppDimensions {
  /// The Figma frame the design was drawn on.
  static const double designWidth = 360;
  static const double designHeight = 800;

  // --- Spacing scale ------------------------------------------------------
  /// Explicit "no spacing", so `0` never appears inline either.
  static const double none = 0;
  static const double xxs = 2;
  static const double xs = 4;
  static const double xsPlus = 6;
  static const double sm = 8;
  static const double smPlus = 10;
  static const double md = 12;
  static const double mdPlus = 14;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  // --- Page layout --------------------------------------------------------
  /// Horizontal page gutter used on every screen: (360 - 320) / 2.
  static const double pageHorizontal = 20;
  static const double pageVerticalSpace = 22;
  static const double contentWidth = 320;

  // --- Shared component sizes --------------------------------------------
  static const double buttonHeight = 56;
  static const double searchBarHeight = 44;
  static const double tabBarHeight = 56;
  static const double categoryCardSize = 152;
  static const double questionCardWidth = 240;
  static const double questionCardHeight = 164;
  static const double premiumBannerHeight = 64;
  static const double errorTextWidth = 180;

  // --- Page indicator -----------------------------------------------------
  static const double pageIndicatorDotActive = 10;
  static const double pageIndicatorDotIdle = 6;
}

/// Corner radii.
abstract final class AppRadius {
  static const double none = 0;
  static const double sm = 7;
  static const double md = 12;
  static const double lg = 14;
  static const double xl = 20;

  /// Anything above half the shortest side renders as a capsule.
  static const double pill = 999;
}

/// Icon sizes that are shared across features. Feature-specific icon sizes
/// live in that feature's own dimensions file.
abstract final class AppIconSize {
  static const double xs = 14;
  static const double sm = 20;
  static const double md = 24;
  static const double lg = 26;
}

/// Border thicknesses. Named by intent, not by value, so a design change is
/// one edit here instead of a project-wide find/replace on `0.5`.
abstract final class AppBorderWidth {
  /// The barely-there outline on the search field.
  static const double hairline = 0.2;

  /// Card and unselected-tile outlines.
  static const double thin = 0.5;

  /// Dividers and the inline text underline.
  static const double regular = 1;

  /// The selected plan tile's green outline.
  static const double emphasis = 1.5;
}

/// Stroke widths for painted (non-border) elements.
abstract final class AppStrokeWidth {
  static const double progressIndicator = 2;
}

/// Elevation values. Material's defaults are deliberately overridden — this
/// design is flat.
abstract final class AppElevation {
  static const double none = 0;
}

/// `maxLines` values, so `maxLines: 2` is never an unexplained literal.
abstract final class AppTextLimits {
  static const int singleLine = 1;
  static const int twoLines = 2;
}

/// Blur radii for background effects.
abstract final class AppBlur {
  static const double backgroundBlob = 60;
}
