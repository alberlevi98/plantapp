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
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(AppDimensions.xxxl)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              failure.displayMessage,
              textAlign: TextAlign.center,
              style: context.textStyles.bodyLarge,
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
