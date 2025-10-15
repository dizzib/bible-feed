import 'package:bible_feed/manager/bible_reader_launch_manager.dart';
import 'package:bible_feed/model/bible_reader.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:bible_feed/service/url_launch_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parameterized_test/parameterized_test.dart';

import '../test_data.dart';
import 'bible_reader_launch_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PlatformService>(), MockSpec<UrlLaunchService>()])
void main() async {
  late MockPlatformService mockPlatformService;
  late MockUrlLaunchService mockUrlLaunchService;
  late BibleReaderLaunchManager testee;

  setUp(() {
    mockPlatformService = MockPlatformService();
    mockUrlLaunchService = MockUrlLaunchService();
    when(mockPlatformService.currentPlatform).thenReturn(TargetPlatform.android);
    testee = BibleReaderLaunchManager(mockPlatformService, mockUrlLaunchService);
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
        verify(mockUrlLaunchService.canLaunchUrl('blb://android/mat/1')).called(1);
      },
    );
  });

  group('maybeLaunch', () {
    parameterizedTest(
      'should (maybe) launchUrl with correct uri and not throw',
      [
        [TargetPlatform.android, noneBibleReader, 1, false, false, false],
        [TargetPlatform.android, blbBibleReader, 1, false, false, false],
        [TargetPlatform.android, blbBibleReader, 1, true, true, true, 'blb://android/b0/1'],
        [TargetPlatform.android, blbBibleReader, 2, true, true, true, 'blb://android/b0/1/2'],
        [TargetPlatform.iOS, blbBibleReader, 1, true, true, true, 'blb://ios/b0/1'],
        [TargetPlatform.iOS, blbBibleReader, 2, true, true, true, 'blb://ios/b0/1/2'],
      ],
      (
        TargetPlatform currentPlatform,
        BibleReader bibleReader,
        int verse,
        bool isRead,
        bool expectLaunch,
        bool launchOk, [
        String? expectLaunchUrl,
      ]) async {
        final state = FeedState(book: b0, verse: verse, isRead: isRead);
        when(mockPlatformService.currentPlatform).thenReturn(currentPlatform);
        when(mockUrlLaunchService.launchUrl(any)).thenAnswer((_) async => launchOk);

        await testee.maybeLaunch(bibleReader, state);

        if (expectLaunch) {
          verify(mockUrlLaunchService.launchUrl(expectLaunchUrl)).called(1);
        } else {
          verifyNever(mockUrlLaunchService.launchUrl(any));
        }
      },
    );

    test('should throw exception if launchUrl returns false', () async {
      final state = FeedState(book: b0, isRead: true);
      when(mockUrlLaunchService.launchUrl(any)).thenAnswer((_) async => false);
      expect(() => testee.maybeLaunch(blbBibleReader, state), throwsException);
    });

    test('should return LaunchFailed on PlatformException', () async {
      var state = FeedState(book: b1, isRead: true);
      when(mockUrlLaunchService.launchUrl(any)).thenThrow(PlatformException(code: 'code'));
      expect(() => testee.maybeLaunch(blbBibleReader, state), throwsException);
    });
  });
}
