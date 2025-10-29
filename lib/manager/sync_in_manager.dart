import 'package:df_log/df_log.dart';
import 'package:injectable/injectable.dart';

import '../model/sync_dto.dart';
import '../service/app_service.dart';
import 'feeds_manager.dart';

@lazySingleton
class SyncInManager {
  final AppService _appService;
  final FeedsManager _feedsManager;

  SyncInManager(this._appService, this._feedsManager);

  void sync(String? json) {
    const help = 'Please ensure you are scanning a Bible Feed QR-code.';

    Log.info('sync $json');
    if (json == null || json.isEmpty) {
      throw Exception('No data was found. $help');
    }

    SyncDto syncDto;
    try {
      syncDto = SyncDtoMapper.fromJson(json);
    } catch (err) {
      Log.err(err);
      throw Exception('The QR-code is not recognised. $help');
    }

    Log.info(syncDto);

    if (syncDto.buildNumber != _appService.buildNumber) {
      throw Exception(
        'The Bible Feed app versions must be identical. Please ensure Bible Feed is up to date on both devices.',
      );
    }

    for (final (index, feed) in _feedsManager.feeds.indexed) {
      feed.state = syncDto.feedStateList[index];
    }
  }
}
