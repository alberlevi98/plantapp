import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/paywall_dimensions.dart';

/// Frosted card in the horizontal feature strip.
class PaywallFeatureCard extends StatelessWidget {
  const PaywallFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.index,
    this.total,
    super.key,
  });

  /// Either an `Icon(...)` (Material) or an `Image.asset(...)` — the caller
  /// decides, so a card can use a real exported icon once one exists
  /// without this widget needing to know the difference.
  final Widget icon;
  final String title;
  final String subtitle;

  /// Same "item N of total" reasoning as QuestionCard — this strip has a
  /// fixed 3 cards rather than a builder, so callers pass their own
  /// position instead of it being derived from a list index.
  final int? index;
  final int? total;

  @override
  Widget build(BuildContext context) {
    final String position =
    index != null && total != null ? '. Item ${index! + 1} of $total' : '';

    return Semantics(
      // Not a button — this card has no onTap, it's a plain description of
      // one benefit, so combining its two Text children into a single
      // announcement is enough (no `button: true`).
      label: '$title. $subtitle$position',
      excludeSemantics: true,
      onDidGainAccessibilityFocus: () {
        // Same nested-horizontal-in-vertical-scroll workaround as
        // QuestionCard — see that file's comment for why this is explicit
        // rather than relying on TalkBack's own auto-scroll.
        Scrollable.ensureVisible(
          context,
          alignment: 0.5,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
      child: Container(
        width: context.w(PaywallDimensions.featureCardWidth),
        constraints: BoxConstraints(
          minHeight: context.h(PaywallDimensions.featureListViewHeight),
        ),
          padding: EdgeInsets.only(
            top: context.h(AppDimensions.lg),
            left: context.w(AppDimensions.lg),
            bottom: context.h(AppDimensions.lg),
            right: context.w(PaywallDimensions.featureCardTrailingPadding),
          ),
        decoration: BoxDecoration(
          color: AppColors.light.paywallCard,
          borderRadius: BorderRadius.circular(context.r(AppRadius.lg)),
        ),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          icon,
          SizedBox(height: context.h(AppDimensions.smPlus)),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: AppTextLimits.singleLine,
                    style: context.scale(AppTextStyles.titleLarge).copyWith(color: Colors.white),
                  ),
                  SizedBox(height: context.h(AppDimensions.xs)),
                  Text(
                    subtitle,
                    maxLines: AppTextLimits.singleLine,
                    style: context.scale(AppTextStyles.bodySmall).copyWith(
                      color: AppColors.light.paywallTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}