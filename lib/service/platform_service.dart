import 'dart:io';

import 'package:injectable/injectable.dart';

abstract class PlatformService {
  bool get isAndroid;
  bool get isIOS;
}

@prod
@LazySingleton(as: PlatformService)
class ProductionPlatformService extends PlatformService {
  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  bool get isIOS => Platform.isIOS;
}
