import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/app_breakpoints.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/responsive.dart';
import '../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'di/injector.dart';
import 'router/app_router.dart';

class PlantApp extends StatelessWidget {
  const PlantApp({super.key});

  static const String _title = 'PlantApp';

  @override
  Widget build(BuildContext context) {
    final AppRouter router = getIt<AppRouter>();

    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        // Spans the whole onboarding flow, so the paywall can complete it.
        BlocProvider<OnboardingBloc>(create: (_) => getIt<OnboardingBloc>()),
      ],
      child: MaterialApp.router(
        title: _title,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: router.config(),
        builder: (BuildContext context, Widget? child) {
          // One responsive scope for the whole app. The clamp bounds are
          // documented on [AppScale]: the lower one stops the OS setting from
          // shrinking text below the design size, the upper one is Android's
          // own accessibility ceiling. Screens whose layout can't absorb that
          // must use Flexible/FittedBox/scrolling rather than lowering the cap.
          final MediaQueryData mq = MediaQuery.of(context);
          return MediaQuery(
            data: mq.copyWith(
              textScaler: mq.textScaler.clamp(
                minScaleFactor: AppScale.minSystemText,
                maxScaleFactor: AppScale.maxSystemText,
              ),
            ),
            child: Responsive.builder(child: child ?? const SizedBox.shrink()),
          );
        },
      ),
    );
  }
}
