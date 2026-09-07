import 'package:injectable/injectable.dart';

import '../model/share_dto.dart';
import '../service/app_service.dart';
import 'catchup_manager.dart';
import 'feeds_manager.dart';

@lazySingleton
class ShareOutManager {
  final AppService _appService;
  final CatchupManager _catchupManager;
  final FeedsManager _feedsManager;

  ShareOutManager(this._appService, this._catchupManager, this._feedsManager);

  // BEWARE! changing these field names will break share across versions
  String getJson() =>
      ShareDto(
        feedList: _feedsManager.feedManagers.map((f) => f.feed).toList(),
        version: _appService.version,
        virtualAllDoneDate: _catchupManager.virtualAllDoneDate,
      ).toJson();
}
