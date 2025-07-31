import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'injectable.config.dart'; // AUTO-GENERATED

@InjectableInit(
    generateForDir: ['lib/model', 'test'],
    preferRelativeImports: true, // because classes inside of the test folder can not be package-imports
    initializerName: 'initTest' // optional name to avoid confusion with the main init method
    )
Future configureDependencies() async {
  await di.reset();
  await di.initTest(environment: 'test');
}

@module // register third-party
abstract class RegisterModuleTest {
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
