import 'package:dartx/dartx.dart';
import 'package:injectable/injectable.dart';

import '../model/feed.dart';
import '../model/share_dto.dart';
import '../service/app_service.dart';
import 'feeds_manager.dart';

@lazySingleton
class ShareInManager {
  final AppService _appService;
  final FeedsManager _feedsManager;

  ShareInManager(this._appService, this._feedsManager);

  void sync(String? json) {
    const help = 'Please ensure you are scanning a Bible Feed QR-code.';

    if (json == null || json.isEmpty) {
      throw Exception('No data was found. $help');
    }

    ShareDto syncDto;

    try {
      syncDto = ShareDtoMapper.fromJson(json);
    } catch (err, stackTrace) {
      Error.throwWithStackTrace(Exception('The QR-code is not recognised. $help'), stackTrace);
    }

    if (syncDto.buildNumber != _appService.buildNumber) {
      throw Exception(
        'The Bible Feed app versions must be identical. Please ensure Bible Feed is up to date on both devices.',
      );
    }

    final actualFeedsCount = syncDto.feedStateList.length;
    final expectedFeedsCount = _feedsManager.feeds.length;
    if (actualFeedsCount != expectedFeedsCount) {
      throw Exception('Expected $expectedFeedsCount feeds in the QR-code but got $actualFeedsCount. $help');
    }

    for (final (index, feed) in _feedsManager.feeds.indexed) {
      feed.state = syncDto.feedStateList[index];
    }

    // touch the last modified feed to preserve lastModifiedDate
    final latestBookKey = syncDto.feedStateList.maxBy((s) => s.dateModified ?? DateTime(1970))?.bookKey;
    _feedsManager.feeds.firstWhere((Feed f) => f.book.key == latestBookKey).touch();
  }
}
