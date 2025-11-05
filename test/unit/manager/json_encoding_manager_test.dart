import 'package:bible_feed/manager/json_encoding_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JsonEncodingManager', () {
    late JsonEncodingManager testee;

    setUp(() {
      testee = JsonEncodingManager();
    });

    test('encode and decode returns original JSON string', () {
      final json = '{"key":"value"}';
      final encoded = testee.encode(json);
      final decoded = testee.decode(encoded);
      expect(decoded, json);
    });

    test('decode returns expected JSON string', () {
      final json = '{"key":"value"}';
      final encoded = testee.encode(json);
      final decoded = testee.decode(encoded);
      expect(decoded, equals(json));
    });

    test('encode produces non-empty string', () {
      final json = '{"key":"value"}';
      final encoded = testee.encode(json);
      expect(encoded.isNotEmpty, true);
    });
  });
}
