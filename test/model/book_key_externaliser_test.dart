import 'package:bible_feed/model.production/book_key_externaliser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BibleReaderBookKeyExternaliser', () {
    test('getExternalBookKey returns original key if not in keyMap', () {
      expect(const _TestBookKeyExternaliser().getExternalBookKey('unknown'), 'unknown');
    });
  });

  test('identity apply returns original key unchanged', () {
    expect(BookKeyExternaliser.identity.getExternalBookKey('anykey'), 'anykey');
  });
}

// Helper class for testing concrete class
class _TestBookKeyExternaliser extends BookKeyExternaliser {
  const _TestBookKeyExternaliser() : super(const []);
}
