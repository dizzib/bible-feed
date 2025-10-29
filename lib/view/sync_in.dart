import 'package:df_log/df_log.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/sync_in_manager.dart';

class SyncIn extends StatelessWidget {
  @override
  build(context) {
    final msc = MobileScannerController();
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            textAlign: TextAlign.center,
            'Scan the QR-code shown on the other device to transfer its reading state to this device.',
          ),
        ),
        Expanded(
          child: MobileScanner(
            controller: msc,
            onDetect: (result) {
              try {
                sl<SyncInManager>().sync(result.barcodes.first.rawValue);
                msc.stop();
                Navigator.pop(context);
              } catch (e) {
                Log.err(e);
              }
            },
          ),
        ),
      ],
    );
  }
}
