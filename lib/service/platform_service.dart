class PlatformService {
  PlatformService({required this.isAndroid, required this.isIOS, required this.isHapticAvailable});

  final bool isAndroid;
  final bool isIOS;
  final bool isHapticAvailable;
}
