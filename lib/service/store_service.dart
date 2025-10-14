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

  @factoryMethod
  @preResolve
  static Future<StoreService> create() async => StoreService(await SharedPreferences.getInstance());

  bool? getBool(String key) => _sharedPreferences.getBool(key);
  double? getDouble(String key) => _sharedPreferences.getDouble(key);
  int? getInt(String key) => _sharedPreferences.getInt(key);
  String? getString(String key) => _sharedPreferences.getString(key);

  Future<bool> setBool(String key, bool value) => _sharedPreferences.setBool(key, value);
  Future<bool> setDouble(String key, double value) => _sharedPreferences.setDouble(key, value);
  Future<bool> setInt(String key, int value) => _sharedPreferences.setInt(key, value);
  Future<bool> setString(String key, String value) => _sharedPreferences.setString(key, value);
}
