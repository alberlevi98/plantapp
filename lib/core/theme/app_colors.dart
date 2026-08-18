import 'package:flutter/material.dart';

import '../constants/app_opacity.dart';

/// Design tokens for one [Brightness]. Figma only specifies the light
/// variant — dark-mode values below are a reasoned counterpart, not an
/// extracted spec, called out wherever that matters.
///
/// Access through `context.appColors` (see `context_extensions.dart`),
/// never `AppColors.light`/`.dark` directly from a widget — that's what
/// makes every color follow the active brightness automatically.
@immutable
class AppColors {
  const AppColors({
    required this.primary,
    required this.primaryLight,
    required this.textPrimary,
    required this.textOnPrimary,
    required this.textTerms,
    required this.searchHint,
    required this.searchIcon,
    required this.scaffoldBackground,
    required this.headerBackground,
    required this.categoryCardBackground,
    required this.categoryCardBorder,
    required this.searchBarBackground,
    required this.hairline,
    required this.searchBorder,
    required this.paywallBackground,
    required this.paywallCard,
    required this.paywallCardUnselected,
    required this.paywallCardBorder,
    required this.paywallIconBackground,
    required this.paywallTextSecondary,
    required this.paywallTextTertiary,
    required this.paywallCloseBackground,
    required this.premiumBannerBackground,
    required this.premiumArrow,
    required this.premiumTitleGradient,
    required this.premiumIconGradient,
    required this.badgeRed,
    required this.tabInactiveLabel,
    required this.tabInactiveIcon,
    required this.tabBarBackground,
    required this.onboardingGradientStart,
    required this.onboardingGradientEnd,
    required this.blobSkyBlue,
    required this.blobLavender,
    required this.blobPeriwinkle,
    required this.blobPink,
    required this.blobBlush,
    required this.blobMagenta,
    required this.imageScrim,
  });

