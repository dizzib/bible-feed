import 'package:app_install_events/app_install_events.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import 'injectable.config.dart'; // AUTO-GENERATED

// this file must reside here in /test for coverage to include all files!?

@InjectableInit(
  generateForDir: ['lib/model*', 'lib/service', 'test'],
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
  @lazySingleton
  AppIUEvents get appIUEvents => AppIUEvents();

  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
