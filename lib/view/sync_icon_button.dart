import 'package:flutter/material.dart';

import '_build_context_extension.dart';
import '_constants.dart';
import 'sync.dart';

class SyncIconButton extends StatelessWidget {
  @override
  build(BuildContext context) => IconButton(
    key: const Key('syncIconButton'), // for generate screenshots
    icon: const Icon(Icons.sync_alt, size: Constants.appbarIconSize),
    tooltip: 'Open sync',
    onPressed: () => context.navigateTo(Sync()),
  );
}
