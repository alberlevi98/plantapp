import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../domain/entities/subscription_plan.dart';
import '../bloc/paywall_bloc.dart';
import '../constants/paywall_assets.dart';
import '../constants/paywall_dimensions.dart';
import '../widgets/paywall_feature_card.dart';
import '../widgets/plan_option_tile.dart';

/// Final step of the onboarding flow. Closing it marks onboarding complete and
/// replaces the whole stack with the home flow, so the user cannot go back.
@RoutePage()
class PaywallPage extends StatelessWidget implements AutoRouteWrapper {
  const PaywallPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider<PaywallBloc>(
    create: (_) => getIt<PaywallBloc>(),
    child: this,
  );

  Future<void> _close(BuildContext context) async {
    final OnboardingBloc bloc = context.read<OnboardingBloc>();
    // `add()` is fire-and-forget — the actual storage write happens inside
    // the event handler, so we still need to wait for it to land before
    // navigating away (killing the app right after should not lose the
    // "onboarding completed" flag). Skip the wait if it's already done,
    // e.g. a double-tap on the close button.
    if (!bloc.state.isCompleted) {
      final Future<void> completed =
      bloc.stream.firstWhere((OnboardingState s) => s.isCompleted);
      bloc.add(const OnboardingEvent.completed());
      await completed;
    }
    if (!context.mounted) return;
    await context.router.replaceAll(<PageRouteInfo<dynamic>>[const HomeRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light.paywallBackground,
      body: Stack(
        children: <Widget>[
          Positioned(
            child: Image.asset(
              PaywallAssets.paywallHero,
              fit: BoxFit.contain,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: AlignmentGeometry.topRight,
              child: Padding(
                  padding: EdgeInsets.only(right: context.w(AppDimensions.xl)),
                  child: _CloseButton(onPressed: () => _close(context)),
              ),
            ),
          ),
          _PaywallContent(onClose: () => _close(context)),
        ],
      ),
    );
  }
}

class _PaywallContent extends StatelessWidget {
  const _PaywallContent({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final double gutter = context.w(AppDimensions.pageHorizontal);

    return BlocBuilder<PaywallBloc, PaywallState>(
      builder: (BuildContext context, PaywallState state) {
        return Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Expanded(child: SizedBox.shrink()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(AppDimensions.pageHorizontal)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      SizedBox(
                        height: context.h(AppDimensions.xxxl),
                        child: Image.asset(
                          PaywallAssets.plantTxtIcon,
                          fit: BoxFit.contain,
                        ),
                      ),
                      // FIX: Figma Title grubu gap: 6px → xsPlus (was: sm = 8px)
                      SizedBox(width: context.w(AppDimensions.xsPlus)),
                      Text(
                        'Premium',
                        style: context.scale(AppTextStyles.paywallTitle),
                      ),
                    ],
                  ),

                  Text(
                    'Access All Features',
                    textAlign: TextAlign.left,
                    style: context.scale(AppTextStyles.paywallSubtitle).copyWith(
                      color: AppColors.light.paywallTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Texts ↔ Features: Figma Content gap: 24px → xxl (24px) — already correct.
            SizedBox(height: context.h(AppDimensions.xxl)),
            SizedBox(
              height: context.h(PaywallDimensions.featureListViewHeight),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: gutter),
                children: <Widget>[
                  PaywallFeatureCard(
                    icon: Image.asset(
                      PaywallAssets.unlimitedIcon,
                      width: context.r(PaywallDimensions.featureCardIconSize ),
                      height: context.r(PaywallDimensions.featureCardIconSize ),
                      // Assumes a monochrome/alpha-shaped export, same
                      // treatment as the Material icon it replaces
                      // (Icon(..., color: Colors.white)). Drop color +
                      // colorBlendMode if the real asset is full-colour.
                      colorBlendMode: BlendMode.srcIn,
                    ),
                    title: 'Unlimited',
                    subtitle: 'Plant Identify',
                    index: 0,
                    total: 3,
                  ),
                  SizedBox(width: context.w(AppDimensions.sm)),
                  PaywallFeatureCard(
                    icon: Image.asset(
                      PaywallAssets.fasterIcon,
                      width: context.r(PaywallDimensions.featureCardIconSize ),
                      height: context.r(PaywallDimensions.featureCardIconSize ),
                      colorBlendMode: BlendMode.srcIn,
                    ),
                    title: 'Faster',
                    subtitle: 'Process',
                    index: 1,
                    total: 3,
                  ),
                  SizedBox(width: context.w(AppDimensions.sm)),
                  PaywallFeatureCard(
                    icon: Image.asset(
                      PaywallAssets.detailedIcon,
                      width: context.r(PaywallDimensions.featureCardIconSize ),
                      height: context.r(PaywallDimensions.featureCardIconSize ),
                      colorBlendMode: BlendMode.srcIn,
                    ),
                    title: 'Detailed',
                    subtitle: 'Plant care',
                    index: 2,
                    total: 3,
                  ),
                ],
              ),
            ),
            // Features ↔ Plan tiles: Figma Content gap: 24px → xxl (24px) — already correct.
            SizedBox(height: context.h(AppDimensions.xxl)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              child: Column(
                children: <Widget>[
                  for (int i = 0; i < state.plans.length; i++) ...<Widget>[
                    PlanOptionTile(
                      plan: state.plans[i],
                      isSelected: state.selectedIndex == i,
                      onTap: () => context.read<PaywallBloc>().add(PaywallEvent.planSelected(i)),
                    ),
                    // Tile ↔ Tile: Figma Premium-options gap: 16px → lg (16px) — already correct.
                    if (i != state.plans.length - 1)
                      SizedBox(height: context.h(AppDimensions.lg)),
                  ],
                  // FIX: last tile ↔ button: Figma Content gap: 24px → xxl (was: lg = 16px)
                  SizedBox(height: context.h(AppDimensions.xxl)),
                  PrimaryButton(
                    label: 'Try free for 3 days',
                    isLoading: state.isPurchasing,
                    // Purchases are out of scope for the case: closing the
                    // paywall is what ends the onboarding flow.
                    onPressed: onClose,
                  ),
                  // FIX: button ↔ disclaimer: Figma Content gap: 10px → smPlus (was: sm = 8px)
                  SizedBox(height: context.h(AppDimensions.smPlus)),
                  Text(
                    _disclaimer(state.selectedPlan),
                    textAlign: TextAlign.center,
                    style: context.scale(AppTextStyles.disclaimer).copyWith(
                      color: AppColors.light.paywallTextTertiary,
                    ),
                  ),
                  // FIX: disclaimer ↔ terms row: Figma Content gap: 8px → sm (was: raw literal 6)
                  SizedBox(height: context.h(AppDimensions.sm)),
                  const _LegalLinksRow(),
                  SizedBox(height: context.hWithSafeBottom(0)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _disclaimer(SubscriptionPlan? plan) {
    if (plan?.period == PlanPeriod.monthly) {
      return 'You will be charged monthly until you cancel. Cancel any time in the App Store.';
    }
    return 'After the 3-day free trial period you’ll be charged ₺274.99 per year '
        'unless you cancel before the trial expires. Yearly Subscription is Auto-Renewable';
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // The visible circle stays at the Figma size (24x24); the tappable area
    // is grown to Material's 48x48 minimum so the target isn't a
    // fine-motor-skill test. The extra hit area is transparent, so nothing
    // shifts visually.
    return Semantics(
      button: true,
      label: 'Close and continue to the home screen',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: kMinInteractiveDimension,
          height: kMinInteractiveDimension,
          child: Center(
            child: Container(
              width: context.r(AppDimensions.xxl),
              height: context.r(AppDimensions.xxl),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.light.paywallCloseBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: context.r(AppRadius.lg), color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Terms • Privacy • Restore" — three separately-tappable, individually
/// focusable links, not one flat string.
///
/// Built with [Wrap] + separate widgets rather than [Text.rich] +
/// [WidgetSpan] — same reasoning as onboarding's "Terms of Use & Privacy
/// Policy" agreement text: WidgetSpan semantics nested inside a shared
/// RenderParagraph aren't reliably reachable via TalkBack's linear swipe
/// navigation on Android. Separate sibling widgets have no shared paragraph
/// to fight with.
class _LegalLinksRow extends StatelessWidget {
  const _LegalLinksRow();

  @override
  Widget build(BuildContext context) {
    final TextStyle style = context.scale(AppTextStyles.terms).copyWith(
      color: Colors.white.withValues(alpha: 0.5),
    );

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        _LegalLink(text: 'Terms', style: style),
        Text('•', style: style),
        _LegalLink(text: 'Privacy', style: style),
        Text('•', style: style),
        _LegalLink(text: 'Restore', style: style),
      ],
    );
  }
}

class _LegalLink extends StatelessWidget {
  const _LegalLink({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: text,
      // The Semantics node's OWN onTap — gives it an actual accessibility
      // action, invoked directly by TalkBack/VoiceOver's activation
      // gesture. Without this, `excludeSemantics` below would hide the
      // GestureDetector's auto-generated tap action too, leaving a
      // link-flagged node with no action — which is what made "Terms of
      // Use"/"Privacy Policy" unreachable during swipe navigation before.
      onTap: () => unawaited(HapticFeedback.selectionClick()),
      excludeSemantics: true,
      child: GestureDetector(
        // No real destination in this case study — a light haptic tap is
        // the only feedback that the tap actually landed.
        onTap: () => unawaited(HapticFeedback.selectionClick()),
        behavior: HitTestBehavior.opaque,
        child: Text(text, style: style),
      ),
    );
  }
}