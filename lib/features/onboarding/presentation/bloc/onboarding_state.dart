part of 'onboarding_bloc.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int pageIndex,
    @Default(false) bool isCompleted,
  }) = _OnboardingState;

  const OnboardingState._();

  bool get isLastPage => pageIndex >= OnboardingBloc.slides.length - 1;
}
