// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabaseService {
  DatabaseService._privateConstructor();

  // Static instance
  static final DatabaseService instance = DatabaseService._privateConstructor();

  // Hive box (e.g., for general data storage)
  late Box _box;

  /// Initialize Hive and open the box
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('appBox');
  }

  /// Save data to Hive
  Future<void> saveData(String key, dynamic value) async {
    await _box.put(key, value);
  }

  /// Retrieve data from Hive
  dynamic getData(String key) {
    return _box.get(key);
  }

  /// Delete data from Hive
  Future<void> deleteData(String key) async {
    await _box.delete(key);
  }

  /// Clear all data in the box
  Future<void> clearAll() async {
    await _box.clear();
  }
}
