import 'package:flutter/widgets.dart';

import '../constants/app_breakpoints.dart';
import '../constants/app_dimensions.dart';

/// Scales design values from the Figma frame
/// ([AppDimensions.designWidth] x [AppDimensions.designHeight]) to the
/// running device.
///
/// Wrap the app once with [Responsive] (see `app.dart`) and then read values
/// through the `BuildContext` extensions in `core/extensions`.
class Responsive extends InheritedWidget {
  const Responsive({
    required this.scaleWidth,
    required this.scaleHeight,
    required this.textScale,
    required this.size,
    required super.child,
    super.key,
  });

  final double scaleWidth;
  final double scaleHeight;
  final double textScale;
  final Size size;

  /// Builds a [Responsive] scope from the constraints of the current layout.
  static Widget builder({required Widget child}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = Size(constraints.maxWidth, constraints.maxHeight);
        final double scaleWidth = size.width / AppDimensions.designWidth;
        final double scaleHeight = size.height / AppDimensions.designHeight;
        return Responsive(
          scaleWidth: scaleWidth,
          scaleHeight: scaleHeight,
          // Clamped so type never becomes unreadable on very small phones or
          // comically large on tablets.
          textScale: scaleWidth.clamp(
            AppScale.minDeviceText,
            AppScale.maxDeviceText,
          ),
          size: size,
          child: child,
        );
      },
    );
  }

  static Responsive of(BuildContext context) {
    final Responsive? result =
        context.dependOnInheritedWidgetOfExactType<Responsive>();
    assert(result != null, 'No Responsive scope found in the widget tree.');
    return result!;
  }

  double width(double value) => value * scaleWidth;

  double height(double value) => value * scaleHeight;

  /// Uses the smaller axis so square elements stay square.
  double radius(double value) =>
      value * (scaleWidth < scaleHeight ? scaleWidth : scaleHeight);

  double font(double value) => value * textScale;

  bool get isCompact => size.width < AppBreakpoints.compact;

  bool get isExpanded => size.width >= AppBreakpoints.expanded;

  @override
  bool updateShouldNotify(Responsive oldWidget) =>
      oldWidget.size != size || oldWidget.textScale != textScale;
}
