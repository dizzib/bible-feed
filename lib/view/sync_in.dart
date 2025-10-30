import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/sync_in_manager.dart';

class SyncIn extends StatelessWidget {
  @override
  build(context) {
    final controller = MobileScannerController();
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
            controller: controller,
            onDetect: (result) {
              const toastTimeSecs = 3;
              try {
                controller.stop();
                sl<SyncInManager>().sync(result.barcodes.first.rawValue);
                Navigator.pop(context);
                Fluttertoast.showToast(
                  backgroundColor: Colors.green,
                  msg: 'Sync was successful!',
                  textColor: Colors.white,
                  timeInSecForIosWeb: toastTimeSecs,
                  toastLength: Toast.LENGTH_LONG,
                );
              } catch (err) {
                Fluttertoast.cancel();
                Fluttertoast.showToast(
                  backgroundColor: Colors.red,
                  msg: err.toString(),
                  textColor: Colors.white,
                  timeInSecForIosWeb: toastTimeSecs,
                  toastLength: Toast.LENGTH_LONG,
                );
                Future.delayed(const Duration(seconds: toastTimeSecs), controller.start);
              }
            },
          ),
        ),
      ],
    );
  }
}
