import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/foundation.dart';

import 'package:bible_feed/service/app_install_service.dart';
import 'package:bible_feed/service/bible_reader_link_service.dart';
import 'package:bible_feed/service/bible_reader_launch_service.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:bible_feed/service/platform_event_service.dart';

import 'app_install_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<BibleReaderLaunchService>(),
  MockSpec<BibleReaderLinkService>(),
  MockSpec<PlatformEventService>(),
  MockSpec<PlatformService>(),
])
void main() {
  late MockBibleReaderLinkService mockBibleReaderLinkService;
  late MockBibleReaderLaunchService mockBibleReaderLaunchService;
  late MockPlatformService mockPlatformService;
  late MockPlatformEventService mockPlatformEventService;
  late bool notified;

  setUp(() {
    mockBibleReaderLaunchService = MockBibleReaderLaunchService();
    mockBibleReaderLinkService = MockBibleReaderLinkService();
    mockPlatformEventService = MockPlatformEventService();
    mockPlatformService = MockPlatformService();
  });

  createTestee() {
    final testee = AppInstallService(
      mockBibleReaderLaunchService,
      mockBibleReaderLinkService,
      mockPlatformEventService,
      mockPlatformService,
    );
    notified = false;
    testee.addListener(() => notified = true);
  }

  test('on ios, does not add listener', () {
    when(mockPlatformService.isIOS).thenReturn(true);
    createTestee();
    verifyNever(mockPlatformEventService.addListener(any));
  });

  group('on android, on platform event fired', () {
    setUp(() {
      when(mockPlatformService.isIOS).thenReturn(false);
      createTestee();
      verify(mockPlatformEventService.addListener(any)).called(1);
    });

    test('if linked bible reader is available, should notify listeners', () async {
      when(mockBibleReaderLaunchService.isAvailable(any)).thenAnswer((_) async => true);
      late VoidCallback listener;
      when(mockPlatformEventService.addListener(any)).thenAnswer((invocation) {
        listener = invocation.positionalArguments[0] as VoidCallback;
      });
      createTestee();
      listener.call();
      await Future.delayed(Duration.zero); // wait for async listener
      expect(notified, true);
      verifyNever(mockBibleReaderLinkService.unlinkBibleReader());
    });

    test('if linked bible reader is not available, should unlink', () async {
      when(mockBibleReaderLaunchService.isAvailable(any)).thenAnswer((_) async => false);
      late VoidCallback listener;
      when(mockPlatformEventService.addListener(any)).thenAnswer((invocation) {
        listener = invocation.positionalArguments[0] as VoidCallback;
      });
      createTestee();
      listener.call();
      await Future.delayed(Duration.zero); // wait for async listener
      expect(notified, false);
      verify(mockBibleReaderLinkService.unlinkBibleReader()).called(1);
    });
  });
}
