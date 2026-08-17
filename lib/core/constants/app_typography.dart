import 'package:flutter/widgets.dart';

/// Typography tokens.
///
/// Font sizes and line heights are both stored in **design pixels**, exactly
/// as Figma reports them, and combined at the point of use:
///
///     height: AppLineHeight.bodyLarge / AppFontSize.bodyLarge
///
/// Both operands are `const double`, so the division is still a constant
/// expression and the resulting [TextStyle] stays `const`. The upside is that
/// `22 / 16` never appears in the code — the pair reads as "22px leading on
/// 16px type", which is what the design file actually says.
abstract final class AppFontSize {
  static const double displayLarge = 28;
  static const double displayMedium = 28;
  static const double headlineSmall = 24;
  static const double titleLarge = 20;
  static const double titleMedium = 16;
  static const double button = 16;
  static const double bodyLarge = 16;
  static const double bodyMedium = 15;
  static const double bodySmall = 13;
  static const double labelSmall = 11;
  static const double terms = 11;
  static const double disclaimer = 9;

  // Paywall
  static const double paywallTitle = 27;
  static const double paywallSubtitle = 17;
  static const double planTitle = 16;
  static const double planSubtitle = 12;
  static const double badge = 12;
}

/// Line heights in design pixels — divide by the matching [AppFontSize] to
/// get Flutter's `height` multiplier.
abstract final class AppLineHeight {
  static const double displayLarge = 33;
  static const double displayMedium = 33;
  static const double headlineSmall = 28;
  static const double titleLarge = 24;
  static const double titleMedium = 21;
  static const double button = 24;
  static const double bodyLarge = 22;
  static const double bodyMedium = 20;
  static const double bodySmall = 18;
  static const double labelSmall = 13;
  static const double terms = 15;

  /// Figma gives this one as a 1.32 multiplier rather than a px value;
  /// 9 * 1.32 = 11.88, kept in px so every entry here is the same unit.
  static const double disclaimer = 11.88;

  // Paywall
  static const double paywallTitle = 32;
  static const double paywallSubtitle = 24;
  static const double planTitle = 19;
  static const double planSubtitle = 14;
  static const double badge = 18;
}

/// Letter spacing, named by the effect rather than the number.
abstract final class AppLetterSpacing {
  static const double none = 0;

  /// Onboarding headlines pull the tracking in hard.
  static const double tight = -1;

  /// Small caption/label type is only slightly condensed.
  static const double condensed = -0.24;
  static const double slightlyCondensed = -0.08;

  /// iOS-style title tracking used by titleLarge and the paywall subtitle.
  static const double wide = 0.38;
}

/// The subset of [FontWeight]s the design actually uses.
abstract final class AppFontWeight {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}
