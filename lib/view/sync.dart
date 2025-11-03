import 'package:flutter/material.dart';

import '_constants.dart';
import 'sync_out.dart';

class Sync extends StatelessWidget {
  final size = 300.0;
  @override
  build(context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxHeight: size, maxWidth: size),
        child: Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              'Scan this QR-code to share the reading state to another device.',
            ),
            Expanded(child: SyncOut()),
          ],
        ),
      ),
    );
  }
}
