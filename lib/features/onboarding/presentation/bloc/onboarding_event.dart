part of 'onboarding_bloc.dart';

/// UI-triggered inputs to [OnboardingBloc].
///
/// A plain Dart 3 `sealed` class — same reasoning as [HomeEvent]: the
/// `sealed class X with _$X` freezed syntax is freezed 3.x only, and this
/// project pins freezed ^2.5.7. `const factory` redirecting constructors are
/// plain Dart, not a freezed feature, so call sites read the same either way
/// (`OnboardingEvent.pageChanged(i)`, `OnboardingEvent.completed()`).
sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  /// Fired as the PageView settles on a new slide.
  const factory OnboardingEvent.pageChanged(int index) = OnboardingPageChanged;

  /// Fired when the paywall closes.
  const factory OnboardingEvent.completed() = OnboardingCompleted;

  @override
  List<Object?> get props => const <Object?>[];
}

final class OnboardingPageChanged extends OnboardingEvent {
  const OnboardingPageChanged(this.index);

  final int index;

  @override
  List<Object?> get props => <Object?>[index];
}

final class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}
