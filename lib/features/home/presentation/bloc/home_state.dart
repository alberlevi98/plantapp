part of 'home_bloc.dart';

enum HomeStatus { initial, loading, refreshing, success, failure }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    @Default(<Question>[]) List<Question> questions,
    @Default(<PlantCategory>[]) List<PlantCategory> categories,
    @Default('') String query,
    Failure? failure,
  }) = _HomeState;

  const HomeState._();

  /// Categories after the local search filter is applied.
  List<PlantCategory> get visibleCategories {
    if (query.trim().isEmpty) return categories;
    final String needle = query.trim().toLowerCase();
    return categories
        .where((PlantCategory c) => c.title.toLowerCase().contains(needle))
        .toList(growable: false);
  }

  bool get isBusy => status == HomeStatus.loading || status == HomeStatus.refreshing;

  bool get hasContent => categories.isNotEmpty || questions.isNotEmpty;

  /// Only block the whole screen when there is nothing cached to show.
  bool get showFullScreenError => status == HomeStatus.failure && !hasContent;
}
