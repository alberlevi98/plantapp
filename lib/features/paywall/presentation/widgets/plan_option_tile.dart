import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/constants/app_opacity.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/subscription_plan.dart';
import '../constants/paywall_dimensions.dart';

/// Selectable plan row. Selected state gets the green border, gradient wash
/// and the corner badge.
class PlanOptionTile extends StatelessWidget {
  const PlanOptionTile({
    required this.plan,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(context.r(AppRadius.lg));

    return Semantics(
      excludeSemantics: true,
      selected: isSelected,
      button: true,
      label: '${plan.title}. ${plan.description}',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppMotion.resize,
          constraints: BoxConstraints(
            minHeight: context.h(PaywallDimensions.planTileHeight + AppBorderWidth.emphasis),
          ),
          decoration: BoxDecoration(
            color: isSelected ? null : AppColors.light.paywallCardUnselected,
            gradient: isSelected ? _selectedWash : null,
            border: Border.all(
              color: isSelected
                  ? AppColors.light.primary
                  : AppColors.light.paywallCardBorder,
              width: isSelected
                  ? AppBorderWidth.emphasis
                  : AppBorderWidth.thin,
            ),
            borderRadius: radius,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(
                    context.w(PaywallDimensions.planTilePadding),
                  ),
                  child: Row(
                    children: <Widget>[
                      _RadioDot(isSelected: isSelected),
                      SizedBox(width: context.w(AppDimensions.md)),
                      Expanded(child: _PlanText(plan: plan)),
                    ],
                  ),
                ),
                if (plan.badge != null && isSelected)
                  Positioned(
                    top: AppDimensions.none,
                    right: AppDimensions.none,
                    child: _Badge(text: plan.badge!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The green wash behind a selected tile, fading out towards the left.
  LinearGradient get _selectedWash => LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: <Color>[
          AppColors.light.primary
              .withValues(alpha: AppOpacity.selectedPlanWash),
          AppColors.light.primary.withValues(alpha: AppOpacity.transparent),
        ],
      );
}

class _PlanText extends StatelessWidget {
  const _PlanText({required this.plan});

  final SubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(plan.title, style: context.scale(AppTextStyles.planTitle)),
        SizedBox(height: context.h(AppDimensions.xxs)),
        Text(
          plan.description,
          maxLines: AppTextLimits.singleLine,
          overflow: TextOverflow.ellipsis,
          style: context.scale(AppTextStyles.planSubtitle).copyWith(
                color: AppColors.light.paywallTextSecondary,
              ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.h(AppDimensions.xxl),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(PaywallDimensions.badgeHorizontalPadding),
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.light.primary,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(context.r(AppRadius.lg)),
          bottomLeft: Radius.circular(context.r(AppRadius.xl)),
        ),
      ),
      child: Text(text, style: context.scale(AppTextStyles.badge)),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final double size = context.r(PaywallDimensions.radioDotSize);
    final double innerSize = size * PaywallDimensions.radioDotInnerRatio;

    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppMotion.resize,
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? AppColors.light.primary
            : Colors.white.withValues(alpha: AppOpacity.radioDotIdle),
      ),
      child: isSelected
          ? Container(
              width: innerSize,
              height: innerSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
