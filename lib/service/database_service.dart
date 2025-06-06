// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabaseService {
  DatabaseService._privateConstructor();

  // Static instance
  static final DatabaseService instance = DatabaseService._privateConstructor();

  // Hive box (e.g., for general data storage)
  late Box _box;
  String id = '0';

  /// Initialize Hive and open the box
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('appBox');
  }

  void setUserId(String newId) {
    id = newId;
  }

  /// Save data to Hive
  Future<void> saveData(String key, dynamic value) async {
    await _box.put(generateKey(key), value);
  }

  /// Retrieve data from Hive
  dynamic getData(String key) {
    return _box.get(generateKey(key));
  }

  /// Delete data from Hive
  Future<void> deleteData(String key) async {
    await _box.delete(generateKey(key));
  }

  /// Clear all data in the box
  Future<void> clearAll() async {
    await _box.clear();
  }

  Future<void> clearUserAllData() async {
    final keysToDelete =
        _box.keys.where((key) => key is String && key.startsWith(id)).toList();

    await _box.deleteAll(keysToDelete);
  }

  String generateKey(String key) {
    if (key == 'user') {
      return key;
    }

    return "${id}_$key";
  }
}
