import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantapp/features/onboarding/presentation/constants/onboarding_dimensions.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/page_indicator.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../paywall/presentation/constants/paywall_assets.dart';
import '../../domain/entities/onboarding_slide.dart';
import '../bloc/onboarding_bloc.dart';
import '../constants/onboarding_assets.dart';
import '../widgets/onboarding_slide_view.dart';

/// The swipeable middle of the onboarding flow.
///
/// [OnboardingBloc] is provided app-wide in `app.dart`, not here: the paywall
/// is a sibling route and completes the flow through the same instance, so the
/// cubit has to live above the router.
@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  bool _isNavigating = false;
  bool _didPrecache = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Same reasoning as GetStartedPage: warm Paywall's hero image before the
    // user can reach the last slide, so its first paint doesn't land mid
    // transition.
    if (!_didPrecache) {
      _didPrecache = true;
      unawaited(precacheImage(const AssetImage(PaywallAssets.paywallHero), context));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Advances the carousel, or hands off to the paywall on the last slide.
  Future<void> _continue(OnboardingState state) async {
    // A quick double-tap on the last slide could otherwise fire `push`
    // twice before the first navigation settles, stacking Paywall on top
    // of itself.
    if (_isNavigating) return;

    unawaited(HapticFeedback.selectionClick());

    if (state.isLastPage) {
      _isNavigating = true;
      await context.router.push(const PaywallRoute());
      if (mounted) _isNavigating = false;
      return;
    }

    _isNavigating = true;
    await _controller.nextPage(
      duration: AppDurations.medium,
      curve: AppMotion.pageSwipe,
    );
    _isNavigating = false;

    // A swipe-triggered page change moves TalkBack focus naturally along
    // with the gesture; a button tap doesn't — focus stays on "Continue"
    // and the screen reader stays silent even though the slide underneath
    // it just changed. Announcing the new slide's headline directly is
    // what makes that change actually reach a screen reader user.
    if (mounted) {
      final OnboardingSlide nextSlide = OnboardingBloc.slides[state.pageIndex + 1];
      unawaited(
        SemanticsService.sendAnnouncement(
          View.of(context),
          nextSlide.title,
          TextDirection.ltr,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
      body: Stack(
        children: <Widget>[
          // Same background image behind both slides — only the foreground
          // artwork in OnboardingSlideView changes as the user swipes.
          Positioned.fill(
            child: Image.asset(
              // Deliberately reuses Get Started's dark asset rather than a
              // dedicated one for this screen — the two share the same dark
              // background by design, not a copy-paste mismatch.
              context.isDarkMode
                  ? OnboardingAssets.getStartedBackgroundDark
                  : OnboardingAssets.onboardingBackground,
              fit: BoxFit.contain,
              // Decorative background — the headline carries the meaning,
              // this shouldn't get its own screen-reader announcement.
              excludeFromSemantics: true,
            ),
          ),
          BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (BuildContext context, OnboardingState state) {
              return _OnboardingContent(
                controller: _controller,
                state: state,
                onPageChanged: (int index) =>
                    context.read<OnboardingBloc>().add(OnboardingEvent.pageChanged(index)),
                onContinue: () => _continue(state),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  /// The paywall is not a PageView page, but it does own a dot.
  static const int _paywallIndicatorDot = 1;

  const _OnboardingContent({
    required this.controller,
    required this.state,
    required this.onPageChanged,
    required this.onContinue,
  });

  final PageController controller;
  final OnboardingState state;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    const List<OnboardingSlide> slides = OnboardingBloc.slides;
    final double gutter = context.w(AppDimensions.pageHorizontal);

    return Column(
      children: <Widget>[
        const SizedBox(height: AppDimensions.pageVerticalSpace),
        Expanded(
          child: PageView.builder(
            controller: controller,
            itemCount: slides.length,
            onPageChanged: onPageChanged,
            itemBuilder: (BuildContext context, int index) =>
                OnboardingSlideView(slide: slides[index]),
          ),
        ),
        SizedBox(
          height: context.hWithSafeBottom(OnboardingDimensions.bottomHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: gutter),
            child: Column(
              children: <Widget>[
                PrimaryButton(label: 'Continue', onPressed: onContinue),
                SizedBox(height: context.h(AppDimensions.lg)),
                // The paywall is the last dot, so the indicator counts one
                // more page than the carousel actually holds.
                PageIndicator(
                  count: slides.length + _paywallIndicatorDot,
                  activeIndex: state.pageIndex,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}