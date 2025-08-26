import 'package:bible_feed/service/bible_reader_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';

void main() async {
  late BibleReaderService fixture;

  init(Map<String, Object> storeValues) async {
    await configureDependencies(storeValues);
    fixture = sl<BibleReaderService>();
  }

  group('isLinked', () {
    test('should be false if store is empty', () async {
      await init({});
      expect(fixture.isLinked, false);
    });

    test('should be false if store is invalid', () async {
      await init({'linkedBibleReader': 'nonsense'});
      expect(fixture.isLinked, false);
    });

    test('should be true if store is valid', () async {
      await init({'linkedBibleReader': 'blueLetterApp'});
      expect(fixture.isLinked, true);
    });
  });

  group('linkedBibleReader', () {
    test('should be none if not linked', () async {
      await init({});
      expect(fixture.linkedBibleReader.displayName, 'None');
    });

    test('should be blb if linked to blb', () async {
      await init({'linkedBibleReader': 'blueLetterApp'});
      expect(fixture.linkedBibleReader.displayName, 'Blue Letter Bible app');
    });
  });

  group('linkedBibleReaderIndex', () {
    test('should be zero if not linked', () async {
      await init({});
      expect(fixture.linkedBibleReaderIndex, 0);
    });

    test('should be 1 if linked to blb', () async {
      await init({'linkedBibleReader': 'blueLetterApp'});
      expect(fixture.linkedBibleReaderIndex, 1);
    });
  });
}
