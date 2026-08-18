import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Transient failure notice shown when a refresh fails while content is
/// already on screen — the full-screen `ErrorView` covers the empty case.
///
/// Deliberately avoids [SnackBar.action]: Material places that slot beside
/// the message, which squeezed a three-line failure string into a narrow
/// column. Stacking "Try again" under a small close affordance in a trailing
/// column keeps the message readable and still gives an explicit way out —
/// swipe-to-dismiss alone isn't reliable once a screen reader is running,
/// and an action-bearing SnackBar never times out in that mode.
///
/// Takes a [BuildContext] rather than reading one itself because a SnackBar
/// is built before it is inserted into the tree — the scaled dimensions and
/// theme tokens below have to come from the caller's context.
class ConnectionErrorSnackBar extends SnackBar {
  ConnectionErrorSnackBar({
    required BuildContext context,
    required String message,
    required VoidCallback onRetry,
    super.key,
  }) : super(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(
      left: context.w(AppDimensions.lg),
      right: context.w(AppDimensions.lg),
      // Clears the tab bar so the notice never covers navigation.
      bottom: context.h(AppDimensions.tabBarHeight) +
          context.h(AppDimensions.lg),
    ),
    content: _Content(message: message, onRetry: onRetry),
  );
}

/// Split out so it builds against the context it is actually mounted in,
/// rather than the one captured when the SnackBar was constructed.
class _Content extends StatelessWidget {
  const _Content({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(message)),
        SizedBox(width: context.w(AppDimensions.sm)),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Semantics(
              button: true,
              label: 'Dismiss',
              child: GestureDetector(
                onTap: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.all(context.w(AppDimensions.xs)),
                  child: Icon(
                    Icons.close,
                    size: context.r(AppIconSize.xs),
                    // Follows the snack bar's own content colour from SnackBarThemeData,
                    // so it stays legible whichever surface the theme paints underneath.
                    color: DefaultTextStyle.of(context).style.color,
                  ),
                ),
              ),
            ),
            Semantics(
              button: true,
              child: GestureDetector(
                onTap: () {
                  // Hide first, so the next failure replaces this notice
                  // instead of queueing behind it.
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  onRetry();
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.h(AppDimensions.xs),
                  ),
                  child: Text(
                    'Try again',
                    style: context.textStyles.bodyMedium.copyWith(
                      color: context.appColors.primary,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}