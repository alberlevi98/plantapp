import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/subscription_plan.dart';
import '../constants/paywall_dimensions.dart';

part 'paywall_bloc.freezed.dart';
part 'paywall_event.dart';
part 'paywall_state.dart';

/// Holds the plan list and the current selection.
///
/// Plans are hardcoded here because the case provides no billing endpoint;
/// swapping in a store/API-backed repository only changes [_defaultPlans].
class PaywallBloc extends Bloc<PaywallEvent, PaywallState> {
  PaywallBloc()
      : super(
          const PaywallState(
            plans: _defaultPlans,
            selectedIndex: PaywallConstants.initialPlanIndex,
          ),
        ) {
    on<PaywallPlanSelected>(
      (PaywallPlanSelected event, Emitter<PaywallState> emit) =>
          emit(state.copyWith(selectedIndex: event.index)),
    );
  }

  static const List<SubscriptionPlan> _defaultPlans = <SubscriptionPlan>[
    SubscriptionPlan(
      id: 'monthly',
      period: PlanPeriod.monthly,
      title: '1 Month',
      description: r'$2.99/month, auto renewable',
    ),
    SubscriptionPlan(
      id: 'yearly',
      period: PlanPeriod.yearly,
      title: '1 Year',
      description: r'First 3 days free, then $529,99/year',
      badge: 'Save 50%',
    ),
  ];
}
