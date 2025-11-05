import 'package:bible_feed/manager/deeplink_out_manager.dart';
import 'package:bible_feed/manager/json_encoding_manager.dart';
import 'package:bible_feed/manager/share_out_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'deeplink_out_manager_test.mocks.dart';

// base64 is non deterministic, so mock JsonEncodingManager
@GenerateNiceMocks([MockSpec<JsonEncodingManager>(), MockSpec<ShareOutManager>()])
void main() {
  group('DeepLinkOutManager', () {
    late MockShareOutManager mockShareOutManager;
    late MockJsonEncodingManager mockJsonEncodingManager;
    late DeepLinkOutManager testee;

    setUp(() {
      mockShareOutManager = MockShareOutManager();
      mockJsonEncodingManager = MockJsonEncodingManager();
      testee = DeepLinkOutManager(mockJsonEncodingManager, mockShareOutManager);
    });

    test('getUrl returns correct deep link URL with encoded JSON', () {
      final json = '{"key":"value"}';
      when(mockShareOutManager.getJson()).thenReturn(json);
      when(mockJsonEncodingManager.encode(json)).thenReturn(Uri.encodeComponent(json));
      expect(testee.getUrl(), 'biblefeed://me2christ.com/share?json=%7B%22key%22%3A%22value%22%7D');
    });
  });
}
