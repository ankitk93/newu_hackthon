import 'package:shared_preferences/shared_preferences.dart';
import 'package:newu_health/core/utils/app_logger.dart';

/// Wrapper around SharedPreferences for key-value storage.
/// Use this for simple data: user tokens, settings, flags, etc.
class PreferenceService {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    AppLogger.info('PreferenceService', 'SharedPreferences initialized');
  }

  // ─── String ───

  Future<bool> setString(String key, String value) => _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  // ─── Int ───

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  int? getInt(String key) => _prefs.getInt(key);

  // ─── Bool ───

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);

  // ─── Double ───

  Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);
  double? getDouble(String key) => _prefs.getDouble(key);

  // ─── String List ───

  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // ─── Common Keys ───

  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyOnboardingComplete = 'onboarding_complete';

  // ─── Auth Helpers ───

  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await setString(keyAccessToken, accessToken);
    await setString(keyRefreshToken, refreshToken);
    await setBool(keyIsLoggedIn, true);
  }

  String? get accessToken => getString(keyAccessToken);
  String? get refreshToken => getString(keyRefreshToken);
  bool get isLoggedIn => getBool(keyIsLoggedIn) ?? false;

  // ─── Clear ───

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clearAll() async {
    AppLogger.info('PreferenceService', 'All preferences cleared');
    return _prefs.clear();
  }
}
