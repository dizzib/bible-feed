import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '/injectable.env.dart';

class PlatformService {
  PlatformService({required this.currentPlatform});

  final TargetPlatform currentPlatform;

  bool get isAndroid => currentPlatform == TargetPlatform.android;
  bool get isIOS => currentPlatform == TargetPlatform.iOS;
}

@integrationTest
@midnightTest
@prod
@LazySingleton(as: PlatformService)
class ProductionPlatformService extends PlatformService {
  ProductionPlatformService() : super(currentPlatform: defaultTargetPlatform);
}
