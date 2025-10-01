import 'package:package_info_plus/package_info_plus.dart';
import 'package:injectable/injectable.dart';

import '../injectable.env.dart';

abstract class AppService {
  AppService({required this.buildNumber, required this.version});

  final String buildNumber;
  final String version;
}

@midnightTest
@prod
@LazySingleton(as: AppService)
class ProductionAppService extends AppService {
  ProductionAppService({required super.buildNumber, required super.version});

  @factoryMethod
  @preResolve
  static Future<AppService> create() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return ProductionAppService(buildNumber: packageInfo.buildNumber, version: packageInfo.version);
  }
}
