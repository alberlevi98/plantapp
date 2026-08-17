import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_text_styles.dart';

/// The green full-width CTA used on every onboarding screen and the paywall.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.trailing,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? trailing;


  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null && !isLoading;

    // While isLoading is true the button's child is a bare spinner with no
    // text, so the default button semantics (derived from the child) would
    // be empty — a screen reader user would hear "button" and nothing else.
    return Semantics(
      button: true,
      enabled: enabled,
      label: isLoading ? '$label, loading' : label,
      excludeSemantics: true,
      child: SizedBox(
        width: double.infinity,
        height: context.h(AppDimensions.buttonHeight),
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.appColors.primary,
            foregroundColor: context.appColors.textOnPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.r(AppRadius.md)),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: context.r(AppIconSize.sm),
                  height: context.r(AppIconSize.sm),
                  child: CircularProgressIndicator(
                    strokeWidth: AppStrokeWidth.progressIndicator,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.appColors.textOnPrimary,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: context.scale(AppTextStyles.button),
                      ),
                    ),
                    if (trailing != null) ...<Widget>[
                      SizedBox(width: context.w(AppDimensions.sm)),
                      trailing!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
