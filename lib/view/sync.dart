import 'package:flutter/material.dart';

import '_constants.dart';
import 'sync_out.dart';

class Sync extends StatelessWidget {
  final maxWidth = 400.0;
  final heightRatio = 1.2;
  @override
  build(context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxWidth * heightRatio),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: Constants.settingsSpacing,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(textAlign: TextAlign.center, 'Scan this QR-code to share the reading state to another device.'),
            Flexible(child: AspectRatio(aspectRatio: 1, child: SyncOut())),
          ],
        ),
      ),
    );
  }
}
