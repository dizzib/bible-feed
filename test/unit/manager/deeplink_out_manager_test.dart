import 'package:bible_feed/manager/deeplink_out_manager.dart';
import 'package:bible_feed/manager/json_encoding_manager.dart';
import 'package:bible_feed/manager/sync_out_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'deeplink_out_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SyncOutManager>()])
void main() {
  group('DeepLinkOutManager', () {
    late MockSyncOutManager mockSyncOutManager;
    late DeepLinkOutManager testee;

    setUp(() {
      mockSyncOutManager = MockSyncOutManager();
      testee = DeepLinkOutManager(JsonEncodingManager(), mockSyncOutManager);
    });

    test('getUrl returns correct deep link URL with encoded JSON', () {
      final json = '{"key":"value"}';
      when(mockSyncOutManager.getJson()).thenReturn(json);
      expect(testee.getUrl(), 'biblefeed://me2christ.com/share?json=%7B%22key%22%3A%22value%22%7D');
    });
  });
}
