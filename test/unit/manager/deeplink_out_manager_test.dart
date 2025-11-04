import 'package:bible_feed/manager/deeplink_out_manager.dart';
import 'package:bible_feed/manager/json_encoding_manager.dart';
import 'package:bible_feed/manager/sync_out_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'deeplink_out_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<JsonEncodingManager>(), MockSpec<SyncOutManager>()])
void main() {
  group('DeepLinkOutManager', () {
    late MockSyncOutManager mockSyncOutManager;
    late MockJsonEncodingManager mockJsonEncodingManager;
    late DeepLinkOutManager testee;

    setUp(() {
      mockSyncOutManager = MockSyncOutManager();
      mockJsonEncodingManager = MockJsonEncodingManager();
      testee = DeepLinkOutManager(mockJsonEncodingManager, mockSyncOutManager);
    });

    test('getUrl returns correct deep link URL with encoded JSON', () {
      final json = '{"key":"value"}';
      when(mockSyncOutManager.getJson()).thenReturn(json);
      when(mockJsonEncodingManager.encode(json)).thenReturn(Uri.encodeComponent(json));
      expect(testee.getUrl(), 'biblefeed://me2christ.com/share?json=%7B%22key%22%3A%22value%22%7D');
    });
  });
}
