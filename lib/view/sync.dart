import 'package:flutter/material.dart';

import '_constants.dart';
import 'sync_in.dart';
import 'sync_out.dart';

class Sync extends StatelessWidget {
  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sync devices')),
      body: Padding(
        padding: const EdgeInsets.all(Constants.settingsSpacing),
        child: Wrap(
          direction: Axis.horizontal,
          children: [
            SizedBox(height: 200, width: 110, child: SyncOut()),
            SizedBox(height: 300, width: 400, child: SyncIn()),
          ],
        ),
      ),
    );
  }
}
