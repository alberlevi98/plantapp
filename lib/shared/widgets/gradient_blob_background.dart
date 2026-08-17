import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';

/// The onboarding backdrop: a soft diagonal gradient with blurred colour blobs
/// layered on top. Built in code rather than shipped as a PNG so it stays
/// crisp at any resolution and adds nothing to the bundle.
///
/// Positions come straight from the Figma export and are expressed in design
/// units of a 360x800 frame, then scaled by the app's Responsive scope.
class GradientBlobBackground extends StatelessWidget {
  const GradientBlobBackground({this.child, super.key});

  final Widget? child;

  // `final`, not `const`: the color values come from `AppColors.light`
  // instance fields, and Dart doesn't allow field access on a const object
  // inside a constant expression — only the const-ness of the outer list
  // literal is lost, the `_Blob`s themselves are still built from a const
  // constructor.
  static final List<_Blob> _blobs = <_Blob>[
    // Group 46888 — opacity .7. Same hue in light and dark — see AppColors'
    // class doc — so referencing .light here is accurate for both.
    _Blob(left: 244, top: -500, width: 952, height: 952, color: AppColors.light.blobSkyBlue, opacity: 0.49),
    _Blob(left: -305, top: 163, width: 419, height: 419, color: AppColors.light.blobSkyBlue, opacity: 0.35),
    _Blob(left: -235, top: 309, width: 186, height: 186, color: AppColors.light.blobLavender, opacity: 0.35),
    // Group 46889 — opacity .24
    _Blob(left: 348, top: -492, width: 952, height: 952, color: AppColors.light.blobPeriwinkle, opacity: 0.24),
    _Blob(left: 526, top: -578, width: 952, height: 952, color: AppColors.light.blobPink, opacity: 0.24),
    _Blob(left: 811, top: -605, width: 952, height: 952, color: AppColors.light.blobBlush, opacity: 0.24),
    // Vector 160 — the one non-circular shape in the group, an elongated
    // magenta oval. Figma only gives its bounding box, not the exact path,
    // so an ellipse matching that box is the closest approximation once
    // blurred this heavily. Opacity is the fill's own alpha (.63) times its
    // own layer opacity (.6) times the parent group's opacity (.24) —
    // 0.63 * 0.6 * 0.24 ≈ 0.09.
    _Blob(left: 425.63, top: -263.1, width: 452.47, height: 763.31, color: AppColors.light.blobMagenta, opacity: 0.09),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      // Not const: the gradient stops are genuinely different between the
      // two schemes (a calm off-white in light, a deep green-black in
      // dark), unlike the blob hues above.
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // 104.84deg in CSS ≈ this begin/end pair in Flutter.
          begin: const Alignment(-0.96, -0.26),
          end: const Alignment(0.96, 0.26),
          colors: <Color>[
            context.appColors.onboardingGradientStart,
            context.appColors.onboardingGradientEnd,
          ],
          stops: const <double>[0.395, 0.899],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // RepaintBoundary keeps the expensive blur out of the repaint path
          // when the content above it animates.
          RepaintBoundary(
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  for (final _Blob blob in _blobs)
                    Positioned(
                      left: context.w(blob.left),
                      top: context.h(blob.top),
                      child: Opacity(
                        opacity: blob.opacity,
                        child: Container(
                          // Both axes scale off the *width* factor, not
                          // width/height independently — otherwise a device
                          // whose aspect ratio differs from the 360x800
                          // design frame would stretch every blob (including
                          // the five that are meant to stay perfectly round)
                          // into an unintended oval.
                          width: context.w(blob.width),
                          height: context.w(blob.height),
                          decoration: BoxDecoration(
                            color: blob.color,
                            // Radius.elliptical(w/2, h/2) draws a perfect
                            // circle when width==height (the five round
                            // blobs) and a true oval for Vector 160, so one
                            // shape path covers both cases.
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(
                                context.w(blob.width) / 2,
                                context.w(blob.height) / 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _Blob {
  const _Blob({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.color,
    required this.opacity,
  });

  /// All values are in design units of the [AppSpacing.designWidth] frame.
  final double left;
  final double top;
  final double width;
  final double height;
  final Color color;
  final double opacity;
}