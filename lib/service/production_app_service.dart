import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app_service.dart';

@prod
@LazySingleton(as: AppService)
class ProductionAppService extends AppService {
  ProductionAppService({required super.buildNumber, required super.version});

  @factoryMethod
  @preResolve
  static Future<ProductionAppService> create() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return ProductionAppService(buildNumber: packageInfo.buildNumber, version: packageInfo.version);
  }
}
