import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '/model/bible_reader.dart';
import '/model/feed.dart';
import 'result.dart';
import 'url_launch_service.dart';

@lazySingleton
class BibleReaderLaunchService {
  final UrlLaunchService _urlLaunchService;

  BibleReaderLaunchService(this._urlLaunchService);

  String _getDeeplinkUri(BibleReader bibleReader, String internalBookKey, int chapter, [int verse = 1]) {
    final externalBookKey = bibleReader.bookKeyExternaliser.getExternalBookKey(internalBookKey);
    var url = bibleReader.uriTemplate.replaceAll('BOOK', externalBookKey).replaceAll('CHAPTER', chapter.toString());
    if (bibleReader.uriVersePath != null && verse > 1) {
      url += bibleReader.uriVersePath!.replaceAll('VERSE', verse.toString());
    }
    return url;
  }

  Future<bool> isAvailable(BibleReader bibleReader) {
    if (bibleReader.isNone) return Future.value(true);
    return _urlLaunchService.canLaunchUrl(_getDeeplinkUri(bibleReader, 'mat', 1));
  }

  Future<Result> launch(BibleReader bibleReader, FeedState state) async {
    if (bibleReader.isNone || state.isRead) return Future.value(Success());
    try {
      final uri = _getDeeplinkUri(bibleReader, state.book.key, state.chapter, state.verse);
      return Future.value(await _urlLaunchService.launchUrl(uri) ? Success() : Failure());
    } on PlatformException catch (e) {
      return Future.value(Failure(e));
    }
  }
}
