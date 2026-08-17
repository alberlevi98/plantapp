import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_theme.dart';
import '../utils/responsive.dart';

extension ResponsiveContextX on BuildContext {
  Responsive get responsive => Responsive.of(this);

  /// Horizontal design value scaled to the device.
  double w(double value) => Responsive.of(this).width(value);

  /// Vertical design value scaled to the device.
  double h(double value) => Responsive.of(this).height(value);

  /// Radius / square-icon design value scaled to the device.
  double r(double value) => Responsive.of(this).radius(value);

  /// Scaled [value] plus the status bar / notch height — for a container
  /// that isn't wrapped in a [SafeArea] but still needs to clear it itself
  /// (e.g. a full-bleed header whose own height must include that gap).
  /// Uses the raw system inset (`MediaQuery.viewPaddingOf`), not the
  /// "remaining after SafeArea" one — nothing upstream has consumed it
  /// here, so there's nothing to subtract.
  double hWithSafeTop(double value) =>
      MediaQuery.of(this).viewPadding.top + h(value);
}

extension ThemeContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  /// The app's text ramp, already scaled to the running device.
  ///
  /// Every style here has had its fontSize scaled for the device, so call
  /// sites just use `context.textStyles.bodyLarge` — no
  /// `.copyWith(fontSize: <manually scaled 16>)` boilerplate, and no repeating a
  /// magic number that's already declared in AppTextStyles.
  ///
  /// Use [rawTextStyles] only if you deliberately need an unscaled style.
  AppTextTheme get textStyles => AppTextTheme(
    scale: Responsive.of(this).textScale,
    onSurface: Theme.of(this).colorScheme.onSurface,
  );

  /// The unscaled TextTheme, straight from ThemeData.
  TextTheme get rawTextStyles => Theme.of(this).textTheme;

  /// Scales any [TextStyle] not covered by [textStyles] — the app-specific
  /// ones that don't map onto a Material TextTheme slot (paywallTitle,
  /// planTitle, badge, and friends).
  ///
  ///     Text(plan.title, style: context.scale(AppTextStyles.planTitle))
  ///
  /// Same effect as `.copyWith(fontSize: <its own size> * textScale)`, but
  /// without restating a number that AppTextStyles already declares.
  TextStyle scale(TextStyle style) => style.copyWith(
    fontSize:
    style.fontSize == null ? null : Responsive.of(this).font(style.fontSize!),
  );

  ColorScheme get colors => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  /// Remaining system-UI inset at this point in the tree — reads 0 if a
  /// [SafeArea] above has already consumed it. If you need the raw inset
  /// regardless of any SafeArea ancestor (e.g. manually positioning
  /// something outside one), use `MediaQuery.viewPaddingOf(context)`
  /// directly instead.
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  Size get screenSize => MediaQuery.sizeOf(this);

  /// The design-token color set matching the current [Brightness] — light
  /// or dark, resolved from `ThemeMode.system`. Every widget should read
  /// colors through this, never `AppColors.light`/`.dark` directly.
  AppColors get appColors => isDarkMode ? AppColors.dark : AppColors.light;
}