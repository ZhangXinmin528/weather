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
}
