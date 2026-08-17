import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/extensions/context_extensions.dart';

/// Network image with a quiet placeholder and a graceful fallback.
///
/// Uses [CachedNetworkImage] so the category grid scrolls without refetching.
/// Every parameter this widget declares is actually forwarded — an earlier
/// version accepted [fit], [width], [height] and friends and then dropped
/// them, which is why `CategoryCard`'s `BoxFit.contain` had no effect.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.semanticLabel,
    super.key,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final Widget image = url.isEmpty
        ? _Placeholder(width: width, height: height)
        : CachedNetworkImage(
            imageUrl: url,
            fit: fit,
            width: width,
            height: height,
            fadeInDuration: Duration.zero,
            placeholder: (BuildContext context, String _) =>
                _Placeholder(width: width, height: height),
            errorWidget: (BuildContext context, String _, Object __) =>
                _Placeholder(width: width, height: height, isError: true),
          );

    final Widget clipped = borderRadius == null
        ? image
        : ClipRRect(borderRadius: borderRadius!, child: image);

    if (semanticLabel == null) {
      return ExcludeSemantics(child: clipped);
    }
    return Semantics(image: true, label: semanticLabel, child: clipped);
  }
}

/// Neutral fill shown while loading and when the image can't be fetched.
/// Deliberately silent: a broken remote thumbnail is not something the user
/// can act on, so it degrades to the card's own surface colour instead of
/// shouting with an error glyph.
class _Placeholder extends StatelessWidget {
  const _Placeholder({this.width, this.height, this.isError = false});

  final double? width;
  final double? height;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: context.appColors.categoryCardBackground,
      alignment: Alignment.center,
      child: isError
          ? Icon(
              Icons.image_not_supported_outlined,
              size: context.r(AppIconSize.md),
              color: context.appColors.textDisabled,
            )
          : null,
    );
  }
}
