import 'package:flutter/material.dart';

import '_constants.dart';
import 'sync_in.dart';

class Sync extends StatelessWidget {
  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sync')),
      body: Padding(padding: const EdgeInsets.all(Constants.settingsSpacing), child: SyncIn()),
    );
  }
}
