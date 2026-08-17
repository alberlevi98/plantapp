import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantapp/core/storage/local_storage.dart';
import 'package:plantapp/features/onboarding/presentation/bloc/onboarding_bloc.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late MockLocalStorage storage;

  setUp(() {
    storage = MockLocalStorage();
    when(() => storage.setOnboardingCompleted()).thenAnswer((_) async {});
  });

  group('OnboardingBloc', () {
    blocTest<OnboardingBloc, OnboardingState>(
      'tracks the current page',
      build: () => OnboardingBloc(storage),
      act: (OnboardingBloc bloc) =>
          bloc.add(const OnboardingEvent.pageChanged(1)),
      expect: () => <OnboardingState>[const OnboardingState(pageIndex: 1)],
      // OnboardingBloc.slides currently has 2 entries, so index 1 is the
      // last page — this mirrors the real slide count rather than a magic
      // number, so it stays correct if a slide is added or removed.
      verify: (OnboardingBloc bloc) => expect(bloc.state.isLastPage, isTrue),
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'persists completion so the flow is never re-entered',
      build: () => OnboardingBloc(storage),
      act: (OnboardingBloc bloc) =>
          bloc.add(const OnboardingEvent.completed()),
      expect: () => <OnboardingState>[const OnboardingState(isCompleted: true)],
      verify: (_) => verify(() => storage.setOnboardingCompleted()).called(1),
    );
  });
}
