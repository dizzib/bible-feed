import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'injectable.config.dart'; // AUTO-GENERATED

@InjectableInit(
  generateForDir: [
    'lib/model',
    'lib/service',
    'test',
  ],
  preferRelativeImports: true, // because classes inside this folder can not be package-imports
)
Future configureDependencies() async {
  await di.reset();
  await di.init(environment: 'test'); // use test reading lists
}

@module // register third-party
abstract class RegisterModuleTest {
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
