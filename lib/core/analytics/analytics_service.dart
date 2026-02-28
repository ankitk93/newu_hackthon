import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:newu_health/core/utils/app_logger.dart';

/// Service wrapper for Firebase Analytics.
/// Provides a single point for tracking all analytics events.
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: _analytics);

  static const String EVENT_LOGIN_BUTTON_CLICK = 'login_button_click';
  static const String EVENT_TEST_BUTTON_CLICK = 'test_button_click';
  static const String EVENT_HOME_SCREEN_VIEW = 'home_screen_view';




  // ─── Custom Events ───
  Future<void> logEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: eventName, parameters: parameters);
    AppLogger.debug('Analytics', 'Event: $eventName | params: $parameters');
  }

  // ─── Pre-built Events ───
  Future<void> logLoginButtonClick({
    required String buttonName,
    String? screenName,
  }) async {
    await logEvent(
      eventName: EVENT_LOGIN_BUTTON_CLICK,
      parameters: {
        'button_name': buttonName,
        if (screenName != null) 'screen_name': screenName,
      },
    );
  }

  Future<void> logButtonClick({
    required String buttonName,
    String? screenName,
  }) async {
    await logEvent(
      eventName: EVENT_TEST_BUTTON_CLICK,
      parameters: {
        'button_name': buttonName,
        if (screenName != null) 'screen_name': screenName,
      },
    );
  }
}
