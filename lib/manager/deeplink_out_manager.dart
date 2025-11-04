import 'package:injectable/injectable.dart';

import 'sync_out_manager.dart';

@singleton
class DeepLinkOutManager {
  final SyncOutManager _syncOutManager;

  DeepLinkOutManager(this._syncOutManager);

  String getUrl() {
    final json = _syncOutManager.getJson();
    final encodedJson = Uri.encodeComponent(json);
    // scheme, host and path are defined in <intent-filter> in AndroidManifest.xml
    return 'biblefeed://me2christ.com/share?json=$encodedJson';
  }
}
