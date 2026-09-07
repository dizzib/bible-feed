import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../injectable.env.dart';

@golden
@prod
@lazySingleton
class StoreService {
  // TODO replace with SharedPreferencesWithCache when it supports unit tests
  // https://github.com/flutter/flutter/issues/159597
  final SharedPreferences _sharedPreferences;

  StoreService(this._sharedPreferences);

  @FactoryMethod(preResolve: true)
  static Future<StoreService> create() async {
    final sp = await SharedPreferences.getInstance();
    return StoreService(sp);
  }

  T? get<T>(String key) {
    final value = _sharedPreferences.get(key);

    switch (value) {
      case bool _:
      case int _:
        return value as T;
      case String _:
        // Intentionally coerce ISO-like strings to DateTime.
        // This service stores DateTime as ISO strings in SharedPreferences, and callers
        // are expected to use non-date-like values for plain String keys.
        final dt = DateTime.tryParse(value);
        return (dt ?? value) as T;
      case null:
        return null;
      default:
        throw UnsupportedError("Type ${value.runtimeType} is not supported for key '$key'");
    }
  }

  Future<void> set<T>(String key, T value) {
    switch (value) {
      case bool _:
        return _sharedPreferences.setBool(key, value);
      case DateTime _:
        return _sharedPreferences.setString(key, value.toIso8601String());
      case int _:
        return _sharedPreferences.setInt(key, value);
      case String _:
        return _sharedPreferences.setString(key, value);
      default:
        throw UnsupportedError("Cannot store type $T in SharedPreferences");
    }
  }
}
