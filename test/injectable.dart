import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import 'injectable.config.dart'; // AUTO-GENERATED

// this must be called from any unit test for coverage to include uncovered files!
@InjectableInit(
  generateForDir: ['lib/model*', 'lib/manager*', 'lib/service*', 'test'],
  preferRelativeImports: true, // because classes inside this folder can not be package-imports
)
Future configureDependencies(String environment) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // https://stackoverflow.com/questions/74093954/how-to-fix-no-implementation-found-for-method-getall-on-channel-plugins-flutter
  SharedPreferences.setMockInitialValues({});

  await di.reset();
  await di.init(environment: environment);
}

@module // register third-party
abstract class RegisterModuleTest {
  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
