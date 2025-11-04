import 'package:bible_feed/manager/deeplink_in_manager.dart';
import 'package:bible_feed/manager/sync_in_manager.dart';
import 'package:bible_feed/service/deeplink_service.dart';
import 'package:bible_feed/service/toast_service.dart';
import 'package:bible_feed/view/_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'deeplink_in_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DeepLinkService>(), MockSpec<SyncInManager>(), MockSpec<ToastService>()])
void main() {
  group('DeepLinkInManager', () {
    late MockDeepLinkService mockDeepLinkService;
    late MockSyncInManager mockSyncInManager;
    late MockToastService mockToastService;

    setUp(() {
      mockDeepLinkService = MockDeepLinkService();
      mockSyncInManager = MockSyncInManager();
      mockToastService = MockToastService();

      when(mockDeepLinkService.addListener(any)).thenAnswer((invocation) {
        final listener = invocation.positionalArguments[0] as void Function();
        listener(); // Simulate listener call immediately for testing
      });
    });

    test('calls sync and shows success toast on valid deep link', () {
      when(mockDeepLinkService.uri).thenReturn(
        Uri.parse('biblefeed://me2christ.com/share?${Constants.deeplinkQueryKey}=%7B%22key%22%3A%22value%22%7D'),
      );
      DeepLinkInManager(mockDeepLinkService, mockSyncInManager, mockToastService);
      verify(mockSyncInManager.sync('{"key":"value"}')).called(1);
      verify(mockToastService.showOk('Success!')).called(1);
      verifyNever(mockToastService.showError(any));
    });

    test('shows error toast on invalid deep link', () {
      when(mockDeepLinkService.uri).thenReturn(Uri.parse('biblefeed://me2christ.com/share?wrongkey=value'));
      DeepLinkInManager(mockDeepLinkService, mockSyncInManager, mockToastService);
      verify(mockToastService.showError(any)).called(1);
      verifyNever(mockToastService.showOk(any));
      verifyNever(mockSyncInManager.sync(any));
    });
  });
}
