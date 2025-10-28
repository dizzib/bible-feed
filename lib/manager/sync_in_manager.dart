import 'package:df_log/df_log.dart';
import 'package:injectable/injectable.dart';

import '../model/sync_dto.dart';

@lazySingleton
class SyncInManager {
  void sync(String? json) {
    Log.info('sync $json');
    if (json == null || json.isEmpty) throw Exception('empty');
    final syncDto = SyncDtoMapper.fromJson(json);
    Log.info(syncDto);
  }
}
