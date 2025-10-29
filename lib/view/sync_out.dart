import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/sync_out_manager.dart';
import '_constants.dart';

class SyncOut extends StatelessWidget {
  @override
  build(context) {
    return Padding(
      padding: Constants.defaultPadding,
      child: QrImageView(
        backgroundColor: Colors.white,
        data: sl<SyncOutManager>().getJson(),
        errorStateBuilder: (_, err) => Center(child: Text('Unable to make qr code: $err', textAlign: TextAlign.center)),
        gapless: false,
        version: QrVersions.auto,
      ),
    );
  }
}
