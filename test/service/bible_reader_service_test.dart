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

  group('constructor initialisation:', () {
    test('should load as unlinked if store is empty', () async {
      await init({});
      expect(fixture.isLinked, false);
      expect(fixture.linkedBibleReader.displayName, 'None');
    });

    test('should load unlinked if store is invalid', () async {
      await init({'linkedBibleReader': 'nonsense'});
      expect(fixture.isLinked, false);
      expect(fixture.linkedBibleReader.displayName, 'None');
    });

    test('should load linked if store is valid', () async {
      await init({'linkedBibleReader': 'blueLetterApp'});
      expect(fixture.isLinked, true);
      expect(fixture.linkedBibleReader.displayName, 'Blue Letter Bible app');
      expect(fixture.linkedBibleReaderIndex, 1);
    });
  });

  group('linkedBibleReaderIndex', () {
    test('should be zero if not linked', () async {
      await init({});
      expect(fixture.linkedBibleReaderIndex, 0);
    });
  });
}
