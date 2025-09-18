import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/model/bible_reader_book_keymap.dart';
import 'package:bible_feed/model/book.dart';

void main() {
  group('BibleReaderBookKeyMap', () {
    test('apply returns original key if not in keyMap', () {
      final map = _TestBookKeyMap();
      final book = const Book('unknown', 'dummy', 1);
      expect(map.apply(book), equals('unknown'));
    });
  });

  group('IdentityBookKeyMap', () {
    final map = const IdentityBookKeyMap();

    test('apply returns original key unchanged', () {
      final book = const Book('anykey', 'dummy', 1);
      expect(map.apply(book), equals('anykey'));
    });
  });

  group('BlueLetterBookKeyMap', () {
    final map = const BlueLetterBookKeyMap();

    test('apply returns mapped key for known keys', () {
      expect(map.apply(const Book('1cr', 'dummy', 1)), equals('1ch'));
      expect(map.apply(const Book('jam', 'dummy', 1)), equals('jas'));
    });

    test('apply returns original key for unknown keys', () {
      expect(map.apply(const Book('unknown', 'dummy', 1)), equals('unknown'));
    });
  });

  group('LogosBookKeyMap', () {
    final map = const LogosBookKeyMap();

    test('apply returns mapped key for known keys', () {
      expect(map.apply(const Book('1cr', 'dummy', 1)), equals('1ch'));
      expect(map.apply(const Book('rth', 'dummy', 1)), equals('rut'));
    });

    test('apply returns original key for unknown keys', () {
      expect(map.apply(const Book('unknown', 'dummy', 1)), equals('unknown'));
    });
  });

  group('OsisParatextBookKeyMap', () {
    final map = const OsisParatextBookKeyMap();

    test('apply returns mapped key for known keys', () {
      expect(map.apply(const Book('1cr', 'dummy', 1)), equals('1ch'));
      expect(map.apply(const Book('nah', 'dummy', 1)), equals('nam'));
    });

    test('apply returns original key for unknown keys', () {
      expect(map.apply(const Book('unknown', 'dummy', 1)), equals('unknown'));
    });
  });

  group('OliveTreeBookKeyMap', () {
    final map = const OliveTreeBookKeyMap();

    test('apply returns mapped key for known keys', () {
      expect(map.apply(const Book('1cr', 'dummy', 1)), equals('1ch'));
      expect(map.apply(const Book('sos', 'dummy', 1)), equals('ss'));
    });

    test('apply returns original key for unknown keys', () {
      expect(map.apply(const Book('unknown', 'dummy', 1)), equals('unknown'));
    });
  });
}

// Helper class for testing abstract class
class _TestBookKeyMap extends BibleReaderBookKeyMap {
  @override
  Map<String, String> get keyMap => const {};
}
