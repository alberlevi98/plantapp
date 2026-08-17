import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_motion.dart';
import '../../core/extensions/context_extensions.dart';

/// Dots under the onboarding CTA; the active one is larger.
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    required this.count,
    required this.activeIndex,
    super.key,
  });

  final int count;
  final int activeIndex;

  /// Screen readers count from one, the list index from zero.
  static const int _humanIndexOffset = 1;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      excludeSemantics: true,
      label: 'Page ${activeIndex + _humanIndexOffset} of $count',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(count, (int index) {
          final bool isActive = index == activeIndex;
          final double size = context.r(
            isActive
                ? AppDimensions.pageIndicatorDotActive
                : AppDimensions.pageIndicatorDotIdle,
          );
          return Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.w(AppDimensions.xs)),
            child: AnimatedContainer(
              duration: AppDurations.fast,
              curve: AppMotion.resize,
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? context.appColors.textPrimary
                    : context.appColors.textDisabled,
              ),
            ),
          );
        }),
      ),
    );
  }
}
