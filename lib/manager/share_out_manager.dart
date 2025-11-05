import 'package:injectable/injectable.dart';

import '../model/share_dto.dart';
import '../service/app_service.dart';
import 'feeds_manager.dart';

@lazySingleton
class ShareOutManager {
  final AppService _appService;
  final FeedsManager _feedsManager;

  ShareOutManager(this._appService, this._feedsManager);

  String getJson() {
    final feedStateList = _feedsManager.feeds.map((f) => f.state).toList();
    return ShareDto(buildNumber: _appService.buildNumber, feedStateList: feedStateList).toJson();
  }
}
