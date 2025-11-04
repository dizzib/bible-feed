import 'package:app_links/app_links.dart';
import 'package:df_log/df_log.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';

import '../view/_constants.dart';
import 'sync_in_manager.dart';

@singleton
class DeepLinkInManager {
  final SyncInManager _syncInManager;

  DeepLinkInManager(this._syncInManager) {
    AppLinks().uriLinkStream.listen(
      (uri) {
        try {
          final queryStart = '${Constants.deeplinkQueryKey}=';
          if (!uri.query.startsWith(queryStart)) {
            throw Exception('Invalid querystring does not start with "$queryStart"');
          }
          final value = uri.query.substring(queryStart.length);
          Log.info(value);
          final decodedJson = Uri.decodeComponent(value);
          Log.info(decodedJson);
          _syncInManager.sync(decodedJson);
          _showToast(msg: 'Success!', backgroundColor: Colors.green);
        } catch (err) {
          _showToast(msg: err.toString(), backgroundColor: Colors.red);
        }
      },
      onError: (err) {
        _showToast(msg: err.toString(), backgroundColor: Colors.red);
      },
    );
  }

  void _showToast({required String msg, required Color backgroundColor}) {
    final toastTimeSecs = 5;
    Fluttertoast.showToast(
      backgroundColor: backgroundColor,
      msg: msg,
      textColor: Colors.white,
      timeInSecForIosWeb: toastTimeSecs,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
