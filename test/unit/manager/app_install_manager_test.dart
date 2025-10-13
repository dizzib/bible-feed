import 'package:bible_feed/manager/app_install_manager.dart';
import 'package:bible_feed/manager/bible_reader_launch_manager.dart';
import 'package:bible_feed/manager/bible_reader_link_service.dart';
import 'package:bible_feed/service/platform_event_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_install_manager_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<BibleReaderLaunchManager>(),
  MockSpec<BibleReaderLinkService>(),
  MockSpec<PlatformEventService>(),
])
void main() {
  late MockBibleReaderLinkService mockBibleReaderLinkService;
  late MockBibleReaderLaunchManager mockBibleReaderLaunchManager;
  late MockPlatformEventService mockPlatformEventService;
  late VoidCallback listener;
  late bool notified;

  AppInstallManager createTestee() =>
      AppInstallManager(mockBibleReaderLaunchManager, mockBibleReaderLinkService, mockPlatformEventService);

  setUp(() {
    mockBibleReaderLaunchManager = MockBibleReaderLaunchManager();
    mockBibleReaderLinkService = MockBibleReaderLinkService();
    mockPlatformEventService = MockPlatformEventService();
    // capture the PlatformEventService listener so we can invoke it
    when(mockPlatformEventService.addListener(any)).thenAnswer((invocation) {
      listener = invocation.positionalArguments[0] as VoidCallback;
    });
    notified = false;
    createTestee().addListener(() => notified = true);
  });

  Future run(bool isAvailable) async {
    when(mockBibleReaderLaunchManager.isAvailable(any)).thenAnswer((_) async => isAvailable);
    listener.call(); // invoke PlatformEventService listener
    await Future.delayed(Duration.zero);
    expect(notified, isAvailable);
  }

  test('if linked bible reader is available, should notify listeners', () async {
    await run(true);
    verifyNever(mockBibleReaderLinkService.unlinkBibleReader());
  });

  test('if linked bible reader is not available, should unlink', () async {
    await run(false);
    verify(mockBibleReaderLinkService.unlinkBibleReader()).called(1);
  });
}
