import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import 'package:injectable/injectable.dart';
import 'injectable.config.dart'; // AUTO-GENERATED

@InjectableInit()
void configureDependencies() {
  di.init();
}

@module // register third-party
abstract class RegisterModule {
  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
