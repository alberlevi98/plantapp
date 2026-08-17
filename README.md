# PlantApp — HUBX Flutter Developer Case

Feature-first Clean Architecture implementation of the PlantApp brief: a one-time
onboarding flow (Get Started → 2 onboarding slides → paywall) that hands off to a
home flow backed by the case API.

## Getting it running

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed / json / auto_route
flutter run
```

`build_runner` generates the files referenced by `part` directives:
`*.freezed.dart`, `*.g.dart` and `lib/app/router/app_router.gr.dart`. They are
intentionally not checked in.

### Before first run

1. **Confirm the API host.** `lib/core/constants/api_constants.dart` holds the
   base URL. The host came through OCR-garbled in the case PDF
   (`jtg6beeeta` vs `jtq6bessta`) — verify it against the original brief.
2. **Drop in the exported assets.** `lib/core/constants/app_assets.dart` lists
   the four images the screens expect under `assets/images/`, plus the five
   Roboto weights under `assets/fonts/` declared in `pubspec.yaml`.

## Layers

```
presentation  ← widgets, Blocs/Cubits. Knows nothing about Dio or JSON.
     ↓ depends on
domain        ← entities, repository interfaces, use cases. Pure Dart.
     ↑ implemented by
data          ← DTOs (freezed + json_serializable), datasources, repositories.
```

Dependencies point inward only. `HomeRepositoryImpl` is the single place where
`AppException`s from the transport layer become `Failure`s, and every use case
returns `Result<T>` so nothing throws across a layer boundary.

## Structure

```
lib/
├── main.dart                     # bootstrap: orientation, DI, error zone
├── app/
│   ├── app.dart                  # MaterialApp.router + Responsive scope
│   ├── di/injector.dart          # get_it wiring for every layer
│   └── router/
│       ├── app_router.dart       # auto_route config, both flows
│       └── guards/onboarding_guard.dart
├── core/
│   ├── constants/                # api, assets, spacing/radii/durations
│   ├── error/                    # exceptions (data) + Failure (presentation)
│   ├── network/                  # DioClient, Result union, interceptors
│   ├── storage/local_storage.dart
│   ├── theme/                    # colors, text styles, ThemeData
│   ├── usecase/usecase.dart
│   ├── utils/                    # Responsive, BlocObserver
│   └── extensions/               # context.w / .h / .r / .sp, theme getters
├── shared/widgets/               # OnboardingPrimaryButton, PageIndicator, ErrorView, …
└── features/
    ├── onboarding/  {domain, presentation}
    ├── paywall/     {domain, presentation}
    └── home/        {data, domain, presentation}
```

## How the brief's requirements map to the code

| Requirement | Where |
|---|---|
| Material widgets only, custom + layout widgets | `shared/widgets`, every `presentation/widgets` folder |
| MediaQuery / LayoutBuilder / Theme.of | `core/utils/responsive.dart`, `core/extensions/context_extensions.dart`, `core/theme/app_theme.dart` |
| Bloc-like state management | `HomeBloc` (events/states), `OnboardingCubit`, `PaywallCubit` |
| Clean Architecture, scalable folders | `features/*/{data,domain,presentation}` + `core` + `shared` |
| dio with interceptors, timeouts, cancellation | `core/network/dio_client.dart` + `interceptors/` |
| json_serializable code generation | `features/home/data/models/*.dart` |
| Immutable models via freezed | same, plus `Result`, `Failure`, all Bloc states |
| Error handling & status-code validation | `DioClient._mapStatusCode`, `Failure.fromException`, `ErrorView` |
| Onboarding entered once only | `LocalStorage.hasCompletedOnboarding` + `OnboardingGuard` + `replaceAll` on paywall close |
| Pixel-perfect & responsive | design tokens in `core/theme` + `core/constants/app_spacing.dart`, scaled by `Responsive` |
| Data fetched, parsed, displayed | `HomeRemoteDataSource` → `HomeRepositoryImpl` → `HomeBloc` → `HomePage` |
| Light/dark + accessibility (bonus) | `AppTheme.light/dark`, `Semantics` on every tappable, clamped text scaling |
| Tests (bonus) | `test/` — bloc_test, mocktail, widget tests |
| Performance (bonus) | lazy `ListView.builder`/`SliverGrid.builder`, `cached_network_image`, debounced search, `AnimatedContainer` transitions |
| Static analysis (bonus) | `analysis_options.yaml` on `flutter_lints` with strict casts/inference |

## Notes and deliberate choices

- **No magic numbers in widgets.** Everything comes from `AppSpacing`,
  `AppRadius`, `AppColors` or `AppTextStyles`, then goes through `context.w/h/r/sp`
  so the 360×800 Figma frame maps onto any device.
- **The paywall's close button is the flow boundary**, exactly as the brief
  states: it persists completion and calls `replaceAll([HomeRoute()])`, so the
  back gesture cannot return to onboarding.
- **Tolerant JSON parsing.** `ApiListResponse` accepts a bare array or a
  `data`-wrapped object, and `ImageUrlConverter` normalises string/nested image
  fields — the dummy API's exact envelope isn't documented in the brief.
- **Purchases are out of scope.** `PaywallCubit` holds the two plans locally;
  swapping in a store-backed repository only touches that one file.

## Suggested commit sequence

```
chore: bootstrap project, lints and build config
feat(core): design tokens, theme and responsive scaling
feat(core): dio client, interceptors and error model
feat(onboarding): get started and onboarding slides
feat(paywall): plans, feature cards and flow completion
feat(home): categories and questions from the API
test: bloc, model and widget coverage
```
