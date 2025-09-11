import 'dart:io';

import 'package:injectable/injectable.dart';

import 'platform_service.dart';

@prod
@LazySingleton(as: PlatformService)
class ProductionPlatformService extends PlatformService {
  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  bool get isIOS => Platform.isIOS;
}
