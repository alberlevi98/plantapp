import 'package:flutter/painting.dart';

/// Layout tokens that only the onboarding flow uses.
/// Anything shared with another feature belongs in `core/constants` instead.
abstract final class OnboardingDimensions {
  /// Width of the "By tapping next…" agreement block, so it wraps exactly
  /// where the design wraps it.
  static const double agreementTextWidth = 232;

  static const double bottomHeight = 130;
  /// Gap between the agreement block and the bottom of the screen.
  static const double agreementBottomSpace = 8;
}

/// The hand-drawn brush stroke behind highlighted headline words.
abstract final class BrushUnderlineDimensions {
  /// Natural aspect ratio of the exported PNG (139 x 13).
  static const double sourceWidth = 139;
  static const double sourceHeight = 13;
  static const double aspectRatio = sourceWidth / sourceHeight;

  /// How far the stroke overhangs the word it sits under. The two sides
  /// differ because the stroke's own artwork is asymmetric — it tapers on
  /// the left and flicks out on the right.
  static const double overhangLeft = 3;
  static const double overhangRight = 13;

  /// How far below the text baseline box the stroke is pushed.
  static const double dropBelowText = 8;
}

/// The code-drawn gradient + blurred blob backdrop.
///
/// The blob geometry itself lives with the widget: each value there is a
/// named field on a `_Blob` record (`left:`, `top:`, `width:` …) straight out
/// of the Figma export, which is labelled design *data* rather than a magic
/// number. What belongs here is everything that describes the *effect*.
abstract final class OnboardingBackgroundDimensions {
  /// Figma's 104.84deg linear gradient, expressed as Flutter alignments.
  static const Alignment gradientBegin = Alignment(-0.96, -0.26);
  static const Alignment gradientEnd = Alignment(0.96, 0.26);
  static const List<double> gradientStops = <double>[0.395, 0.899];

  /// Half of a blob's box, used to turn a rectangle into an ellipse.
  static const double ellipseDivisor = 2;
}
