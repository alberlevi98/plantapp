import 'package:shared_preferences/shared_preferences.dart';

import '../error/exceptions.dart';

/// Key/value persistence. The onboarding gate lives here, which is what keeps
/// users out of the onboarding flow once they have finished it.
abstract interface class LocalStorage {
  bool get hasCompletedOnboarding;
  Future<void> setOnboardingCompleted();
  String? get accessToken;
  Future<void> setAccessToken(String token);
  Future<void> clearAccessToken();
}

class LocalStorageImpl implements LocalStorage {
  const LocalStorageImpl(this._prefs);

  final SharedPreferences _prefs;

  static const String _onboardingKey = 'onboarding_completed';
  static const String _tokenKey = 'access_token';

  @override
  bool get hasCompletedOnboarding => _prefs.getBool(_onboardingKey) ?? false;

  @override
  Future<void> setOnboardingCompleted() async {
    final bool ok = await _prefs.setBool(_onboardingKey, true);
    if (!ok) throw const CacheException('Could not save onboarding state.');
  }

  @override
  String? get accessToken => _prefs.getString(_tokenKey);

  @override
  Future<void> setAccessToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  @override
  Future<void> clearAccessToken() async {
    await _prefs.remove(_tokenKey);
  }
}
