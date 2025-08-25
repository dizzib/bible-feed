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

  setUp(() async {
    await init({});
  });

  group('constructor', () {
    test('should load as unlinked if store is empty', () {
      expect(fixture.isLinked, false);
    });

    test('should load as unlinked if store is invalid', () async {
      await init({'linkedBibleReader': 'nonsense'});
      expect(fixture.isLinked, false);
    });

    test('should load as linked if store is valid', () async {
      await init({'linkedBibleReader': 'blueLetterApp'});
      expect(fixture.isLinked, true);
    });
  });

  group('linkedBibleReaderIndex', () {
    test('should be zero if not linked', () {
      // expect(fixture.linkedBibleReaderIndex, 0);
    });
  });
}
