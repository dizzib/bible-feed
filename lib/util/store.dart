import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static late SharedPreferences _sp;

  // CALL THIS METHOD FIRST!!!
  static init() async {
    _sp = await SharedPreferences.getInstance();
  }

  static reload() async {
    await _sp.reload();
  }

  // gets
  static bool? getBool(String key) => _sp.getBool(key);
  static int? getInt(String key) => _sp.getInt(key);
  static String? getString(String key) => _sp.getString(key);

  // sets
  static setBool(String key, bool value) async => await _sp.setBool(key, value);
  static setInt(String key, int value) async => await _sp.setInt(key, value);
  static setString(String key, String value) async => await _sp.setString(key, value);
}
