import 'package:bible_feed/service/platform_service.dart';
import 'package:injectable/injectable.dart';

@test
@LazySingleton(as: PlatformService)
class ProdPlatformService extends PlatformService {
  @override
  bool get isAndroid => false;

  @override
  bool get isIOS => true;
}
