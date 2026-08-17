part of 'home_bloc.dart';

/// UI-triggered inputs to [HomeBloc].
///
/// A plain Dart 3 `sealed` class, the same fix applied to [Failure]/[Result]:
/// `sealed class X with _$X` is freezed 3.x syntax, and this project pins
/// freezed ^2.5.7, so it failed to build. `const factory` redirecting
/// constructors are plain Dart, not a freezed feature, so every existing
/// call site (`HomeEvent.started()`, `HomeEvent.searchChanged(q)`, ...)
/// keeps working unchanged.
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  /// Initial load of both collections.
  const factory HomeEvent.started() = HomeStarted;

  /// Pull-to-refresh / retry after a failure.
  const factory HomeEvent.refreshed() = HomeRefreshed;

  /// Local filtering of the category grid.
  const factory HomeEvent.searchChanged(String query) = HomeSearchChanged;

  @override
  List<Object?> get props => const <Object?>[];
}

final class HomeStarted extends HomeEvent {
  const HomeStarted();
}

final class HomeRefreshed extends HomeEvent {
  const HomeRefreshed();
}

final class HomeSearchChanged extends HomeEvent {
  const HomeSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => <Object?>[query];
}
