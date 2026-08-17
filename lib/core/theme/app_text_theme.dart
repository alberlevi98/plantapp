import 'package:flutter/material.dart';

import 'app_text_styles.dart';

/// The app's own text ramp, already scaled to the running device.
///
/// This exists so `context.textStyles.bodyLarge` resolves to **our**
/// [bodyLarge] instead of Flutter's `TextTheme.bodyLarge`. The previous
/// version returned a Material [TextTheme], which meant two things:
///
/// * Go-to-definition on a style name jumped into the Flutter SDK, not into
///   [AppTextStyles], so the design token was two files away from the call
///   site with no way to follow the link.
/// * Every slot was `TextStyle?`, which is why call sites were littered with
///   `?.copyWith(...)` for values that are never actually null here.
///
/// Every getter below is a one-liner naming its [AppTextStyles] token, so
/// ctrl-click lands in this file and the next click reaches the real
/// [TextStyle] declaration.
@immutable
class AppTextTheme {
  const AppTextTheme({required double scale, required Color onSurface})
      : _scale = scale,
        _onSurface = onSurface;

  /// Device text-scale factor from the [Responsive] scope.
  final double _scale;

  /// Foreground colour of the active [Brightness].
  final Color _onSurface;

  // -------------------------------------------------------------------------
  // Theme-following: these take the active scheme's onSurface colour, so the
  // same style reads correctly on a light or a dark surface.
  // -------------------------------------------------------------------------

  TextStyle get displayLarge => _onSurfaceStyle(AppTextStyles.displayLarge);

  TextStyle get headlineSmall => _onSurfaceStyle(AppTextStyles.headlineSmall);

  TextStyle get titleLarge => _onSurfaceStyle(AppTextStyles.titleLarge);

  TextStyle get titleMedium => _onSurfaceStyle(AppTextStyles.titleMedium);

  TextStyle get bodyLarge => _onSurfaceStyle(AppTextStyles.bodyLarge);

  TextStyle get bodyMedium => _onSurfaceStyle(AppTextStyles.bodyMedium);

  TextStyle get bodySmall => _onSurfaceStyle(AppTextStyles.bodySmall);

  TextStyle get labelSmall => _onSurfaceStyle(AppTextStyles.labelSmall);

  /// Onboarding headline. Moved here from the fixed-colour group: it used
  /// to assume the slide background stayed a fixed light photo in both
  /// themes, but that background is now genuinely dark-mode-aware — fixed
  /// dark-green text on it would go near-invisible in dark mode.
  TextStyle get displayMedium => _onSurfaceStyle(AppTextStyles.displayMedium);

  // -------------------------------------------------------------------------
  // Fixed colour: the design pins these regardless of brightness, either
  // because they sit on a surface that doesn't invert (the paywall, the CTA)
  // or on artwork that is the same image in both themes.
  // -------------------------------------------------------------------------

  /// Sits on the green CTA, so it keeps `textOnPrimary`.
  TextStyle get button => _scaled(AppTextStyles.button);

  TextStyle get terms => _scaled(AppTextStyles.terms);

  TextStyle get disclaimer => _scaled(AppTextStyles.disclaimer);

  TextStyle get paywallTitle => _scaled(AppTextStyles.paywallTitle);

  TextStyle get paywallSubtitle => _scaled(AppTextStyles.paywallSubtitle);

  TextStyle get planTitle => _scaled(AppTextStyles.planTitle);

  TextStyle get planSubtitle => _scaled(AppTextStyles.planSubtitle);

  TextStyle get badge => _scaled(AppTextStyles.badge);

  // -------------------------------------------------------------------------

  /// Scales a token's font size for the running device, leaving its own
  /// colour alone.
  TextStyle _scaled(TextStyle style) => style.copyWith(
    fontSize: style.fontSize == null ? null : style.fontSize! * _scale,
  );

  /// As [_scaled], then repaints the style in the active scheme's foreground.
  TextStyle _onSurfaceStyle(TextStyle style) =>
      _scaled(style).copyWith(color: _onSurface);

  /// Escape hatch for a one-off style that has no token here — scales it the
  /// same way the ramp above is scaled.
  TextStyle scale(TextStyle style) => _scaled(style);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppTextTheme &&
              other._scale == _scale &&
              other._onSurface == _onSurface;

  @override
  int get hashCode => Object.hash(_scale, _onSurface);
}