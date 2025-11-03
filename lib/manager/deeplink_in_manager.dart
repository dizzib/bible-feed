import 'package:app_links/app_links.dart';
import 'package:df_log/df_log.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';

import 'sync_in_manager.dart';

@singleton
class DeepLinkInManager {
  final SyncInManager _syncInManager;

  DeepLinkInManager(this._syncInManager) {
    AppLinks().uriLinkStream.listen(
      (uri) {
        try {
          if (!uri.query.startsWith('json=')) {
            throw Exception('Invalid querystring');
          }
          final value = uri.query.substring('json='.length);
          Log.info(value);
          final decodedJson = Uri.decodeComponent(value);
          Log.info(decodedJson);
          _syncInManager.sync(decodedJson);
          Fluttertoast.showToast(msg: 'Success!');
        } catch (e) {
          Fluttertoast.showToast(msg: 'Error!');
        }
      },
      onError: (err) {
        Log.err('Error receiving deep link: $err');
      },
    );
  }
}
