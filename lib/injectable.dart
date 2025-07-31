import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'package:injectable/injectable.dart';
import 'injectable.config.dart'; // AUTO-GENERATED

@InjectableInit(
  generateForDir: [
    'lib/model',
    'lib/service',
  ],
)
Future configureDependencies() async {
  sl.registerSingleton(await PackageInfo.fromPlatform());
  sl.registerSingleton(await SharedPreferences.getInstance());
  di.init();
}
