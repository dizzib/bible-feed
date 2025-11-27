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

  String getJson() =>
      ShareDto(
        buildNumber: _appService.buildNumber,
        feedStateList: _feedsManager.feeds.map((f) => f.state).toList(),
        virtualAllDoneDate: _catchupManager.virtualAllDoneDate,
      ).toJson();
}
