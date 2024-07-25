import 'package:shared_preferences/shared_preferences.dart';
// import '../util/log.dart';

class Store {
  static late SharedPreferences _sp;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _sp = await SharedPreferences.getInstance();
    return _sp;
  }

  // sets
  static Future<bool> setBool(String key, bool value) async {
    // log.t('set $key $value');
    return await _sp.setBool(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    // log.t('set $key $value');
    return await _sp.setInt(key, value);
  }

  static Future<bool> setString(String key, String value) async {
    // log.t('set $key $value');
    return await _sp.setString(key, value);
  }

  // gets
  static bool? getBool(String key) {
    var val = _sp.getBool(key);
    // log.t('get $key $val');
    return val;
  }

  static int? getInt(String key) {
    var val = _sp.getInt(key);
    // log.t('get $key $val');
    return val;
  }

  static String? getString(String key) {
    var val = _sp.getString(key);
    // log.t('get $key $val');
    return val;
  }
}
