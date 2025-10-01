import 'package:bible_feed/injectable.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:injectable/injectable.dart';

@screenshot
@LazySingleton(as: PlatformService)
class ScreenshotPlatformService extends PlatformService {
  ScreenshotPlatformService() : super(isAndroid: true, isIOS: false, isHapticAvailable: true);
}
