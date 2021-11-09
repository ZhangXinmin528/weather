import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  Future<int?> getInt(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }

  Future<bool> setInt(String key, int val) async {
    final sp = await SharedPreferences.getInstance();
    return sp.setInt(key, val);
  }

  Future<String?> getString(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future<bool> setString(String key, String val) async {
    final sp = await SharedPreferences.getInstance();
    return sp.setString(key, val);
  }

  Future<bool?> getBool(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(key);
  }

  Future<bool> setBool(String key, bool val) async {
    final sp = await SharedPreferences.getInstance();
    return sp.setBool(key, val);
  }

  Future<double?> getDouble(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getDouble(key);
  }

  Future<bool> setDouble(String key, double val) async {
    final sp = await SharedPreferences.getInstance();
    return sp.setDouble(key, val);
  }

  Future<bool> removeKey(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.remove(key);
  }

  Future<bool> clearAll() async {
    final sp = await SharedPreferences.getInstance();
    return sp.clear();
  }
}
