import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/service/app_service.dart' as base;

@prod
@LazySingleton(as: base.AppService)
class AppService extends base.AppService {
  AppService({required super.buildNumber, required super.version});

  @factoryMethod
  @preResolve
  static Future<AppService> create() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return AppService(buildNumber: packageInfo.buildNumber, version: packageInfo.version);
  }
}
