import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/deeplink_out_manager.dart';
import '_constants.dart';

class SyncOut extends StatelessWidget {
  @override
  build(context) {
    return QrImageView(
      backgroundColor: Colors.white,
      data: sl<DeepLinkOutManager>().getUrl(),
      errorStateBuilder: (_, err) => Center(child: Text('Unable to make qr code: $err', textAlign: TextAlign.center)),
      gapless: true,
      version: QrVersions.auto,
    );
  }
}
