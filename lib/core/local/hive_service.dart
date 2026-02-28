import 'package:hive_flutter/hive_flutter.dart';
import 'package:newu_health/core/utils/app_logger.dart';

/// Service for managing Hive NoSQL local database.
/// Use this for complex data objects that need local persistence.
class HiveService {
  static const String _userBoxName = 'user_box';
  static const String _cacheBoxName = 'cache_box';

  late Box<dynamic> _userBox;
  late Box<dynamic> _cacheBox;

  Future<void> init() async {
    // Register adapters here as needed:
    // Hive.registerAdapter(YourModelAdapter());

    _userBox = await Hive.openBox(_userBoxName);
    _cacheBox = await Hive.openBox(_cacheBoxName);

    AppLogger.info('HiveService', 'Boxes opened: $_userBoxName, $_cacheBoxName');
  }

  // ─── User Box Operations ───

  Box<dynamic> get userBox => _userBox;

  Future<void> saveUserData(String key, dynamic value) async {
    await _userBox.put(key, value);
  }

  dynamic getUserData(String key) {
    return _userBox.get(key);
  }

  Future<void> deleteUserData(String key) async {
    await _userBox.delete(key);
  }

  // ─── Cache Box Operations ───

  Box<dynamic> get cacheBox => _cacheBox;

  Future<void> saveToCache(String key, dynamic value) async {
    await _cacheBox.put(key, value);
  }

  dynamic getFromCache(String key) {
    return _cacheBox.get(key);
  }

  Future<void> clearCache() async {
    await _cacheBox.clear();
    AppLogger.info('HiveService', 'Cache cleared');
  }

  // ─── Open custom boxes for features ───

  Future<Box<T>> openBox<T>(String name) async {
    return await Hive.openBox<T>(name);
  }

  // ─── Cleanup ───

  Future<void> closeAll() async {
    await Hive.close();
    AppLogger.info('HiveService', 'All boxes closed');
  }
}
