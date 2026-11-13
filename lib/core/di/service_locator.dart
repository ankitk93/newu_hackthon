import 'package:hive_flutter/hive_flutter.dart';
import 'package:network_module/network_module.dart';
import 'package:newu_health/core/local/hive_service.dart';
import 'package:newu_health/core/local/preference_service.dart';
import 'package:newu_health/core/utils/app_logger.dart';

/// Central service initializer for all core infrastructure.
/// Responsible for setting up Hive, SharedPreferences, and Dio (via network module).
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

    // 3. Dio (Network) — plug-and-play module
    final networkConfig = NetworkModuleConfig(
      baseUrl: '',
      log: (level, tag, message) {
        switch (level) {
          case 'debug':
            AppLogger.debug(tag, message);
            break;
          case 'info':
            AppLogger.info(tag, message);
            break;
          case 'warning':
            AppLogger.warning(tag, message);
            break;
          case 'error':
            AppLogger.error(tag, message);
            break;
          default:
            AppLogger.info(tag, message);
        }
      },
      enableConnectivity: true,
      enableLogging: true,
      enableRetry: true,
      enableErrorHandling: true,
    );
    dioClient = NetworkModule.create(networkConfig);
    AppLogger.info('ServiceLocator', 'Dio client initialized (network module)');

    _isInitialized = true;
    AppLogger.info('ServiceLocator', 'All core services initialized ✓');
  }
}
