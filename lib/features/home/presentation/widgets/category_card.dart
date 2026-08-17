import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../domain/entities/plant_category.dart';
import '../constants/home_dimensions.dart';

/// Square category tile: title top-left, artwork bleeding off the bottom-right.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.category,
    this.onTap,
    this.index,
    this.total,
    super.key,
  });

  final PlantCategory category;
  final VoidCallback? onTap;

  /// Same "item N of total" reasoning as QuestionCard — see its doc comment.
  final int? index;
  final int? total;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(context.r(AppRadius.md));
    const double bleed = HomeDimensions.categoryImageBleed;
    final String position =
    index != null && total != null ? '. Item ${index! + 1} of $total' : '';

    return Semantics(
      button: onTap != null,
      label: '${category.title}$position',
      excludeSemantics: true,
      // Same reasoning as QuestionCard/PaywallFeatureCard: a card near the
      // viewport edge (e.g. the bottom row of the grid, half cut off) can
      // gain accessibility focus without TalkBack fully scrolling it into
      // view on its own — bring it into view explicitly instead.
      onDidGainAccessibilityFocus: () {
        Scrollable.ensureVisible(
          context,
          alignment: 0.5,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.appColors.categoryCardBackground,
            border: Border.all(
              color: context.appColors.categoryCardBorder,
              width: AppBorderWidth.thin,
            ),
            borderRadius: radius,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: context.w(HomeDimensions.categoryImageLeftInset),
                  top: context.h(AppDimensions.xxl),
                  // Negative insets: the artwork deliberately runs past the
                  // card's bottom-right corner and is clipped by the
                  // ClipRRect above.
                  right: -context.w(bleed),
                  bottom: -context.h(bleed),
                  child: AppNetworkImage(
                    url: category.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(context.w(AppDimensions.lg)),
                  child: SizedBox(
                    width: context.w(HomeDimensions.categoryTitleWidth),
                    child: Text(
                      category.title,
                      maxLines: AppTextLimits.twoLines,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.titleMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}