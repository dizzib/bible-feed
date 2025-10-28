import 'package:df_log/df_log.dart';
import 'package:injectable/injectable.dart';

import '../model/sync_dto.dart';
import '../service/app_service.dart';

@lazySingleton
class SyncOutManager {
  final AppService _appService;

  SyncOutManager(this._appService);

  String getJson() {
    final syncDto = SyncDto(version: _appService.version);

    Log.info(syncDto.toJson());
    return syncDto.toJson();
  }
}
