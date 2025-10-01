import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '/model/bible_reader.dart';
import '/model/feed.dart';
import 'bible_reader_launch_result.dart';
import 'url_launch_service.dart';

@lazySingleton
class BibleReaderLaunchService {
  final UrlLaunchService _urlLaunchService;

  BibleReaderLaunchService(this._urlLaunchService);

  String _getDeeplinkUri(BibleReader bibleReader, String internalBookKey, int chapter, [int verse = 1]) {
    final externalBookKey = bibleReader.bookKeyExternaliser.getExternalBookKey(internalBookKey);
    var url = bibleReader.uriTemplate.replaceAll('BOOK', externalBookKey).replaceAll('CHAPTER', chapter.toString());
    if (bibleReader.uriVersePath == null || verse == 1) return url;
    // ignore: avoid-non-null-assertion, passed above null check
    return url + bibleReader.uriVersePath!.replaceAll('VERSE', verse.toString());
  }

  Future<bool> isAvailable(BibleReader bibleReader) {
    if (bibleReader.isNone) return Future.value(true);
    return _urlLaunchService.canLaunchUrl(_getDeeplinkUri(bibleReader, 'mat', 1));
  }

  Future<BibleReaderLaunchResult> launch(BibleReader bibleReader, FeedState state) async {
    if (bibleReader.isNone || !state.isRead) return Future.value(LaunchBypassed());
    try {
      final uri = _getDeeplinkUri(bibleReader, state.book.key, state.chapter, state.verse);
      return Future.value(await _urlLaunchService.launchUrl(uri) ? LaunchOk() : LaunchFailed());
    } on PlatformException catch (e) {
      return Future.value(LaunchFailed(e));
    }
  }
}
