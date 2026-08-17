import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../features/onboarding/presentation/constants/onboarding_assets.dart';

/// The hand-drawn stroke behind the highlighted words in onboarding
/// headlines — a real exported asset (assets/images/brush.png, 139x13),
/// not a shape drawn with a Container.
///
/// It fills whatever width its parent gives it (typically a Positioned with
/// `left: 0, right: 0`) and derives its height from the asset's own aspect
/// ratio, so the stroke scales with each word's width — "identify" and
/// "care guides" are different lengths — without ever looking stretched.
class BrushUnderline extends StatelessWidget {
  const BrushUnderline({super.key});

  /// Natural aspect ratio of the source PNG.
  static const double _aspectRatio = 139 / 13;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: Image.asset(
        OnboardingAssets.brushUnderline,
        fit: BoxFit.contain,
        // Purely decorative — the highlighted word right above it already
        // carries the meaning, so a screen reader has nothing useful to say
        // about this image.
        excludeFromSemantics: true,
      ),
    );
  }
}