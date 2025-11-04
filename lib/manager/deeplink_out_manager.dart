import 'package:injectable/injectable.dart';

import '../view/_constants.dart';
import 'sync_out_manager.dart';

@singleton
class DeepLinkOutManager {
  final SyncOutManager _syncOutManager;

  DeepLinkOutManager(this._syncOutManager);

  String getUrl() {
    final json = _syncOutManager.getJson();
    final encodedJson = Uri.encodeComponent(json);
    // for android: scheme, host and path are defined in <intent-filter> in AndroidManifest.xml
    // for ios: scheme is defined in Info.plist
    return 'biblefeed://me2christ.com/share?${Constants.deeplinkQueryKey}=$encodedJson';
  }
}
