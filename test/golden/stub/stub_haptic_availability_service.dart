import 'package:bible_feed/injectable.env.dart';
import 'package:bible_feed/service/haptic_availability_service.dart';
import 'package:injectable/injectable.dart';

@golden
@LazySingleton(as: HapticAvailabilityService)
class GoldenHapticAvailabilityService extends HapticAvailabilityService {
  GoldenHapticAvailabilityService() : super(isHapticAvailable: true);
}
