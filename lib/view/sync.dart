import 'package:flutter/material.dart';

import '_build_context_extension.dart';
import '_constants.dart';
import 'sync_in.dart';
import 'sync_out.dart';

class Sync extends StatelessWidget {
  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sync devices')),
      body:
          Padding(
            padding: Constants.defaultPadding,
            child: context.isOrientationPortrait
                ? Column(children: [Expanded(child: SyncOut()), Expanded(child: SyncIn())])
                : Row(children: [Expanded(child: SyncOut()), Expanded(child: SyncIn())]),
          ),
    );
  }
}
