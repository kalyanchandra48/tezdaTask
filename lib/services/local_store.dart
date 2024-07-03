import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  /// Save data to shared preferences based on the type of data
  static Future<void> saveData(
      {required String key, required dynamic value}) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      print('Type not supported');
    }
  }

  static Future<List<String>?> readStrinList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final obj = prefs.getStringList(key);
    return obj;
  }

  /// Read data from shared preferences
  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    return obj;
  }
  static Future<String?> readString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final obj = prefs.getString(key);
    return obj;
  }

  /// Delete data from shared preferences
  static Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  /// to reload the instance
  static Future<void> reloadData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
  }
}
