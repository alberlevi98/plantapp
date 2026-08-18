import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../constants/onboarding_assets.dart';
import '../constants/onboarding_dimensions.dart';

/// First screen of the onboarding flow.
@RoutePage()
class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  bool _isNavigating = false;
  bool _didPrecache = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Decode Onboarding's background once, ahead of time, so the crossfade
    // isn't the first time that image is ever painted — a large PNG's first
    // decode is a classic source of a dropped frame right at the moment of
    // navigation.
    if (!_didPrecache) {
      _didPrecache = true;
      unawaited(
        precacheImage(
          const AssetImage(OnboardingAssets.onboardingBackground),
          context,
        ),
      );
    }
  }

  /// Pushes Onboarding, guarding against a quick double-tap stacking the
  /// route twice before the first navigation settles.
  Future<void> _start() async {
    if (_isNavigating) return;
    _isNavigating = true;
    unawaited(HapticFeedback.selectionClick());
    await context.router.push(const OnboardingRoute());
    if (mounted) _isNavigating = false;
  }

  @override
  Widget build(BuildContext context) {

    final double gutter = context.w(AppDimensions.pageHorizontal);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            context.isDarkMode
                ? OnboardingAssets.getStartedBackgroundDark
                : OnboardingAssets.getStartedBackground,
          ),
          fit: BoxFit.contain,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  // Artwork fills this section; the headline sits on top of it.
                  Positioned.fill(
                    child: Image.asset(
                      OnboardingAssets.getStartedForeground,
                      fit: BoxFit.contain,
                      // Decorative — "Welcome to PlantApp" + the subtitle
                      // right on top of it already say what this screen is.
                      excludeFromSemantics: true,
                    ),
                  ), Padding(
                    padding: EdgeInsets.fromLTRB(
                      gutter,
                      context.hWithSafeTop(AppDimensions.pageVerticalSpace),
                      gutter,
                      AppDimensions.none,
                    ),
                    child: const _Intro(),
                  ),
                ],
              ),
            ),
            // Separate sibling of the Column, so the CTA can never overlap
            // the artwork above no matter how tall the text becomes.
            SizedBox(
              height: context.hWithSafeBottom(OnboardingDimensions.bottomHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: gutter),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    PrimaryButton(label: 'Get Started', onPressed: _start),
                    SizedBox(height: context.h(AppDimensions.md)),
                    const _Agreement(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(text: 'Welcome to '),
              TextSpan(
                text: 'PlantApp',
                style: context.textStyles.displayLarge
                    .copyWith(fontWeight: AppFontWeight.extraBold),
              ),
            ],
          ),
          style: context.textStyles.displayLarge,
        ),
        SizedBox(height: context.h(AppDimensions.sm)),
        Text(
          'Identify more than 3000+ plants and 88% accuracy.',
          style: context.textStyles.bodyLarge
              .copyWith(color: context.appColors.textSecondary),
        ),
      ],
    );
  }
}

/// The "By tapping next…" block, with two inline underlined links.
class _Agreement extends StatelessWidget {
  const _Agreement();

  @override
  Widget build(BuildContext context) {
    // The terms ramp already exists in AppTextStyles — scaled here rather
    // than re-declared with its own font size and line height.
    final TextStyle style = context.scale(AppTextStyles.terms).copyWith(
      color: context.appColors.textTerms,
    );

    return SizedBox(
      width: context.w(OnboardingDimensions.agreementTextWidth),
      child: Text.rich(
        TextSpan(
          style: style,
          children: <InlineSpan>[
            const TextSpan(
              text: 'By tapping next, you are agreeing to PlantID ',
            ),
            _UnderlinedWord(
              text: 'Terms of Use',
              style: style,
              color: context.appColors.textTerms,
              // No real destination in this case study — a light haptic
              // tap is the only feedback that the tap actually landed,
              // rather than the link silently doing nothing.
              onTap: () => unawaited(HapticFeedback.selectionClick()),
            ),
            const TextSpan(text: ' & '),
            _UnderlinedWord(
              text: 'Privacy Policy',
              style: style,
              color: context.appColors.textTerms,
              // Same as above.
              onTap: () => unawaited(HapticFeedback.selectionClick()),
            ),
            const TextSpan(text: '.'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// An inline underlined word/phrase for use inside a [TextSpan] tree —
/// a real, separately-focusable link, not just underlined text.
///
/// `Semantics(link: true)` + `excludeSemantics: true` makes a screen reader
/// treat this as its own stop distinct from the surrounding sentence — a
/// user can navigate directly to "Terms of Use" without it being merged
/// into the whole paragraph's announcement. `GestureDetector` is what makes
/// it actually tappable for every user, not just accessibility users: this
/// span had no tap handling at all before, so the underline was purely
/// decorative regardless of who was using the app.
///
/// Deliberately not `TextDecoration.underline` for the visual line itself —
/// that's the "correct" API, but nested TextSpans occasionally fail to
/// paint the decoration at all depending on the text engine, with no
/// visible error. A real bottom border always paints, so this sidesteps the
/// issue entirely rather than chasing TextStyle properties that should work.
class _UnderlinedWord extends WidgetSpan {
  _UnderlinedWord({
    required String text,
    required TextStyle style,
    required Color color,
    required VoidCallback onTap,
  }) : super(
    alignment: PlaceholderAlignment.baseline,
    baseline: TextBaseline.alphabetic,
    child: Semantics(
      link: true,
      label: text,
      // The Semantics node's OWN onTap — this is what gives it an
      // actual accessibility action. Without it, `excludeSemantics`
      // below hides the GestureDetector's own auto-generated tap
      // action along with everything else it would normally expose,
      // leaving this node flagged as a link but with no action
      // attached — which is exactly why TalkBack was skipping it
      // entirely during swipe navigation instead of stopping on it.
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: color,
              ),
            ),
          ),
          child: Text(text, style: style),
        ),
      ),
    ),
  );
}