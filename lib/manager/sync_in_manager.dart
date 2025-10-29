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
    Log.info('sync $json');
    if (json == null || json.isEmpty) throw Exception('empty');

    final syncDto = SyncDtoMapper.fromJson(json);
    Log.info(syncDto);

    if (syncDto.buildNumber != _appService.buildNumber) throw Exception('version mismatch');

    for (final (index, feed) in _feedsManager.feeds.indexed) {
      feed.state = syncDto.feedStateList[index];
    }
  }
}
