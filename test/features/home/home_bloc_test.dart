import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantapp/core/error/failure.dart';
import 'package:plantapp/core/network/result.dart';
import 'package:plantapp/core/usecase/usecase.dart';
import 'package:plantapp/features/home/domain/entities/plant_category.dart';
import 'package:plantapp/features/home/domain/entities/question.dart';
import 'package:plantapp/features/home/domain/usecases/get_categories.dart';
import 'package:plantapp/features/home/domain/usecases/get_questions.dart';
import 'package:plantapp/features/home/presentation/bloc/home_bloc.dart';

class MockGetCategories extends Mock implements GetCategories {}

class MockGetQuestions extends Mock implements GetQuestions {}

void main() {
  late MockGetCategories getCategories;
  late MockGetQuestions getQuestions;

  const List<PlantCategory> categories = <PlantCategory>[
    PlantCategory(id: 1, title: 'Ferns', imageUrl: 'https://example.com/f.png'),
    PlantCategory(id: 2, title: 'Palms', imageUrl: 'https://example.com/p.png'),
  ];
  const List<Question> questions = <Question>[
    Question(id: 1, title: 'How to identify plants?', imageUrl: 'https://example.com/q.png'),
  ];

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    getCategories = MockGetCategories();
    getQuestions = MockGetQuestions();
  });

  HomeBloc buildBloc() => HomeBloc(
        getCategories: getCategories,
        getQuestions: getQuestions,
      );

  group('HomeBloc', () {
    blocTest<HomeBloc, HomeState>(
      'emits loading then success when both endpoints resolve',
      setUp: () {
        when(() => getCategories(any()))
            .thenAnswer((_) async => const Result<List<PlantCategory>>.success(categories));
        when(() => getQuestions(any()))
            .thenAnswer((_) async => const Result<List<Question>>.success(questions));
      },
      build: buildBloc,
      act: (HomeBloc bloc) => bloc.add(const HomeEvent.started()),
      expect: () => <Matcher>[
        isA<HomeState>().having((HomeState s) => s.status, 'status', HomeStatus.loading),
        isA<HomeState>()
            .having((HomeState s) => s.status, 'status', HomeStatus.success)
            .having((HomeState s) => s.categories, 'categories', categories)
            .having((HomeState s) => s.questions, 'questions', questions),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'surfaces a failure when the categories endpoint fails',
      setUp: () {
        when(() => getCategories(any())).thenAnswer(
          (_) async => const Result<List<PlantCategory>>.failure(Failure.network()),
        );
        when(() => getQuestions(any()))
            .thenAnswer((_) async => const Result<List<Question>>.success(questions));
      },
      build: buildBloc,
      act: (HomeBloc bloc) => bloc.add(const HomeEvent.started()),
      skip: 1,
      expect: () => <Matcher>[
        isA<HomeState>()
            .having((HomeState s) => s.status, 'status', HomeStatus.failure)
            .having((HomeState s) => s.failure, 'failure', const Failure.network()),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'filters categories locally when the query changes',
      seed: () => const HomeState(status: HomeStatus.success, categories: categories),
      build: buildBloc,
      act: (HomeBloc bloc) => bloc.add(const HomeEvent.searchChanged('fer')),
      wait: const Duration(milliseconds: 300),
      verify: (HomeBloc bloc) {
        expect(bloc.state.visibleCategories, hasLength(1));
        expect(bloc.state.visibleCategories.single.title, 'Ferns');
      },
    );
  });
}
