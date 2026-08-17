import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../../core/storage/local_storage.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_categories.dart';
import '../../features/home/domain/usecases/get_questions.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/paywall/presentation/bloc/paywall_bloc.dart';
import '../router/app_router.dart';
import '../router/guards/onboarding_guard.dart';

final GetIt getIt = GetIt.instance;

/// Wires the layers together. Nothing else in the app constructs dependencies,
/// which keeps every class testable with fakes.
Future<void> configureDependencies() async {
  // --- External -----------------------------------------------------------
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  getIt
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerLazySingleton<Connectivity>(Connectivity.new);

  // --- Core ---------------------------------------------------------------
  getIt
    ..registerLazySingleton<LocalStorage>(
      () => LocalStorageImpl(getIt<SharedPreferences>()),
    )
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(getIt<Connectivity>()),
    )
    ..registerLazySingleton<DioClient>(
      () => DioClient(storage: getIt<LocalStorage>()),
    );

  // --- Routing ------------------------------------------------------------
  getIt
    ..registerLazySingleton<OnboardingGuard>(
      () => OnboardingGuard(getIt<LocalStorage>()),
    )
    ..registerLazySingleton<AppRouter>(
      () => AppRouter(onboardingGuard: getIt<OnboardingGuard>()),
    );

  // --- Home feature -------------------------------------------------------
  getIt
    ..registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(getIt<DioClient>()),
    )
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(
        remote: getIt<HomeRemoteDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ),
    )
    ..registerLazySingleton<GetCategories>(
      () => GetCategories(getIt<HomeRepository>()),
    )
    ..registerLazySingleton<GetQuestions>(
      () => GetQuestions(getIt<HomeRepository>()),
    )
    ..registerFactory<HomeBloc>(
      () => HomeBloc(
        getCategories: getIt<GetCategories>(),
        getQuestions: getIt<GetQuestions>(),
      ),
    );

  // --- Onboarding & paywall ----------------------------------------------
  getIt
    ..registerLazySingleton<OnboardingBloc>(
      () => OnboardingBloc(getIt<LocalStorage>()),
    )
    ..registerFactory<PaywallBloc>(PaywallBloc.new);
}
