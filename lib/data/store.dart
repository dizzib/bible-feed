import 'package:shared_preferences/shared_preferences.dart';
// import '../util/log.dart';

class Store {
  static late SharedPreferences _sp;

  // call this method from main() function
  static init() async {
    _sp = await SharedPreferences.getInstance();
    return _sp;
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
