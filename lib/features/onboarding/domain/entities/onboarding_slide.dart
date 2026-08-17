import 'package:equatable/equatable.dart';

/// Content for one onboarding page.
///
/// The background is shared across every slide (see [OnboardingPage]); only
/// the foreground artwork and headline change between slides.
class OnboardingSlide extends Equatable {
  const OnboardingSlide({
    required this.title,
    required this.highlight,
    required this.foregroundImage,
    this.foregroundImageDark,
  });

  /// Full headline, e.g. "Take a photo to identify the plant!".
  final String title;

  /// The trailing words that carry the brush stroke, e.g. "identify".
  final String highlight;

  /// The slide-specific artwork drawn on top of the shared background.
  final String foregroundImage;

  /// Dark-mode counterpart of [foregroundImage]. Null where one hasn't
  /// been prepared yet — the widget that renders this falls back to
  /// [foregroundImage] in that case, so a slide without a dark asset just
  /// keeps showing its light artwork rather than breaking.
  final String? foregroundImageDark;

  @override
  List<Object?> get props => <Object?>[title, highlight, foregroundImage, foregroundImageDark];
}