  // Brand
  final Color primary;
  final Color primaryLight;
  LinearGradient get primaryGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[primary, primaryLight],
      );

  // Text
  final Color textPrimary;
  Color get textSecondary =>
      textPrimary.withValues(alpha: AppOpacity.textSecondary);
  Color get textDisabled =>
      textPrimary.withValues(alpha: AppOpacity.textDisabled);
  final Color textTerms;
  final Color textOnPrimary;
  final Color searchHint;
  final Color searchIcon;

  // Surfaces
  final Color scaffoldBackground; // was onboardingBackground / homeBackground
  final Color headerBackground;
  final Color categoryCardBackground;
  final Color categoryCardBorder;
  final Color searchBarBackground;
  final Color hairline;
  final Color searchBorder;

  // Paywall — deliberately a fixed dark surface in the Figma file itself,
  // not "light mode inverted". Identical in both schemes on purpose.
  final Color paywallBackground;
  final Color paywallCard;
  final Color paywallCardUnselected;
  final Color paywallCardBorder;
  final Color paywallIconBackground;
  final Color paywallTextSecondary;
  final Color paywallTextTertiary;
  final Color paywallCloseBackground;

  // Premium banner (home) — same reasoning as Paywall: an intentionally
  // dark card treatment regardless of the screen's own theme.
  final Color premiumBannerBackground;
  final Color premiumArrow;
  final LinearGradient premiumTitleGradient;
  final LinearGradient premiumIconGradient;
  final Color badgeRed;

  // Tab bar
  final Color tabInactiveLabel;
  final Color tabInactiveIcon;
  Color get tabBarBorder =>
      textPrimary.withValues(alpha: AppOpacity.tabBarBorder);
  final Color tabBarBackground;

  // Onboarding background (gradient + blurred blobs behind Get Started and
  // the onboarding slides).
  final Color onboardingGradientStart;
  final Color onboardingGradientEnd;
  final Color blobSkyBlue;
  final Color blobLavender;
  final Color blobPeriwinkle;
  final Color blobPink;
  final Color blobBlush;
  final Color blobMagenta;

  // Overlays
  final Color imageScrim;

  // ---------------------------------------------------------------------
  // Light — Figma-exact.
  // ---------------------------------------------------------------------
  static const AppColors light = AppColors(
    primary: Color(0xFF28AF6E),
    primaryLight: Color(0xFF2CCC80),
    textPrimary: Color(0xFF13231B),
    textOnPrimary: Color(0xFFFFFFFF),
    textTerms: Color(0xB3597165), // rgba(89,113,101,.7)
    searchHint: Color(0xFFAFAFAF),
    searchIcon: Color(0xFFABABAB),
    scaffoldBackground: Color(0xFFFBFAFA),
    headerBackground: Color(0xD6F7F7F7), // rgba(247,247,247,.84)
    categoryCardBackground: Color(0xFFF4F6F6),
    categoryCardBorder: Color(0x2E29BB89), // rgba(41,187,137,.18)
    searchBarBackground: Color(0xE0FFFFFF), // white 88% — was hardcoded inline
    hairline: Color(0x1A3C3C43), // rgba(60,60,67,.1)
    searchBorder: Color(0x403C3C43), // rgba(60,60,67,.25)
    paywallBackground: Color(0xFF101E17),
    paywallCard: Color(0x14FFFFFF), // white 8%
    paywallCardUnselected: Color(0x0DFFFFFF), // white 5%
    paywallCardBorder: Color(0x4DFFFFFF), // white 30%
    paywallIconBackground: Color(0x3D000000), // black 24%
    paywallTextSecondary: Color(0xB3FFFFFF), // white 70%
    paywallTextTertiary: Color(0x85FFFFFF), // white 52%
    paywallCloseBackground: Colors.black, // black 40%
    premiumBannerBackground: Color(0xFF24201A),
    premiumArrow: Color(0xFFD0B070),
    premiumTitleGradient: LinearGradient(
      colors: <Color>[
        Color(0xFFE6C990), // warm champagne gold
        Color(0xFFE4B046), // richer golden amber
      ],
    ),
    premiumIconGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Color(0xFFF0D399), Color(0xFFD9A846)],
    ),
    badgeRed: Color(0xE6E82C13),
    tabInactiveLabel: Color(0xFF737373), // was #979798 (2.92:1, fails WCAG AA)
    tabInactiveIcon: Color(0xFFBDBDBD),
    tabBarBackground: Color(0xEBFFFFFF), // white 92%
    onboardingGradientStart: Color(0xFFF8FAFF),
    onboardingGradientEnd: Color(0xFFFAFAFA),
    blobSkyBlue: Color(0xFFC0F0FF),
    blobLavender: Color(0xFFE7C0FF),
    blobPeriwinkle: Color(0xFF93AAFF),
    blobPink: Color(0xFFFEBDFF),
    blobBlush: Color(0xFFFEDEFF),
    blobMagenta: Color(0xFFFA00FF), // Vector 160 fill; effective opacity handled by the Opacity widget below
    imageScrim: Color(0x26000000),
  );

  // ---------------------------------------------------------------------
  // Dark — not in the Figma file; reasoned counterparts. Neutral surfaces
  // and text invert; already-dark, deliberately-branded surfaces (paywall,
  // premium banner, the blob accent hues) stay as designed.
  // ---------------------------------------------------------------------
  static const AppColors dark = AppColors(
    primary: Color(0xFF28AF6E), // brand accent stays constant
    primaryLight: Color(0xFF2CCC80),
    textPrimary: Color(0xFFF2F5F3),
    textOnPrimary: Color(0xFFFFFFFF),
    textTerms: Color(0xB3C7D6CD),
    searchHint: Color(0xFF8A8F8C),
    searchIcon: Color(0xFF9AA39D),
    scaffoldBackground: Color(0xFF101E17),
    headerBackground: Color(0xD6132018),
    categoryCardBackground: Color(0xFF17281F),
    categoryCardBorder: Color(0x4029BB89),
    searchBarBackground: Color(0xE617281F), // categoryCardBackground @ 90%
    hairline: Color(0x1FFFFFFF), // white 12%
    searchBorder: Color(0x3DFFFFFF), // white 24%
    paywallBackground: Color(0xFF101E17), // unchanged — see class doc
    paywallCard: Color(0x14FFFFFF),
    paywallCardUnselected: Color(0x0DFFFFFF),
    paywallCardBorder: Color(0x4DFFFFFF),
    paywallIconBackground: Color(0x3D000000),
    paywallTextSecondary: Color(0xB3FFFFFF),
    paywallTextTertiary: Color(0x85FFFFFF),
    paywallCloseBackground: Color(0x66000000),
    premiumBannerBackground: Color(0xFF24201A), // unchanged — see class doc
    premiumArrow: Color(0xFFD0B070),
    premiumTitleGradient: LinearGradient(
      colors: <Color>[Color(0xFFE6C990), Color(0xFFE4B046)],
    ),
    premiumIconGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Color(0xFFF0D399), Color(0xFFD9A846)],
    ),
    badgeRed: Color(0xE6E82C13),
    tabInactiveLabel: Color(0xFFA0A0A0), // ~7.3:1 on the dark background
    tabInactiveIcon: Color(0xFF8C8C8C),
    tabBarBackground: Color(0xEB17281F), // categoryCardBackground @ 92%
    onboardingGradientStart: Color(0xFF0E1613),
    onboardingGradientEnd: Color(0xFF10201A),
    blobSkyBlue: Color(0xFFC0F0FF), // kept vivid — reads as a soft glow on dark
    blobLavender: Color(0xFFE7C0FF),
    blobPeriwinkle: Color(0xFF93AAFF),
    blobPink: Color(0xFFFEBDFF),
    blobBlush: Color(0xFFFEDEFF),
    blobMagenta: Color(0xFFFA00FF),
    imageScrim: Color(0x26000000),
  );
}
