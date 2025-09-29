import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import 'injectable.config.dart'; // AUTO-GENERATED

const screenshot = Environment('screenshot'); // ignore: prefer-static-class, global for @screenshot

@InjectableInit(generateForDir: ['lib'])
// ignore: prefer-static-class, allow global
Future configureDependencies() async {
  await di.init(environment: 'prod');
}

@module
// ignore: prefer-match-file-name, @InjectableInit only works on top-level function, not on Injectable class
abstract class RegisterThirdParty {
  // TODO replace with SharedPreferencesWithCache when it supports unit tests
  // https://github.com/flutter/flutter/issues/159597
  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
