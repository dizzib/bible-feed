import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/sync_out_manager.dart';

class SyncOut extends StatelessWidget {
  @override
  build(context) {
    return QrImageView(
      backgroundColor: Colors.white,
      data: sl<SyncOutManager>().getJson(),
      version: QrVersions.auto,
      size: 320,
      gapless: false,
    );
  }
}
