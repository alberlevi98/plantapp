import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../constants/onboarding_assets.dart';
import '../constants/onboarding_dimensions.dart';

/// The hand-drawn stroke behind the highlighted words in onboarding
/// headlines — a real exported asset, not a shape drawn with a Container.
///
/// It fills whatever width its parent gives it (typically a Positioned with
/// `left`/`right` overhangs) and derives its height from the asset's own
/// aspect ratio, so the stroke scales with each word's width — "identify" and
/// "care guides" are different lengths — without ever looking stretched.
class BrushUnderline extends StatelessWidget {
  const BrushUnderline({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: BrushUnderlineDimensions.aspectRatio,
      child: Image.asset(
        context.isDarkMode
            ? OnboardingAssets.brushUnderlineWhite
            : OnboardingAssets.brushUnderline,
        fit: BoxFit.cover,
        // Purely decorative — the highlighted word right above it already
        // carries the meaning, so a screen reader has nothing useful to say
        // about this image.
        excludeFromSemantics: true,
      ),
    );
  }
}