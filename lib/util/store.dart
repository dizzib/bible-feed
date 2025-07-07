import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

class Store {
  static reload() async {
    await sl<SharedPreferences>().reload();
  }

  // gets
  static bool? getBool(String key) => sl<SharedPreferences>().getBool(key);
  static int? getInt(String key) => sl<SharedPreferences>().getInt(key);
  static String? getString(String key) => sl<SharedPreferences>().getString(key);

  // sets
  static setBool(String key, bool value) async => await sl<SharedPreferences>().setBool(key, value);
  static setInt(String key, int value) async => await sl<SharedPreferences>().setInt(key, value);
  static setString(String key, String value) async => await sl<SharedPreferences>().setString(key, value);
}
