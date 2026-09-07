import 'package:dartx/dartx.dart';
import 'package:injectable/injectable.dart';

import 'feed_manager.dart';
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

    _catchupManager.virtualAllDoneDate = shareDto.virtualAllDoneDate;

    for (final (index, feed) in _feedsManager.feedManagers.indexed) {
      feed.feed = shareDto.feedList[index];
    }

    // touch the last modified feed to preserve lastModifiedDate
    final latestBookKey = shareDto.feedList.maxBy((s) => s.dateModified ?? DateTime(1970))?.bookKey;
    _feedsManager.feedManagers.firstWhere((FeedManager fm) => fm.book.key == latestBookKey).touch();
  }
}
