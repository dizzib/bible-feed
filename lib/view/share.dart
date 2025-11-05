import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/deeplink_out_manager.dart';
import '_build_context_extension.dart';
import '_constants.dart';

class Share extends StatelessWidget {
  final maxWidth = 400.0;
  final heightRatio = 1.2;
  @override
  build(context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxWidth * heightRatio),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: Constants.defaultSpacing,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(textAlign: TextAlign.center, 'Scan this QR-code to share the reading state to another device.'),
            Flexible(
              child: Padding(
                padding: Constants.defaultPadding,
                child: PrettyQrView.data(
                  data: sl<DeepLinkOutManager>().getUrl(),
                  decoration: PrettyQrDecoration(
                    shape: PrettyQrSmoothSymbol(color: context.isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
