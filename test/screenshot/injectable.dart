import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import 'injectable.config.dart'; // AUTO-GENERATED

const screenshot = Environment('screenshot');

@InjectableInit(
  generateForDir: ['lib/model*', 'lib/service', 'test/screenshot'],
  preferRelativeImports: true, // because classes inside this folder can not be package-imports
)
Future configureDependencies() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // https://stackoverflow.com/questions/74093954/how-to-fix-no-implementation-found-for-method-getall-on-channel-plugins-flutter
  SharedPreferences.setMockInitialValues({});

  await di.reset();
  await di.init(environment: 'screenshot'); // use test reading lists
}

@module // register third-party
abstract class RegisterModuleTest {
  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
