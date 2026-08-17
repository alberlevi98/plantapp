part of 'paywall_bloc.dart';

@freezed
abstract class PaywallState with _$PaywallState {
  const factory PaywallState({
    @Default(<SubscriptionPlan>[]) List<SubscriptionPlan> plans,
    // Mirrors [PaywallConstants.initialPlanIndex]. Left as a literal on
    // purpose: freezed bakes `@Default(...)` into the generated file, so
    // pointing it at the token would need a build_runner run to stay in
    // sync. The bloc's own initial state uses the token.
    @Default(1) int selectedIndex,
    @Default(false) bool isPurchasing,
    String? errorMessage,
  }) = _PaywallState;

  const PaywallState._();

  SubscriptionPlan? get selectedPlan =>
      selectedIndex >= 0 && selectedIndex < plans.length ? plans[selectedIndex] : null;
}
