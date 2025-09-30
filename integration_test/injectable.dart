import 'package:injectable/injectable.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import 'injectable.config.dart'; // AUTO-GENERATED

@singleton // cannot be lazy, else https://github.com/dart-lang/tools/issues/705 manifests in integration test
class AutoAdvanceService {}

@InjectableInit(
  generateForDir: ['integration_test', 'lib/model*', 'lib/service*'],
  preferRelativeImports: true, // because classes inside this folder can not be package-imports
)
Future configureDependencies() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await di.init(environment: 'integration_test');
}

@module // register third-party
abstract class RegisterModule {
  // TODO replace with SharedPreferencesWithCache when it supports unit tests
  // https://github.com/flutter/flutter/issues/159597
  @preResolve
  @singleton
  Future<SharedPreferences> get clearedSharedPreferences async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
    return sp;
  }
}
