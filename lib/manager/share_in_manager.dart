import 'package:dartx/dartx.dart';
import 'package:injectable/injectable.dart';

import 'feed_manager.dart';
import '../model/feed.dart';
import '../model/share_dto.dart';
import '../service/app_service.dart';
import 'catchup_manager.dart';
import 'feeds_manager.dart';

@lazySingleton
class ShareInManager {
  final AppService _appService;
  final CatchupManager _catchupManager;
  final FeedsManager _feedsManager;

  ShareInManager(this._appService, this._catchupManager, this._feedsManager);

  void _validateFeedList(List<Feed> feedList) {
    for (var index = 0; index < feedList.length; index++) {
      final incomingFeed = feedList[index];
      final readingList = _feedsManager.feedManagers[index].readingList;
      final isKnownBook = readingList.any((book) => book.key == incomingFeed.bookKey);
      if (!isKnownBook) {
        throw Exception('The QR-code contains an unknown book key "${incomingFeed.bookKey}" for ${readingList.name}.');
      }

      final chapterCount = readingList.getBook(incomingFeed.bookKey).chapterCount;

      if (incomingFeed.chapter < 1 || incomingFeed.chapter > chapterCount) {
        throw Exception(
          'The QR-code contains an invalid chapter ${incomingFeed.chapter} for ${readingList.name}. '
          'Expected chapter 1 to $chapterCount.',
        );
      }

      if (incomingFeed.verse < 1) {
        throw Exception(
          'The QR-code contains an invalid verse ${incomingFeed.verse} for ${readingList.name}. Expected verse 1 or higher.',
        );
      }
    }
  }

  void sync(String? json) {
    const help = 'Please ensure you are scanning a Bible Feed QR-code.';

    if (json == null || json.isEmpty) {
      throw Exception('No data was found. $help');
    }

    ShareDto shareDto;

    try {
      shareDto = ShareDtoMapper.fromJson(json);
    } catch (err, stackTrace) {
      Error.throwWithStackTrace(Exception('The QR-code is not recognised. $help'), stackTrace);
    }

    if (shareDto.version != _appService.version) {
      throw Exception(
        'The Bible Feed versions must be identical. Please ensure Bible Feed is up to date on both devices.',
      );
    }

    final actualFeedsCount = shareDto.feedList.length;
    final expectedFeedsCount = _feedsManager.feedManagers.length;
    if (actualFeedsCount != expectedFeedsCount) {
      throw Exception('Expected $expectedFeedsCount feeds in the QR-code but got $actualFeedsCount. $help');
    }

    _validateFeedList(shareDto.feedList);

    _catchupManager.virtualAllDoneDate = shareDto.virtualAllDoneDate;

    for (final (index, feed) in _feedsManager.feedManagers.indexed) {
      feed.feed = shareDto.feedList[index];
    }

    // touch the last modified feed to preserve lastModifiedDate
    final latestBookKey = shareDto.feedList.maxBy((s) => s.dateModified ?? DateTime(1970))?.bookKey;
    _feedsManager.feedManagers.firstOrNullWhere((FeedManager fm) => fm.book.key == latestBookKey)?.touch();
  }
}
