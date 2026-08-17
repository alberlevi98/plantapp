import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/extensions/context_extensions.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: AppStrokeWidth.progressIndicator,
        valueColor:
            AlwaysStoppedAnimation<Color>(context.appColors.primary),
      ),
    );
  }
}
