import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import 'injectable.config.dart'; // AUTO-GENERATED

const screenshot = Environment('screenshot');

@InjectableInit(generateForDir: ['lib'])
Future configureDependencies() async {
  await di.init(environment: 'prod');
}

@module // register third-party
abstract class RegisterModule {
  // TODO replace with SharedPreferencesWithCache when it supports unit tests
  // https://github.com/flutter/flutter/issues/159597
  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
