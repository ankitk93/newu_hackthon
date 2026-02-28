import 'package:hive_flutter/hive_flutter.dart';
import 'package:newu_health/core/local/hive_service.dart';
import 'package:newu_health/core/local/preference_service.dart';
import 'package:newu_health/core/network/dio_client.dart';
import 'package:newu_health/core/utils/app_logger.dart';

/// Central service initializer for all core infrastructure.
/// Responsible for setting up Hive, SharedPreferences, and Dio.
class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator instance = ServiceLocator._();

  late final DioClient dioClient;
  late final HiveService hiveService;
  late final PreferenceService preferenceService;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    AppLogger.info('ServiceLocator', 'Initializing core services...');

    // 1. Hive (NoSQL local DB)
    await Hive.initFlutter();
    hiveService = HiveService();
    await hiveService.init();
    AppLogger.info('ServiceLocator', 'Hive initialized');

    // 2. SharedPreferences
    preferenceService = PreferenceService();
    await preferenceService.init();
    AppLogger.info('ServiceLocator', 'SharedPreferences initialized');

    // 3. Dio (Network)
    dioClient = DioClient();
    AppLogger.info('ServiceLocator', 'Dio client initialized');

    _isInitialized = true;
    AppLogger.info('ServiceLocator', 'All core services initialized ✓');
  }
}
