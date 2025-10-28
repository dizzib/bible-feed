import 'package:df_log/df_log.dart';
import 'package:injectable/injectable.dart';

import '../model/sync_dto.dart';
import '../service/app_service.dart';

@lazySingleton
class SyncInManager {
  final AppService _appService;

  SyncInManager(this._appService);

  void sync(String? json) {
    Log.info('sync $json');
    if (json == null || json.isEmpty) throw Exception('empty');

    final syncDto = SyncDtoMapper.fromJson(json);
    Log.info(syncDto);

    if (syncDto.buildNumber != _appService.buildNumber) throw Exception('version mismatch');
  }
}
