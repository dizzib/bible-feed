import 'package:bible_feed/model.production/bible_reader_key.dart';
import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/bible_reader_type.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/bible_reader_launch_service.dart';
import 'package:bible_feed/service/result.dart';
import 'package:bible_feed/service/url_launch_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';
import 'bible_reader_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UrlLaunchService>()])
void main() async {
  late MockUrlLaunchService mockUrlLaunchService;
  late BibleReaderLaunchService testee;

  final noneBibleReader = const BibleReader(BibleReaderKey.none, BibleReaderType.none, '', '', []);
  final blbBibleReader = const BibleReader(
    BibleReaderKey.blueLetterApp,
    BibleReaderType.app,
    'name',
    'scheme://uri/BOOK/CHAPTER',
    [TargetPlatform.android, TargetPlatform.iOS],
    uriVersePath: '/VERSE',
  );

  setUp(() {
    mockUrlLaunchService = MockUrlLaunchService();
    testee = BibleReaderLaunchService(mockUrlLaunchService);
  });

  group('launch', () {
    parameterizedTest(
      'should launchUrl with correct uri and return Success unless launchUrl returned false',
      [
        [noneBibleReader, 1, false, false, false, Success()],
        [blbBibleReader, 1, true, false, false, Success()],
        [blbBibleReader, 1, false, true, true, Success(), 'scheme://uri/b0/1'],
        [blbBibleReader, 2, false, true, true, Success(), 'scheme://uri/b0/1/2'],
        [blbBibleReader, 1, false, true, false, Failure(), 'scheme://uri/b0/1'],
      ],
      (
        BibleReader bibleReader,
        int verse,
        bool isRead,
        bool expectLaunch,
        bool launchOk,
        Result expectResult, [
        String? expectLaunchUrl,
      ]) async {
        final state = FeedState(book: b0, verse: verse, isRead: isRead);
        when(mockUrlLaunchService.launchUrl(any)).thenAnswer((_) async => launchOk);

        final result = await testee.launch(bibleReader, state);

        if (expectLaunch) {
          verify(mockUrlLaunchService.launchUrl(expectLaunchUrl)).called(1);
        } else {
          verifyNever(mockUrlLaunchService.launchUrl(any));
        }
        expect(result.runtimeType, expectResult.runtimeType);
      },
    );

    test('should return Failure on PlatformException', () async {
      var state = FeedState(book: b1, isRead: false);
      when(mockUrlLaunchService.launchUrl(any)).thenThrow(PlatformException(code: 'code'));
      expect((await testee.launch(blbBibleReader, state)).runtimeType, Failure);
    });
  });
}
