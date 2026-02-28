/// Utility class for defining app-wide constants.
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'NewU Health';
  static const String appVersion = '1.0.0';

  // Network
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Hive box names
  static const String userBox = 'user_box';
  static const String cacheBox = 'cache_box';

  // SharedPreferences keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyIsLoggedIn = 'is_logged_in';
}
