import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/storage/local_storage.dart';
import '../../domain/entities/onboarding_slide.dart';
import '../constants/onboarding_assets.dart';

part 'onboarding_bloc.freezed.dart';
part 'onboarding_event.dart';
part 'onboarding_state.dart';

/// Drives the onboarding carousel and records completion so the flow is
/// entered exactly once per install.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(this._storage) : super(const OnboardingState()) {
    on<OnboardingPageChanged>(
          (OnboardingPageChanged event, Emitter<OnboardingState> emit) =>
          emit(state.copyWith(pageIndex: event.index)),
    );
    on<OnboardingCompleted>(_onCompleted);
  }

  final LocalStorage _storage;

  static const List<OnboardingSlide> slides = <OnboardingSlide>[
    OnboardingSlide(
      title: 'Take a photo to identify \nthe plant!',
      highlight: 'identify',
      foregroundImage: OnboardingAssets.onboardingScanForeground,
    ),
    OnboardingSlide(
      title: 'Get plant care guides',
      highlight: 'care guides',
      foregroundImage: OnboardingAssets.onboardingCareForeground,
      foregroundImageDark: OnboardingAssets.onboardingCareForegroundDark,
    ),
  ];

  /// Called when the paywall is dismissed — the point the brief defines as
  /// the end of the onboarding flow.
  Future<void> _onCompleted(OnboardingCompleted event, Emitter<OnboardingState> emit) async {
    await _storage.setOnboardingCompleted();
    emit(state.copyWith(isCompleted: true));
  }

  bool get hasCompletedOnboarding => _storage.hasCompletedOnboarding;
}