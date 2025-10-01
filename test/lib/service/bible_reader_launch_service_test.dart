import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/bible_reader_launch_result.dart';
import 'package:bible_feed/service/bible_reader_launch_service.dart';
import 'package:bible_feed/service/url_launch_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';
import 'bible_reader_launch_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UrlLaunchService>()])
void main() async {
  late MockUrlLaunchService mockUrlLaunchService;
  late BibleReaderLaunchService testee;

  setUp(() {
    mockUrlLaunchService = MockUrlLaunchService();
    testee = BibleReaderLaunchService(mockUrlLaunchService);
  });

  group('isAvailable', () {
    test('if bibleReader is None, should not attempt launch and return true', () async {
      expect(await testee.isAvailable(noneBibleReader), true);
      verifyNever(mockUrlLaunchService.canLaunchUrl(any));
    });

    parameterizedTest(
      'if bibleReader is not None, should attempt to launch matthew 1 and return true/false on ok/fail',
      [
        [true, true],
        [false, false],
      ],
      (bool canLaunch, bool expectIsAvailable) async {
        when(mockUrlLaunchService.canLaunchUrl(any)).thenAnswer((_) async => canLaunch);
        expect(await testee.isAvailable(blbBibleReader), expectIsAvailable);
        verify(mockUrlLaunchService.canLaunchUrl('scheme://uri/mat/1')).called(1);
      },
    );
  });

  group('maybeLaunch', () {
    parameterizedTest(
      'should (maybe) launchUrl with correct uri and return correct Launch result',
      [
        [noneBibleReader, 1, false, false, false, LaunchBypassed()],
        [blbBibleReader, 1, false, false, false, LaunchBypassed()],
        [blbBibleReader, 1, true, true, true, LaunchOk(), 'scheme://uri/b0/1'],
        [blbBibleReader, 2, true, true, true, LaunchOk(), 'scheme://uri/b0/1/2'],
        [blbBibleReader, 1, true, true, false, LaunchFailed(), 'scheme://uri/b0/1'],
      ],
      (
        BibleReader bibleReader,
        int verse,
        bool isRead,
        bool expectLaunch,
        bool launchOk,
        BibleReaderLaunchResult expectResult, [
        String? expectLaunchUrl,
      ]) async {
        final state = FeedState(book: b0, verse: verse, isRead: isRead);
        when(mockUrlLaunchService.launchUrl(any)).thenAnswer((_) async => launchOk);

        final result = await testee.maybeLaunch(bibleReader, state);

        if (expectLaunch) {
          verify(mockUrlLaunchService.launchUrl(expectLaunchUrl)).called(1);
        } else {
          verifyNever(mockUrlLaunchService.launchUrl(any));
        }
        expect(result.runtimeType, expectResult.runtimeType);
      },
    );

    test('should return LaunchFailed on PlatformException', () async {
      var state = FeedState(book: b1, isRead: true);
      when(mockUrlLaunchService.launchUrl(any)).thenThrow(PlatformException(code: 'code'));
      expect((await testee.maybeLaunch(blbBibleReader, state)).runtimeType, LaunchFailed);
    });
  });
}
