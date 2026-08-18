import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/error/failure.dart';
import '../../core/extensions/context_extensions.dart';
import 'primary_button.dart';

/// Explains what went wrong and offers the way out, per the copy guidelines.
class ErrorView extends StatelessWidget {
  const ErrorView({required this.failure, this.onRetry, super.key});

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final int? code = failure.displayCode;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(AppDimensions.xxxl)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // `liveRegion` so the failure is announced the moment this view
            // replaces the content, rather than sitting silently until the
            // user happens to swipe onto it. A screen-reader user who loses
            // connectivity mid-scroll otherwise just hears the list vanish
            // with no explanation of why. Wraps both lines so the code is
            // read as part of the same announcement, not a second one.
            Semantics(
              liveRegion: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    failure.displayMessage,
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyLarge,
                  ),
                  // Only the cases where the number tells the user something
                  // the sentence above cannot: a 404 means the address is
                  // wrong rather than their connection, a 5xx means the
                  // fault is ours. "You appear to be offline" needs no code.
                  if (code != null) ...<Widget>[
                    SizedBox(height: context.h(AppDimensions.xs)),
                    Text(
                      'Error $code',
                      textAlign: TextAlign.center,
                      style: context.textStyles.bodySmall
                          .copyWith(color: context.appColors.textDisabled),
                    ),
                  ],
                ],
              ),
            ),
            if (onRetry != null && failure.isRetryable) ...<Widget>[
              SizedBox(height: context.h(AppDimensions.xxl)),
              SizedBox(
                width: context.w(AppDimensions.errorTextWidth),
                child: PrimaryButton(label: 'Try again', onPressed: onRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}