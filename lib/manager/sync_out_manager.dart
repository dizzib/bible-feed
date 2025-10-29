import 'package:df_log/df_log.dart';
import 'package:injectable/injectable.dart';

import '../model/sync_dto.dart';
import '../service/app_service.dart';
import 'feeds_manager.dart';

@lazySingleton
class SyncOutManager {
  final AppService _appService;
  final FeedsManager _feedsManager;

  SyncOutManager(this._appService, this._feedsManager);

  String getJson() {
    final feedStateList = _feedsManager.feeds.map((f) => f.state).toList();
    final syncDto = SyncDto(buildNumber: _appService.buildNumber, feedStateList: feedStateList);

    Log.info(syncDto.toJson());
    return syncDto.toJson();
  }
}
