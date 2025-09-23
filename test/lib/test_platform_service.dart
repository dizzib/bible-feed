import 'package:bible_feed/service/platform_service.dart';
import 'package:injectable/injectable.dart';

@test
@LazySingleton(as: PlatformService)
class TestPlatformService extends PlatformService {
  TestPlatformService() : super(isAndroid: true, isIOS: false, isHapticAvailable: true);
}
