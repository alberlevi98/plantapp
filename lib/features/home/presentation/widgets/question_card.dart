import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../domain/entities/question.dart';
import '../constants/home_dimensions.dart';

/// Article card in the "Get Started" carousel.
class QuestionCard extends StatelessWidget {
  const QuestionCard({
    required this.question,
    this.onTap,
    this.index,
    this.total,
    super.key,
  });

  final Question question;
  final VoidCallback? onTap;

  /// Zero-based position and the list's total length — when both are given,
  /// they're announced as "item N of total" so a screen reader user knows
  /// where they are and how much is left, matching what a sighted user sees
  /// at a glance (the row's scroll extent). Optional: null just omits it.
  final int? index;
  final int? total;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(context.r(AppRadius.md));
    final String position =
    index != null && total != null ? '. Item ${index! + 1} of $total' : '';

    return Semantics(
      button: onTap != null,
      label: '${question.title}$position',
      excludeSemantics: true,
      // TalkBack doesn't reliably auto-scroll a horizontal list nested
      // inside a vertically-scrolling screen when focus moves to a
      // partially-visible item — a known cross-platform limitation, not
      // Flutter-specific. Scrolling explicitly here, rather than relying on
      // the implicit behaviour, is the standard workaround.
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
        child: SizedBox(
          width: context.w(AppDimensions.questionCardWidth),
          height: context.h(AppDimensions.questionCardHeight),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                AppNetworkImage(url: question.imageUrl),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: context.h(HomeDimensions.questionCaptionHeight),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(
                        HomeDimensions.questionCaptionHorizontalPadding,
                      ),
                      vertical: context.h(
                        HomeDimensions.questionCaptionVerticalPadding,
                      ),
                    ),
                    child: Text(
                      question.title,
                      maxLines: AppTextLimits.twoLines,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodyMedium
                          ?.copyWith(color: Colors.white),
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