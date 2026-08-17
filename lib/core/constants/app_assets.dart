/// Assets genuinely shared by 2+ features go here.
///
/// This is a sibling to each feature's own `<feature>_assets.dart`
/// (e.g. lib/features/home/presentation/constants/home_assets.dart), not a
/// base class — Dart's `static const` members aren't inherited in any way
/// that would help here, so there's no `extends`/`implements` relationship
/// between this and the feature-specific ones. A feature imports this file
/// directly if (and only if) it needs something that lives here.
///
/// Empty right now: nothing in the app is actually used by more than one
/// feature yet. Before adding something here, check it's a genuine
/// cross-feature asset — if only one feature uses it, it belongs in that
/// feature's own asset file instead, not here.
abstract final class AppAssets {}