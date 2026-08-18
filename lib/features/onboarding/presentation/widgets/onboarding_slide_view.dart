import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/onboarding_slide.dart';
import '../constants/onboarding_dimensions.dart';
import 'brush_underline.dart';

/// One onboarding page: the headline with a brush stroke behind the
/// highlighted words, then the artwork filling whatever space is left.
class OnboardingSlideView extends StatelessWidget {
  const OnboardingSlideView({required this.slide, super.key});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Stack(
        // The Stack itself fills the space the PageView hands it.
        fit: StackFit.expand,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left:context.w(AppDimensions.pageHorizontal),
              right:context.w(AppDimensions.pageHorizontal),
              top: context.hWithSafeTop(0),
            ),
            child: _Headline(slide: slide),
          ),
          Positioned.fill(
            child: Image.asset(
                context.isDarkMode
                    ? (slide.foregroundImageDark ?? slide.foregroundImage)
                    : slide.foregroundImage,
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              height: double.infinity,
              semanticLabel: slide.title,
            ),
          ),
        ],
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({required this.slide});

  final OnboardingSlide slide;

  /// [String.indexOf] returns this when the highlight isn't in the title.
  static const int _notFound = -1;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = context.textStyles.displayMedium;
    final int start = slide.title.indexOf(slide.highlight);

    // No highlight match: render the plain headline rather than guessing.
    if (start <= _notFound) return Text(slide.title, style: style);

    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(text: slide.title.substring(0, start)),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Stack(
              alignment: Alignment.bottomCenter,
              // The Stack's own size is fixed by its one non-positioned
              // child (the Text below), so a Positioned underline with a
              // positive `bottom` sits INSIDE that box and overlaps the
              // glyphs. Clip.none plus a negative `bottom` pushes it fully
              // below the text's bounding box instead.
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  bottom: -context.h(BrushUnderlineDimensions.dropBelowText),
                  left: -context.w(BrushUnderlineDimensions.overhangLeft),
                  right: -context.w(BrushUnderlineDimensions.overhangRight),
                  child: const BrushUnderline(),
                ),
                Text(
                  slide.highlight,
                  // No fontSize here: `style` already carries the scaled
                  // size. Re-stating the raw design size made this word
                  // render unscaled while the words around it scaled with
                  // the device.
                  style: style.copyWith(fontWeight: AppFontWeight.extraBold),
                ),
              ],
            ),
          ),
          TextSpan(
            text: slide.title.substring(start + slide.highlight.length),
          ),
        ],
      ),
      style: style,
    );
  }
}
