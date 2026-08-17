part of 'paywall_bloc.dart';

/// UI-triggered inputs to [PaywallBloc]. Same plain-`sealed`-class approach
/// as [OnboardingEvent] and [HomeEvent] — see either for why.
sealed class PaywallEvent extends Equatable {
  const PaywallEvent();

  const factory PaywallEvent.planSelected(int index) = PaywallPlanSelected;

  @override
  List<Object?> get props => const <Object?>[];
}

final class PaywallPlanSelected extends PaywallEvent {
  const PaywallPlanSelected(this.index);

  final int index;

  @override
  List<Object?> get props => <Object?>[index];
}
