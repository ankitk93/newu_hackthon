import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newu_health/core/analytics/analytics_service.dart';
import 'package:newu_health/core/local/hive_service.dart';
import 'package:newu_health/core/local/preference_service.dart';
import 'package:newu_health/core/network/dio_client.dart';
import 'package:newu_health/core/utils/app_logger.dart';
import 'package:newu_health/firebase_options.dart';

/// Central service initializer for all core infrastructure.
/// Responsible for setting up Firebase, Hive, SharedPreferences, Dio, and Analytics.
class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator instance = ServiceLocator._();

  late final DioClient dioClient;
  late final HiveService hiveService;
  late final PreferenceService preferenceService;
  late final AnalyticsService analyticsService;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    AppLogger.info('ServiceLocator', 'Initializing core services...');

    // 1. Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.info('ServiceLocator', 'Firebase initialized');

    // 2. Hive (NoSQL local DB)
    await Hive.initFlutter();
    hiveService = HiveService();
    await hiveService.init();
    AppLogger.info('ServiceLocator', 'Hive initialized');

    // 3. SharedPreferences
    preferenceService = PreferenceService();
    await preferenceService.init();
    AppLogger.info('ServiceLocator', 'SharedPreferences initialized');

    // 4. Dio (Network)
    dioClient = DioClient();
    AppLogger.info('ServiceLocator', 'Dio client initialized');

    // 5. Analytics
    analyticsService = AnalyticsService();
    AppLogger.info('ServiceLocator', 'Analytics service initialized');

    _isInitialized = true;
    AppLogger.info('ServiceLocator', 'All core services initialized ✓');
  }
}
