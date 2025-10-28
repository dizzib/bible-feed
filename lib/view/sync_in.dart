import 'package:df_log/df_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/sync_in_manager.dart';

class SyncIn extends StatelessWidget {
  @override
  build(context) {
    return ReaderWidget(
      showFlashlight: false,
      showGallery: false,
      showToggleCamera: false,
      onScan: (qrcode) {
        try {
          sl<SyncInManager>().sync(qrcode.text);
          Navigator.pop(context);
        } catch (e) {
          Log.err(e);
        }
      },
    );
  }
}
