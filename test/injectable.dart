import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'injectable.config.dart'; // AUTO-GENERATED

@InjectableInit(
  generateForDir: ['lib/model', 'lib/service', 'test'],
  preferRelativeImports: true, // because classes inside this folder can not be package-imports
)
Future configureDependencies([Map<String, Object> storeValues = const {}]) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // https://stackoverflow.com/questions/74093954/how-to-fix-no-implementation-found-for-method-getall-on-channel-plugins-flutter
  SharedPreferences.setMockInitialValues(storeValues);

  await di.reset();
  await di.init(environment: 'test'); // use test reading lists
}

@module // register third-party
abstract class RegisterModuleTest {
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
