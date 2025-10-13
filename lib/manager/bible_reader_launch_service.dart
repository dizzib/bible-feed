import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../model/bible_reader.dart';
import '../model/feed.dart';
import 'bible_reader_launch_result.dart';
import 'platform_service.dart';
import 'url_launch_service.dart';

@lazySingleton
class BibleReaderLaunchService {
  final PlatformService _platformService;
  final UrlLaunchService _urlLaunchService;

  BibleReaderLaunchService(this._platformService, this._urlLaunchService);

  String _getDeeplinkUrl(BibleReader bibleReader, String internalBookKey, int chapter, [int verse = 1]) {
    final externalBookKey = bibleReader.bookKeyExternaliser.getExternalBookKey(internalBookKey);
    var url = bibleReader.urlTemplate[_platformService.currentPlatform]!;
    url = url.replaceAll('BOOK', externalBookKey).replaceAll('CHAPTER', chapter.toString());
    if (bibleReader.urlVersePath == null || verse == 1) return url;
    // ignore: avoid-non-null-assertion, passed above null check
    return url + bibleReader.urlVersePath!.replaceAll('VERSE', verse.toString());
  }

  Future<bool> isAvailable(BibleReader bibleReader) {
    if (bibleReader.isNone) return Future.value(true);
    final externalBookKey = bibleReader.bookKeyExternaliser.getExternalBookKey('mat');
    return _urlLaunchService.canLaunchUrl(_getDeeplinkUrl(bibleReader, externalBookKey, 1));
  }

  Future<BibleReaderLaunchResult> maybeLaunch(BibleReader bibleReader, FeedState state) async {
    if (bibleReader.isNone || !state.isRead) return Future.value(LaunchBypassed());
    try {
      final url = _getDeeplinkUrl(bibleReader, state.book.key, state.chapter, state.verse);
      return Future.value(await _urlLaunchService.launchUrl(url) ? LaunchOk() : LaunchFailed());
    } on PlatformException catch (e) {
      return Future.value(LaunchFailed(e));
    }
  }
}
