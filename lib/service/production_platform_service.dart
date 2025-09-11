import 'dart:io';

import 'package:injectable/injectable.dart';

import 'platform_service.dart';

@prod
@LazySingleton(as: PlatformService)
class ProductionPlatformService extends PlatformService {
  ProductionPlatformService() : super(isAndroid: Platform.isAndroid, isIOS: Platform.isIOS);
}
