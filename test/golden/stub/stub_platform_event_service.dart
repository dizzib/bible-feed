import 'package:bible_feed/injectable.env.dart';
import 'package:bible_feed/manager/platform_event_service.dart';
import 'package:injectable/injectable.dart';

// prevent MissingPluginException(No implementation found for method listen on channel com.abian.app_install_events/app_monitor)
@golden
@LazySingleton(as: PlatformEventService)
class ScreenshotPlatformEventService extends PlatformEventService {}
