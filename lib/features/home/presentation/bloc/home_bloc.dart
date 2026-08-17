import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/constants/app_motion.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/plant_category.dart';
import '../../domain/entities/question.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_questions.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

/// Owns everything the home screen needs. The widgets below it hold no
/// business logic — they render state and dispatch events.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetCategories getCategories,
    required GetQuestions getQuestions,
  })  : _getCategories = getCategories,
        _getQuestions = getQuestions,
        super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefreshed>(_onRefreshed);
    on<HomeSearchChanged>(
      _onSearchChanged,
      // Debounced so typing does not rebuild the grid on every keystroke.
      transformer: (Stream<HomeSearchChanged> events, EventMapper<HomeSearchChanged> mapper) =>
          restartable<HomeSearchChanged>()(
        events.debounce(AppDurations.searchDebounce),
        mapper,
      ),
    );
  }

  final GetCategories _getCategories;
  final GetQuestions _getQuestions;

  /// Positions in the [Future.wait] result list below — declared so the
  /// order of the two parallel requests is stated once, not read off two
  /// bare subscripts.
  static const int _questionsResult = 0;
  static const int _categoriesResult = 1;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) =>
      _load(emit, status: HomeStatus.loading);

  Future<void> _onRefreshed(HomeRefreshed event, Emitter<HomeState> emit) =>
      _load(emit, status: HomeStatus.refreshing);

  void _onSearchChanged(HomeSearchChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(query: event.query));
  }

  Future<void> _load(Emitter<HomeState> emit, {required HomeStatus status}) async {
    emit(state.copyWith(status: status, failure: null));

    // Both endpoints are independent, so fetch them in parallel.
    final List<Result<Object>> results = await Future.wait<Result<Object>>(
      <Future<Result<Object>>>[
        _getQuestions(const NoParams()),
        _getCategories(const NoParams()),
      ],
    );

    final Result<Object> questionsResult = results[_questionsResult];
    final Result<Object> categoriesResult = results[_categoriesResult];

    final Failure? failure =
        questionsResult.failureOrNull ?? categoriesResult.failureOrNull;

    emit(
      state.copyWith(
        status: failure == null ? HomeStatus.success : HomeStatus.failure,
        questions: (questionsResult.dataOrNull as List<Question>?) ?? state.questions,
        categories:
            (categoriesResult.dataOrNull as List<PlantCategory>?) ?? state.categories,
        failure: failure,
      ),
    );
  }
}
