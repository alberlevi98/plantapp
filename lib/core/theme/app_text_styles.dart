import 'package:flutter/material.dart';

import '../constants/app_typography.dart';
import 'app_colors.dart';

/// Every text size/weight/line-height pair that appears in the Figma file.
///
/// No numeric literal lives here either: sizes come from [AppFontSize],
/// leading from [AppLineHeight], tracking from [AppLetterSpacing] and weights
/// from [AppFontWeight]. Colours are applied at call sites via `copyWith` so
/// the same ramp can be reused on light and dark surfaces.
abstract final class AppTextStyles {
  static const String fontFamily = 'Roboto';

  static final TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.displayLarge,
    height: AppLineHeight.displayLarge / AppFontSize.displayLarge,
    fontWeight: AppFontWeight.regular,
    color: AppColors.light.textPrimary,
  );

  /// Onboarding headlines.
  static final TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.displayMedium,
    height: AppLineHeight.displayMedium / AppFontSize.displayMedium,
    fontWeight: AppFontWeight.medium,
    letterSpacing: AppLetterSpacing.tight,
    color: AppColors.light.textPrimary,
  );

  static final TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.headlineSmall,
    height: AppLineHeight.headlineSmall / AppFontSize.headlineSmall,
    fontWeight: AppFontWeight.medium,
    color: AppColors.light.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.titleLarge,
    height: AppLineHeight.titleLarge / AppFontSize.titleLarge,
    fontWeight: AppFontWeight.medium,
    letterSpacing: AppLetterSpacing.wide,
  );

  static final TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.titleMedium,
    height: AppLineHeight.titleMedium / AppFontSize.titleMedium,
    fontWeight: AppFontWeight.medium,
    color: AppColors.light.textPrimary,
  );

  static final TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.button,
    height: AppLineHeight.button / AppFontSize.button,
    fontWeight: AppFontWeight.semiBold,
    color: AppColors.light.textOnPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.bodyLarge,
    height: AppLineHeight.bodyLarge / AppFontSize.bodyLarge,
    fontWeight: AppFontWeight.regular,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.bodyMedium,
    height: AppLineHeight.bodyMedium / AppFontSize.bodyMedium,
    fontWeight: AppFontWeight.regular,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.bodySmall,
    height: AppLineHeight.bodySmall / AppFontSize.bodySmall,
    fontWeight: AppFontWeight.regular,
    letterSpacing: AppLetterSpacing.slightlyCondensed,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.labelSmall,
    height: AppLineHeight.labelSmall / AppFontSize.labelSmall,
    fontWeight: AppFontWeight.regular,
    letterSpacing: AppLetterSpacing.condensed,
  );

  /// The "By tapping next…" agreement copy on Get Started.
  static final TextStyle terms = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.terms,
    height: AppLineHeight.terms / AppFontSize.terms,
    fontWeight: AppFontWeight.regular,
    color: AppColors.light.textTerms,
  );

  static const TextStyle disclaimer = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.disclaimer,
    height: AppLineHeight.disclaimer / AppFontSize.disclaimer,
    fontWeight: AppFontWeight.light,
  );

  // --- Paywall specific ---------------------------------------------------
  static const TextStyle paywallTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.paywallTitle,
    height: AppLineHeight.paywallTitle / AppFontSize.paywallTitle,
    fontWeight: AppFontWeight.light,
    color: Colors.white,
  );

  static const TextStyle paywallSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.paywallSubtitle,
    height: AppLineHeight.paywallSubtitle / AppFontSize.paywallSubtitle,
    fontWeight: AppFontWeight.light,
    letterSpacing: AppLetterSpacing.wide,
  );

  static const TextStyle planTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.planTitle,
    height: AppLineHeight.planTitle / AppFontSize.planTitle,
    fontWeight: AppFontWeight.medium,
    color: Colors.white,
  );

  static const TextStyle planSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.planSubtitle,
    height: AppLineHeight.planSubtitle / AppFontSize.planSubtitle,
    fontWeight: AppFontWeight.light,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppFontSize.badge,
    height: AppLineHeight.badge / AppFontSize.badge,
    fontWeight: AppFontWeight.medium,
    color: Colors.white,
  );
}
