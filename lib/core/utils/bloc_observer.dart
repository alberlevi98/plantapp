import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

/// Debug-only visibility into every state transition.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    developer.log('${bloc.runtimeType}: ${change.nextState}', name: 'bloc');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    developer.log(
      '${bloc.runtimeType} failed',
      name: 'bloc',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
