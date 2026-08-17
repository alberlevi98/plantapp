import 'package:equatable/equatable.dart';

enum PlanPeriod { monthly, yearly }

/// A purchasable plan shown on the paywall.
class SubscriptionPlan extends Equatable {
  const SubscriptionPlan({
    required this.id,
    required this.period,
    required this.title,
    required this.description,
    this.badge,
  });

  final String id;
  final PlanPeriod period;
  final String title;
  final String description;

  /// e.g. "Save 50%".
  final String? badge;

  @override
  List<Object?> get props => <Object?>[id, period, title, description, badge];
}
