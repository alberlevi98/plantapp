import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/home_assets.dart';
import '../constants/home_dimensions.dart';

/// The dark gold "FREE Premium" row under the search bar.
///
/// Reads from [AppColors.light] on purpose: like the paywall, this is an
/// intentionally dark, gold-on-near-black card in the Figma file rather than
/// a surface that inverts with the theme.
class PremiumBanner extends StatelessWidget {
  const PremiumBanner({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(context.r(AppRadius.md));
    final double trailingInset =
        context.w(HomeDimensions.premiumBannerTrailingInset);

    return Padding(
      padding: EdgeInsets.only(
        left: context.w(AppDimensions.lg),
        right: trailingInset,
      ),
      child: Semantics(
        excludeSemantics: true,
        button: true,
        label: 'FREE Premium available, subscription billed yearly',
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            height: context.h(AppDimensions.premiumBannerHeight),
            padding: EdgeInsets.only(
              left: context.w(AppDimensions.lg),
              right: trailingInset,
            ),
            decoration: BoxDecoration(
              color: AppColors.light.premiumBannerBackground,
              borderRadius: radius,
            ),
            child: Row(
              children: <Widget>[
                Image.asset(
                  HomeAssets.mailIcon,
                  fit: BoxFit.contain,
                  excludeFromSemantics: true,
                ),
                SizedBox(width: context.w(AppDimensions.md)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _GradientText(
                        'FREE Premium Available',
                        gradient: AppColors.light.premiumTitleGradient,
                        style: context
                            .scale(AppTextStyles.titleMedium)
                            .copyWith(fontWeight: AppFontWeight.bold),
                      ),
                      SizedBox(height: context.h(AppDimensions.xxs)),
                      _GradientText(
                        'Tap to upgrade your account!',
                        gradient: AppColors.light.premiumTitleGradient,
                        style: context.scale(AppTextStyles.bodySmall),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  HomeAssets.nextIcon,
                  fit: BoxFit.fill,
                  width: context.w(HomeDimensions.premiumChevronSize),
                  height: context.w(HomeDimensions.premiumChevronSize),
                  excludeFromSemantics: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientText extends StatelessWidget {
  const _GradientText(this.text, {required this.gradient, required this.style});

  final String text;
  final Gradient gradient;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: gradient.createShader,
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        maxLines: AppTextLimits.singleLine,
        overflow: TextOverflow.ellipsis,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}
