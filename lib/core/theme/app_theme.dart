import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_opacity.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Builds the light and dark [ThemeData] from the design tokens.
/// Widgets must read colours/typography through `Theme.of(context)` or the
/// token classes, never by hardcoding values.
abstract final class AppTheme {
  static ThemeData get light => _base(
        ColorScheme.fromSeed(
          seedColor: AppColors.light.primary,
          primary: AppColors.light.primary,
          onPrimary: AppColors.light.textOnPrimary,
          surface: AppColors.light.scaffoldBackground,
          onSurface: AppColors.light.textPrimary,
        ),
      );

  static ThemeData get dark => _base(
        ColorScheme.fromSeed(
          seedColor: AppColors.dark.primary,
          brightness: Brightness.dark,
          primary: AppColors.dark.primary,
          onPrimary: AppColors.dark.textOnPrimary,
          surface: AppColors.dark.scaffoldBackground,
          onSurface: AppColors.dark.textPrimary,
        ),
      );

  static ThemeData _base(ColorScheme scheme) {
    final bool isDark = scheme.brightness == Brightness.dark;
    final Color onSurface = scheme.onSurface;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: AppTextStyles.fontFamily,
      splashFactory: InkSparkle.splashFactory,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: onSurface),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: onSurface),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: onSurface),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: onSurface),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: onSurface),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: onSurface),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: onSurface),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: onSurface),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: onSurface),
        labelLarge: AppTextStyles.button,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor:
              scheme.primary.withValues(alpha: AppOpacity.disabledButton),
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          elevation: AppElevation.none,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.dark.hairline : AppColors.light.hairline,
        thickness: AppBorderWidth.regular,
        space: AppBorderWidth.regular,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
