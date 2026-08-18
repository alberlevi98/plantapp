import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/extensions/context_extensions.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Same reasoning as ErrorView: a screen-reader user needs to hear that
      // something is in flight, otherwise the screen just goes quiet between
      // navigation and the first frame of real content.
      child: Semantics(
        label: 'Loading',
        liveRegion: true,
        child: CircularProgressIndicator(
          strokeWidth: AppStrokeWidth.progressIndicator,
          valueColor:
          AlwaysStoppedAnimation<Color>(context.appColors.primary),
        ),
      ),
    );
  }
}
